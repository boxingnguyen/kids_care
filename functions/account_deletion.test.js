// Cần Firestore emulator: cd functions && npm run test:emulator
// Không có emulator (npm test thường) thì bỏ qua.
import { beforeEach, describe, test } from 'node:test';
import assert from 'node:assert/strict';
import { getApps, initializeApp } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';
import { deleteUserData } from './account_deletion.js';

const hasEmulator = Boolean(process.env.FIRESTORE_EMULATOR_HOST);
const projectId = 'demo-kids-care';

describe('deleteUserData', { skip: !hasEmulator }, () => {
  let db;

  const exists = async (path) => (await db.doc(path).get()).exists;
  const data = async (path) => (await db.doc(path).get()).data();

  beforeEach(async () => {
    if (getApps().length === 0) initializeApp({ projectId });
    db = getFirestore();
    await fetch(
      `http://${process.env.FIRESTORE_EMULATOR_HOST}/emulator/v1/projects/${projectId}/databases/(default)/documents`,
      { method: 'DELETE' },
    );

    await db.doc('users/child').set({
      role: 'child',
      linkCode: 'CHD-111',
      linkedParentIds: ['mom', 'dad'],
    });
    await db.doc('users/mom').set({ role: 'parent', linkedChildIds: ['child', 'sibling'] });
    await db.doc('users/dad').set({ role: 'parent', linkedChildIds: ['child'] });
    await db.doc('users/sibling').set({ role: 'child', linkedParentIds: ['mom'] });
    await db.doc('users/legacy').set({ role: 'child', linkedParentId: 'mom' });

    // Dữ liệu con của bé.
    await db.doc('users/child/location/current').set({ lat: 10.7, lng: 106.7 });
    await db.doc('users/child/zones/z1').set({ name: 'Home', lat: 10.7, lng: 106.7 });
    await db.doc('users/child/location_requests/mom').set({ fromUid: 'mom' });

    // Sự kiện của bé nằm ở hồ sơ bố/mẹ — kể cả người đã gỡ liên kết.
    await db.doc('users/mom/geofence_events/e1').set({ childUid: 'child', childName: 'Mia' });
    await db.doc('users/ex/geofence_events/e2').set({ childUid: 'child', childName: 'Mia' });
    await db.doc('users/mom/geofence_events/e3').set({ childUid: 'sibling', childName: 'Sam' });

    await db.doc('link_codes/CHD-111').set({ uid: 'child', role: 'child' });
    await db.doc('link_codes/MOM-222').set({ uid: 'mom', role: 'parent' });
    await db.doc('link_requests/r1').set({ fromUid: 'child', toUid: 'mom' });
    await db.doc('link_requests/r2').set({ fromUid: 'dad', toUid: 'child' });
    await db.doc('link_requests/r3').set({ fromUid: 'dad', toUid: 'sibling' });

    await db.doc('todos/t1').set({ assignedChildId: 'child', createdBy: 'mom' });
    await db.doc('todos/t2').set({ assignedChildId: 'child', createdBy: 'child' });
    await db.doc('todos/t3').set({ assignedChildId: 'sibling', createdBy: 'mom' });
    await db.doc('todos/t4').set({ assignedChildId: 'sibling', createdBy: 'dad' });

    await db.doc('parent_todos/n1').set({ childId: 'child', title: 'Pencils' });
    await db.doc('parent_todos/n2').set({
      childId: 'sibling',
      title: 'Lunch',
      isCompleted: true,
      completedBy: 'mom',
      completedByName: 'Mom',
    });
  });

  test('xoá bé: hồ sơ, subcollection và mọi dữ liệu liên quan tới bé', async () => {
    await deleteUserData(db, 'child');

    for (const path of [
      'users/child',
      'users/child/location/current',
      'users/child/zones/z1',
      'users/child/location_requests/mom',
      'users/mom/geofence_events/e1',
      'users/ex/geofence_events/e2',
      'link_codes/CHD-111',
      'link_requests/r1',
      'link_requests/r2',
      'todos/t1',
      'todos/t2',
      'parent_todos/n1',
    ]) {
      assert.equal(await exists(path), false, `${path} phải bị xoá`);
    }
  });

  test('xoá bé: gỡ khỏi bố/mẹ, không đụng dữ liệu của bé khác', async () => {
    await deleteUserData(db, 'child');

    assert.deepEqual((await data('users/mom')).linkedChildIds, ['sibling']);
    assert.deepEqual((await data('users/dad')).linkedChildIds, []);
    for (const path of [
      'users/mom/geofence_events/e3',
      'link_codes/MOM-222',
      'link_requests/r3',
      'todos/t3',
      'todos/t4',
      'parent_todos/n2',
    ]) {
      assert.equal(await exists(path), true, `${path} phải còn`);
    }
  });

  test('xoá bố/mẹ: gỡ khỏi các bé, xoá việc đã tạo, xoá tên trong lời nhắn', async () => {
    await deleteUserData(db, 'mom');

    assert.equal(await exists('users/mom'), false);
    assert.equal(await exists('users/mom/geofence_events/e1'), false);
    assert.equal(await exists('link_codes/MOM-222'), false);
    assert.equal(await exists('todos/t1'), false);
    assert.equal(await exists('todos/t3'), false);
    assert.equal(await exists('users/child/location_requests/mom'), false);

    assert.deepEqual((await data('users/child')).linkedParentIds, ['dad']);
    assert.deepEqual((await data('users/sibling')).linkedParentIds, []);
    assert.equal('linkedParentId' in (await data('users/legacy')), false);

    assert.equal(await exists('todos/t4'), true);
    const note = await data('parent_todos/n2');
    assert.equal(note.completedBy, null);
    assert.equal(note.completedByName, null);
    assert.equal(note.title, 'Lunch');
  });

  test('gọi lại khi đã xoá vẫn thành công (thử lại an toàn)', async () => {
    await deleteUserData(db, 'child');
    await deleteUserData(db, 'child');
    assert.equal(await exists('users/child'), false);
  });

  test('hồ sơ đã mất vẫn dọn được subcollection còn sót', async () => {
    await db.doc('users/child').delete();
    await deleteUserData(db, 'child');
    assert.equal(await exists('users/child/location/current'), false);
    assert.equal(await exists('users/child/zones/z1'), false);
  });
});
