// Nội dung thông báo đẩy — chép từ lib/l10n/app_*.arb (geofenceLeft /
// geofenceEntered, eventShare*, eventTodo*, eventNoteCreated, statusLabel*). Sửa .arb thì sửa
// cả ở đây.

const STRINGS = {
  vi: {
    left: (name, zone) => `${name} vừa rời khỏi ${zone}`,
    entered: (name, zone) => `${name} đã vào ${zone}`,
    shareStarted: (name) => `${name} đang chia sẻ vị trí trực tiếp`,
    shareStopped: (name) => `${name} đã dừng chia sẻ vị trí`,
    todoCreated: (name, title) => `${name} vừa thêm việc: ${title}`,
    todoDone: (name, title) => `${name} đã làm xong: ${title}`,
    noteCreated: (name, title) => `${name} nhắn: ${title}`,
    status: { school: "Con đang đi học", playing: "Con đang đi chơi", home: "Con đã về nhà", arrived: "Con đã đến trường" },
  },
  en: {
    left: (name, zone) => `${name} just left ${zone}`,
    entered: (name, zone) => `${name} arrived at ${zone}`,
    shareStarted: (name) => `${name} is sharing live location`,
    shareStopped: (name) => `${name} stopped sharing location`,
    todoCreated: (name, title) => `${name} added a to-do: ${title}`,
    todoDone: (name, title) => `${name} finished: ${title}`,
    noteCreated: (name, title) => `${name} asks: ${title}`,
    status: { school: "At school", playing: "Playing", home: "Back home", arrived: "Arrived" },
  },
  pt: {
    left: (name, zone) => `${name} acabou de sair de ${zone}`,
    entered: (name, zone) => `${name} chegou em ${zone}`,
    shareStarted: (name) => `${name} está compartilhando a localização ao vivo`,
    shareStopped: (name) => `${name} parou de compartilhar a localização`,
    todoCreated: (name, title) => `${name} adicionou uma tarefa: ${title}`,
    todoDone: (name, title) => `${name} concluiu: ${title}`,
    noteCreated: (name, title) => `${name} pede: ${title}`,
    status: { school: "Na escola", playing: "Brincando", home: "Em casa", arrived: "Chegou" },
  },
  ja: {
    left: (name, zone) => `${name}さんが${zone}を出ました`,
    entered: (name, zone) => `${name}さんが${zone}に着きました`,
    shareStarted: (name) => `${name}が現在地をライブ共有中です`,
    shareStopped: (name) => `${name}が位置情報の共有を停止しました`,
    todoCreated: (name, title) => `${name}がやることを追加しました：${title}`,
    todoDone: (name, title) => `${name}が完了しました：${title}`,
    noteCreated: (name, title) => `${name}からのお願い：${title}`,
    status: { school: "学校", playing: "遊び中", home: "帰宅", arrived: "到着" },
  },
  zh: {
    left: (name, zone) => `${name} 刚刚离开了 ${zone}`,
    entered: (name, zone) => `${name} 已到达 ${zone}`,
    shareStarted: (name) => `${name} 正在实时共享位置`,
    shareStopped: (name) => `${name} 已停止共享位置`,
    todoCreated: (name, title) => `${name} 添加了待办：${title}`,
    todoDone: (name, title) => `${name} 完成了：${title}`,
    noteCreated: (name, title) => `${name} 留言：${title}`,
    status: { school: "上学", playing: "在玩", home: "到家了", arrived: "已到达" },
  },
  id: {
    left: (name, zone) => `${name} baru saja meninggalkan ${zone}`,
    entered: (name, zone) => `${name} sudah tiba di ${zone}`,
    shareStarted: (name) => `${name} sedang membagikan lokasi langsung`,
    shareStopped: (name) => `${name} berhenti membagikan lokasi`,
    todoCreated: (name, title) => `${name} menambahkan tugas: ${title}`,
    todoDone: (name, title) => `${name} selesai: ${title}`,
    noteCreated: (name, title) => `${name} minta: ${title}`,
    status: { school: "Di sekolah", playing: "Sedang bermain", home: "Sudah pulang", arrived: "Sudah sampai" },
  },
};

