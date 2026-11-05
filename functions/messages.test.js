import { test } from 'node:test';
import assert from 'node:assert/strict';
import {
  ANDROID_CHANNEL_ID,
  buildGeofenceMessage,
  buildGeofenceNotification,
  shouldPush,
  staleTokens,
} from './messages.js';

test('pushes every child update type (missing type = legacy geofence)', () => {
  assert.equal(shouldPush({ status: 'exit' }), true);
  assert.equal(shouldPush({ type: 'geofence', status: 'enter' }), true);
  assert.equal(shouldPush({ type: 'geofence', status: 'dwell' }), false);
  assert.equal(shouldPush({ type: 'status', status: 'school' }), true);
  assert.equal(shouldPush({ type: 'status', status: 'bogus' }), false);
  assert.equal(shouldPush({ type: 'share_started', status: '' }), true);
  assert.equal(shouldPush({ type: 'todo_done', zoneName: 'Homework' }), true);
  assert.equal(shouldPush({ type: 'note_created', zoneName: 'Mua bút' }), true);
  assert.equal(shouldPush({ type: 'something_new' }), false);
});

test('new update types match the in-app text', () => {
  const base = { childUid: 'kid1', childName: 'Bin', zoneName: 'Tưới cây' };
  assert.deepEqual(buildGeofenceNotification({ ...base, type: 'todo_done' }, 'vi'), {
    title: '🎉 Bin',
    body: 'Bin đã làm xong: Tưới cây',
  });
  assert.equal(
    buildGeofenceNotification({ ...base, type: 'share_started' }, 'en').body,
    'Bin is sharing live location',
  );
  assert.deepEqual(buildGeofenceNotification({ ...base, type: 'note_created' }, 'vi'), {
    title: '💌 Bin',
    body: 'Bin nhắn: Tưới cây',
  });
  assert.deepEqual(buildGeofenceNotification({ ...base, type: 'status', status: 'home' }, 'vi'), {
    title: '🏠 Bin',
    body: 'Con đã về nhà',
  });
});

const exitEvent = {
  zoneId: 'z1',
  zoneName: 'Trường',
  childUid: 'kid1',
  childName: 'Bin',
  status: 'exit',
};

test('exit event uses warning title and "left" body', () => {
  assert.deepEqual(buildGeofenceNotification(exitEvent, 'vi'), {
    title: '⚠️ Trường',
    body: 'Bin vừa rời khỏi Trường',
  });
});

test('enter event in English', () => {
  const n = buildGeofenceNotification({ ...exitEvent, status: 'enter' }, 'en');
  assert.deepEqual(n, { title: '✅ Trường', body: 'Bin arrived at Trường' });
});

test('unknown or missing locale falls back to Vietnamese', () => {
  assert.equal(buildGeofenceNotification(exitEvent, 'fr').body, 'Bin vừa rời khỏi Trường');
  assert.equal(buildGeofenceNotification(exitEvent, undefined).body, 'Bin vừa rời khỏi Trường');
});

test('message targets geofence channel with high priority and string data', () => {
  const m = buildGeofenceMessage(exitEvent, 'ev1', 'ja', ['t1', 't2']);
  assert.deepEqual(m.tokens, ['t1', 't2']);
  assert.equal(m.notification.body, 'BinさんがTrườngを出ました');
  assert.equal(m.android.priority, 'high');
  assert.equal(m.android.notification.channelId, ANDROID_CHANNEL_ID);
  assert.equal(m.android.notification.sound, 'child_alert');
  assert.equal(m.apns.headers['apns-priority'], '10');
  assert.equal(m.apns.payload.aps.sound, 'child_alert.wav');
  for (const v of Object.values(m.data)) assert.equal(typeof v, 'string');
  assert.equal(m.data.eventId, 'ev1');
});

test('only unregistered/invalid tokens are stale', () => {
  const tokens = ['ok', 'gone', 'bad', 'flaky'];
  const responses = [
    { success: true },
    { success: false, error: { code: 'messaging/registration-token-not-registered' } },
    { success: false, error: { code: 'messaging/invalid-registration-token' } },
    { success: false, error: { code: 'messaging/internal-error' } },
  ];
  assert.deepEqual(staleTokens(tokens, responses), ['gone', 'bad']);
});
