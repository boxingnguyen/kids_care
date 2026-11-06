// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'FamHub';

  @override
  String get back => 'Back';

  @override
  String get home => 'Home';

  @override
  String get tasks => 'To-do';

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
      'Trial mode, no sign-up needed. Link an email in Settings so you don\'t lose your data if you log out or change phones.';

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
      'Your password has been changed. Log in to continue with FamHub!';

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
  String get noNotifications => 'No updates yet';

  @override
  String get childNoStatusYet =>
      'Status updates, location shares and finished to-dos from your child show up here';

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
  String get myTasksTitle => 'My to-dos 🌟';

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

  @override
  String get searchPlaceHint => 'Search school, home, park…';

  @override
  String get searchNoResults => 'No places found';

  @override
  String get searchFailed => 'Search failed, please try again';

  @override
  String get locationPermissionDenied =>
      'Location permission is off, so the map can\'t open at your position.';

  @override
  String get locationServiceDisabled => 'Location services are turned off.';

  @override
  String get openSettings => 'Open settings';

  @override
  String get myLocation => 'My location';

  @override
  String get linkChildToAssign =>
      'No child linked yet. Have your child enter your link code to assign tasks.';

  @override
  String get assignTo => 'Assign to';

  @override
  String get linkEmailTitle => 'Link email';

  @override
  String get linkEmailSubtitle =>
      'Add an email to keep your data and sign back in on a new phone or after reinstalling.';

  @override
  String get linkEmailAction => 'Link and send verification email';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get invalidEmail => 'Invalid email';

  @override
  String get tooManyRequests =>
      'Too many attempts, please try again in a few minutes.';

  @override
  String get verifyEmailTitle => 'Verify your email';

  @override
  String verifyEmailMessage(String email) {
    return 'We sent a verification link to $email. Open the email, tap the link, then come back to the app.';
  }

  @override
  String get verifyEmailCheck => 'I\'ve verified';

  @override
  String get verifyEmailResend => 'Resend email';

  @override
  String verifyEmailResendIn(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get verifyEmailSent => 'Verification email sent again';

  @override
  String get verifyEmailNotYet =>
      'Your email isn\'t verified yet. Tap the link in the email.';

  @override
  String get emailLinkedLoggedOut =>
      'Email linked. Next time, sign in with this email to get your data back.';

  @override
  String get logoutGuestLinkTitle => 'Your data will be lost';

  @override
  String get logoutGuestLinkMessage =>
      'You\'re using a guest account. If you log out, all data and links will be lost for good. Link an email to keep them.';

  @override
  String get logoutAnyway => 'Log out anyway';

  @override
  String get setNameTitle => 'What\'s your name?';

  @override
  String get setNameParentHint => 'e.g. Mom Lan';

  @override
  String get setNameChildHint => 'e.g. Ben';

  @override
  String get save => 'Save';

  @override
  String get regenerateLinkCode => 'New code';

  @override
  String get regenerateLinkCodeConfirm =>
      'The old code will stop working. Already linked accounts stay linked.';

  @override
  String get linkCodeRegenerated => 'New link code created';

  @override
  String get confirmPasswordHint => 'Confirm password';

  @override
  String get sendLinkRequest => 'Send link request';

  @override
  String get linkRequestSent =>
      'Link request sent. Waiting for the other side to accept!';

  @override
  String linkRequestFromParent(String name) {
    return '$name (parent) wants to link with you';
  }

  @override
  String linkRequestFromChild(String name) {
    return '$name (child) wants to link with you';
  }

  @override
  String get linkRequestHint =>
      'Accept to sync safe zones, tasks and notifications.';

  @override
  String get accept => 'Accept';

  @override
  String get reject => 'Decline';

  @override
  String linkRequestAccepted(String name) {
    return 'Linked with $name';
  }

  @override
  String get pendingRequestsTitle => 'Waiting for acceptance';

  @override
  String pendingRequestCode(String code) {
    return 'Code $code';
  }

  @override
  String get cancelRequest => 'Cancel request';

  @override
  String get linkedAccountsTitle => 'Linked accounts';

  @override
  String get unlink => 'Unlink';

  @override
  String unlinkConfirmTitle(String name) {
    return 'Unlink from $name?';
  }

  @override
  String get unlinkConfirmMessageParent =>
      'Your child will no longer see your safe zones and tasks, and you won\'t get their notifications. You can link again with a code.';

  @override
  String get unlinkConfirmMessageChild =>
      'Your parents won\'t be notified when you arrive at or leave safe zones anymore. Ask them first!';

  @override
  String get unlinked => 'Unlinked';

  @override
  String get errRequestPending =>
      'Request already sent, waiting for acceptance';

  @override
  String get errAlreadyLinked => 'These accounts are already linked';

  @override
  String get errRequestGone =>
      'This request is no longer valid, or the child already has 3 linked guardians.';

  @override
  String get errChildHasParent =>
      'Already linked to another parent. Unlink first.';

  @override
  String get zonesNeedChild =>
      'Link with your child first to create their safe zones.';

  @override
  String get errMaxGuardians =>
      'This child already has 3 linked guardians. Unlink one first.';

  @override
  String eventShareStarted(String name) {
    return '$name is sharing live location';
  }

  @override
  String eventShareStopped(String name) {
    return '$name stopped sharing location';
  }

  @override
  String eventTodoCreated(String name, String title) {
    return '$name added a to-do: $title';
  }

  @override
  String eventTodoDone(String name, String title) {
    return '$name finished: $title';
  }

  @override
  String get locationRequestTitle => 'Share location';

  @override
  String locationRequestBody(String name) {
    return '$name wants to see where you are';
  }

  @override
  String get locationRequestHint => 'Tap \"Share live location\" below';

  @override
  String locationRequestSent(String name) {
    return 'Asked $name to share location';
  }

  @override
  String locationRequestPending(String time) {
    return 'Asked at $time, waiting for a reply';
  }

  @override
  String get liveShareNotifTitle => 'Sharing location';

  @override
  String get liveShareNotifText => 'Your parents can see where you are';

  @override
  String get noLocationYet => 'No location yet — ask your child to share';

  @override
  String liveSharingRemaining(String minutes) {
    return 'Sharing live · $minutes min left';
  }

  @override
  String lastSeenAt(String time) {
    return 'Last seen at $time';
  }

  @override
  String childLocationTitle(String name) {
    return '$name is here';
  }

  @override
  String askChildLocation(String name) {
    return 'Ask $name for location';
  }

  @override
  String get askAgain => 'Ask again';

  @override
  String get liveBadge => 'LIVE';

  @override
  String get noChildLinkedTitle =>
      'Link with your child to see their location and get updates';

  @override
  String get linkWithChild => 'Link with child';

  @override
  String get notLinkedYetHint =>
      'Not linked with your parents yet — link in Settings';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get locationServiceOff =>
      'Location services are off. Turn them on and try again.';

  @override
  String get locationPermissionNeeded =>
      'Location permission is needed to share with your parents.';

  @override
  String get locationPermissionSettings =>
      'Location permission is off. Open Settings to allow it.';

  @override
  String get locationNoFix =>
      'Couldn’t get your location. Try again somewhere more open.';

  @override
  String minutesRemaining(String minutes) {
    return '$minutes minutes remaining';
  }

  @override
  String get liveShareHint =>
      'Your parents will see where you are for 60 minutes';

  @override
  String get startLiveShare => 'Share live location';

  @override
  String get stopLiveShare => 'Stop sharing location';

  @override
  String get addTodo => 'Add to-do';

  @override
  String get addTodoTitle => 'What do you want to do? ✨';

  @override
  String get addTodoHint => 'e.g. Water the plants';

  @override
  String get childCanAddTodo =>
      'Tap \"Add to-do\" to add one yourself, or wait for your parents 😊';

  @override
  String get assignTab => 'Assign';

  @override
  String get notesTab => 'Notes';

  @override
  String get notesTitle => 'Notes for my parents 💌';

  @override
  String get notesSubtitle => 'What would you like your parents to do?';

  @override
  String notesWaiting(String count) {
    return '$count notes waiting for your parents';
  }

  @override
  String notesDoneCount(String count) {
    return 'Done ($count)';
  }

  @override
  String get writeNote => 'Write a note';

  @override
  String get addNoteTitle => 'What do you want to tell your parents? 💌';

  @override
  String get addNoteHint => 'e.g. Please buy me colored pencils';

  @override
  String get sendNote => 'Send to parents';

  @override
  String get deleteNoteTitle => 'Delete note?';

  @override
  String noteDoneBy(String name, String time) {
    return 'Done by $name at $time';
  }

  @override
  String get noteWaiting => 'Waiting for your parents…';

  @override
  String get noNotesYet => 'No notes yet';

  @override
  String get noNotesHint =>
      'Tap \"Write a note\" to ask your parents for something 😊';

  @override
  String get parentNotesTitle => 'Notes from your child';

  @override
  String get parentNotesAllDone => 'All of your child’s notes are done 🎉';

  @override
  String parentNotesWaiting(String count) {
    return '$count requests from your child — tap to mark done';
  }

  @override
  String get parentNotesEmpty => 'No notes from your child yet';

  @override
  String get parentNotesEmptyHint =>
      'When your child asks you for something, it shows up here';

  @override
  String eventNoteCreated(String name, String title) {
    return '$name asks: $title';
  }

  @override
  String noteDoneNotif(String name, String title) {
    return '$name did it: $title';
  }

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountSubtitle =>
      'Permanently remove your account and data';

  @override
  String get deleteAccountConfirmTitle => 'Delete your account?';

  @override
  String get deleteAccountConfirmMessage =>
      'Your account, location, safe zones, to-dos, notes and links will be permanently deleted. This can\'t be undone.';

  @override
  String get deleteAccountAskParent => 'Ask Mom or Dad first!';

  @override
  String get deleteAccountAction => 'Delete permanently';

  @override
  String get deleteAccountFailed =>
      'Couldn\'t delete your account. Check your connection and try again.';

  @override
  String get accountDeleted => 'Your account has been deleted';

  @override
  String get locationDisclosureTitle => 'FamHub uses your location';

  @override
  String get locationDisclosureBody =>
      'FamHub collects your location to tell your linked parents when you arrive at or leave a safe zone, even when the app is closed or not in use.\n\nYour location is also sent when you tap a check-in button or share live location. Only the parents you are linked with can see it.';

  @override
  String get locationDisclosureContinue => 'Continue';

  @override
  String get locationDisclosureNotNow => 'Not now';

  @override
  String get checkInLocationHint =>
      'Tapping a button also sends your location to your parents';
}
