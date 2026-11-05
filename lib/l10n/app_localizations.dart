import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
    Locale('ja'),
    Locale('pt'),
    Locale('vi'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In vi, this message translates to:
  /// **'Kids Care'**
  String get appTitle;

  /// No description provided for @back.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại'**
  String get back;

  /// No description provided for @home.
  ///
  /// In vi, this message translates to:
  /// **'Trang chủ'**
  String get home;

  /// No description provided for @tasks.
  ///
  /// In vi, this message translates to:
  /// **'Việc cần làm'**
  String get tasks;

  /// No description provided for @map.
  ///
  /// In vi, this message translates to:
  /// **'Bản đồ'**
  String get map;

  /// No description provided for @settings.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get settings;

  /// No description provided for @notifications.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get notifications;

  /// No description provided for @cancel.
  ///
  /// In vi, this message translates to:
  /// **'Huỷ'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In vi, this message translates to:
  /// **'Xoá'**
  String get delete;

  /// No description provided for @add.
  ///
  /// In vi, this message translates to:
  /// **'Thêm'**
  String get add;

  /// No description provided for @ok.
  ///
  /// In vi, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @later.
  ///
  /// In vi, this message translates to:
  /// **'Để sau'**
  String get later;

  /// No description provided for @login.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get login;

  /// No description provided for @register.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký'**
  String get register;

  /// No description provided for @password.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu'**
  String get password;

  /// No description provided for @email.
  ///
  /// In vi, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @haveAccount.
  ///
  /// In vi, this message translates to:
  /// **'Đã có tài khoản? '**
  String get haveAccount;

  /// No description provided for @noAccount.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có tài khoản? '**
  String get noAccount;

  /// No description provided for @unknown.
  ///
  /// In vi, this message translates to:
  /// **'Không rõ'**
  String get unknown;

  /// No description provided for @errorWithMessage.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi: {message}'**
  String errorWithMessage(String message);

  /// No description provided for @errorGeneric.
  ///
  /// In vi, this message translates to:
  /// **'Đã có lỗi xảy ra: {message}'**
  String errorGeneric(String message);

  /// No description provided for @unknownError.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi không xác định: {message}'**
  String unknownError(String message);

  /// No description provided for @fillAllFields.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng điền đầy đủ thông tin'**
  String get fillAllFields;

  /// No description provided for @signUpFailed.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký thất bại'**
  String get signUpFailed;

  /// No description provided for @signUpFailedWithMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký thất bại: {message}'**
  String signUpFailedWithMessage(String message);

  /// No description provided for @notFoundTitle.
  ///
  /// In vi, this message translates to:
  /// **'Ôi, lạc đường rồi!'**
  String get notFoundTitle;

  /// No description provided for @notFoundMessage.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy trang này.'**
  String get notFoundMessage;

  /// No description provided for @goHome.
  ///
  /// In vi, this message translates to:
  /// **'Về trang chủ'**
  String get goHome;

  /// No description provided for @language.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In vi, this message translates to:
  /// **'Theo thiết bị'**
  String get languageSystem;

  /// No description provided for @chooseLanguage.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngôn ngữ'**
  String get chooseLanguage;

  /// No description provided for @welcomeTagline.
  ///
  /// In vi, this message translates to:
  /// **'Bảo vệ con yêu mọi lúc, mọi nơi'**
  String get welcomeTagline;

  /// No description provided for @guestModeWarning.
  ///
  /// In vi, this message translates to:
  /// **'Chế độ thử không cần đăng ký. Dữ liệu chỉ gắn với thiết bị này — hãy ghi lại mã liên kết và nâng cấp tài khoản để không mất dữ liệu.'**
  String get guestModeWarning;

  /// No description provided for @tryAsParent.
  ///
  /// In vi, this message translates to:
  /// **'Thử với tư cách Bố/Mẹ'**
  String get tryAsParent;

  /// No description provided for @tryAsChild.
  ///
  /// In vi, this message translates to:
  /// **'Thử với tư cách Con'**
  String get tryAsChild;

  /// No description provided for @loginTagline.
  ///
  /// In vi, this message translates to:
  /// **'An toàn cho trẻ, bình yên cho bố mẹ'**
  String get loginTagline;

  /// No description provided for @helloWave.
  ///
  /// In vi, this message translates to:
  /// **'Xin chào! 👋'**
  String get helloWave;

  /// No description provided for @loginSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập bằng email (bố/mẹ) hoặc tên đăng nhập (bé)'**
  String get loginSubtitle;

  /// No description provided for @loginIdentifierHint.
  ///
  /// In vi, this message translates to:
  /// **'Email (bố/mẹ) hoặc tên đăng nhập (bé)'**
  String get loginIdentifierHint;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu?'**
  String get forgotPasswordTitle;

  /// No description provided for @loginNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy tài khoản'**
  String get loginNotFound;

  /// No description provided for @loginWrongPassword.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu không đúng'**
  String get loginWrongPassword;

  /// No description provided for @loginInvalidCredential.
  ///
  /// In vi, this message translates to:
  /// **'Email/tên đăng nhập hoặc mật khẩu không đúng'**
  String get loginInvalidCredential;

  /// No description provided for @loginFailed.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập thất bại: {message}'**
  String loginFailed(String message);

  /// No description provided for @googleLoginFailed.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập Google thất bại: {message}'**
  String googleLoginFailed(String message);

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Đừng lo lắng, nhập email để nhận mã khôi phục nhé! 🔑'**
  String get forgotPasswordSubtitle;

  /// No description provided for @yourEmail.
  ///
  /// In vi, this message translates to:
  /// **'Email của bạn'**
  String get yourEmail;

  /// No description provided for @sendRecoveryCode.
  ///
  /// In vi, this message translates to:
  /// **'Gửi mã khôi phục'**
  String get sendRecoveryCode;

  /// No description provided for @strengthWeak.
  ///
  /// In vi, this message translates to:
  /// **'Yếu'**
  String get strengthWeak;

  /// No description provided for @strengthMedium.
  ///
  /// In vi, this message translates to:
  /// **'Trung bình'**
  String get strengthMedium;

  /// No description provided for @strengthGood.
  ///
  /// In vi, this message translates to:
  /// **'Tốt'**
  String get strengthGood;

  /// No description provided for @strengthStrong.
  ///
  /// In vi, this message translates to:
  /// **'Mạnh'**
  String get strengthStrong;

  /// No description provided for @passwordMismatch.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu không khớp'**
  String get passwordMismatch;

  /// No description provided for @setNewPassword.
  ///
  /// In vi, this message translates to:
  /// **'Đặt mật khẩu mới'**
  String get setNewPassword;

  /// No description provided for @newPasswordHint.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu mới phải khác mật khẩu trước đó'**
  String get newPasswordHint;

  /// No description provided for @newPassword.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu mới'**
  String get newPassword;

  /// No description provided for @passwordStrength.
  ///
  /// In vi, this message translates to:
  /// **'Độ mạnh: {level}'**
  String passwordStrength(String level);

  /// No description provided for @confirmNewPassword.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận mật khẩu mới'**
  String get confirmNewPassword;

  /// No description provided for @ruleMin8.
  ///
  /// In vi, this message translates to:
  /// **'Ít nhất 8 ký tự'**
  String get ruleMin8;

  /// No description provided for @ruleUppercase.
  ///
  /// In vi, this message translates to:
  /// **'Có chữ hoa'**
  String get ruleUppercase;

  /// No description provided for @ruleNumber.
  ///
  /// In vi, this message translates to:
  /// **'Có số'**
  String get ruleNumber;

  /// No description provided for @resetPassword.
  ///
  /// In vi, this message translates to:
  /// **'Đặt lại mật khẩu'**
  String get resetPassword;

  /// No description provided for @resetSuccessTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đặt lại thành công!'**
  String get resetSuccessTitle;

  /// No description provided for @resetSuccessMessage.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu đã được thay đổi. Đăng nhập để lướt cùng Kids Care!'**
  String get resetSuccessMessage;

  /// No description provided for @loginNow.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập ngay'**
  String get loginNow;

  /// No description provided for @emailTaken.
  ///
  /// In vi, this message translates to:
  /// **'Địa chỉ email đã được sử dụng'**
  String get emailTaken;

  /// No description provided for @createNewAccount.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tài khoản mới'**
  String get createNewAccount;

  /// No description provided for @registerSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu hành trình nuôi dưỡng cùng bé yêu 🌟'**
  String get registerSubtitle;

  /// No description provided for @parentFullName.
  ///
  /// In vi, this message translates to:
  /// **'Họ và tên bố/mẹ'**
  String get parentFullName;

  /// No description provided for @passwordConfirmMismatch.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu xác nhận không khớp'**
  String get passwordConfirmMismatch;

  /// No description provided for @usernameTaken.
  ///
  /// In vi, this message translates to:
  /// **'Tên đăng nhập đã được sử dụng'**
  String get usernameTaken;

  /// No description provided for @createChildAccount.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tài khoản cho con'**
  String get createChildAccount;

  /// No description provided for @createChildSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu hành trình làm bạn cùng bé yêu'**
  String get createChildSubtitle;

  /// No description provided for @usernameLabelCaps.
  ///
  /// In vi, this message translates to:
  /// **'TÊN ĐĂNG NHẬP'**
  String get usernameLabelCaps;

  /// No description provided for @childUsernameHint.
  ///
  /// In vi, this message translates to:
  /// **'tên/ nickname của bé'**
  String get childUsernameHint;

  /// No description provided for @passwordLabelCaps.
  ///
  /// In vi, this message translates to:
  /// **'MẬT KHẨU'**
  String get passwordLabelCaps;

  /// No description provided for @confirmPasswordLabelCaps.
  ///
  /// In vi, this message translates to:
  /// **'XÁC NHẬN MẬT KHẨU'**
  String get confirmPasswordLabelCaps;

  /// No description provided for @startNow.
  ///
  /// In vi, this message translates to:
  /// **'BẮT ĐẦU NGAY →'**
  String get startNow;

  /// No description provided for @callDad.
  ///
  /// In vi, this message translates to:
  /// **'Bố'**
  String get callDad;

  /// No description provided for @connecting.
  ///
  /// In vi, this message translates to:
  /// **'Đang kết nối...'**
  String get connecting;

  /// No description provided for @micOn.
  ///
  /// In vi, this message translates to:
  /// **'Bật mic'**
  String get micOn;

  /// No description provided for @micOff.
  ///
  /// In vi, this message translates to:
  /// **'Tắt mic'**
  String get micOff;

  /// No description provided for @speaker.
  ///
  /// In vi, this message translates to:
  /// **'Loa ngoài'**
  String get speaker;

  /// No description provided for @video.
  ///
  /// In vi, this message translates to:
  /// **'Video'**
  String get video;

  /// No description provided for @endCall.
  ///
  /// In vi, this message translates to:
  /// **'Kết thúc cuộc gọi'**
  String get endCall;

  /// No description provided for @toldParents.
  ///
  /// In vi, this message translates to:
  /// **'Đã báo bố mẹ: {status}'**
  String toldParents(String status);

  /// No description provided for @zoneSchool.
  ///
  /// In vi, this message translates to:
  /// **'Trường học'**
  String get zoneSchool;

  /// No description provided for @zonePlayground.
  ///
  /// In vi, this message translates to:
  /// **'Sân chơi'**
  String get zonePlayground;

  /// No description provided for @zoneHome.
  ///
  /// In vi, this message translates to:
  /// **'Nhà'**
  String get zoneHome;

  /// No description provided for @howAreYouToday.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay con thế nào?'**
  String get howAreYouToday;

  /// No description provided for @pickButtonToTell.
  ///
  /// In vi, this message translates to:
  /// **'Chọn một nút để báo cho bố mẹ biết nhé!'**
  String get pickButtonToTell;

  /// No description provided for @statusGoSchool.
  ///
  /// In vi, this message translates to:
  /// **'Con đi học'**
  String get statusGoSchool;

  /// No description provided for @statusGoPlay.
  ///
  /// In vi, this message translates to:
  /// **'Con đi chơi'**
  String get statusGoPlay;

  /// No description provided for @statusArrived.
  ///
  /// In vi, this message translates to:
  /// **'Con đã đến'**
  String get statusArrived;

  /// No description provided for @statusBackHome.
  ///
  /// In vi, this message translates to:
  /// **'Con đã về'**
  String get statusBackHome;

  /// No description provided for @callParents.
  ///
  /// In vi, this message translates to:
  /// **'GỌI BỐ MẸ'**
  String get callParents;

  /// No description provided for @callParentsHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhấn nút xanh nếu con cần bố mẹ giúp ngay!'**
  String get callParentsHint;

  /// No description provided for @helloCaps.
  ///
  /// In vi, this message translates to:
  /// **'XIN CHÀO'**
  String get helloCaps;

  /// No description provided for @childGreeting.
  ///
  /// In vi, this message translates to:
  /// **'{name} của Bố Mẹ nha! 👋'**
  String childGreeting(String name);

  /// No description provided for @statusLabelSchool.
  ///
  /// In vi, this message translates to:
  /// **'Con đang đi học'**
  String get statusLabelSchool;

  /// No description provided for @statusLabelPlaying.
  ///
  /// In vi, this message translates to:
  /// **'Con đang đi chơi'**
  String get statusLabelPlaying;

  /// No description provided for @statusLabelHome.
  ///
  /// In vi, this message translates to:
  /// **'Con đã về nhà'**
  String get statusLabelHome;

  /// No description provided for @statusLabelArrived.
  ///
  /// In vi, this message translates to:
  /// **'Con đã đến trường'**
  String get statusLabelArrived;

  /// No description provided for @statusLabelLeft.
  ///
  /// In vi, this message translates to:
  /// **'Rời khỏi'**
  String get statusLabelLeft;

  /// No description provided for @linkCodeFormatError.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mã 6 ký tự (VD: ABC-123)'**
  String get linkCodeFormatError;

  /// No description provided for @notSignedIn.
  ///
  /// In vi, this message translates to:
  /// **'Chưa đăng nhập'**
  String get notSignedIn;

  /// No description provided for @linkSuccessTitle.
  ///
  /// In vi, this message translates to:
  /// **'Liên kết thành công!'**
  String get linkSuccessTitle;

  /// No description provided for @linkSuccessMessage.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản đã được liên kết. Bắt đầu sử dụng ngay?'**
  String get linkSuccessMessage;

  /// No description provided for @linkAccountTitle.
  ///
  /// In vi, this message translates to:
  /// **'Liên kết tài khoản'**
  String get linkAccountTitle;

  /// No description provided for @enterLinkCode.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mã liên kết'**
  String get enterLinkCode;

  /// No description provided for @enterLinkCodeDescription.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mã 6 ký tự của bố/mẹ hoặc con để liên kết hai tài khoản với nhau.'**
  String get enterLinkCodeDescription;

  /// No description provided for @linkCodeHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: ABC-123'**
  String get linkCodeHint;

  /// No description provided for @linkCode.
  ///
  /// In vi, this message translates to:
  /// **'Mã liên kết'**
  String get linkCode;

  /// No description provided for @linkAction.
  ///
  /// In vi, this message translates to:
  /// **'Liên kết'**
  String get linkAction;

  /// No description provided for @errLinkOtherParent.
  ///
  /// In vi, this message translates to:
  /// **'Mã này thuộc về tài khoản bố/mẹ khác, không thể liên kết'**
  String get errLinkOtherParent;

  /// No description provided for @errLinkNotParent.
  ///
  /// In vi, this message translates to:
  /// **'Mã này không thuộc về tài khoản bố/mẹ'**
  String get errLinkNotParent;

  /// No description provided for @errOwnAccountNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy tài khoản của bạn'**
  String get errOwnAccountNotFound;

  /// No description provided for @errLinkCodeNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy mã liên kết'**
  String get errLinkCodeNotFound;

  /// No description provided for @errOwnCode.
  ///
  /// In vi, this message translates to:
  /// **'Đây là mã của chính bạn'**
  String get errOwnCode;

  /// No description provided for @errMaxZones.
  ///
  /// In vi, this message translates to:
  /// **'Tối đa 3 vùng an toàn'**
  String get errMaxZones;

  /// No description provided for @helloParents.
  ///
  /// In vi, this message translates to:
  /// **'Chào bố mẹ! 👋'**
  String get helloParents;

  /// No description provided for @whatToDoToday.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay bạn muốn làm gì?'**
  String get whatToDoToday;

  /// No description provided for @menuNotificationsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo từ con'**
  String get menuNotificationsTitle;

  /// No description provided for @menuNotificationsDesc.
  ///
  /// In vi, this message translates to:
  /// **'Con đang ở đâu, vừa báo gì, gọi khẩn cho con'**
  String get menuNotificationsDesc;

  /// No description provided for @menuMapTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bản đồ & vùng an toàn'**
  String get menuMapTitle;

  /// No description provided for @menuMapDesc.
  ///
  /// In vi, this message translates to:
  /// **'Đánh dấu trường, nhà, nơi chơi của con'**
  String get menuMapDesc;

  /// No description provided for @menuTasksTitle.
  ///
  /// In vi, this message translates to:
  /// **'Việc cần làm của con'**
  String get menuTasksTitle;

  /// No description provided for @menuTasksDesc.
  ///
  /// In vi, this message translates to:
  /// **'Giao việc hằng ngày và xem con đã làm xong chưa'**
  String get menuTasksDesc;

  /// No description provided for @addSafeZone.
  ///
  /// In vi, this message translates to:
  /// **'Thêm vùng an toàn'**
  String get addSafeZone;

  /// No description provided for @zoneNameHint.
  ///
  /// In vi, this message translates to:
  /// **'Tên vùng (VD: Trường học)'**
  String get zoneNameHint;

  /// No description provided for @zoneLimitReached.
  ///
  /// In vi, this message translates to:
  /// **'Đã đạt giới hạn 3 vùng'**
  String get zoneLimitReached;

  /// No description provided for @childMapTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bản đồ của con'**
  String get childMapTitle;

  /// No description provided for @mapHintParent.
  ///
  /// In vi, this message translates to:
  /// **'Nhấn giữ một điểm trên bản đồ để thêm vùng an toàn mới.'**
  String get mapHintParent;

  /// No description provided for @mapHintChild.
  ///
  /// In vi, this message translates to:
  /// **'Đây là những nơi an toàn bố mẹ đã chọn cho con 💛'**
  String get mapHintChild;

  /// No description provided for @linkCodeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mã liên kết: '**
  String get linkCodeLabel;

  /// No description provided for @safeZonesCount.
  ///
  /// In vi, this message translates to:
  /// **'Vùng an toàn ({count}/{max})'**
  String safeZonesCount(String count, String max);

  /// No description provided for @noSafeZones.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có vùng an toàn nào được thiết lập.'**
  String get noSafeZones;

  /// No description provided for @deleteZoneSemantic.
  ///
  /// In vi, this message translates to:
  /// **'Xoá vùng {name}'**
  String deleteZoneSemantic(String name);

  /// No description provided for @zoneLimitHint.
  ///
  /// In vi, this message translates to:
  /// **'Đã đạt giới hạn 3 vùng. Xoá một vùng để thêm mới.'**
  String get zoneLimitHint;

  /// No description provided for @deleteZoneTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xoá vùng an toàn?'**
  String get deleteZoneTitle;

  /// No description provided for @deleteZoneMessage.
  ///
  /// In vi, this message translates to:
  /// **'Vùng \"{name}\" sẽ bị xoá khỏi bản đồ.'**
  String deleteZoneMessage(String name);

  /// No description provided for @recent.
  ///
  /// In vi, this message translates to:
  /// **'Gần đây'**
  String get recent;

  /// No description provided for @updatedAtToday.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật lúc {time} hôm nay'**
  String updatedAtToday(String time);

  /// No description provided for @childIsNear.
  ///
  /// In vi, this message translates to:
  /// **'{name} đang ở gần'**
  String childIsNear(String name);

  /// No description provided for @statusSafe.
  ///
  /// In vi, this message translates to:
  /// **'✅ An toàn'**
  String get statusSafe;

  /// No description provided for @emergencyCallChild.
  ///
  /// In vi, this message translates to:
  /// **'Gọi khẩn cho con'**
  String get emergencyCallChild;

  /// No description provided for @voiceCallVia.
  ///
  /// In vi, this message translates to:
  /// **'Cuộc gọi thoại qua ZegoCloud'**
  String get voiceCallVia;

  /// No description provided for @noNotifications.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có cập nhật nào'**
  String get noNotifications;

  /// No description provided for @childNoStatusYet.
  ///
  /// In vi, this message translates to:
  /// **'Khi con báo trạng thái, chia sẻ vị trí hay làm xong việc, bạn sẽ thấy ở đây'**
  String get childNoStatusYet;

  /// No description provided for @accountSecurity.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản & bảo mật'**
  String get accountSecurity;

  /// No description provided for @logout.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get logout;

  /// No description provided for @logoutSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất khỏi tài khoản hiện tại'**
  String get logoutSubtitle;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất?'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutGuestWarning.
  ///
  /// In vi, this message translates to:
  /// **'Đây là tài khoản dùng thử. Nếu đăng xuất, dữ liệu có thể bị mất. Hãy nhờ bố mẹ trước nhé!'**
  String get logoutGuestWarning;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc muốn đăng xuất không?'**
  String get logoutConfirmMessage;

  /// No description provided for @stay.
  ///
  /// In vi, this message translates to:
  /// **'Ở lại'**
  String get stay;

  /// No description provided for @upgradeAccount.
  ///
  /// In vi, this message translates to:
  /// **'Nâng cấp tài khoản'**
  String get upgradeAccount;

  /// No description provided for @upgradeAccountSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Liên kết với Google để không mất dữ liệu'**
  String get upgradeAccountSubtitle;

  /// No description provided for @accountUpgraded.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản đã được nâng cấp!'**
  String get accountUpgraded;

  /// No description provided for @googleAccountInUse.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản Google này đã được dùng cho tài khoản khác'**
  String get googleAccountInUse;

  /// No description provided for @yourLinkCode.
  ///
  /// In vi, this message translates to:
  /// **'Mã liên kết của bạn'**
  String get yourLinkCode;

  /// No description provided for @copy.
  ///
  /// In vi, this message translates to:
  /// **'Sao chép'**
  String get copy;

  /// No description provided for @linkCodeCopied.
  ///
  /// In vi, this message translates to:
  /// **'Đã sao chép mã liên kết'**
  String get linkCodeCopied;

  /// No description provided for @linkedAddMore.
  ///
  /// In vi, this message translates to:
  /// **'Đã liên kết — nhập mã để liên kết thêm'**
  String get linkedAddMore;

  /// No description provided for @enterChildCode.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mã của con để liên kết'**
  String get enterChildCode;

  /// No description provided for @enterParentCode.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mã của bố/mẹ để liên kết'**
  String get enterParentCode;

  /// No description provided for @pendingCount.
  ///
  /// In vi, this message translates to:
  /// **'Cần làm ({count})'**
  String pendingCount(String count);

  /// No description provided for @doneCount.
  ///
  /// In vi, this message translates to:
  /// **'Đã hoàn thành ({count})'**
  String doneCount(String count);

  /// No description provided for @childTasksLoadError.
  ///
  /// In vi, this message translates to:
  /// **'Ôi, chưa tải được việc cần làm 😢\nCon thử lại sau một chút nhé!'**
  String get childTasksLoadError;

  /// No description provided for @myTasksTitle.
  ///
  /// In vi, this message translates to:
  /// **'Việc cần làm 🌟'**
  String get myTasksTitle;

  /// No description provided for @tapTaskWhenDone.
  ///
  /// In vi, this message translates to:
  /// **'Chạm vào việc khi con làm xong nhé!'**
  String get tapTaskWhenDone;

  /// No description provided for @doneOfTotalToday.
  ///
  /// In vi, this message translates to:
  /// **'Đã xong {done}/{total} việc hôm nay!'**
  String doneOfTotalToday(String done, String total);

  /// No description provided for @greatJobDone.
  ///
  /// In vi, this message translates to:
  /// **'🎉 Giỏi lắm! Hoàn thành \"{title}\"!'**
  String greatJobDone(String title);

  /// No description provided for @dueShort.
  ///
  /// In vi, this message translates to:
  /// **'Hạn {date}'**
  String dueShort(String date);

  /// No description provided for @doneAt.
  ///
  /// In vi, this message translates to:
  /// **'Xong lúc {time}'**
  String doneAt(String time);

  /// No description provided for @noTasksYetChild.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có việc nào!'**
  String get noTasksYetChild;

  /// No description provided for @parentWillAssign.
  ///
  /// In vi, this message translates to:
  /// **'Bố/mẹ sẽ giao nhiệm vụ cho mình sớm nhé 😊'**
  String get parentWillAssign;

  /// No description provided for @parentTasksLoadError.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được danh sách việc cần làm.\n{message}'**
  String parentTasksLoadError(String message);

  /// No description provided for @parentTasksTitle.
  ///
  /// In vi, this message translates to:
  /// **'📋 Việc cần làm của con'**
  String get parentTasksTitle;

  /// No description provided for @tasksCompleted.
  ///
  /// In vi, this message translates to:
  /// **'{done}/{total} việc đã xong'**
  String tasksCompleted(String done, String total);

  /// No description provided for @deleteTaskTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xoá việc này?'**
  String get deleteTaskTitle;

  /// No description provided for @deleteTaskMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn muốn xoá \"{title}\"?'**
  String deleteTaskMessage(String title);

  /// No description provided for @taskDone.
  ///
  /// In vi, this message translates to:
  /// **'Xong'**
  String get taskDone;

  /// No description provided for @taskPending.
  ///
  /// In vi, this message translates to:
  /// **'Chờ'**
  String get taskPending;

  /// No description provided for @addTask.
  ///
  /// In vi, this message translates to:
  /// **'Thêm việc'**
  String get addTask;

  /// No description provided for @addNewTask.
  ///
  /// In vi, this message translates to:
  /// **'✨ Thêm việc mới'**
  String get addNewTask;

  /// No description provided for @chooseIcon.
  ///
  /// In vi, this message translates to:
  /// **'Chọn biểu tượng'**
  String get chooseIcon;

  /// No description provided for @taskNameHint.
  ///
  /// In vi, this message translates to:
  /// **'Tên việc (ví dụ: Làm bài tập)'**
  String get taskNameHint;

  /// No description provided for @taskDescriptionHint.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả thêm (không bắt buộc)'**
  String get taskDescriptionHint;

  /// No description provided for @dueDateLabel.
  ///
  /// In vi, this message translates to:
  /// **'Hạn: {date}'**
  String dueDateLabel(String date);

  /// No description provided for @pickDueDate.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngày hết hạn (không bắt buộc)'**
  String get pickDueDate;

  /// No description provided for @assignTask.
  ///
  /// In vi, this message translates to:
  /// **'Giao việc 🚀'**
  String get assignTask;

  /// No description provided for @noTasksYetParent.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có việc nào'**
  String get noTasksYetParent;

  /// No description provided for @tapPlusToAssign.
  ///
  /// In vi, this message translates to:
  /// **'Bấm + để giao việc cho con nhé!'**
  String get tapPlusToAssign;

  /// No description provided for @geofenceChannelName.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo vùng an toàn'**
  String get geofenceChannelName;

  /// No description provided for @geofenceChannelDesc.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo khi con vào/ra khỏi vùng an toàn'**
  String get geofenceChannelDesc;

  /// No description provided for @geofenceLeft.
  ///
  /// In vi, this message translates to:
  /// **'{name} vừa rời khỏi {zone}'**
  String geofenceLeft(String name, String zone);

  /// No description provided for @geofenceEntered.
  ///
  /// In vi, this message translates to:
  /// **'{name} đã vào {zone}'**
  String geofenceEntered(String name, String zone);

  /// No description provided for @searchPlaceHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm trường, nhà, công viên…'**
  String get searchPlaceHint;

  /// No description provided for @searchNoResults.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy địa điểm nào'**
  String get searchNoResults;

  /// No description provided for @searchFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm được, vui lòng thử lại'**
  String get searchFailed;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có quyền vị trí nên không thể mở bản đồ tại chỗ bạn đứng.'**
  String get locationPermissionDenied;

  /// No description provided for @locationServiceDisabled.
  ///
  /// In vi, this message translates to:
  /// **'Dịch vụ vị trí đang tắt.'**
  String get locationServiceDisabled;

  /// No description provided for @openSettings.
  ///
  /// In vi, this message translates to:
  /// **'Mở cài đặt'**
  String get openSettings;

  /// No description provided for @myLocation.
  ///
  /// In vi, this message translates to:
  /// **'Vị trí của tôi'**
  String get myLocation;

  /// No description provided for @linkChildToAssign.
  ///
  /// In vi, this message translates to:
  /// **'Chưa liên kết với con. Hãy cho con nhập mã liên kết để giao việc.'**
  String get linkChildToAssign;

  /// No description provided for @assignTo.
  ///
  /// In vi, this message translates to:
  /// **'Giao cho'**
  String get assignTo;

  /// No description provided for @linkEmailTitle.
  ///
  /// In vi, this message translates to:
  /// **'Liên kết email'**
  String get linkEmailTitle;

  /// No description provided for @linkEmailSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Gắn email để giữ dữ liệu và đăng nhập lại khi đổi máy hoặc cài lại app.'**
  String get linkEmailSubtitle;

  /// No description provided for @linkEmailAction.
  ///
  /// In vi, this message translates to:
  /// **'Liên kết và gửi email xác thực'**
  String get linkEmailAction;

  /// No description provided for @passwordTooShort.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu cần ít nhất 6 ký tự'**
  String get passwordTooShort;

  /// No description provided for @invalidEmail.
  ///
  /// In vi, this message translates to:
  /// **'Email không hợp lệ'**
  String get invalidEmail;

  /// No description provided for @tooManyRequests.
  ///
  /// In vi, this message translates to:
  /// **'Bạn thao tác quá nhanh, hãy thử lại sau ít phút.'**
  String get tooManyRequests;

  /// No description provided for @verifyEmailTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xác thực email'**
  String get verifyEmailTitle;

  /// No description provided for @verifyEmailMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi link xác thực tới {email}. Mở email, bấm vào link rồi quay lại app.'**
  String verifyEmailMessage(String email);

  /// No description provided for @verifyEmailCheck.
  ///
  /// In vi, this message translates to:
  /// **'Tôi đã xác thực'**
  String get verifyEmailCheck;

  /// No description provided for @verifyEmailResend.
  ///
  /// In vi, this message translates to:
  /// **'Gửi lại email'**
  String get verifyEmailResend;

  /// No description provided for @verifyEmailResendIn.
  ///
  /// In vi, this message translates to:
  /// **'Gửi lại sau {seconds}s'**
  String verifyEmailResendIn(int seconds);

  /// No description provided for @verifyEmailSent.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi lại email xác thực'**
  String get verifyEmailSent;

  /// No description provided for @verifyEmailNotYet.
  ///
  /// In vi, this message translates to:
  /// **'Email chưa được xác thực. Hãy bấm link trong email.'**
  String get verifyEmailNotYet;

  /// No description provided for @emailLinkedLoggedOut.
  ///
  /// In vi, this message translates to:
  /// **'Đã liên kết email. Lần sau đăng nhập bằng email này để lấy lại dữ liệu.'**
  String get emailLinkedLoggedOut;

  /// No description provided for @logoutGuestLinkTitle.
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu sẽ bị mất'**
  String get logoutGuestLinkTitle;

  /// No description provided for @logoutGuestLinkMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đang dùng tài khoản khách. Nếu đăng xuất, toàn bộ dữ liệu và liên kết sẽ mất vĩnh viễn. Hãy liên kết email để giữ lại.'**
  String get logoutGuestLinkMessage;

  /// No description provided for @logoutAnyway.
  ///
  /// In vi, this message translates to:
  /// **'Vẫn đăng xuất'**
  String get logoutAnyway;

  /// No description provided for @setNameTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bạn tên là gì?'**
  String get setNameTitle;

  /// No description provided for @setNameParentHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: Mẹ Lan'**
  String get setNameParentHint;

  /// No description provided for @setNameChildHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: Bin'**
  String get setNameChildHint;

  /// No description provided for @save.
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get save;

  /// No description provided for @regenerateLinkCode.
  ///
  /// In vi, this message translates to:
  /// **'Tạo mã mới'**
  String get regenerateLinkCode;

  /// No description provided for @regenerateLinkCodeConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Mã cũ sẽ không dùng được nữa. Các tài khoản đã liên kết vẫn giữ nguyên.'**
  String get regenerateLinkCodeConfirm;

  /// No description provided for @linkCodeRegenerated.
  ///
  /// In vi, this message translates to:
  /// **'Đã tạo mã liên kết mới'**
  String get linkCodeRegenerated;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập lại mật khẩu'**
  String get confirmPasswordHint;

  /// No description provided for @sendLinkRequest.
  ///
  /// In vi, this message translates to:
  /// **'Gửi yêu cầu liên kết'**
  String get sendLinkRequest;

  /// No description provided for @linkRequestSent.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi yêu cầu liên kết. Chờ bên kia chấp nhận nhé!'**
  String get linkRequestSent;

  /// No description provided for @linkRequestFromParent.
  ///
  /// In vi, this message translates to:
  /// **'{name} (bố/mẹ) muốn liên kết với bạn'**
  String linkRequestFromParent(String name);

  /// No description provided for @linkRequestFromChild.
  ///
  /// In vi, this message translates to:
  /// **'{name} (con) muốn liên kết với bạn'**
  String linkRequestFromChild(String name);

  /// No description provided for @linkRequestHint.
  ///
  /// In vi, this message translates to:
  /// **'Chấp nhận để đồng bộ vùng an toàn, việc cần làm và thông báo.'**
  String get linkRequestHint;

  /// No description provided for @accept.
  ///
  /// In vi, this message translates to:
  /// **'Chấp nhận'**
  String get accept;

  /// No description provided for @reject.
  ///
  /// In vi, this message translates to:
  /// **'Từ chối'**
  String get reject;

  /// No description provided for @linkRequestAccepted.
  ///
  /// In vi, this message translates to:
  /// **'Đã liên kết với {name}'**
  String linkRequestAccepted(String name);

  /// No description provided for @pendingRequestsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đang chờ chấp nhận'**
  String get pendingRequestsTitle;

  /// No description provided for @pendingRequestCode.
  ///
  /// In vi, this message translates to:
  /// **'Mã {code}'**
  String pendingRequestCode(String code);

  /// No description provided for @cancelRequest.
  ///
  /// In vi, this message translates to:
  /// **'Huỷ yêu cầu'**
  String get cancelRequest;

  /// No description provided for @linkedAccountsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản đã liên kết'**
  String get linkedAccountsTitle;

  /// No description provided for @unlink.
  ///
  /// In vi, this message translates to:
  /// **'Gỡ liên kết'**
  String get unlink;

  /// No description provided for @unlinkConfirmTitle.
  ///
  /// In vi, this message translates to:
  /// **'Gỡ liên kết với {name}?'**
  String unlinkConfirmTitle(String name);

  /// No description provided for @unlinkConfirmMessageParent.
  ///
  /// In vi, this message translates to:
  /// **'Con sẽ không còn thấy vùng an toàn và việc cần làm của bạn, bạn cũng không nhận thông báo từ con nữa. Có thể liên kết lại bằng mã.'**
  String get unlinkConfirmMessageParent;

  /// No description provided for @unlinkConfirmMessageChild.
  ///
  /// In vi, this message translates to:
  /// **'Bố mẹ sẽ không nhận được thông báo khi con đến hoặc rời vùng an toàn nữa. Hãy hỏi bố mẹ trước nhé!'**
  String get unlinkConfirmMessageChild;

  /// No description provided for @unlinked.
  ///
  /// In vi, this message translates to:
  /// **'Đã gỡ liên kết'**
  String get unlinked;

  /// No description provided for @errRequestPending.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi yêu cầu, đang chờ bên kia chấp nhận'**
  String get errRequestPending;

  /// No description provided for @errAlreadyLinked.
  ///
  /// In vi, this message translates to:
  /// **'Hai tài khoản đã liên kết rồi'**
  String get errAlreadyLinked;

  /// No description provided for @errRequestGone.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu không còn hiệu lực, hoặc bé đã đủ 3 người liên kết.'**
  String get errRequestGone;

  /// No description provided for @errChildHasParent.
  ///
  /// In vi, this message translates to:
  /// **'Đang liên kết với bố/mẹ khác. Hãy gỡ liên kết trước.'**
  String get errChildHasParent;

  /// No description provided for @zonesNeedChild.
  ///
  /// In vi, this message translates to:
  /// **'Liên kết với bé trước để tạo vùng an toàn cho bé.'**
  String get zonesNeedChild;

  /// No description provided for @errMaxGuardians.
  ///
  /// In vi, this message translates to:
  /// **'Bé đã có đủ 3 người liên kết. Hãy gỡ bớt một người trước.'**
  String get errMaxGuardians;

  /// No description provided for @eventShareStarted.
  ///
  /// In vi, this message translates to:
  /// **'{name} đang chia sẻ vị trí trực tiếp'**
  String eventShareStarted(String name);

  /// No description provided for @eventShareStopped.
  ///
  /// In vi, this message translates to:
  /// **'{name} đã dừng chia sẻ vị trí'**
  String eventShareStopped(String name);

  /// No description provided for @eventTodoCreated.
  ///
  /// In vi, this message translates to:
  /// **'{name} vừa thêm việc: {title}'**
  String eventTodoCreated(String name, String title);

  /// No description provided for @eventTodoDone.
  ///
  /// In vi, this message translates to:
  /// **'{name} đã làm xong: {title}'**
  String eventTodoDone(String name, String title);

  /// No description provided for @locationRequestTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ vị trí'**
  String get locationRequestTitle;

  /// No description provided for @locationRequestBody.
  ///
  /// In vi, this message translates to:
  /// **'{name} muốn xem con đang ở đâu'**
  String locationRequestBody(String name);

  /// No description provided for @locationRequestHint.
  ///
  /// In vi, this message translates to:
  /// **'Bấm nút \"Chia sẻ vị trí trực tiếp\" ở dưới nhé'**
  String get locationRequestHint;

  /// No description provided for @locationRequestSent.
  ///
  /// In vi, this message translates to:
  /// **'Đã nhờ {name} chia sẻ vị trí'**
  String locationRequestSent(String name);

  /// No description provided for @locationRequestPending.
  ///
  /// In vi, this message translates to:
  /// **'Đã hỏi lúc {time}, đang chờ con trả lời'**
  String locationRequestPending(String time);

  /// No description provided for @liveShareNotifTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đang chia sẻ vị trí'**
  String get liveShareNotifTitle;

  /// No description provided for @liveShareNotifText.
  ///
  /// In vi, this message translates to:
  /// **'Bố mẹ đang thấy vị trí của con'**
  String get liveShareNotifText;

  /// No description provided for @noLocationYet.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có vị trí — hãy nhờ con chia sẻ'**
  String get noLocationYet;

  /// No description provided for @liveSharingRemaining.
  ///
  /// In vi, this message translates to:
  /// **'Đang chia sẻ trực tiếp · còn {minutes} phút'**
  String liveSharingRemaining(String minutes);

  /// No description provided for @lastSeenAt.
  ///
  /// In vi, this message translates to:
  /// **'Vị trí gần nhất lúc {time}'**
  String lastSeenAt(String time);

  /// No description provided for @childLocationTitle.
  ///
  /// In vi, this message translates to:
  /// **'{name} đang ở đây'**
  String childLocationTitle(String name);

  /// No description provided for @askChildLocation.
  ///
  /// In vi, this message translates to:
  /// **'Hỏi vị trí của {name}'**
  String askChildLocation(String name);

  /// No description provided for @askAgain.
  ///
  /// In vi, this message translates to:
  /// **'Hỏi lại'**
  String get askAgain;

  /// No description provided for @liveBadge.
  ///
  /// In vi, this message translates to:
  /// **'TRỰC TIẾP'**
  String get liveBadge;

  /// No description provided for @noChildLinkedTitle.
  ///
  /// In vi, this message translates to:
  /// **'Liên kết với con để xem vị trí và nhận thông báo'**
  String get noChildLinkedTitle;

  /// No description provided for @linkWithChild.
  ///
  /// In vi, this message translates to:
  /// **'Liên kết với con'**
  String get linkWithChild;

  /// No description provided for @notLinkedYetHint.
  ///
  /// In vi, this message translates to:
  /// **'Con chưa liên kết với bố mẹ — vào Cài đặt để liên kết nhé'**
  String get notLinkedYetHint;

  /// No description provided for @dismiss.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ qua'**
  String get dismiss;

  /// No description provided for @locationServiceOff.
  ///
  /// In vi, this message translates to:
  /// **'Dịch vụ vị trí đang tắt. Hãy bật lên rồi thử lại nhé.'**
  String get locationServiceOff;

  /// No description provided for @locationPermissionNeeded.
  ///
  /// In vi, this message translates to:
  /// **'Cần cho phép vị trí để chia sẻ với bố mẹ.'**
  String get locationPermissionNeeded;

  /// No description provided for @locationPermissionSettings.
  ///
  /// In vi, this message translates to:
  /// **'Quyền vị trí đang bị tắt. Mở Cài đặt để cho phép nhé.'**
  String get locationPermissionSettings;

  /// No description provided for @locationNoFix.
  ///
  /// In vi, this message translates to:
  /// **'Chưa lấy được vị trí. Thử ra chỗ thoáng rồi bấm lại nhé.'**
  String get locationNoFix;

  /// No description provided for @minutesRemaining.
  ///
  /// In vi, this message translates to:
  /// **'Còn {minutes} phút'**
  String minutesRemaining(String minutes);

  /// No description provided for @liveShareHint.
  ///
  /// In vi, this message translates to:
  /// **'Bố mẹ sẽ thấy con ở đâu trong 60 phút'**
  String get liveShareHint;

  /// No description provided for @startLiveShare.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ vị trí trực tiếp'**
  String get startLiveShare;

  /// No description provided for @stopLiveShare.
  ///
  /// In vi, this message translates to:
  /// **'Dừng chia sẻ vị trí'**
  String get stopLiveShare;

  /// No description provided for @addTodo.
  ///
  /// In vi, this message translates to:
  /// **'Thêm việc'**
  String get addTodo;

  /// No description provided for @addTodoTitle.
  ///
  /// In vi, this message translates to:
  /// **'Con muốn làm gì? ✨'**
  String get addTodoTitle;

  /// No description provided for @addTodoHint.
  ///
  /// In vi, this message translates to:
  /// **'Ví dụ: Tưới cây'**
  String get addTodoHint;

  /// No description provided for @childCanAddTodo.
  ///
  /// In vi, this message translates to:
  /// **'Bấm \"Thêm việc\" để tự thêm, hoặc chờ bố mẹ giao nhé 😊'**
  String get childCanAddTodo;

  /// No description provided for @assignTab.
  ///
  /// In vi, this message translates to:
  /// **'Giao việc'**
  String get assignTab;

  /// No description provided for @notesTab.
  ///
  /// In vi, this message translates to:
  /// **'Lời nhắn gửi'**
  String get notesTab;

  /// No description provided for @notesTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lời nhắn gửi bố mẹ 💌'**
  String get notesTitle;

  /// No description provided for @notesSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Con muốn bố mẹ làm gì giúp con?'**
  String get notesSubtitle;

  /// No description provided for @notesWaiting.
  ///
  /// In vi, this message translates to:
  /// **'{count} lời nhắn đang chờ bố mẹ'**
  String notesWaiting(String count);

  /// No description provided for @notesDoneCount.
  ///
  /// In vi, this message translates to:
  /// **'Đã làm ({count})'**
  String notesDoneCount(String count);

  /// No description provided for @writeNote.
  ///
  /// In vi, this message translates to:
  /// **'Viết lời nhắn'**
  String get writeNote;

  /// No description provided for @addNoteTitle.
  ///
  /// In vi, this message translates to:
  /// **'Con muốn nhắn bố mẹ điều gì? 💌'**
  String get addNoteTitle;

  /// No description provided for @addNoteHint.
  ///
  /// In vi, this message translates to:
  /// **'Ví dụ: Mua giúp con hộp bút chì'**
  String get addNoteHint;

  /// No description provided for @sendNote.
  ///
  /// In vi, this message translates to:
  /// **'Gửi bố mẹ'**
  String get sendNote;

  /// No description provided for @deleteNoteTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xoá lời nhắn?'**
  String get deleteNoteTitle;

  /// No description provided for @noteDoneBy.
  ///
  /// In vi, this message translates to:
  /// **'{name} đã làm lúc {time}'**
  String noteDoneBy(String name, String time);

  /// No description provided for @noteWaiting.
  ///
  /// In vi, this message translates to:
  /// **'Đang chờ bố mẹ…'**
  String get noteWaiting;

  /// No description provided for @noNotesYet.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có lời nhắn nào'**
  String get noNotesYet;

  /// No description provided for @noNotesHint.
  ///
  /// In vi, this message translates to:
  /// **'Bấm \"Viết lời nhắn\" để nhờ bố mẹ làm giúp con nhé 😊'**
  String get noNotesHint;

  /// No description provided for @parentNotesTitle.
  ///
  /// In vi, this message translates to:
  /// **'Việc con nhắn gửi'**
  String get parentNotesTitle;

  /// No description provided for @parentNotesAllDone.
  ///
  /// In vi, this message translates to:
  /// **'Đã làm hết lời nhắn của con 🎉'**
  String get parentNotesAllDone;

  /// No description provided for @parentNotesWaiting.
  ///
  /// In vi, this message translates to:
  /// **'Con nhờ {count} việc — chạm để đánh dấu đã làm'**
  String parentNotesWaiting(String count);

  /// No description provided for @parentNotesEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có lời nhắn nào từ con'**
  String get parentNotesEmpty;

  /// No description provided for @parentNotesEmptyHint.
  ///
  /// In vi, this message translates to:
  /// **'Khi con nhờ bạn làm gì, lời nhắn sẽ hiện ở đây'**
  String get parentNotesEmptyHint;

  /// No description provided for @eventNoteCreated.
  ///
  /// In vi, this message translates to:
  /// **'{name} nhắn: {title}'**
  String eventNoteCreated(String name, String title);

  /// No description provided for @noteDoneNotif.
  ///
  /// In vi, this message translates to:
  /// **'{name} đã làm: {title}'**
  String noteDoneNotif(String name, String title);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'en',
    'id',
    'ja',
    'pt',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
    case 'ja':
      return AppLocalizationsJa();
    case 'pt':
      return AppLocalizationsPt();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
