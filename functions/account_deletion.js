import { FieldValue } from 'firebase-admin/firestore';

/**
 * Xoá toàn bộ dữ liệu Firestore của [uid]. Gọi lại an toàn nếu lần trước lỗi
 * giữa chừng (Apple yêu cầu xoá cả dữ liệu liên quan, không chỉ tài khoản).
 *
 * Xoá hồ sơ không tự xoá subcollection, nên dùng recursiveDelete. Sự kiện của
 * bé nằm ở hồ sơ bố/mẹ nên cần collection group: người đã gỡ liên kết cũng còn
 * sự kiện cũ. Lời nhắn bố/mẹ đã làm thuộc về bé, nên giữ lại và chỉ bỏ tên.
 */
export async function deleteUserData(db, uid) {
  const users = db.collection('users');
  const docsOf = async (query) => (await query.get()).docs;

  const [
    childrenOfUser,
    legacyChildrenOfUser,
    parentsOfUser,
    linkCodes,
    requestsSent,
    requestsReceived,
    todosAssigned,
    todosCreated,
    notes,
    notesCompleted,
    childEvents,
  ] = await Promise.all([
    docsOf(users.where('linkedParentIds', 'array-contains', uid)),
    docsOf(users.where('linkedParentId', '==', uid)),
    docsOf(users.where('linkedChildIds', 'array-contains', uid)),
    docsOf(db.collection('link_codes').where('uid', '==', uid)),
    docsOf(db.collection('link_requests').where('fromUid', '==', uid)),
    docsOf(db.collection('link_requests').where('toUid', '==', uid)),
    docsOf(db.collection('todos').where('assignedChildId', '==', uid)),
    docsOf(db.collection('todos').where('createdBy', '==', uid)),
    docsOf(db.collection('parent_todos').where('childId', '==', uid)),
    docsOf(db.collection('parent_todos').where('completedBy', '==', uid)),
    docsOf(db.collectionGroup('geofence_events').where('childUid', '==', uid)),
  ]);

  const toDelete = new Map();
  for (const doc of [
    ...linkCodes,
    ...requestsSent,
    ...requestsReceived,
    ...todosAssigned,
    ...todosCreated,
    ...notes,
    ...childEvents,
  ]) {
    toDelete.set(doc.ref.path, doc.ref);
  }
  for (const child of [...childrenOfUser, ...legacyChildrenOfUser]) {
    const request = child.ref.collection('location_requests').doc(uid);
    toDelete.set(request.path, request);
  }

  const writer = db.bulkWriter();
  const writes = [];
  for (const ref of toDelete.values()) writes.push(writer.delete(ref));
  for (const child of childrenOfUser) {
    writes.push(writer.update(child.ref, { linkedParentIds: FieldValue.arrayRemove(uid) }));
  }
  for (const child of legacyChildrenOfUser) {
    writes.push(writer.update(child.ref, { linkedParentId: FieldValue.delete() }));
  }
  for (const parent of parentsOfUser) {
    writes.push(writer.update(parent.ref, { linkedChildIds: FieldValue.arrayRemove(uid) }));
  }
  for (const note of notesCompleted) {
    writes.push(writer.update(note.ref, { completedBy: null, completedByName: null }));
  }
  await writer.close();
  await Promise.all(writes);

  await db.recursiveDelete(users.doc(uid));
}
