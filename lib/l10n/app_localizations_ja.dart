// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'FamHub';

  @override
  String get back => '戻る';

  @override
  String get home => 'ホーム';

  @override
  String get tasks => 'やること';

  @override
  String get map => 'マップ';

  @override
  String get settings => '設定';

  @override
  String get notifications => 'お知らせ';

  @override
  String get cancel => 'キャンセル';

  @override
  String get delete => '削除';

  @override
  String get add => '追加';

  @override
  String get ok => 'OK';

  @override
  String get later => 'あとで';

  @override
  String get login => 'ログイン';

  @override
  String get register => '登録';

  @override
  String get password => 'パスワード';

  @override
  String get email => 'メールアドレス';

  @override
  String get haveAccount => 'アカウントをお持ちですか？';

  @override
  String get noAccount => 'アカウントをお持ちでないですか？';

  @override
  String get unknown => '不明';

  @override
  String errorWithMessage(String message) {
    return 'エラー：$message';
  }

  @override
  String errorGeneric(String message) {
    return '問題が発生しました：$message';
  }

  @override
  String unknownError(String message) {
    return '不明なエラー：$message';
  }

  @override
  String get fillAllFields => 'すべての項目を入力してください';

  @override
  String get signUpFailed => '登録に失敗しました';

  @override
  String signUpFailedWithMessage(String message) {
    return '登録に失敗しました：$message';
  }

  @override
  String get notFoundTitle => 'あれ、迷子になっちゃった！';

  @override
  String get notFoundMessage => 'このページは見つかりません。';

  @override
  String get goHome => 'ホームにもどる';

  @override
  String get language => '言語';

  @override
  String get languageSystem => '端末の設定に合わせる';

  @override
  String get chooseLanguage => '言語を選ぶ';

  @override
  String get welcomeTagline => 'いつでも、どこでも、お子さまを見守ります';

  @override
  String get guestModeWarning =>
      '登録不要のお試しモードです。ログアウトや機種変更でデータを失わないよう、設定でメールアドレスを連携してください。';

  @override
  String get tryAsParent => '保護者として試す';

  @override
  String get tryAsChild => '子どもとして試す';

  @override
  String get loginTagline => '子どもに安全を、親に安心を';

  @override
  String get helloWave => 'こんにちは！👋';

  @override
  String get loginSubtitle => 'メール（保護者）またはユーザー名（お子さま）でログイン';

  @override
  String get loginIdentifierHint => 'メール（保護者）またはユーザー名（お子さま）';

  @override
  String get forgotPasswordTitle => 'パスワードをお忘れですか？';

  @override
  String get loginNotFound => 'アカウントが見つかりません';

  @override
  String get loginWrongPassword => 'パスワードが違います';

  @override
  String get loginInvalidCredential => 'メール／ユーザー名またはパスワードが違います';

  @override
  String loginFailed(String message) {
    return 'ログインに失敗しました：$message';
  }

  @override
  String get forgotPasswordSubtitle => 'ご安心ください。メールアドレスを入力すると復旧コードが届きます！🔑';

  @override
  String get yourEmail => 'メールアドレス';

  @override
  String get sendRecoveryCode => '復旧コードを送信';

  @override
  String get strengthWeak => '弱い';

  @override
  String get strengthMedium => 'ふつう';

  @override
  String get strengthGood => '良い';

  @override
  String get strengthStrong => '強い';

  @override
  String get passwordMismatch => 'パスワードが一致しません';

  @override
  String get setNewPassword => '新しいパスワードを設定';

  @override
  String get newPasswordHint => '以前とは違うパスワードにしてください';

  @override
  String get newPassword => '新しいパスワード';

  @override
  String passwordStrength(String level) {
    return '強度：$level';
  }

  @override
  String get confirmNewPassword => '新しいパスワード（確認）';

  @override
  String get ruleMin8 => '8文字以上';

  @override
  String get ruleUppercase => '大文字を含む';

  @override
  String get ruleNumber => '数字を含む';

  @override
  String get resetPassword => 'パスワードを再設定';

  @override
  String get resetSuccessTitle => '再設定が完了しました！';

  @override
  String get resetSuccessMessage => 'パスワードが変更されました。ログインしてFamHubを続けましょう！';

  @override
  String get loginNow => '今すぐログイン';

  @override
  String get emailTaken => 'このメールアドレスはすでに使われています';

  @override
  String get createNewAccount => '新しいアカウントを作成';

  @override
  String get registerSubtitle => 'お子さまとの子育ての旅をはじめましょう 🌟';

  @override
  String get parentFullName => '保護者のお名前';

  @override
  String get passwordConfirmMismatch => '確認用パスワードが一致しません';

  @override
  String get usernameTaken => 'このユーザー名はすでに使われています';

  @override
  String get createChildAccount => 'お子さまのアカウントを作成';

  @override
  String get createChildSubtitle => 'お子さまとの毎日をはじめましょう';

  @override
  String get usernameLabelCaps => 'ユーザー名';

  @override
  String get childUsernameHint => 'お子さまの名前・ニックネーム';

  @override
  String get passwordLabelCaps => 'パスワード';

  @override
  String get confirmPasswordLabelCaps => 'パスワード（確認）';

  @override
  String get startNow => 'さっそくはじめる →';

  @override
  String get callDad => 'パパ';

  @override
  String get connecting => '接続中...';

  @override
  String get micOn => 'マイクON';

  @override
  String get micOff => 'マイクOFF';

  @override
  String get speaker => 'スピーカー';

  @override
  String get video => 'ビデオ';

  @override
  String get endCall => '通話を終了';

  @override
  String toldParents(String status) {
    return 'パパ・ママに伝えたよ：$status';
  }

  @override
  String get zoneSchool => '学校';

  @override
  String get zonePlayground => '公園';

  @override
  String get zoneHome => 'おうち';

  @override
  String get howAreYouToday => 'きょうはどうしてる？';

  @override
  String get pickButtonToTell => 'ボタンをおして、パパ・ママにおしえてね！';

  @override
  String get statusGoSchool => '学校に行くよ';

  @override
  String get statusGoPlay => '遊びに行くよ';

  @override
  String get statusArrived => 'ついたよ';

  @override
  String get statusBackHome => 'ただいま';

  @override
  String get callParents => 'パパ・ママに電話';

  @override
  String get callParentsHint => 'すぐに助けてほしいときは緑のボタンをおしてね！';

  @override
  String get helloCaps => 'こんにちは';

  @override
  String childGreeting(String name) {
    return '$name、やっほー！👋';
  }

  @override
  String get statusLabelSchool => '学校';

  @override
  String get statusLabelPlaying => '遊び中';

  @override
  String get statusLabelHome => '帰宅';

  @override
  String get statusLabelArrived => '到着';

  @override
  String get statusLabelLeft => '出発';

  @override
  String get linkCodeFormatError => '6文字のコードを入力してください（例：ABC-123）';

  @override
  String get notSignedIn => 'ログインしていません';

  @override
  String get linkSuccessTitle => '連携しました！';

  @override
  String get linkSuccessMessage => 'アカウントが連携されました。さっそく使いますか？';

  @override
  String get linkAccountTitle => 'アカウント連携';

  @override
  String get enterLinkCode => '連携コードを入力';

  @override
  String get enterLinkCodeDescription =>
      '保護者またはお子さまの6文字のコードを入力して、2つのアカウントを連携します。';

  @override
  String get linkCodeHint => '例：ABC-123';

  @override
  String get linkCode => '連携コード';

  @override
  String get linkAction => '連携する';

  @override
  String get errLinkOtherParent => 'このコードは別の保護者アカウントのものなので連携できません';

  @override
  String get errLinkNotParent => 'このコードは保護者アカウントのものではありません';

  @override
  String get errOwnAccountNotFound => 'あなたのアカウントが見つかりません';

  @override
  String get errLinkCodeNotFound => '連携コードが見つかりません';

  @override
  String get errOwnCode => 'これはあなた自身のコードです';

  @override
  String get errMaxZones => '安全エリアは3つまでです';

  @override
  String get helloParents => 'こんにちは、保護者さま！👋';

  @override
  String get whatToDoToday => '今日は何をしますか？';

  @override
  String get menuNotificationsTitle => 'お子さまからのお知らせ';

  @override
  String get menuNotificationsDesc => 'お子さまの居場所・最新のお知らせ・緊急通話';

  @override
  String get menuMapTitle => 'マップと安全エリア';

  @override
  String get menuMapDesc => '学校・家・遊び場を登録';

  @override
  String get menuTasksTitle => 'お子さまのタスク';

  @override
  String get menuTasksDesc => '毎日のタスクを出して完了をチェック';

  @override
  String get addSafeZone => '安全エリアを追加';

  @override
  String get zoneNameHint => 'エリア名（例：学校）';

  @override
  String get zoneLimitReached => '3つのエリアの上限に達しました';

  @override
  String get childMapTitle => 'わたしのマップ';

  @override
  String get mapHintParent => '地図を長押しすると安全エリアを追加できます。';

  @override
  String get mapHintChild => 'パパ・ママがえらんだ安全な場所だよ 💛';

  @override
  String get linkCodeLabel => '連携コード：';

  @override
  String safeZonesCount(String count, String max) {
    return '安全エリア（$count/$max）';
  }

  @override
  String get noSafeZones => 'まだ安全エリアがありません。';

  @override
  String deleteZoneSemantic(String name) {
    return 'エリア「$name」を削除';
  }

  @override
  String get zoneLimitHint => '3つの上限に達しました。新しく追加するには1つ削除してください。';

  @override
  String get deleteZoneTitle => '安全エリアを削除しますか？';

  @override
  String deleteZoneMessage(String name) {
    return '「$name」が地図から削除されます。';
  }

  @override
  String get recent => '最近';

  @override
  String updatedAtToday(String time) {
    return '今日 $time に更新';
  }

  @override
  String childIsNear(String name) {
    return '$nameの現在地';
  }

  @override
  String get statusSafe => '✅ 安全';

  @override
  String get emergencyCallChild => 'お子さまに緊急通話';

  @override
  String get voiceCallVia => 'ZegoCloudで音声通話';

  @override
  String get noNotifications => 'まだお知らせはありません';

  @override
  String get childNoStatusYet => 'お子さまの状況・位置情報の共有・完了したやることがここに表示されます';

  @override
  String get accountSecurity => 'アカウントとセキュリティ';

  @override
  String get logout => 'ログアウト';

  @override
  String get logoutSubtitle => '現在のアカウントからログアウト';

  @override
  String get logoutConfirmTitle => 'ログアウトしますか？';

  @override
  String get logoutGuestWarning =>
      'これはお試しアカウントです。ログアウトするとデータが消えることがあります。先にパパ・ママに聞いてね！';

  @override
  String get logoutConfirmMessage => '本当にログアウトしますか？';

  @override
  String get stay => 'やめる';

  @override
  String get yourLinkCode => 'あなたの連携コード';

  @override
  String get copy => 'コピー';

  @override
  String get linkCodeCopied => '連携コードをコピーしました';

  @override
  String get linkedAddMore => '連携済み — コードを入力してさらに連携';

  @override
  String get enterChildCode => 'お子さまのコードを入力して連携';

  @override
  String get enterParentCode => 'パパ・ママのコードを入力して連携';

  @override
  String pendingCount(String count) {
    return 'やること（$count）';
  }

  @override
  String doneCount(String count) {
    return 'できた！（$count）';
  }

  @override
  String get childTasksLoadError => 'あれ、タスクを読みこめなかったよ 😢\nすこししてからもう一度ためしてね！';

  @override
  String get myTasksTitle => 'わたしのやること 🌟';

  @override
  String get tapTaskWhenDone => 'おわったらタスクをタップしてね！';

  @override
  String doneOfTotalToday(String done, String total) {
    return '今日は $done/$total こできたよ！';
  }

  @override
  String greatJobDone(String title) {
    return '🎉 すごい！「$title」できたね！';
  }

  @override
  String dueShort(String date) {
    return '期限 $date';
  }

  @override
  String doneAt(String time) {
    return '$time に完了';
  }

  @override
  String get noTasksYetChild => 'まだタスクはないよ！';

  @override
  String get parentWillAssign => 'パパ・ママがもうすぐタスクを出してくれるよ 😊';

  @override
  String parentTasksLoadError(String message) {
    return 'タスクを読み込めませんでした。\n$message';
  }

  @override
  String get parentTasksTitle => '📋 お子さまのタスク';

  @override
  String tasksCompleted(String done, String total) {
    return '$done/$total 件完了';
  }

  @override
  String get deleteTaskTitle => 'タスクを削除しますか？';

  @override
  String deleteTaskMessage(String title) {
    return '「$title」を削除しますか？';
  }

  @override
  String get taskDone => '完了';

  @override
  String get taskPending => '未完了';

  @override
  String get addTask => 'タスクを追加';

  @override
  String get addNewTask => '✨ 新しいタスク';

  @override
  String get chooseIcon => 'アイコンを選ぶ';

  @override
  String get taskNameHint => 'タスク名（例：宿題をする）';

  @override
  String get taskDescriptionHint => '説明（任意）';

  @override
  String dueDateLabel(String date) {
    return '期限：$date';
  }

  @override
  String get pickDueDate => '期限を選ぶ（任意）';

  @override
  String get assignTask => 'タスクを出す 🚀';

  @override
  String get noTasksYetParent => 'タスクはまだありません';

  @override
  String get tapPlusToAssign => '＋ をタップしてタスクを出しましょう！';

  @override
  String get geofenceChannelName => '安全エリアのお知らせ';

  @override
  String get geofenceChannelDesc => 'お子さまが安全エリアに出入りしたときに通知';

  @override
  String geofenceLeft(String name, String zone) {
    return '$nameさんが$zoneを出ました';
  }

  @override
  String geofenceEntered(String name, String zone) {
    return '$nameさんが$zoneに着きました';
  }

  @override
  String get searchPlaceHint => '学校・自宅・公園を検索…';

  @override
  String get searchNoResults => '場所が見つかりません';

  @override
  String get searchFailed => '検索に失敗しました。もう一度お試しください';

  @override
  String get locationPermissionDenied => '位置情報の許可がないため、現在地で地図を開けません。';

  @override
  String get locationServiceDisabled => '位置情報サービスがオフになっています。';

  @override
  String get openSettings => '設定を開く';

  @override
  String get myLocation => '現在地';

  @override
  String get linkChildToAssign =>
      'まだお子さまと連携していません。お子さまに連携コードを入力してもらうとタスクを割り当てられます。';

  @override
  String get assignTo => '割り当て先';

  @override
  String get linkEmailTitle => 'メールを連携';

  @override
  String get linkEmailSubtitle => 'メールを連携すると、機種変更や再インストール後もデータを引き継げます。';

  @override
  String get linkEmailAction => '連携して確認メールを送信';

  @override
  String get passwordTooShort => 'パスワードは6文字以上にしてください';

  @override
  String get invalidEmail => 'メールアドレスが正しくありません';

  @override
  String get tooManyRequests => '操作が多すぎます。数分後にもう一度お試しください。';

  @override
  String get verifyEmailTitle => 'メールアドレスの確認';

  @override
  String verifyEmailMessage(String email) {
    return '$email に確認リンクを送信しました。メールを開いてリンクをタップし、アプリに戻ってください。';
  }

  @override
  String get verifyEmailCheck => '確認しました';

  @override
  String get verifyEmailResend => 'メールを再送';

  @override
  String verifyEmailResendIn(int seconds) {
    return '$seconds秒後に再送できます';
  }

  @override
  String get verifyEmailSent => '確認メールを再送しました';

  @override
  String get verifyEmailNotYet => 'まだ確認されていません。メール内のリンクをタップしてください。';

  @override
  String get emailLinkedLoggedOut => 'メールを連携しました。次回はこのメールでログインするとデータを復元できます。';

  @override
  String get logoutGuestLinkTitle => 'データが失われます';

  @override
  String get logoutGuestLinkMessage =>
      'ゲストアカウントを使用中です。ログアウトするとすべてのデータと連携が完全に失われます。メールを連携して保存しましょう。';

  @override
  String get logoutAnyway => 'ログアウトする';

  @override
  String get setNameTitle => 'お名前は？';

  @override
  String get setNameParentHint => '例: ランママ';

  @override
  String get setNameChildHint => '例: ビン';

  @override
  String get save => '保存';

  @override
  String get regenerateLinkCode => '新しいコード';

  @override
  String get regenerateLinkCodeConfirm => '古いコードは使えなくなります。連携済みのアカウントはそのままです。';

  @override
  String get linkCodeRegenerated => '新しい連携コードを作成しました';

  @override
  String get confirmPasswordHint => 'パスワード（確認）';

  @override
  String get sendLinkRequest => '連携リクエストを送信';

  @override
  String get linkRequestSent => '連携リクエストを送信しました。相手の承認をお待ちください！';

  @override
  String linkRequestFromParent(String name) {
    return '$name（保護者）が連携を希望しています';
  }

  @override
  String linkRequestFromChild(String name) {
    return '$name（子ども）が連携を希望しています';
  }

  @override
  String get linkRequestHint => '承認すると、安全エリア・タスク・通知が同期されます。';

  @override
  String get accept => '承認';

  @override
  String get reject => '拒否';

  @override
  String linkRequestAccepted(String name) {
    return '$nameと連携しました';
  }

  @override
  String get pendingRequestsTitle => '承認待ち';

  @override
  String pendingRequestCode(String code) {
    return 'コード $code';
  }

  @override
  String get cancelRequest => 'リクエストを取り消す';

  @override
  String get linkedAccountsTitle => '連携中のアカウント';

  @override
  String get unlink => '連携を解除';

  @override
  String unlinkConfirmTitle(String name) {
    return '$nameとの連携を解除しますか？';
  }

  @override
  String get unlinkConfirmMessageParent =>
      'お子さまはあなたの安全エリアやタスクを見られなくなり、あなたもお子さまの通知を受け取れなくなります。コードで再連携できます。';

  @override
  String get unlinkConfirmMessageChild =>
      '安全エリアへの到着・出発がおうちの人に通知されなくなります。先におうちの人に聞いてね！';

  @override
  String get unlinked => '連携を解除しました';

  @override
  String get errRequestPending => 'リクエスト送信済み、承認待ちです';

  @override
  String get errAlreadyLinked => 'すでに連携済みです';

  @override
  String get errRequestGone => 'このリクエストは無効です。またはすでに3人と連携しています。';

  @override
  String get errChildHasParent => 'すでに別の保護者と連携しています。先に連携を解除してください。';

  @override
  String get zonesNeedChild => '安全エリアを作るには、先にお子さまと連携してください。';

  @override
  String get errMaxGuardians => 'すでに3人と連携しています。先に1人の連携を解除してください。';

  @override
  String eventShareStarted(String name) {
    return '$nameが現在地をライブ共有中です';
  }

  @override
  String eventShareStopped(String name) {
    return '$nameが位置情報の共有を停止しました';
  }

  @override
  String eventTodoCreated(String name, String title) {
    return '$nameがやることを追加しました：$title';
  }

  @override
  String eventTodoDone(String name, String title) {
    return '$nameが完了しました：$title';
  }

  @override
  String get locationRequestTitle => '位置情報の共有';

  @override
  String locationRequestBody(String name) {
    return '$nameがあなたの居場所を知りたがっています';
  }

  @override
  String get locationRequestHint => '下の「現在地をライブ共有」をタップしてね';

  @override
  String locationRequestSent(String name) {
    return '$nameに位置情報の共有をお願いしました';
  }

  @override
  String locationRequestPending(String time) {
    return '$timeにお願い済み・返事待ち';
  }

  @override
  String get liveShareNotifTitle => '位置情報を共有中';

  @override
  String get liveShareNotifText => 'おうちの人があなたの居場所を見ています';

  @override
  String get noLocationYet => 'まだ位置情報がありません — 共有をお願いしましょう';

  @override
  String liveSharingRemaining(String minutes) {
    return 'ライブ共有中・残り$minutes分';
  }

  @override
  String lastSeenAt(String time) {
    return '最終位置：$time';
  }

  @override
  String childLocationTitle(String name) {
    return '$nameはここにいます';
  }

  @override
  String askChildLocation(String name) {
    return '$nameに位置情報をお願い';
  }

  @override
  String get askAgain => 'もう一度お願い';

  @override
  String get liveBadge => 'ライブ';

  @override
  String get noChildLinkedTitle => 'お子さまと連携して位置情報と通知を受け取りましょう';

  @override
  String get linkWithChild => 'お子さまと連携';

  @override
  String get notLinkedYetHint => 'まだおうちの人と連携していません — 設定から連携してね';

  @override
  String get dismiss => '閉じる';

  @override
  String get locationServiceOff => '位置情報サービスがオフです。オンにしてもう一度試してね。';

  @override
  String get locationPermissionNeeded => 'おうちの人と共有するには位置情報の許可が必要です。';

  @override
  String get locationPermissionSettings => '位置情報の許可がオフです。設定を開いて許可してね。';

  @override
  String get locationNoFix => '位置を取得できませんでした。ひらけた場所でもう一度試してね。';

  @override
  String minutesRemaining(String minutes) {
    return '残り$minutes分';
  }

  @override
  String get liveShareHint => '60分間、おうちの人があなたの居場所を見られます';

  @override
  String get startLiveShare => '現在地をライブ共有';

  @override
  String get stopLiveShare => '共有をやめる';

  @override
  String get addTodo => 'やることを追加';

  @override
  String get addTodoTitle => 'なにをする？ ✨';

  @override
  String get addTodoHint => '例：お花に水をあげる';

  @override
  String get childCanAddTodo => '「やることを追加」で自分で追加するか、おうちの人を待ってね 😊';

  @override
  String get assignTab => 'おねがい';

  @override
  String get notesTab => 'おてがみ';

  @override
  String get notesTitle => 'おうちの人へのおてがみ 💌';

  @override
  String get notesSubtitle => 'おうちの人になにをしてほしい？';

  @override
  String notesWaiting(String count) {
    return '$count件のおてがみがへんじ待ち';
  }

  @override
  String notesDoneCount(String count) {
    return 'できた（$count）';
  }

  @override
  String get writeNote => 'おてがみを書く';

  @override
  String get addNoteTitle => 'おうちの人になにを伝える？ 💌';

  @override
  String get addNoteHint => '例：色えんぴつを買ってね';

  @override
  String get sendNote => 'おくる';

  @override
  String get deleteNoteTitle => 'おてがみを消す？';

  @override
  String noteDoneBy(String name, String time) {
    return '$nameが$timeにやったよ';
  }

  @override
  String get noteWaiting => 'おへんじ待ち…';

  @override
  String get noNotesYet => 'まだおてがみはありません';

  @override
  String get noNotesHint => '「おてがみを書く」でおうちの人にお願いしよう 😊';

  @override
  String get parentNotesTitle => '子どもからのお願い';

  @override
  String get parentNotesAllDone => 'お子さまのおてがみはすべて完了 🎉';

  @override
  String parentNotesWaiting(String count) {
    return 'お子さまからのお願い$count件 — タップで完了';
  }

  @override
  String get parentNotesEmpty => 'お子さまからのおてがみはまだありません';

  @override
  String get parentNotesEmptyHint => 'お子さまがお願いすると、ここに表示されます';

  @override
  String eventNoteCreated(String name, String title) {
    return '$nameからのお願い：$title';
  }

  @override
  String noteDoneNotif(String name, String title) {
    return '$nameがやってくれたよ：$title';
  }

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get deleteAccount => 'アカウントを削除';

  @override
  String get deleteAccountSubtitle => 'アカウントとデータを完全に削除します';

  @override
  String get deleteAccountConfirmTitle => 'アカウントを削除しますか？';

  @override
  String get deleteAccountConfirmMessage =>
      'アカウント、位置情報、安全エリア、やること、メモ、連携がすべて完全に削除されます。元に戻すことはできません。';

  @override
  String get deleteAccountAskParent => '先におうちの人に聞いてね！';

  @override
  String get deleteAccountAction => '完全に削除';

  @override
  String get deleteAccountFailed => 'アカウントを削除できませんでした。接続を確認して、もう一度お試しください。';

  @override
  String get accountDeleted => 'アカウントを削除しました';

  @override
  String get locationDisclosureTitle => 'FamHubは位置情報を使います';

  @override
  String get locationDisclosureBody =>
      'FamHubは、安全エリアへの到着や出発を連携中の保護者に知らせるため、アプリを閉じているときや使用していないときも位置情報を収集します。\n\n状況を知らせるボタンを押したときや、位置情報をリアルタイムで共有したときにも位置情報が送信されます。見られるのは連携中の保護者だけです。';

  @override
  String get locationDisclosureContinue => '続ける';

  @override
  String get locationDisclosureNotNow => '今はしない';

  @override
  String get checkInLocationHint => 'ボタンを押すと、位置情報も保護者に送信されます';
}
