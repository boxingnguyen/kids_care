// Chạy: cd firestore-tests && npm run test:emulator
import { after, before, beforeEach, describe, test } from 'node:test';
import { readFileSync } from 'node:fs';
import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} from '@firebase/rules-unit-testing';
import {
  arrayRemove,
  arrayUnion,
  collection,
  deleteDoc,
  deleteField,
  doc,
  getDoc,
  getDocs,
  query,
  serverTimestamp,
  setDoc,
  updateDoc,
  where,
  writeBatch,
} from 'firebase/firestore';

const P = 'parent-p'; // bố
const M = 'parent-m'; // mẹ
const G = 'parent-g'; // bà
const X = 'parent-x'; // người thứ 4 (vượt giới hạn)
const C = 'child-c'; // bé
const S = 'stranger-parent'; // người lạ (vai trò bố/mẹ)
const SC = 'stranger-child'; // người lạ (vai trò con)

const USERS = [P, M, G, X, C, S, SC];
const ROLES = { [P]: 'parent', [M]: 'parent', [G]: 'parent', [X]: 'parent', [C]: 'child', [S]: 'parent', [SC]: 'child' };
const CODES = Object.fromEntries(USERS.map((u, i) => [u, `COD-${String(i).padStart(3, '0')}`]));

let env;

const db = (uid) => env.authenticatedContext(uid).firestore();

before(async () => {
  env = await initializeTestEnvironment({
    projectId: 'demo-kids-care',
    firestore: {
      rules: readFileSync(new URL('../firestore.rules', import.meta.url), 'utf8'),
      host: '127.0.0.1',
      port: 8080,
    },
  });
});

after(() => env.cleanup());

beforeEach(async () => {
  await env.clearFirestore();
  await env.withSecurityRulesDisabled(async (ctx) => {
    const fs = ctx.firestore();
    for (const uid of USERS) {
      await setDoc(doc(fs, 'users', uid), {
        uid,
        name: uid,
        role: ROLES[uid],
        isGuest: true,
        linkCode: CODES[uid],
        linkedParentIds: [],
        linkedChildIds: [],
      });
      await setDoc(doc(fs, 'link_codes', CODES[uid]), { uid, role: ROLES[uid] });
    }
  });
});

// [fromUid] nhập mã của [toUid] → tạo yêu cầu liên kết.
async function sendRequest(fromUid, toUid, id = `${fromUid}_${toUid}`) {
  await setDoc(doc(db(fromUid), 'link_requests', id), {
    fromUid,
    fromRole: ROLES[fromUid],
    fromName: fromUid,
    toUid,
    toRole: ROLES[toUid],
    code: CODES[toUid],
    status: 'pending',
    createdAt: serverTimestamp(),
  });
  return id;
}

// [acceptorUid] chấp nhận yêu cầu [id] (giống LinkService.accept).
function acceptRequest(acceptorUid, requesterUid, id) {
  const fs = db(acceptorUid);
  const batch = writeBatch(fs);
  batch.update(doc(fs, 'link_requests', id), {
    status: 'accepted',
    respondedAt: serverTimestamp(),
  });
  if (ROLES[acceptorUid] === 'child') {
    batch.update(doc(fs, 'users', acceptorUid), {
      linkedParentIds: arrayUnion(requesterUid),
      linkedVia: id,
    });
    batch.update(doc(fs, 'users', requesterUid), { linkedChildIds: arrayUnion(acceptorUid) });
  } else {
    batch.update(doc(fs, 'users', acceptorUid), {
      linkedChildIds: arrayUnion(requesterUid),
      linkedVia: id,
    });
    batch.update(doc(fs, 'users', requesterUid), { linkedParentIds: arrayUnion(acceptorUid) });
  }
  return batch.commit();
}

// Liên kết [parent] ↔ [child] hoàn chỉnh (con gửi, bố/mẹ chấp nhận).
async function link(parent, child = C) {
  const id = await sendRequest(child, parent);
  await acceptRequest(parent, child, id);
}

// Gỡ liên kết như LinkService.unlink.
function unlinkByParent(parent, child) {
  const fs = db(parent);
  const batch = writeBatch(fs);
  batch.update(doc(fs, 'users', parent), { linkedChildIds: arrayRemove(child) });
  batch.update(doc(fs, 'users', child), { linkedParentIds: arrayRemove(parent) });
  return batch.commit();
}

function unlinkByChild(child, parent) {
  const fs = db(child);
  const batch = writeBatch(fs);
  batch.update(doc(fs, 'users', child), { linkedParentIds: arrayRemove(parent) });
  batch.update(doc(fs, 'users', parent), { linkedChildIds: arrayRemove(child) });
  return batch.commit();
}

