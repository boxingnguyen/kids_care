// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Kids Care';

  @override
  String get back => 'Back';

  @override
  String get home => 'Home';

  @override
  String get tasks => 'Tasks';

  @override
  String get map => 'Map';

  @override
  String get settings => 'Settings';

  @override
  String get notifications => 'Notifications';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get add => 'Add';

  @override
  String get ok => 'OK';

  @override
  String get later => 'Later';

  @override
  String get login => 'Log in';

  @override
  String get register => 'Sign up';

  @override
  String get password => 'Password';

  @override
  String get email => 'Email';

  @override
  String get haveAccount => 'Already have an account? ';

  @override
  String get noAccount => 'Don\'t have an account? ';

  @override
  String get unknown => 'Unknown';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String errorGeneric(String message) {
    return 'Something went wrong: $message';
  }

  @override
  String unknownError(String message) {
    return 'Unknown error: $message';
  }

  @override
  String get fillAllFields => 'Please fill in all fields';

  @override
  String get signUpFailed => 'Sign up failed';

  @override
  String signUpFailedWithMessage(String message) {
    return 'Sign up failed: $message';
  }

  @override
  String get notFoundTitle => 'Oops, we\'re lost!';

  @override
  String get notFoundMessage => 'This page doesn\'t exist.';

  @override
  String get goHome => 'Go home';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'Device default';

  @override
  String get chooseLanguage => 'Choose language';

  @override
  String get welcomeTagline => 'Protecting your child anytime, anywhere';

  @override
  String get guestModeWarning =>
      'Trial mode, no sign-up needed. Data stays on this device only — write down your link code and upgrade your account so you don\'t lose it.';

  @override
  String get tryAsParent => 'Try as a parent';

  @override
  String get tryAsChild => 'Try as a child';

  @override
  String get loginTagline => 'Safe kids, peaceful parents';

  @override
  String get helloWave => 'Hello! 👋';

  @override
  String get loginSubtitle => 'Log in with email (parent) or username (child)';

  @override
  String get loginIdentifierHint => 'Email (parent) or username (child)';

  @override
  String get forgotPasswordTitle => 'Forgot password?';

  @override
  String get loginNotFound => 'Account not found';

  @override
  String get loginWrongPassword => 'Wrong password';

  @override
  String get loginInvalidCredential => 'Incorrect email/username or password';

  @override
  String loginFailed(String message) {
    return 'Log in failed: $message';
  }

  @override
  String googleLoginFailed(String message) {
    return 'Google sign-in failed: $message';
  }

  @override
  String get forgotPasswordSubtitle =>
      'Don\'t worry — enter your email to get a recovery code! 🔑';

  @override
  String get yourEmail => 'Your email';

  @override
  String get sendRecoveryCode => 'Send recovery code';

  @override
  String get strengthWeak => 'Weak';

  @override
  String get strengthMedium => 'Fair';

  @override
  String get strengthGood => 'Good';

  @override
  String get strengthStrong => 'Strong';

  @override
  String get passwordMismatch => 'Passwords don\'t match';

  @override
  String get setNewPassword => 'Set a new password';

  @override
  String get newPasswordHint =>
      'Your new password must be different from the previous one';

  @override
  String get newPassword => 'New password';

  @override
  String passwordStrength(String level) {
    return 'Strength: $level';
  }

  @override
  String get confirmNewPassword => 'Confirm new password';

  @override
  String get ruleMin8 => 'At least 8 characters';

  @override
  String get ruleUppercase => 'Contains an uppercase letter';

  @override
  String get ruleNumber => 'Contains a number';

  @override
  String get resetPassword => 'Reset password';

  @override
  String get resetSuccessTitle => 'Reset successful!';

  @override
  String get resetSuccessMessage =>
      'Your password has been changed. Log in to continue with Kids Care!';

  @override
  String get loginNow => 'Log in now';

  @override
  String get emailTaken => 'This email is already in use';

  @override
  String get createNewAccount => 'Create a new account';

  @override
  String get registerSubtitle =>
      'Start your parenting journey with your little one 🌟';

  @override
  String get parentFullName => 'Parent\'s full name';

  @override
  String get passwordConfirmMismatch => 'The passwords don\'t match';

  @override
  String get usernameTaken => 'This username is already taken';

  @override
  String get createChildAccount => 'Create your child\'s account';

  @override
  String get createChildSubtitle => 'Start your journey with your little one';

  @override
  String get usernameLabelCaps => 'USERNAME';

  @override
  String get childUsernameHint => 'child\'s name or nickname';

  @override
  String get passwordLabelCaps => 'PASSWORD';

  @override
  String get confirmPasswordLabelCaps => 'CONFIRM PASSWORD';

  @override
  String get startNow => 'GET STARTED →';

  @override
  String get callDad => 'Dad';

  @override
  String get connecting => 'Connecting...';

  @override
  String get micOn => 'Unmute';

  @override
  String get micOff => 'Mute';

  @override
  String get speaker => 'Speaker';

  @override
  String get video => 'Video';

  @override
  String get endCall => 'End call';

  @override
  String toldParents(String status) {
    return 'Told Mom & Dad: $status';
  }

  @override
  String get zoneSchool => 'School';

  @override
  String get zonePlayground => 'Playground';

  @override
  String get zoneHome => 'Home';

  @override
  String get howAreYouToday => 'How\'s your day going?';

  @override
  String get pickButtonToTell => 'Tap a button to tell Mom & Dad!';

  @override
  String get statusGoSchool => 'Going to school';

  @override
  String get statusGoPlay => 'Going to play';

  @override
  String get statusArrived => 'I\'ve arrived';

  @override
  String get statusBackHome => 'I\'m home';

  @override
  String get callParents => 'CALL MOM & DAD';

  @override
  String get callParentsHint =>
      'Press the green button if you need help right away!';

  @override
  String get helloCaps => 'HELLO';

  @override
  String childGreeting(String name) {
    return 'Hi, $name! 👋';
  }

  @override
  String get statusLabelSchool => 'At school';

  @override
  String get statusLabelPlaying => 'Playing';

  @override
  String get statusLabelHome => 'Back home';

  @override
  String get statusLabelArrived => 'Arrived';

  @override
  String get statusLabelLeft => 'Left';

  @override
  String get linkCodeFormatError => 'Enter the 6-character code (e.g. ABC-123)';

  @override
  String get notSignedIn => 'Not signed in';

  @override
  String get linkSuccessTitle => 'Linked successfully!';

  @override
  String get linkSuccessMessage =>
      'The accounts are now linked. Start using the app now?';

  @override
  String get linkAccountTitle => 'Link accounts';

  @override
  String get enterLinkCode => 'Enter link code';

  @override
  String get enterLinkCodeDescription =>
      'Enter the 6-character code from the parent or child to link the two accounts.';

  @override
  String get linkCodeHint => 'e.g. ABC-123';

  @override
  String get linkCode => 'Link code';

  @override
  String get linkAction => 'Link';

  @override
  String get errLinkOtherParent =>
      'This code belongs to another parent account and can\'t be linked';

  @override
  String get errLinkNotParent =>
      'This code doesn\'t belong to a parent account';

  @override
  String get errOwnAccountNotFound => 'Your account couldn\'t be found';

  @override
  String get errLinkCodeNotFound => 'Link code not found';

  @override
  String get errOwnCode => 'This is your own code';

  @override
  String get errMaxZones => 'Up to 3 safe zones only';

  @override
  String get helloParents => 'Hello, parents! 👋';

  @override
  String get whatToDoToday => 'What would you like to do today?';

  @override
  String get menuNotificationsTitle => 'Updates from your child';

  @override
  String get menuNotificationsDesc =>
      'Where your child is, latest updates, emergency call';

  @override
  String get menuMapTitle => 'Map & safe zones';

  @override
  String get menuMapDesc => 'Mark your child\'s school, home and play spots';

  @override
  String get menuTasksTitle => 'Your child\'s tasks';

  @override
  String get menuTasksDesc => 'Assign daily tasks and check what\'s done';

  @override
  String get addSafeZone => 'Add safe zone';

  @override
  String get zoneNameHint => 'Zone name (e.g. School)';

  @override
  String get zoneLimitReached => 'You\'ve reached the 3-zone limit';

  @override
  String get childMapTitle => 'My map';

  @override
  String get mapHintParent =>
      'Long-press a spot on the map to add a new safe zone.';

  @override
  String get mapHintChild =>
      'These are the safe places Mom & Dad picked for you 💛';

  @override
  String get linkCodeLabel => 'Link code: ';

  @override
  String safeZonesCount(String count, String max) {
    return 'Safe zones ($count/$max)';
  }

  @override
  String get noSafeZones => 'No safe zones set up yet.';

  @override
  String deleteZoneSemantic(String name) {
    return 'Delete zone $name';
  }

  @override
  String get zoneLimitHint =>
      '3-zone limit reached. Delete one to add a new zone.';

  @override
  String get deleteZoneTitle => 'Delete safe zone?';

  @override
  String deleteZoneMessage(String name) {
    return 'The zone \"$name\" will be removed from the map.';
  }

  @override
  String get recent => 'Recent';

  @override
  String updatedAtToday(String time) {
    return 'Updated at $time today';
  }

  @override
  String childIsNear(String name) {
    return '$name is near';
  }

  @override
  String get statusSafe => '✅ Safe';

  @override
  String get emergencyCallChild => 'Emergency call to your child';

  @override
  String get voiceCallVia => 'Voice call via ZegoCloud';

  @override
  String get noNotifications => 'No notifications yet';

  @override
  String get childNoStatusYet => 'Your child hasn\'t sent any updates yet';

  @override
  String get accountSecurity => 'Account & security';

  @override
  String get logout => 'Log out';

  @override
  String get logoutSubtitle => 'Sign out of the current account';

  @override
  String get logoutConfirmTitle => 'Log out?';

  @override
  String get logoutGuestWarning =>
      'This is a trial account. If you log out, your data may be lost. Ask Mom or Dad first!';

  @override
  String get logoutConfirmMessage => 'Are you sure you want to log out?';

  @override
  String get stay => 'Stay';

  @override
  String get upgradeAccount => 'Upgrade account';

  @override
  String get upgradeAccountSubtitle =>
      'Link with Google so you don\'t lose your data';

  @override
  String get accountUpgraded => 'Account upgraded!';

  @override
  String get googleAccountInUse =>
      'This Google account is already used by another account';

  @override
  String get yourLinkCode => 'Your link code';

  @override
  String get copy => 'Copy';

  @override
  String get linkCodeCopied => 'Link code copied';

  @override
  String get linkedAddMore => 'Linked — enter a code to link more';

  @override
  String get enterChildCode => 'Enter your child\'s code to link';

  @override
  String get enterParentCode => 'Enter Mom or Dad\'s code to link';

  @override
  String pendingCount(String count) {
    return 'To do ($count)';
  }

  @override
  String doneCount(String count) {
    return 'Done ($count)';
  }

  @override
  String get childTasksLoadError =>
      'Oops, couldn\'t load your tasks 😢\nTry again in a little bit!';

  @override
  String get myTasksTitle => 'My tasks 🌟';

  @override
  String get tapTaskWhenDone => 'Tap a task when you finish it!';

  @override
  String doneOfTotalToday(String done, String total) {
    return '$done/$total tasks done today!';
  }

  @override
  String greatJobDone(String title) {
    return '🎉 Great job! You finished \"$title\"!';
  }

  @override
  String dueShort(String date) {
    return 'Due $date';
  }

  @override
  String doneAt(String time) {
    return 'Done at $time';
  }

  @override
  String get noTasksYetChild => 'No tasks yet!';

  @override
  String get parentWillAssign => 'Mom or Dad will give you tasks soon 😊';

  @override
  String parentTasksLoadError(String message) {
    return 'Couldn\'t load tasks.\n$message';
  }

  @override
  String get parentTasksTitle => '📋 Your child\'s tasks';

  @override
  String tasksCompleted(String done, String total) {
    return '$done/$total tasks completed';
  }

  @override
  String get deleteTaskTitle => 'Delete task?';

  @override
  String deleteTaskMessage(String title) {
    return 'Delete \"$title\"?';
  }

  @override
  String get taskDone => 'Done';

  @override
  String get taskPending => 'Pending';

  @override
  String get addTask => 'Add task';

  @override
  String get addNewTask => '✨ New task';

  @override
  String get chooseIcon => 'Choose an icon';

  @override
  String get taskNameHint => 'Task name (e.g. Do homework)';

  @override
  String get taskDescriptionHint => 'Description (optional)';

  @override
  String dueDateLabel(String date) {
    return 'Due: $date';
  }

  @override
  String get pickDueDate => 'Pick a due date (optional)';

  @override
  String get assignTask => 'Assign task 🚀';

  @override
  String get noTasksYetParent => 'No tasks yet';

  @override
  String get tapPlusToAssign => 'Tap + to give your child a task!';

  @override
  String get geofenceChannelName => 'Safe zone alerts';

  @override
  String get geofenceChannelDesc =>
      'Alerts when your child enters or leaves a safe zone';

  @override
  String geofenceLeft(String name, String zone) {
    return '$name just left $zone';
  }

  @override
  String geofenceEntered(String name, String zone) {
    return '$name arrived at $zone';
  }
}
