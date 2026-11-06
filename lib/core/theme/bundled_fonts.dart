import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Font được đóng gói trong assets/fonts/, app không tải gì từ Google Fonts.
/// Dùng thêm độ đậm mới thì phải thêm file Nunito tương ứng vào đó.
void configureBundledFonts() {
  GoogleFonts.config.allowRuntimeFetching = false;
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['Nunito'], license);
  });
}