function newTodo(createdBy, assignedChildId) {
  return {
    title: 'Làm bài tập',
    description: '',
    emoji: '📚',
    assignedChildId,
    createdBy,
    isCompleted: false,
    dueDate: null,
    completedAt: null,
    createdAt: serverTimestamp(),
  };
}

const zone = (name = 'Nhà') => ({ name, lat: 10.7, lng: 106.7, radiusMeters: 500, emoji: '🏠' });

describe('link_codes', () => {
  test('tra được khi biết đúng mã, không liệt kê được', async () => {
    await assertSucceeds(getDoc(doc(db(S), 'link_codes', CODES[P])));
    await assertFails(getDocs(collection(db(S), 'link_codes')));
  });

  test('chỉ tạo được mã cho chính mình, đúng vai trò', async () => {
    await assertSucceeds(setDoc(doc(db(P), 'link_codes', 'NEW-111'), { uid: P, role: 'parent' }));
    await assertFails(setDoc(doc(db(P), 'link_codes', 'NEW-222'), { uid: C, role: 'child' }));
    await assertFails(setDoc(doc(db(C), 'link_codes', 'NEW-333'), { uid: C, role: 'parent' }));
  });

  test('không ghi đè được mã của người khác', async () => {
    await assertFails(setDoc(doc(db(S), 'link_codes', CODES[P]), { uid: S, role: 'parent' }));
  });

  test('chỉ chủ mã xoá được mã', async () => {
    await assertFails(deleteDoc(doc(db(S), 'link_codes', CODES[P])));
    await assertSucceeds(deleteDoc(doc(db(P), 'link_codes', CODES[P])));
  });
});

describe('users — người lạ', () => {
  test('không liệt kê được, không đọc được hồ sơ người khác', async () => {
    await assertFails(getDocs(collection(db(S), 'users')));
    await assertFails(getDocs(query(collection(db(S), 'users'), where('linkCode', '==', CODES[P]))));
    await assertFails(getDoc(doc(db(S), 'users', P)));
    await assertSucceeds(getDoc(doc(db(S), 'users', S)));
  });

  test('không tự thêm bố/mẹ khi chưa được chấp nhận', async () => {
    await assertFails(updateDoc(doc(db(SC), 'users', SC), { linkedParentIds: [P] }));
    await assertFails(updateDoc(doc(db(SC), 'users', SC), { linkedParentIds: [P], linkedVia: 'nope' }));
    const id = await sendRequest(SC, P);
    await assertFails(updateDoc(doc(db(SC), 'users', SC), { linkedParentIds: [P], linkedVia: id }));
  });

  test('không tự thêm mình vào linkedChildIds của bố/mẹ', async () => {
    await assertFails(updateDoc(doc(db(SC), 'users', P), { linkedChildIds: arrayUnion(SC) }));
  });

  test('không tự thêm mình vào linkedParentIds của bé', async () => {
    await assertFails(updateDoc(doc(db(S), 'users', C), { linkedParentIds: arrayUnion(S) }));
    const id = await sendRequest(S, C);
    await assertFails(acceptRequest(S, C, id));
  });
});

describe('users — tự sửa hồ sơ', () => {
  test('đổi được tên, không đổi được vai trò', async () => {
    await assertSucceeds(updateDoc(doc(db(C), 'users', C), { name: 'Bin', nameSet: true }));
    await assertFails(updateDoc(doc(db(C), 'users', C), { role: 'parent' }));
  });

  test('bố/mẹ tự thêm/gỡ token FCM và ngôn ngữ; người khác không ghi được', async () => {
    const mine = doc(db(P), 'users', P);
    await assertSucceeds(updateDoc(mine, { fcmTokens: arrayUnion('tok-1'), locale: 'en' }));
    await assertSucceeds(updateDoc(mine, { fcmTokens: arrayRemove('tok-1') }));
    await assertFails(updateDoc(doc(db(S), 'users', P), { fcmTokens: arrayUnion('tok-x') }));
  });

  test('tạo hồ sơ mới không được kèm sẵn liên kết', async () => {
    const uid = 'new-user';
    await assertFails(setDoc(doc(db(uid), 'users', uid), {
      uid, name: 'x', role: 'child', linkedParentIds: [P], linkedChildIds: [],
    }));
    await assertSucceeds(setDoc(doc(db(uid), 'users', uid), {
      uid, name: 'x', role: 'child', linkedParentIds: [], linkedChildIds: [],
    }));
  });
});

