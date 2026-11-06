// Tạo cặp tài khoản bố/mẹ + bé đã liên kết cho App Review. Chạy lại được: tài
// khoản đã có thì giữ nguyên, thiếu gì bổ sung nấy (kể cả khi reviewer đã xoá).
//
//   REVIEW_PASSWORD=... node tool/seed_review_accounts.mjs
//
// Đi qua đúng đường của app (đăng ký thường + Firestore rules), không cần quyền
// admin. Email @kidscare.app được miễn xác thực (AuthService.needsEmailVerification),
// nên reviewer đăng nhập được ngay; đừng dùng domain này cho tài khoản thật.
import { randomInt } from 'node:crypto';
import { readFileSync } from 'node:fs';
import { createRequire } from 'node:module';

const root = new URL('../', import.meta.url);
const require = createRequire(new URL('firestore-tests/package.json', root));
const { initializeApp } = require('firebase/app');
const {
  createUserWithEmailAndPassword,
  getAuth,
  signInWithEmailAndPassword,
} = require('firebase/auth');
const {
  Timestamp,
  addDoc,
  arrayUnion,
  collection,
  doc,
  getDoc,
  getDocs,
  getFirestore,
  query,
  serverTimestamp,
  setDoc,
  updateDoc,
  where,
  writeBatch,
} = require('firebase/firestore');

const PARENT = { email: 'appreview.parent@kidscare.app', name: 'Alex', role: 'parent' };
const CHILD = { email: 'appreview_child@kidscare.app', name: 'Mia', role: 'child' };
const CODE_CHARS = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

const password = process.env.REVIEW_PASSWORD;
if (!password) {
  console.error('Set REVIEW_PASSWORD');
  process.exit(1);
}

function webOptions() {
  const source = readFileSync(new URL('lib/firebase_options.dart', root), 'utf8');
  const web = source.match(/FirebaseOptions web = FirebaseOptions\(([\s\S]*?)\);/)[1];
  const field = (name) => web.match(new RegExp(`${name}: '([^']+)'`))[1];
  return {
    apiKey: field('apiKey'),
    appId: field('appId'),
    projectId: field('projectId'),
    authDomain: field('authDomain'),
  };
}

const randomCode = () => {
  const raw = Array.from({ length: 6 }, () => CODE_CHARS[randomInt(CODE_CHARS.length)]).join('');
  return `${raw.slice(0, 3)}-${raw.slice(3)}`;
};

// Mỗi người một app Firebase riêng để cùng đăng nhập một lúc.
async function signIn(person) {
  const app = initializeApp(webOptions(), person.role);
  const auth = getAuth(app);
  let credential;
  try {
    credential = await createUserWithEmailAndPassword(auth, person.email, password);
  } catch (e) {
    if (e.code !== 'auth/email-already-in-use') throw e;
    credential = await signInWithEmailAndPassword(auth, person.email, password);
  }
  return { ...person, uid: credential.user.uid, db: getFirestore(app) };
}

// Giống GuestAuthService.createProfile.
async function ensureProfile(me) {
  const ref = doc(me.db, 'users', me.uid);
  const snap = await getDoc(ref);
  if (snap.exists()) return snap.data();

  const linkCode = randomCode();
  const profile = {
    uid: me.uid,
    name: me.name,
    nameSet: true,
    email: me.role === 'parent' ? me.email : null,
    photoUrl: null,
    fcmToken: null,
    role: me.role,
    isGuest: false,
    linkCode,
    linkedParentIds: [],
    linkedChildIds: [],
  };
  const batch = writeBatch(me.db);
  batch.set(ref, { ...profile, createdAt: serverTimestamp() });
  batch.set(doc(me.db, 'link_codes', linkCode), { uid: me.uid, role: me.role });
  await batch.commit();
  return profile;
}

// Giống LinkService.sendRequest + accept: bố/mẹ nhập mã của bé, bé chấp nhận.
async function ensureLinked(parent, child, childProfile) {
  if ((childProfile.linkedParentIds ?? []).includes(parent.uid)) return;
  const request = await addDoc(collection(parent.db, 'link_requests'), {
    fromUid: parent.uid,
    fromRole: 'parent',
    fromName: parent.name,
    toUid: child.uid,
    toRole: 'child',
    code: childProfile.linkCode,
    status: 'pending',
    createdAt: serverTimestamp(),
  });
  const batch = writeBatch(child.db);
  batch.update(doc(child.db, 'link_requests', request.id), {
    status: 'accepted',
    respondedAt: serverTimestamp(),
  });
  batch.update(doc(child.db, 'users', child.uid), {
    linkedParentIds: arrayUnion(parent.uid),
    linkedVia: request.id,
  });
  batch.update(doc(child.db, 'users', parent.uid), {
    linkedChildIds: arrayUnion(child.uid),
  });
  await batch.commit();
}

async function ensureZones(parent, child) {
  const zones = [
    { id: 'z1', name: 'Home', lat: 37.323, lng: -122.0322, radiusMeters: 500, emoji: '🏠' },
    { id: 'z2', name: 'School', lat: 37.3349, lng: -122.009, radiusMeters: 500, emoji: '🏫' },
  ];
  const ref = collection(parent.db, 'users', child.uid, 'zones');
  const taken = new Set((await getDocs(ref)).docs.map((d) => d.id));
  for (const zone of zones) {
    if (!taken.has(zone.id)) await setDoc(doc(ref, zone.id), zone);
  }
}

async function ensureTodos(parent, child) {
  const ref = collection(parent.db, 'todos');
  const existing = await getDocs(query(ref, where('assignedChildId', '==', child.uid)));
  if (!existing.empty) return;
  for (const [title, emoji] of [['Do homework', '📚'], ['Tidy your room', '🧹']]) {
    await addDoc(ref, {
      title,
      description: '',
      emoji,
      assignedChildId: child.uid,
      createdBy: parent.uid,
      isCompleted: false,
      dueDate: null,
      completedAt: null,
      createdAt: Timestamp.now(),
    });
  }
}

async function ensureNote(child) {
  const ref = collection(child.db, 'parent_todos');
  const existing = await getDocs(query(ref, where('childId', '==', child.uid)));
  if (!existing.empty) return;
  await addDoc(ref, {
    childId: child.uid,
    title: 'Please buy colored pencils',
    emoji: '✏️',
    createdAt: serverTimestamp(),
    isCompleted: false,
    completedAt: null,
    completedBy: null,
    completedByName: null,
  });
}

const parent = await signIn(PARENT);
const child = await signIn(CHILD);
await ensureProfile(parent);
const childProfile = await ensureProfile(child);
await ensureLinked(parent, child, childProfile);
await ensureZones(parent, child);
await ensureTodos(parent, child);
await ensureNote(child);

// Đọc lại bằng quyền của từng người để chắc liên kết hoạt động.
const childAfter = (await getDoc(doc(parent.db, 'users', child.uid))).data();
const parentAfter = (await getDoc(doc(child.db, 'users', parent.uid))).data();
const zoneCount = (await getDocs(collection(child.db, 'users', child.uid, 'zones'))).size;
const todoCount = (
  await getDocs(query(collection(parent.db, 'todos'), where('assignedChildId', '==', child.uid)))
).size;
console.log(
  JSON.stringify({
    parent: { email: PARENT.email, uid: parent.uid, linkedChildIds: parentAfter.linkedChildIds },
    child: { username: 'appreview_child', uid: child.uid, linkedParentIds: childAfter.linkedParentIds },
    zones: zoneCount,
    todos: todoCount,
  }),
);
process.exit(0);