const FALLBACK_LOCALE = 'vi';

// Khớp với kênh tạo trong lib/core/notifications/local_notifications.dart
// (alertChannelId) — kênh có âm child_alert.
export const ANDROID_CHANNEL_ID = 'child_updates_v1';
export const ALERT_SOUND_ANDROID = 'child_alert';
export const ALERT_SOUND_IOS = 'child_alert.wav';

const STATUS_EMOJI = { school: '🏫', playing: '⚽', home: '🏠', arrived: '📍' };

/**
 * Mọi cập nhật của bé (ChildEventType trong lib/models/geofence_event_model.dart):
 * vào/ra vùng an toàn, trạng thái, chia sẻ vị trí, việc cần làm. Doc cũ không
 * có type = geofence.
 */
export function shouldPush(event) {
  switch (event.type ?? 'geofence') {
    case 'geofence':
      return event.status === 'enter' || event.status === 'exit';
    case 'status':
      return event.status in STATUS_EMOJI;
    case 'share_started':
    case 'share_stopped':
    case 'todo_created':
    case 'todo_done':
    case 'note_created':
      return true;
    default:
      return false;
  }
}

/** Tiêu đề + nội dung giống thông báo local trong app (describeChildEvent). */
export function buildGeofenceNotification(event, locale) {
  const t = STRINGS[locale] ?? STRINGS[FALLBACK_LOCALE];
  const name = event.childName;
  switch (event.type ?? 'geofence') {
    case 'status':
      return {
        title: `${STATUS_EMOJI[event.status] ?? '📢'} ${name}`,
        body: t.status[event.status] ?? event.status,
      };
    case 'share_started':
      return { title: `📍 ${name}`, body: t.shareStarted(name) };
    case 'share_stopped':
      return { title: `📍 ${name}`, body: t.shareStopped(name) };
    case 'todo_created':
      return { title: `📝 ${name}`, body: t.todoCreated(name, event.zoneName) };
    case 'todo_done':
      return { title: `🎉 ${name}`, body: t.todoDone(name, event.zoneName) };
    case 'note_created':
      return { title: `💌 ${name}`, body: t.noteCreated(name, event.zoneName) };
    default: {
      const isExit = event.status === 'exit';
      return {
        title: isExit ? `⚠️ ${event.zoneName}` : `✅ ${event.zoneName}`,
        body: isExit ? t.left(name, event.zoneName) : t.entered(name, event.zoneName),
      };
    }
  }
}

/** Message multicast gửi tới mọi máy của bố/mẹ. */
export function buildGeofenceMessage(event, eventId, locale, tokens) {
  return {
    tokens,
    notification: buildGeofenceNotification(event, locale),
    data: {
      type: event.type ?? 'geofence',
      eventId,
      childUid: event.childUid ?? '',
      zoneId: event.zoneId ?? '',
      status: event.status ?? '',
    },
    android: {
      priority: 'high',
      notification: { channelId: ANDROID_CHANNEL_ID, tag: eventId, sound: ALERT_SOUND_ANDROID },
    },
    apns: {
      headers: { 'apns-priority': '10' },
      payload: { aps: { sound: ALERT_SOUND_IOS } },
    },
  };
}

const STALE_TOKEN_ERRORS = new Set([
  'messaging/registration-token-not-registered',
  'messaging/invalid-registration-token',
]);

/** Token không còn dùng được (gỡ app, đăng xuất…) → xoá khỏi doc. */
export function staleTokens(tokens, responses) {
  return tokens.filter((_, i) => {
    const r = responses[i];
    return r && !r.success && STALE_TOKEN_ERRORS.has(r.error?.code);
  });
}