describe('chuyển dữ liệu liên kết cũ (linkedParentId → linkedParentIds)', () => {
  beforeEach(() => env.withSecurityRulesDisabled((ctx) =>
    updateDoc(doc(ctx.firestore(), 'users', C), {
      linkedParentId: P, linkedParentIds: deleteField(),
    })));

  test('bé tự chuyển đúng giá trị cũ', async () => {
    await assertSucceeds(updateDoc(doc(db(C), 'users', C), {
      linkedParentId: deleteField(), linkedParentIds: [P],
    }));
  });

  test('không lợi dụng để thêm người khác', async () => {
    await assertFails(updateDoc(doc(db(C), 'users', C), {
      linkedParentId: deleteField(), linkedParentIds: [P, S],
    }));
    await assertFails(updateDoc(doc(db(C), 'users', C), {
      linkedParentId: deleteField(), linkedParentIds: [S],
    }));
    await assertFails(updateDoc(doc(db(S), 'users', C), {
      linkedParentId: deleteField(), linkedParentIds: [P],
    }));
  });
});

describe('yêu cầu liên kết', () => {
  test('gửi yêu cầu cần đúng mã, khác vai trò, đúng người gửi', async () => {
    await assertSucceeds(sendRequest(C, P));
    await assertFails(setDoc(doc(db(C), 'link_requests', 'bad1'), {
      fromUid: C, fromRole: 'child', fromName: 'c', toUid: S, toRole: 'parent',
      code: CODES[P], status: 'pending', createdAt: serverTimestamp(),
    }));
    await assertFails(setDoc(doc(db(SC), 'link_requests', 'bad2'), {
      fromUid: C, fromRole: 'child', fromName: 'c', toUid: P, toRole: 'parent',
      code: CODES[P], status: 'pending', createdAt: serverTimestamp(),
    }));
    await assertFails(sendRequest(C, SC));
    await assertFails(setDoc(doc(db(C), 'link_requests', 'bad3'), {
      fromUid: C, fromRole: 'child', fromName: 'c', toUid: P, toRole: 'parent',
      code: CODES[P], status: 'accepted', createdAt: serverTimestamp(),
    }));
  });

  test('chỉ hai bên đọc được yêu cầu (query realtime)', async () => {
    await sendRequest(C, P);
    await assertSucceeds(getDocs(query(collection(db(P), 'link_requests'),
      where('toUid', '==', P), where('status', '==', 'pending'))));
    await assertSucceeds(getDocs(query(collection(db(C), 'link_requests'),
      where('fromUid', '==', C), where('status', '==', 'pending'))));
    await assertFails(getDocs(query(collection(db(S), 'link_requests'), where('toUid', '==', P))));
    await assertFails(getDoc(doc(db(S), 'link_requests', `${C}_${P}`)));
  });

  test('gửi yêu cầu chưa liên kết gì cả', async () => {
    await sendRequest(C, P);
    await assertFails(getDoc(doc(db(C), 'users', P)));
    await assertFails(getDoc(doc(db(P), 'users', C)));
  });

  test('bố/mẹ chấp nhận yêu cầu của con', async () => {
    const id = await sendRequest(C, P);
    await assertSucceeds(acceptRequest(P, C, id));
    await assertSucceeds(getDoc(doc(db(C), 'users', P)));
    await assertSucceeds(getDoc(doc(db(P), 'users', C)));
  });

  test('con chấp nhận yêu cầu của bố/mẹ', async () => {
    const id = await sendRequest(P, C);
    await assertSucceeds(acceptRequest(C, P, id));
    await assertSucceeds(getDoc(doc(db(P), 'users', C)));
  });

  test('từ chối thì không liên kết, và không chấp nhận lại được', async () => {
    const id = await sendRequest(C, P);
    await assertSucceeds(updateDoc(doc(db(P), 'link_requests', id), {
      status: 'rejected', respondedAt: serverTimestamp(),
    }));
    await assertFails(acceptRequest(P, C, id));
    await assertFails(getDoc(doc(db(P), 'users', C)));
  });

  test('người gửi không tự chấp nhận, người lạ không trả lời được', async () => {
    const id = await sendRequest(C, P);
    await assertFails(updateDoc(doc(db(C), 'link_requests', id), { status: 'accepted' }));
    await assertFails(updateDoc(doc(db(S), 'link_requests', id), { status: 'accepted' }));
  });

  test('yêu cầu đã dùng không dùng lại được để tự liên kết lại', async () => {
    const id = await sendRequest(C, P);
    await acceptRequest(P, C, id);
    await unlinkByChild(C, P);
    await assertFails(updateDoc(doc(db(P), 'users', C), { linkedParentIds: arrayUnion(P) }));
    await assertFails(acceptRequest(P, C, id));
  });

  test('chấp nhận khi đã liên kết: chỉ đổi trạng thái + xoá yêu cầu ngược chiều', async () => {
    const fromC = await sendRequest(C, P);
    const fromP = await sendRequest(P, C);
    await acceptRequest(P, C, fromC);
    const fs = db(C);
    const batch = writeBatch(fs);
    batch.update(doc(fs, 'link_requests', fromP), { status: 'accepted', respondedAt: serverTimestamp() });
    await assertSucceeds(batch.commit());
    // Xoá yêu cầu của chính mình gửi người kia trong batch chấp nhận
    const id3 = await sendRequest(SC, S);
    const id4 = await sendRequest(S, SC);
    const fs2 = db(SC);
    const b2 = writeBatch(fs2);
    b2.update(doc(fs2, 'link_requests', id4), { status: 'accepted', respondedAt: serverTimestamp() });
    b2.update(doc(fs2, 'users', SC), { linkedParentIds: arrayUnion(S), linkedVia: id4 });
    b2.update(doc(fs2, 'users', S), { linkedChildIds: arrayUnion(SC) });
    b2.delete(doc(fs2, 'link_requests', id3));
    await assertSucceeds(b2.commit());
  });

  test('mã cũ hết hiệu lực sau khi tạo mã mới', async () => {
    await assertSucceeds(deleteDoc(doc(db(P), 'link_codes', CODES[P])));
    await assertSucceeds(setDoc(doc(db(P), 'link_codes', 'NEW-PPP'), { uid: P, role: 'parent' }));
    await assertFails(sendRequest(C, P));
  });

  test('người gửi huỷ được yêu cầu', async () => {
    const id = await sendRequest(C, P);
    await assertFails(deleteDoc(doc(db(S), 'link_requests', id)));
    await assertSucceeds(deleteDoc(doc(db(C), 'link_requests', id)));
  });
});

