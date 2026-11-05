import { initializeApp } from 'firebase-admin/app';
import { FieldValue, getFirestore } from 'firebase-admin/firestore';
import { getMessaging } from 'firebase-admin/messaging';
import { logger, setGlobalOptions } from 'firebase-functions/v2';
import { onDocumentCreated } from 'firebase-functions/v2/firestore';
import { buildGeofenceMessage, shouldPush, staleTokens } from './messages.js';

initializeApp();

// Cùng vùng với Firestore (asia-southeast1).
setGlobalOptions({ region: 'asia-southeast1', maxInstances: 10 });

// Con vào/ra vùng an toàn → app của con ghi users/{parentId}/geofence_events
// → gửi thông báo đẩy tới mọi máy của bố/mẹ đó (kể cả khi app tắt).
export const onGeofenceEventCreated = onDocumentCreated(
  'users/{parentId}/geofence_events/{eventId}',
  async (e) => {
    const event = e.data?.data();
    if (!event || !shouldPush(event)) return;
    const { parentId, eventId } = e.params;

    const parentRef = getFirestore().collection('users').doc(parentId);
    const parent = (await parentRef.get()).data();
    const tokens = parent?.fcmTokens ?? [];
    if (tokens.length === 0) {
      logger.info('No FCM tokens', { parentId });
      return;
    }

    const res = await getMessaging().sendEachForMulticast(
      buildGeofenceMessage(event, eventId, parent.locale, tokens),
    );
    logger.info('Geofence push sent', {
      parentId,
      eventId,
      success: res.successCount,
      failure: res.failureCount,
      errors: res.responses.filter((r) => !r.success).map((r) => r.error?.code),
    });

    const stale = staleTokens(tokens, res.responses);
    if (stale.length > 0) {
      await parentRef.update({ fcmTokens: FieldValue.arrayRemove(...stale) });
    }
  },
);
