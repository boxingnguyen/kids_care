// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Kids Care';

  @override
  String get back => '返回';

  @override
  String get home => '首页';

  @override
  String get tasks => '任务';

  @override
  String get map => '地图';

  @override
  String get settings => '设置';

  @override
  String get notifications => '通知';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get add => '添加';

  @override
  String get ok => '好的';

  @override
  String get later => '稍后';

  @override
  String get login => '登录';

  @override
  String get register => '注册';

  @override
  String get password => '密码';

  @override
  String get email => '邮箱';

  @override
  String get haveAccount => '已有账号？';

  @override
  String get noAccount => '还没有账号？';

  @override
  String get unknown => '未知';

  @override
  String errorWithMessage(String message) {
    return '错误：$message';
  }

  @override
  String errorGeneric(String message) {
    return '出错了：$message';
  }

  @override
  String unknownError(String message) {
    return '未知错误：$message';
  }

  @override
  String get fillAllFields => '请填写所有信息';

  @override
  String get signUpFailed => '注册失败';

  @override
  String signUpFailedWithMessage(String message) {
    return '注册失败：$message';
  }

  @override
  String get notFoundTitle => '哎呀，迷路了！';

  @override
  String get notFoundMessage => '找不到这个页面。';

  @override
  String get goHome => '回到首页';

  @override
  String get language => '语言';

  @override
  String get languageSystem => '跟随系统';

  @override
  String get chooseLanguage => '选择语言';

  @override
  String get welcomeTagline => '随时随地守护孩子';

  @override
  String get guestModeWarning => '试用模式，无需注册。数据只保存在这台设备上——请记下关联码并升级账号，以免数据丢失。';

  @override
  String get tryAsParent => '以家长身份试用';

  @override
  String get tryAsChild => '以孩子身份试用';

  @override
  String get loginTagline => '孩子安全，父母安心';

  @override
  String get helloWave => '你好！👋';

  @override
  String get loginSubtitle => '用邮箱（家长）或用户名（孩子）登录';

  @override
  String get loginIdentifierHint => '邮箱（家长）或用户名（孩子）';

  @override
  String get forgotPasswordTitle => '忘记密码？';

  @override
  String get loginNotFound => '找不到账号';

  @override
  String get loginWrongPassword => '密码错误';

  @override
  String get loginInvalidCredential => '邮箱/用户名或密码错误';

  @override
  String loginFailed(String message) {
    return '登录失败：$message';
  }

  @override
  String googleLoginFailed(String message) {
    return 'Google 登录失败：$message';
  }

  @override
  String get forgotPasswordSubtitle => '别担心，输入邮箱即可收到找回验证码！🔑';

  @override
  String get yourEmail => '你的邮箱';

  @override
  String get sendRecoveryCode => '发送验证码';

  @override
  String get strengthWeak => '弱';

  @override
  String get strengthMedium => '中';

  @override
  String get strengthGood => '良好';

  @override
  String get strengthStrong => '强';

  @override
  String get passwordMismatch => '密码不一致';

  @override
  String get setNewPassword => '设置新密码';

  @override
  String get newPasswordHint => '新密码不能与旧密码相同';

  @override
  String get newPassword => '新密码';

  @override
  String passwordStrength(String level) {
    return '强度：$level';
  }

  @override
  String get confirmNewPassword => '确认新密码';

  @override
  String get ruleMin8 => '至少 8 个字符';

  @override
  String get ruleUppercase => '包含大写字母';

  @override
  String get ruleNumber => '包含数字';

  @override
  String get resetPassword => '重置密码';

  @override
  String get resetSuccessTitle => '重置成功！';

  @override
  String get resetSuccessMessage => '密码已修改。登录继续使用 Kids Care！';

  @override
  String get loginNow => '立即登录';

  @override
  String get emailTaken => '该邮箱已被使用';

  @override
  String get createNewAccount => '创建新账号';

  @override
  String get registerSubtitle => '和宝贝一起开启育儿之旅 🌟';

  @override
  String get parentFullName => '家长姓名';

  @override
  String get passwordConfirmMismatch => '两次输入的密码不一致';

  @override
  String get usernameTaken => '该用户名已被使用';

  @override
  String get createChildAccount => '为孩子创建账号';

  @override
  String get createChildSubtitle => '和宝贝一起开启旅程';

  @override
  String get usernameLabelCaps => '用户名';

  @override
  String get childUsernameHint => '孩子的名字或昵称';

  @override
  String get passwordLabelCaps => '密码';

  @override
  String get confirmPasswordLabelCaps => '确认密码';

  @override
  String get startNow => '立即开始 →';

  @override
  String get callDad => '爸爸';

  @override
  String get connecting => '正在连接...';

  @override
  String get micOn => '打开麦克风';

  @override
  String get micOff => '关闭麦克风';

  @override
  String get speaker => '扬声器';

  @override
  String get video => '视频';

  @override
  String get endCall => '结束通话';

  @override
  String toldParents(String status) {
    return '已告诉爸爸妈妈：$status';
  }

  @override
  String get zoneSchool => '学校';

  @override
  String get zonePlayground => '游乐场';

  @override
  String get zoneHome => '家';

  @override
  String get howAreYouToday => '今天过得怎么样？';

  @override
  String get pickButtonToTell => '点一个按钮告诉爸爸妈妈吧！';

  @override
  String get statusGoSchool => '我去上学';

  @override
  String get statusGoPlay => '我去玩';

  @override
  String get statusArrived => '我到了';

  @override
  String get statusBackHome => '我回家了';

  @override
  String get callParents => '给爸爸妈妈打电话';

  @override
  String get callParentsHint => '需要帮忙时就按绿色按钮！';

  @override
  String get helloCaps => '你好';

  @override
  String childGreeting(String name) {
    return '$name，你好呀！👋';
  }

  @override
  String get statusLabelSchool => '上学';

  @override
  String get statusLabelPlaying => '在玩';

  @override
  String get statusLabelHome => '到家了';

  @override
  String get statusLabelArrived => '已到达';

  @override
  String get statusLabelLeft => '已离开';

  @override
  String get linkCodeFormatError => '请输入 6 位代码（例如：ABC-123）';

  @override
  String get notSignedIn => '尚未登录';

  @override
  String get linkSuccessTitle => '关联成功！';

  @override
  String get linkSuccessMessage => '账号已关联。现在开始使用吗？';

  @override
  String get linkAccountTitle => '关联账号';

  @override
  String get enterLinkCode => '输入关联码';

  @override
  String get enterLinkCodeDescription => '输入家长或孩子的 6 位代码，将两个账号关联起来。';

  @override
  String get linkCodeHint => '例如：ABC-123';

  @override
  String get linkCode => '关联码';

  @override
  String get linkAction => '关联';

  @override
  String get errLinkOtherParent => '该代码属于另一个家长账号，无法关联';

  @override
  String get errLinkNotParent => '该代码不属于家长账号';

  @override
  String get errOwnAccountNotFound => '找不到你的账号';

  @override
  String get errLinkCodeNotFound => '找不到关联码';

  @override
  String get errOwnCode => '这是你自己的代码';

  @override
  String get errMaxZones => '最多 3 个安全区域';

  @override
  String get helloParents => '家长您好！👋';

  @override
  String get whatToDoToday => '今天想做什么？';

  @override
  String get menuNotificationsTitle => '孩子的消息';

  @override
  String get menuNotificationsDesc => '孩子在哪儿、最新动态、紧急呼叫';

  @override
  String get menuMapTitle => '地图与安全区域';

  @override
  String get menuMapDesc => '标记孩子的学校、家和玩耍地点';

  @override
  String get menuTasksTitle => '孩子的任务';

  @override
  String get menuTasksDesc => '布置每日任务，查看完成情况';

  @override
  String get addSafeZone => '添加安全区域';

  @override
  String get zoneNameHint => '区域名称（例如：学校）';

  @override
  String get zoneLimitReached => '已达到 3 个区域上限';

  @override
  String get childMapTitle => '我的地图';

  @override
  String get mapHintParent => '长按地图上的位置即可添加安全区域。';

  @override
  String get mapHintChild => '这些是爸爸妈妈为你选的安全地点 💛';

  @override
  String get linkCodeLabel => '关联码：';

  @override
  String safeZonesCount(String count, String max) {
    return '安全区域（$count/$max）';
  }

  @override
  String get noSafeZones => '还没有设置安全区域。';

  @override
  String deleteZoneSemantic(String name) {
    return '删除区域 $name';
  }

  @override
  String get zoneLimitHint => '已达 3 个区域上限。删除一个后才能添加。';

  @override
  String get deleteZoneTitle => '删除安全区域？';

  @override
  String deleteZoneMessage(String name) {
    return '“$name”将从地图上删除。';
  }

  @override
  String get recent => '最近';

  @override
  String updatedAtToday(String time) {
    return '今天 $time 更新';
  }

  @override
  String childIsNear(String name) {
    return '$name 在附近';
  }

  @override
  String get statusSafe => '✅ 安全';

  @override
  String get emergencyCallChild => '紧急呼叫孩子';

  @override
  String get voiceCallVia => '通过 ZegoCloud 语音通话';

  @override
  String get noNotifications => '暂无通知';

  @override
  String get childNoStatusYet => '孩子还没有更新状态';

  @override
  String get accountSecurity => '账号与安全';

  @override
  String get logout => '退出登录';

  @override
  String get logoutSubtitle => '退出当前账号';

  @override
  String get logoutConfirmTitle => '退出登录？';

  @override
  String get logoutGuestWarning => '这是试用账号。退出后数据可能会丢失。请先问问爸爸妈妈！';

  @override
  String get logoutConfirmMessage => '确定要退出登录吗？';

  @override
  String get stay => '留下';

  @override
  String get upgradeAccount => '升级账号';

  @override
  String get upgradeAccountSubtitle => '关联 Google 账号，避免数据丢失';

  @override
  String get accountUpgraded => '账号已升级！';

  @override
  String get googleAccountInUse => '该 Google 账号已被其他账号使用';

  @override
  String get yourLinkCode => '你的关联码';

  @override
  String get copy => '复制';

  @override
  String get linkCodeCopied => '已复制关联码';

  @override
  String get linkedAddMore => '已关联 — 输入代码可继续关联';

  @override
  String get enterChildCode => '输入孩子的代码进行关联';

  @override
  String get enterParentCode => '输入爸爸妈妈的代码进行关联';

  @override
  String pendingCount(String count) {
    return '待完成（$count）';
  }

  @override
  String doneCount(String count) {
    return '已完成（$count）';
  }

  @override
  String get childTasksLoadError => '哎呀，任务加载失败了 😢\n等一会儿再试试吧！';

  @override
  String get myTasksTitle => '我的任务 🌟';

  @override
  String get tapTaskWhenDone => '做完后点一下任务吧！';

  @override
  String doneOfTotalToday(String done, String total) {
    return '今天完成了 $done/$total 个任务！';
  }

  @override
  String greatJobDone(String title) {
    return '🎉 真棒！完成了“$title”！';
  }

  @override
  String dueShort(String date) {
    return '截止 $date';
  }

  @override
  String doneAt(String time) {
    return '$time 完成';
  }

  @override
  String get noTasksYetChild => '还没有任务！';

  @override
  String get parentWillAssign => '爸爸妈妈很快就会给你布置任务哦 😊';

  @override
  String parentTasksLoadError(String message) {
    return '无法加载任务列表。\n$message';
  }

  @override
  String get parentTasksTitle => '📋 孩子的任务';

  @override
  String tasksCompleted(String done, String total) {
    return '已完成 $done/$total 个任务';
  }

  @override
  String get deleteTaskTitle => '删除任务？';

  @override
  String deleteTaskMessage(String title) {
    return '要删除“$title”吗？';
  }

  @override
  String get taskDone => '已完成';

  @override
  String get taskPending => '待完成';

  @override
  String get addTask => '添加任务';

  @override
  String get addNewTask => '✨ 新任务';

  @override
  String get chooseIcon => '选择图标';

  @override
  String get taskNameHint => '任务名称（例如：写作业）';

  @override
  String get taskDescriptionHint => '补充说明（可选）';

  @override
  String dueDateLabel(String date) {
    return '截止：$date';
  }

  @override
  String get pickDueDate => '选择截止日期（可选）';

  @override
  String get assignTask => '布置任务 🚀';

  @override
  String get noTasksYetParent => '还没有任务';

  @override
  String get tapPlusToAssign => '点击 + 给孩子布置任务吧！';

  @override
  String get geofenceChannelName => '安全区域提醒';

  @override
  String get geofenceChannelDesc => '孩子进入或离开安全区域时提醒';

  @override
  String geofenceLeft(String name, String zone) {
    return '$name 刚刚离开了 $zone';
  }

  @override
  String geofenceEntered(String name, String zone) {
    return '$name 已到达 $zone';
  }
}