describe('nhiều người liên kết với một bé (tối đa 3)', () => {
  test('bố, mẹ, bà cùng liên kết được (theo cả hai chiều)', async () => {
    await link(P);
    // Mẹ gửi yêu cầu, bé đồng ý
    const id = await sendRequest(M, C);
    await assertSucceeds(acceptRequest(C, M, id));
    // Bé gửi yêu cầu cho bà, bà chấp nhận
    const id2 = await sendRequest(C, G);
    await assertSucceeds(acceptRequest(G, C, id2));
    for (const parent of [P, M, G]) {
      await assertSucceeds(getDoc(doc(db(parent), 'users', C)));
      await assertSucceeds(getDoc(doc(db(C), 'users', parent)));
    }
  });

  test('người thứ 4 bị chặn (cả hai chiều)', async () => {
    await link(P);
    await link(M);
    await link(G);
    const fromX = await sendRequest(X, C);
    await assertFails(acceptRequest(C, X, fromX));
    const toX = await sendRequest(C, X);
    await assertFails(acceptRequest(X, C, toX));
    // Gỡ một người thì có chỗ
    await unlinkByChild(C, G);
    await assertSucceeds(acceptRequest(X, C, toX));
  });

  test('không thêm trùng một người', async () => {
    await link(P);
    const id = await sendRequest(P, C);
    await assertFails(updateDoc(doc(db(C), 'users', C), { linkedParentIds: [P, P], linkedVia: id }));
  });

  test('bố/mẹ xem danh sách con đã liên kết (realtime query)', async () => {
    await link(P);
    await link(M);
    const snap = await assertSucceeds(
      getDocs(query(collection(db(P), 'users'), where('linkedParentIds', 'array-contains', P))),
    );
    if (snap.size !== 1) throw new Error(`expected 1 child, got ${snap.size}`);
    await assertFails(getDocs(query(collection(db(S), 'users'), where('linkedParentIds', 'array-contains', P))));
  });

  test('người lạ vẫn không vào được', async () => {
    await link(P);
    await assertFails(getDoc(doc(db(SC), 'users', P)));
    await assertFails(getDoc(doc(db(S), 'users', C)));
    await assertFails(updateDoc(doc(db(SC), 'users', P), { linkedChildIds: arrayUnion(SC) }));
  });
});

