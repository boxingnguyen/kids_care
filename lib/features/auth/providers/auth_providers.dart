import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider lưu trạng thái loading khi đang xử lý Google Sign-In
final googleSignInLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);
