// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Kids Care';

  @override
  String get back => 'Quay lại';

  @override
  String get home => 'Trang chủ';

  @override
  String get tasks => 'Nhiệm vụ';

  @override
  String get map => 'Bản đồ';

  @override
  String get settings => 'Cài đặt';

  @override
  String get notifications => 'Thông báo';

  @override
  String get cancel => 'Huỷ';

  @override
  String get delete => 'Xoá';

  @override
  String get add => 'Thêm';

  @override
  String get ok => 'OK';

  @override
  String get later => 'Để sau';

  @override
  String get login => 'Đăng nhập';

  @override
  String get register => 'Đăng ký';

  @override
  String get password => 'Mật khẩu';

  @override
  String get email => 'Email';

  @override
  String get haveAccount => 'Đã có tài khoản? ';

  @override
  String get noAccount => 'Chưa có tài khoản? ';

  @override
  String get unknown => 'Không rõ';

  @override
  String errorWithMessage(String message) {
    return 'Lỗi: $message';
  }

  @override
  String errorGeneric(String message) {
    return 'Đã có lỗi xảy ra: $message';
  }

  @override
  String unknownError(String message) {
    return 'Lỗi không xác định: $message';
  }

  @override
  String get fillAllFields => 'Vui lòng điền đầy đủ thông tin';

  @override
  String get signUpFailed => 'Đăng ký thất bại';

  @override
  String signUpFailedWithMessage(String message) {
    return 'Đăng ký thất bại: $message';
  }

  @override
  String get notFoundTitle => 'Ôi, lạc đường rồi!';

  @override
  String get notFoundMessage => 'Không tìm thấy trang này.';

  @override
  String get goHome => 'Về trang chủ';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get languageSystem => 'Theo thiết bị';

  @override
  String get chooseLanguage => 'Chọn ngôn ngữ';

  @override
  String get welcomeTagline => 'Bảo vệ con yêu mọi lúc, mọi nơi';

  @override
  String get guestModeWarning =>
      'Chế độ thử không cần đăng ký. Dữ liệu chỉ gắn với thiết bị này — hãy ghi lại mã liên kết và nâng cấp tài khoản để không mất dữ liệu.';

  @override
  String get tryAsParent => 'Thử với tư cách Bố/Mẹ';

  @override
  String get tryAsChild => 'Thử với tư cách Con';

  @override
  String get loginTagline => 'An toàn cho trẻ, bình yên cho bố mẹ';

  @override
  String get helloWave => 'Xin chào! 👋';

  @override
  String get loginSubtitle =>
      'Đăng nhập bằng email (bố/mẹ) hoặc tên đăng nhập (bé)';

  @override
  String get loginIdentifierHint => 'Email (bố/mẹ) hoặc tên đăng nhập (bé)';

  @override
  String get forgotPasswordTitle => 'Quên mật khẩu?';

  @override
  String get loginNotFound => 'Không tìm thấy tài khoản';

  @override
  String get loginWrongPassword => 'Mật khẩu không đúng';

  @override
  String get loginInvalidCredential =>
      'Email/tên đăng nhập hoặc mật khẩu không đúng';

  @override
  String loginFailed(String message) {
    return 'Đăng nhập thất bại: $message';
  }

  @override
  String googleLoginFailed(String message) {
    return 'Đăng nhập Google thất bại: $message';
  }

  @override
  String get forgotPasswordSubtitle =>
      'Đừng lo lắng, nhập email để nhận mã khôi phục nhé! 🔑';

  @override
  String get yourEmail => 'Email của bạn';

  @override
  String get sendRecoveryCode => 'Gửi mã khôi phục';

  @override
  String get strengthWeak => 'Yếu';

  @override
  String get strengthMedium => 'Trung bình';

  @override
  String get strengthGood => 'Tốt';

  @override
  String get strengthStrong => 'Mạnh';

  @override
  String get passwordMismatch => 'Mật khẩu không khớp';

  @override
  String get setNewPassword => 'Đặt mật khẩu mới';

  @override
  String get newPasswordHint => 'Mật khẩu mới phải khác mật khẩu trước đó';

  @override
  String get newPassword => 'Mật khẩu mới';

  @override
  String passwordStrength(String level) {
    return 'Độ mạnh: $level';
  }

  @override
  String get confirmNewPassword => 'Xác nhận mật khẩu mới';

  @override
  String get ruleMin8 => 'Ít nhất 8 ký tự';

  @override
  String get ruleUppercase => 'Có chữ hoa';

  @override
  String get ruleNumber => 'Có số';

  @override
  String get resetPassword => 'Đặt lại mật khẩu';

  @override
  String get resetSuccessTitle => 'Đặt lại thành công!';

  @override
  String get resetSuccessMessage =>
      'Mật khẩu đã được thay đổi. Đăng nhập để lướt cùng Kids Care!';

  @override
  String get loginNow => 'Đăng nhập ngay';

  @override
  String get emailTaken => 'Địa chỉ email đã được sử dụng';

  @override
  String get createNewAccount => 'Tạo tài khoản mới';

  @override
  String get registerSubtitle => 'Bắt đầu hành trình nuôi dưỡng cùng bé yêu 🌟';

  @override
  String get parentFullName => 'Họ và tên bố/mẹ';

  @override
  String get passwordConfirmMismatch => 'Mật khẩu xác nhận không khớp';

  @override
  String get usernameTaken => 'Tên đăng nhập đã được sử dụng';

  @override
  String get createChildAccount => 'Tạo tài khoản cho con';

  @override
  String get createChildSubtitle => 'Bắt đầu hành trình làm bạn cùng bé yêu';

  @override
  String get usernameLabelCaps => 'TÊN ĐĂNG NHẬP';

  @override
  String get childUsernameHint => 'tên/ nickname của bé';

  @override
  String get passwordLabelCaps => 'MẬT KHẨU';

  @override
  String get confirmPasswordLabelCaps => 'XÁC NHẬN MẬT KHẨU';

  @override
  String get startNow => 'BẮT ĐẦU NGAY →';

  @override
  String get callDad => 'Bố';

  @override
  String get connecting => 'Đang kết nối...';

  @override
  String get micOn => 'Bật mic';

  @override
  String get micOff => 'Tắt mic';

  @override
  String get speaker => 'Loa ngoài';

  @override
  String get video => 'Video';

  @override
  String get endCall => 'Kết thúc cuộc gọi';

  @override
  String toldParents(String status) {
    return 'Đã báo bố mẹ: $status';
  }

  @override
  String get zoneSchool => 'Trường học';

  @override
  String get zonePlayground => 'Sân chơi';

  @override
  String get zoneHome => 'Nhà';

  @override
  String get howAreYouToday => 'Hôm nay con thế nào?';

  @override
  String get pickButtonToTell => 'Chọn một nút để báo cho bố mẹ biết nhé!';

  @override
  String get statusGoSchool => 'Con đi học';

  @override
  String get statusGoPlay => 'Con đi chơi';

  @override
  String get statusArrived => 'Con đã tới';

  @override
  String get statusBackHome => 'Con đã về';

  @override
  String get callParents => 'GỌI BỐ MẸ';

  @override
  String get callParentsHint => 'Nhấn nút xanh nếu con cần bố mẹ giúp ngay!';

  @override
  String get helloCaps => 'XIN CHÀO';

  @override
  String childGreeting(String name) {
    return '$name của Bố Mẹ nha! 👋';
  }

  @override
  String get statusLabelSchool => 'Đi học';

  @override
  String get statusLabelPlaying => 'Đang chơi';

  @override
  String get statusLabelHome => 'Về nhà';

  @override
  String get statusLabelArrived => 'Đã đến';

  @override
  String get statusLabelLeft => 'Rời khỏi';

  @override
  String get linkCodeFormatError => 'Nhập mã 6 ký tự (VD: ABC-123)';

  @override
  String get notSignedIn => 'Chưa đăng nhập';

  @override
  String get linkSuccessTitle => 'Liên kết thành công!';

  @override
  String get linkSuccessMessage =>
      'Tài khoản đã được liên kết. Bắt đầu sử dụng ngay?';

  @override
  String get linkAccountTitle => 'Liên kết tài khoản';

  @override
  String get enterLinkCode => 'Nhập mã liên kết';

  @override
  String get enterLinkCodeDescription =>
      'Nhập mã 6 ký tự của bố/mẹ hoặc con để liên kết hai tài khoản với nhau.';

  @override
  String get linkCodeHint => 'VD: ABC-123';

  @override
  String get linkCode => 'Mã liên kết';

  @override
  String get linkAction => 'Liên kết';

  @override
  String get errLinkOtherParent =>
      'Mã này thuộc về tài khoản bố/mẹ khác, không thể liên kết';

  @override
  String get errLinkNotParent => 'Mã này không thuộc về tài khoản bố/mẹ';

  @override
  String get errOwnAccountNotFound => 'Không tìm thấy tài khoản của bạn';

  @override
  String get errLinkCodeNotFound => 'Không tìm thấy mã liên kết';

  @override
  String get errOwnCode => 'Đây là mã của chính bạn';

  @override
  String get errMaxZones => 'Tối đa 3 vùng an toàn';

  @override
  String get helloParents => 'Chào bố mẹ! 👋';

  @override
  String get whatToDoToday => 'Hôm nay bạn muốn làm gì?';

  @override
  String get menuNotificationsTitle => 'Thông báo từ con';

  @override
  String get menuNotificationsDesc =>
      'Con đang ở đâu, vừa báo gì, gọi khẩn cho con';

  @override
  String get menuMapTitle => 'Bản đồ & vùng an toàn';

  @override
  String get menuMapDesc => 'Đánh dấu trường, nhà, nơi chơi của con';

  @override
  String get menuTasksTitle => 'Nhiệm vụ của con';

  @override
  String get menuTasksDesc => 'Giao việc hằng ngày và xem con đã làm xong chưa';

  @override
  String get addSafeZone => 'Thêm vùng an toàn';

  @override
  String get zoneNameHint => 'Tên vùng (VD: Trường học)';

  @override
  String get zoneLimitReached => 'Đã đạt giới hạn 3 vùng';

  @override
  String get childMapTitle => 'Bản đồ của con';

  @override
  String get mapHintParent =>
      'Nhấn giữ một điểm trên bản đồ để thêm vùng an toàn mới.';

  @override
  String get mapHintChild =>
      'Đây là những nơi an toàn bố mẹ đã chọn cho con 💛';

  @override
  String get linkCodeLabel => 'Mã liên kết: ';

  @override
  String safeZonesCount(String count, String max) {
    return 'Vùng an toàn ($count/$max)';
  }

  @override
  String get noSafeZones => 'Chưa có vùng an toàn nào được thiết lập.';

  @override
  String deleteZoneSemantic(String name) {
    return 'Xoá vùng $name';
  }

  @override
  String get zoneLimitHint =>
      'Đã đạt giới hạn 3 vùng. Xoá một vùng để thêm mới.';

  @override
  String get deleteZoneTitle => 'Xoá vùng an toàn?';

  @override
  String deleteZoneMessage(String name) {
    return 'Vùng \"$name\" sẽ bị xoá khỏi bản đồ.';
  }

  @override
  String get recent => 'Gần đây';

  @override
  String updatedAtToday(String time) {
    return 'Cập nhật lúc $time hôm nay';
  }

  @override
  String childIsNear(String name) {
    return '$name đang ở gần';
  }

  @override
  String get statusSafe => '✅ An toàn';

  @override
  String get emergencyCallChild => 'Gọi khẩn cho con';

  @override
  String get voiceCallVia => 'Cuộc gọi thoại qua ZegoCloud';

  @override
  String get noNotifications => 'Chưa có thông báo';

  @override
  String get childNoStatusYet => 'Con chưa cập nhật trạng thái nào';

  @override
  String get accountSecurity => 'Tài khoản & bảo mật';

  @override
  String get logout => 'Đăng xuất';

  @override
  String get logoutSubtitle => 'Đăng xuất khỏi tài khoản hiện tại';

  @override
  String get logoutConfirmTitle => 'Đăng xuất?';

  @override
  String get logoutGuestWarning =>
      'Đây là tài khoản dùng thử. Nếu đăng xuất, dữ liệu có thể bị mất. Hãy nhờ bố mẹ trước nhé!';

  @override
  String get logoutConfirmMessage => 'Bạn có chắc muốn đăng xuất không?';

  @override
  String get stay => 'Ở lại';

  @override
  String get upgradeAccount => 'Nâng cấp tài khoản';

  @override
  String get upgradeAccountSubtitle =>
      'Liên kết với Google để không mất dữ liệu';

  @override
  String get accountUpgraded => 'Tài khoản đã được nâng cấp!';

  @override
  String get googleAccountInUse =>
      'Tài khoản Google này đã được dùng cho tài khoản khác';

  @override
  String get yourLinkCode => 'Mã liên kết của bạn';

  @override
  String get copy => 'Sao chép';

  @override
  String get linkCodeCopied => 'Đã sao chép mã liên kết';

  @override
  String get linkedAddMore => 'Đã liên kết — nhập mã để liên kết thêm';

  @override
  String get enterChildCode => 'Nhập mã của con để liên kết';

  @override
  String get enterParentCode => 'Nhập mã của bố/mẹ để liên kết';

  @override
  String pendingCount(String count) {
    return 'Cần làm ($count)';
  }

  @override
  String doneCount(String count) {
    return 'Đã hoàn thành ($count)';
  }

  @override
  String get childTasksLoadError =>
      'Ôi, chưa tải được nhiệm vụ 😢\nCon thử lại sau một chút nhé!';

  @override
  String get myTasksTitle => 'Nhiệm vụ của mình 🌟';

  @override
  String get tapTaskWhenDone => 'Chạm vào nhiệm vụ khi con làm xong nhé!';

  @override
  String doneOfTotalToday(String done, String total) {
    return 'Đã xong $done/$total nhiệm vụ hôm nay!';
  }

  @override
  String greatJobDone(String title) {
    return '🎉 Giỏi lắm! Hoàn thành \"$title\"!';
  }

  @override
  String dueShort(String date) {
    return 'Hạn $date';
  }

  @override
  String doneAt(String time) {
    return 'Xong lúc $time';
  }

  @override
  String get noTasksYetChild => 'Chưa có nhiệm vụ nào!';

  @override
  String get parentWillAssign => 'Bố/mẹ sẽ giao nhiệm vụ cho mình sớm nhé 😊';

  @override
  String parentTasksLoadError(String message) {
    return 'Không tải được danh sách nhiệm vụ.\n$message';
  }

  @override
  String get parentTasksTitle => '📋 Nhiệm vụ của con';

  @override
  String tasksCompleted(String done, String total) {
    return '$done/$total nhiệm vụ hoàn thành';
  }

  @override
  String get deleteTaskTitle => 'Xoá nhiệm vụ?';

  @override
  String deleteTaskMessage(String title) {
    return 'Bạn muốn xoá \"$title\"?';
  }

  @override
  String get taskDone => 'Xong';

  @override
  String get taskPending => 'Chờ';

  @override
  String get addTask => 'Thêm nhiệm vụ';

  @override
  String get addNewTask => '✨ Thêm nhiệm vụ mới';

  @override
  String get chooseIcon => 'Chọn biểu tượng';

  @override
  String get taskNameHint => 'Tên nhiệm vụ (ví dụ: Làm bài tập)';

  @override
  String get taskDescriptionHint => 'Mô tả thêm (không bắt buộc)';

  @override
  String dueDateLabel(String date) {
    return 'Hạn: $date';
  }

  @override
  String get pickDueDate => 'Chọn ngày hết hạn (không bắt buộc)';

  @override
  String get assignTask => 'Giao nhiệm vụ 🚀';

  @override
  String get noTasksYetParent => 'Chưa có nhiệm vụ nào';

  @override
  String get tapPlusToAssign => 'Bấm + để giao nhiệm vụ cho con nhé!';

  @override
  String get geofenceChannelName => 'Thông báo vùng an toàn';

  @override
  String get geofenceChannelDesc =>
      'Thông báo khi con vào/ra khỏi vùng an toàn';

  @override
  String geofenceLeft(String name, String zone) {
    return '$name vừa rời khỏi $zone';
  }

  @override
  String geofenceEntered(String name, String zone) {
    return '$name đã vào $zone';
  }
}