describe('gỡ liên kết', () => {
  beforeEach(async () => {
    await link(P);
    await link(M);
  });

  test('bố gỡ bé — mẹ vẫn giữ liên kết', async () => {
    await assertSucceeds(unlinkByParent(P, C));
    await assertFails(getDoc(doc(db(P), 'users', C)));
    await assertSucceeds(getDoc(doc(db(M), 'users', C)));
  });

  test('bé gỡ một người', async () => {
    await assertSucceeds(unlinkByChild(C, M));
    await assertFails(getDoc(doc(db(C), 'users', M)));
    await assertSucceeds(getDoc(doc(db(C), 'users', P)));
  });

  test('chỉ gỡ được chính mình, không gỡ hộ người khác', async () => {
    // Bố không gỡ được mẹ khỏi bé
    await assertFails(updateDoc(doc(db(P), 'users', C), { linkedParentIds: arrayRemove(M) }));
    await assertFails(updateDoc(doc(db(P), 'users', C), { linkedParentIds: [] }));
    // Người lạ không gỡ được ai
    await assertFails(updateDoc(doc(db(SC), 'users', P), { linkedChildIds: arrayRemove(C) }));
    await assertFails(updateDoc(doc(db(S), 'users', C), { linkedParentIds: arrayRemove(P) }));
    // Con không gỡ anh/chị/em khỏi bố/mẹ
    await env.withSecurityRulesDisabled((ctx) =>
      updateDoc(doc(ctx.firestore(), 'users', P), { linkedChildIds: [C, 'sibling'] }));
    await assertFails(updateDoc(doc(db(C), 'users', P), { linkedChildIds: arrayRemove('sibling') }));
  });
});

describe('vùng an toàn của bé (tối đa 3)', () => {
  beforeEach(async () => {
    await link(P);
    await link(M);
  });

  test('mọi bố/mẹ đang liên kết thêm/xoá được, bé chỉ đọc', async () => {
    await assertSucceeds(setDoc(doc(db(P), 'users', C, 'zones', 'z1'), zone('Nhà')));
    await assertSucceeds(setDoc(doc(db(M), 'users', C, 'zones', 'z2'), zone('Trường')));
    await assertSucceeds(getDocs(collection(db(C), 'users', C, 'zones')));
    await assertSucceeds(getDocs(collection(db(M), 'users', C, 'zones')));
    await assertFails(setDoc(doc(db(C), 'users', C, 'zones', 'z3'), zone()));
    await assertFails(deleteDoc(doc(db(C), 'users', C, 'zones', 'z1')));
    await assertSucceeds(deleteDoc(doc(db(M), 'users', C, 'zones', 'z1')));
  });

  test('tối đa 3 vùng, không ghi đè ô đã có', async () => {
    await assertFails(setDoc(doc(db(P), 'users', C, 'zones', 'z4'), zone()));
    await assertFails(setDoc(doc(db(P), 'users', C, 'zones', 'abc'), zone()));
    await setDoc(doc(db(P), 'users', C, 'zones', 'z1'), zone());
    await assertFails(setDoc(doc(db(M), 'users', C, 'zones', 'z1'), zone('Khác')));
  });

  test('người lạ / người đã gỡ không đọc, không sửa', async () => {
    await setDoc(doc(db(P), 'users', C, 'zones', 'z1'), zone());
    await assertFails(getDocs(collection(db(S), 'users', C, 'zones')));
    await assertFails(setDoc(doc(db(S), 'users', C, 'zones', 'z2'), zone()));
    await unlinkByParent(M, C);
    await assertFails(getDocs(collection(db(M), 'users', C, 'zones')));
    await assertFails(deleteDoc(doc(db(M), 'users', C, 'zones', 'z1')));
  });
});

describe('sự kiện geofence', () => {
  test('bé ghi sự kiện cho từng bố/mẹ đang liên kết', async () => {
    await link(P);
    await link(M);
    const ev = { childUid: C, zoneId: 'z1', status: 'enter' };
    await assertSucceeds(setDoc(doc(db(C), 'users', P, 'geofence_events', 'e1'), ev));
    await assertSucceeds(setDoc(doc(db(C), 'users', M, 'geofence_events', 'e1'), ev));
    await assertFails(setDoc(doc(db(C), 'users', S, 'geofence_events', 'e1'), ev));
    await assertFails(getDocs(collection(db(M), 'users', P, 'geofence_events')));
  });
});

