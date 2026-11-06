import 'package:kids_care/core/constants/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openPrivacyPolicy() async {
  await launchUrl(
    Uri.parse(AppConstants.privacyPolicyUrl),
    mode: LaunchMode.externalApplication,
  );
}
