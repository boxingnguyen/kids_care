// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Kids Care';

  @override
  String get back => '戻る';

  @override
  String get home => 'ホーム';

  @override
  String get tasks => 'タスク';

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
      '登録不要のお試しモードです。データはこの端末だけに保存されます。連携コードを控えて、アカウントをアップグレードするとデータを失いません。';

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
  String googleLoginFailed(String message) {
    return 'Googleログインに失敗しました：$message';
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
  String get resetSuccessMessage => 'パスワードが変更されました。ログインしてKids Careを続けましょう！';

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
  String get noNotifications => 'お知らせはまだありません';

  @override
  String get childNoStatusYet => 'お子さまからの更新はまだありません';

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
  String get upgradeAccount => 'アカウントをアップグレード';

  @override
  String get upgradeAccountSubtitle => 'Googleと連携してデータを守りましょう';

  @override
  String get accountUpgraded => 'アカウントをアップグレードしました！';

  @override
  String get googleAccountInUse => 'このGoogleアカウントは別のアカウントで使われています';

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
  String get myTasksTitle => 'わたしのタスク 🌟';

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
}