describe('vị trí của bé', () => {
  const loc = (extra = {}) => ({
    lat: 10.7, lng: 106.7, accuracy: 12, updatedAt: serverTimestamp(), sharingUntil: null, ...extra,
  });

  beforeEach(async () => {
    await link(P);
    await link(M);
  });

  test('bé ghi (cả ghi đè), bố/mẹ đang liên kết đọc realtime', async () => {
    const ref = (uid) => doc(db(uid), 'users', C, 'location', 'current');
    await assertSucceeds(setDoc(ref(C), loc()));
    await assertSucceeds(setDoc(ref(C), loc({ lat: 10.8, sharingUntil: new Date() })));
    await assertSucceeds(getDoc(ref(P)));
    await assertSucceeds(getDoc(ref(M)));
    await assertFails(getDoc(ref(S)));
    await assertFails(getDoc(ref(SC)));
  });

  test('chỉ doc current, đúng các trường; bố/mẹ không ghi vị trí của bé', async () => {
    await assertFails(setDoc(doc(db(C), 'users', C, 'location', 'other'), loc()));
    await assertFails(setDoc(doc(db(C), 'users', C, 'location', 'current'), loc({ hack: 1 })));
    await assertFails(setDoc(doc(db(C), 'users', C, 'location', 'current'), loc({ lat: 'x' })));
    await assertFails(setDoc(doc(db(P), 'users', C, 'location', 'current'), loc()));
    await assertFails(setDoc(doc(db(SC), 'users', C, 'location', 'current'), loc()));
  });

  test('người đã gỡ liên kết không đọc được nữa', async () => {
    await setDoc(doc(db(C), 'users', C, 'location', 'current'), loc());
    await unlinkByParent(M, C);
    await assertFails(getDoc(doc(db(M), 'users', C, 'location', 'current')));
    await assertSucceeds(getDoc(doc(db(P), 'users', C, 'location', 'current')));
  });

  const req = (from) => ({ fromUid: from, fromName: from, createdAt: serverTimestamp() });

  test('bố/mẹ nhờ bé chia sẻ (hỏi lại = ghi đè); bé thấy hết và xoá', async () => {
    await assertSucceeds(setDoc(doc(db(P), 'users', C, 'location_requests', P), req(P)));
    await assertSucceeds(setDoc(doc(db(P), 'users', C, 'location_requests', P), req(P)));
    await assertSucceeds(setDoc(doc(db(M), 'users', C, 'location_requests', M), req(M)));
    const snap = await assertSucceeds(getDocs(collection(db(C), 'users', C, 'location_requests')));
    if (snap.size !== 2) throw new Error(`expected 2 requests, got ${snap.size}`);
    await assertSucceeds(getDoc(doc(db(P), 'users', C, 'location_requests', P)));
    await assertSucceeds(deleteDoc(doc(db(C), 'users', C, 'location_requests', M)));
    await assertSucceeds(deleteDoc(doc(db(P), 'users', C, 'location_requests', P)));
  });

  test('không giả danh, không đọc yêu cầu người khác, người lạ không nhờ được', async () => {
    await assertFails(setDoc(doc(db(P), 'users', C, 'location_requests', M), req(M)));
    await assertFails(setDoc(doc(db(P), 'users', C, 'location_requests', P), req(M)));
    await assertFails(setDoc(doc(db(S), 'users', C, 'location_requests', S), req(S)));
    await setDoc(doc(db(M), 'users', C, 'location_requests', M), req(M));
    await assertFails(getDoc(doc(db(P), 'users', C, 'location_requests', M)));
    await assertFails(getDocs(collection(db(P), 'users', C, 'location_requests')));
    await assertFails(deleteDoc(doc(db(P), 'users', C, 'location_requests', M)));
  });
});

describe('todos (thuộc về bé, các bố/mẹ dùng chung)', () => {
  beforeEach(async () => {
    await link(P);
    await link(M);
  });

  test('bố/mẹ đang liên kết giao việc, người khác không', async () => {
    await assertSucceeds(setDoc(doc(db(P), 'todos', 't1'), newTodo(P, C)));
    await assertSucceeds(setDoc(doc(db(M), 'todos', 't2'), newTodo(M, C)));
    await assertFails(setDoc(doc(db(P), 'todos', 't3'), newTodo(P, SC)));
    await assertFails(setDoc(doc(db(S), 'todos', 't4'), newTodo(S, C)));
    await assertFails(setDoc(doc(db(S), 'todos', 't5'), newTodo(P, C)));
  });

  test('bố thấy cả việc mẹ giao (query theo bé, realtime)', async () => {
    await setDoc(doc(db(P), 'todos', 't1'), newTodo(P, C));
    await setDoc(doc(db(M), 'todos', 't2'), newTodo(M, C));
    const snap = await assertSucceeds(getDocs(query(collection(db(P), 'todos'),
      where('assignedChildId', '==', C))));
    if (snap.size !== 2) throw new Error(`expected 2 todos, got ${snap.size}`);
    await assertSucceeds(getDocs(query(collection(db(C), 'todos'), where('assignedChildId', '==', C))));
    await assertFails(getDocs(query(collection(db(S), 'todos'), where('assignedChildId', '==', C))));
    await assertFails(getDocs(collection(db(S), 'todos')));
  });

  test('bố/mẹ sửa/xoá việc của nhau; bé chỉ đánh dấu hoàn thành', async () => {
    await setDoc(doc(db(P), 'todos', 't1'), newTodo(P, C));
    await assertSucceeds(updateDoc(doc(db(M), 'todos', 't1'), { title: 'Đọc sách' }));
    await assertFails(updateDoc(doc(db(M), 'todos', 't1'), { createdBy: M }));
    await assertSucceeds(updateDoc(doc(db(C), 'todos', 't1'), {
      isCompleted: true, completedAt: serverTimestamp(),
    }));
    await assertFails(updateDoc(doc(db(C), 'todos', 't1'), { title: 'Chơi game' }));
    await assertFails(deleteDoc(doc(db(C), 'todos', 't1')));
    await assertSucceeds(deleteDoc(doc(db(M), 'todos', 't1')));
  });

  test('bé tự thêm việc cho mình, sửa/xoá việc mình tạo', async () => {
    await assertSucceeds(setDoc(doc(db(C), 'todos', 'c1'), newTodo(C, C)));
    await assertSucceeds(updateDoc(doc(db(C), 'todos', 'c1'), { title: 'Tưới cây' }));
    await assertFails(updateDoc(doc(db(C), 'todos', 'c1'), { assignedChildId: SC }));
    // Bố/mẹ vẫn thấy và sửa/xoá được
    await assertSucceeds(updateDoc(doc(db(M), 'todos', 'c1'), { title: 'Tưới cây sáng' }));
    await assertSucceeds(deleteDoc(doc(db(C), 'todos', 'c1')));
    await setDoc(doc(db(C), 'todos', 'c2'), newTodo(C, C));
    await assertSucceeds(deleteDoc(doc(db(P), 'todos', 'c2')));
  });

  test('bé không thêm việc cho bé khác, không xoá việc bố/mẹ giao', async () => {
    await assertFails(setDoc(doc(db(C), 'todos', 'c1'), newTodo(C, SC)));
    await assertFails(setDoc(doc(db(C), 'todos', 'c2'), newTodo(P, C)));
    // Bố/mẹ không giả làm "bé tự tạo" cho chính mình
    await assertFails(setDoc(doc(db(S), 'todos', 'c3'), newTodo(S, S)));
    await setDoc(doc(db(P), 'todos', 't1'), newTodo(P, C));
    await assertFails(deleteDoc(doc(db(C), 'todos', 't1')));
  });

  test('người đã gỡ liên kết mất quyền với việc của bé', async () => {
    await setDoc(doc(db(P), 'todos', 't1'), newTodo(P, C));
    await unlinkByParent(P, C);
    await assertFails(getDocs(query(collection(db(P), 'todos'), where('assignedChildId', '==', C))));
    await assertFails(updateDoc(doc(db(P), 'todos', 't1'), { title: 'x' }));
    // Mẹ vẫn thấy
    await assertSucceeds(getDocs(query(collection(db(M), 'todos'), where('assignedChildId', '==', C))));
  });
});

describe('lời nhắn gửi (bé nhờ bố/mẹ)', () => {
  const note = (childId, extra = {}) => ({
    childId, title: 'Mua bút chì', emoji: '✏️', createdAt: serverTimestamp(),
    isCompleted: false, completedAt: null, completedBy: null, completedByName: null, ...extra,
  });
  const done = (by) => ({
    isCompleted: true, completedAt: serverTimestamp(), completedBy: by, completedByName: by,
  });

  beforeEach(async () => {
    await link(P);
    await link(M);
  });

  test('bé viết; mọi bố/mẹ đang liên kết thấy (query theo bé)', async () => {
    await assertSucceeds(setDoc(doc(db(C), 'parent_todos', 'n1'), note(C)));
    for (const uid of [C, P, M]) {
      await assertSucceeds(getDocs(query(collection(db(uid), 'parent_todos'), where('childId', '==', C))));
    }
    await assertFails(getDocs(query(collection(db(S), 'parent_todos'), where('childId', '==', C))));
    await assertFails(getDocs(collection(db(P), 'parent_todos')));
  });

  test('chỉ bé tạo cho chính mình, chưa hoàn thành, tiêu đề hợp lệ', async () => {
    await assertFails(setDoc(doc(db(P), 'parent_todos', 'n1'), note(P)));
    await assertFails(setDoc(doc(db(P), 'parent_todos', 'n2'), note(C)));
    await assertFails(setDoc(doc(db(C), 'parent_todos', 'n3'), note(SC)));
    await assertFails(setDoc(doc(db(C), 'parent_todos', 'n4'), note(C, done(C))));
    await assertFails(setDoc(doc(db(C), 'parent_todos', 'n5'), note(C, { title: '' })));
    await assertFails(setDoc(doc(db(C), 'parent_todos', 'n6'), note(C, { hack: 1 })));
  });

  test('bố/mẹ đánh dấu đã làm bằng tên mình, bỏ đánh dấu được; không sửa nội dung', async () => {
    await setDoc(doc(db(C), 'parent_todos', 'n1'), note(C));
    await assertFails(updateDoc(doc(db(M), 'parent_todos', 'n1'), done(P)));
    await assertSucceeds(updateDoc(doc(db(M), 'parent_todos', 'n1'), done(M)));
    await assertSucceeds(updateDoc(doc(db(P), 'parent_todos', 'n1'), {
      isCompleted: false, completedAt: null, completedBy: null, completedByName: null,
    }));
    await assertFails(updateDoc(doc(db(P), 'parent_todos', 'n1'), { title: 'Khác' }));
    await assertFails(updateDoc(doc(db(S), 'parent_todos', 'n1'), done(S)));
    await assertFails(deleteDoc(doc(db(P), 'parent_todos', 'n1')));
  });

  test('bé sửa nội dung, xoá; không tự đánh dấu hộ bố/mẹ', async () => {
    await setDoc(doc(db(C), 'parent_todos', 'n1'), note(C));
    await assertSucceeds(updateDoc(doc(db(C), 'parent_todos', 'n1'), { title: 'Mua vở' }));
    await assertFails(updateDoc(doc(db(C), 'parent_todos', 'n1'), done(C)));
    await assertFails(updateDoc(doc(db(C), 'parent_todos', 'n1'), { childId: SC }));
    await assertSucceeds(deleteDoc(doc(db(C), 'parent_todos', 'n1')));
  });

  test('người đã gỡ liên kết không thấy, không đánh dấu', async () => {
    await setDoc(doc(db(C), 'parent_todos', 'n1'), note(C));
    await unlinkByParent(M, C);
    await assertFails(getDocs(query(collection(db(M), 'parent_todos'), where('childId', '==', C))));
    await assertFails(updateDoc(doc(db(M), 'parent_todos', 'n1'), done(M)));
  });
});

// Mô phỏng đúng các lệnh ghi của client (GuestAuthService / AuthService).
describe('luồng client', () => {
  test('createProfile: users + link_codes trong một batch', async () => {
    const uid = 'new-guest';
    const fs = db(uid);
    const batch = writeBatch(fs);
    batch.set(doc(fs, 'users', uid), {
      uid, name: 'Con', nameSet: false, email: null, photoUrl: null, fcmToken: null,
      role: 'child', isGuest: true, linkCode: 'NEW-GST',
      linkedParentIds: [], linkedChildIds: [], createdAt: serverTimestamp(),
    });
    batch.set(doc(fs, 'link_codes', 'NEW-GST'), { uid, role: 'child' });
    await assertSucceeds(batch.commit());
  });

  test('ensureLinkCode: bổ sung link_codes cho tài khoản cũ', async () => {
    await env.withSecurityRulesDisabled((ctx) =>
      deleteDoc(doc(ctx.firestore(), 'link_codes', CODES[P])));
    await assertSucceeds(setDoc(doc(db(P), 'link_codes', CODES[P]), { uid: P, role: 'parent' }));
  });

  test('regenerateLinkCode: tạo mã mới, xoá mã cũ, cập nhật hồ sơ', async () => {
    const fs = db(P);
    const batch = writeBatch(fs);
    batch.set(doc(fs, 'link_codes', 'REG-NEW'), { uid: P, role: 'parent' });
    batch.delete(doc(fs, 'link_codes', CODES[P]));
    batch.update(doc(fs, 'users', P), { linkCode: 'REG-NEW' });
    await assertSucceeds(batch.commit());
  });

  test('markEmailVerified + updateName', async () => {
    await assertSucceeds(updateDoc(doc(db(P), 'users', P), { isGuest: false, email: 'a@b.com' }));
    await assertSucceeds(updateDoc(doc(db(P), 'users', P), { name: 'Mẹ Lan', nameSet: true }));
  });
});
