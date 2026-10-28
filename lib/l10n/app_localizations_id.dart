// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Kids Care';

  @override
  String get back => 'Kembali';

  @override
  String get home => 'Beranda';

  @override
  String get tasks => 'Tugas';

  @override
  String get map => 'Peta';

  @override
  String get settings => 'Pengaturan';

  @override
  String get notifications => 'Notifikasi';

  @override
  String get cancel => 'Batal';

  @override
  String get delete => 'Hapus';

  @override
  String get add => 'Tambah';

  @override
  String get ok => 'OK';

  @override
  String get later => 'Nanti';

  @override
  String get login => 'Masuk';

  @override
  String get register => 'Daftar';

  @override
  String get password => 'Kata sandi';

  @override
  String get email => 'Email';

  @override
  String get haveAccount => 'Sudah punya akun? ';

  @override
  String get noAccount => 'Belum punya akun? ';

  @override
  String get unknown => 'Tidak diketahui';

  @override
  String errorWithMessage(String message) {
    return 'Kesalahan: $message';
  }

  @override
  String errorGeneric(String message) {
    return 'Terjadi kesalahan: $message';
  }

  @override
  String unknownError(String message) {
    return 'Kesalahan tidak diketahui: $message';
  }

  @override
  String get fillAllFields => 'Harap isi semua kolom';

  @override
  String get signUpFailed => 'Pendaftaran gagal';

  @override
  String signUpFailedWithMessage(String message) {
    return 'Pendaftaran gagal: $message';
  }

  @override
  String get notFoundTitle => 'Ups, kita tersesat!';

  @override
  String get notFoundMessage => 'Halaman ini tidak ditemukan.';

  @override
  String get goHome => 'Kembali ke beranda';

  @override
  String get language => 'Bahasa';

  @override
  String get languageSystem => 'Sesuai perangkat';

  @override
  String get chooseLanguage => 'Pilih bahasa';

  @override
  String get welcomeTagline => 'Melindungi si kecil kapan saja, di mana saja';

  @override
  String get guestModeWarning =>
      'Mode percobaan tanpa daftar. Data hanya tersimpan di perangkat ini — catat kode tautan dan tingkatkan akun agar data tidak hilang.';

  @override
  String get tryAsParent => 'Coba sebagai orang tua';

  @override
  String get tryAsChild => 'Coba sebagai anak';

  @override
  String get loginTagline => 'Anak aman, orang tua tenang';

  @override
  String get helloWave => 'Halo! 👋';

  @override
  String get loginSubtitle =>
      'Masuk dengan email (orang tua) atau nama pengguna (anak)';

  @override
  String get loginIdentifierHint =>
      'Email (orang tua) atau nama pengguna (anak)';

  @override
  String get forgotPasswordTitle => 'Lupa kata sandi?';

  @override
  String get loginNotFound => 'Akun tidak ditemukan';

  @override
  String get loginWrongPassword => 'Kata sandi salah';

  @override
  String get loginInvalidCredential =>
      'Email/nama pengguna atau kata sandi salah';

  @override
  String loginFailed(String message) {
    return 'Gagal masuk: $message';
  }

  @override
  String googleLoginFailed(String message) {
    return 'Gagal masuk dengan Google: $message';
  }

  @override
  String get forgotPasswordSubtitle =>
      'Jangan khawatir, masukkan email untuk menerima kode pemulihan! 🔑';

  @override
  String get yourEmail => 'Email kamu';

  @override
  String get sendRecoveryCode => 'Kirim kode pemulihan';

  @override
  String get strengthWeak => 'Lemah';

  @override
  String get strengthMedium => 'Sedang';

  @override
  String get strengthGood => 'Baik';

  @override
  String get strengthStrong => 'Kuat';

  @override
  String get passwordMismatch => 'Kata sandi tidak cocok';

  @override
  String get setNewPassword => 'Atur kata sandi baru';

  @override
  String get newPasswordHint => 'Kata sandi baru harus berbeda dari sebelumnya';

  @override
  String get newPassword => 'Kata sandi baru';

  @override
  String passwordStrength(String level) {
    return 'Kekuatan: $level';
  }

  @override
  String get confirmNewPassword => 'Konfirmasi kata sandi baru';

  @override
  String get ruleMin8 => 'Minimal 8 karakter';

  @override
  String get ruleUppercase => 'Ada huruf kapital';

  @override
  String get ruleNumber => 'Ada angka';

  @override
  String get resetPassword => 'Atur ulang kata sandi';

  @override
  String get resetSuccessTitle => 'Berhasil diatur ulang!';

  @override
  String get resetSuccessMessage =>
      'Kata sandi telah diubah. Masuk untuk lanjut dengan Kids Care!';

  @override
  String get loginNow => 'Masuk sekarang';

  @override
  String get emailTaken => 'Email ini sudah digunakan';

  @override
  String get createNewAccount => 'Buat akun baru';

  @override
  String get registerSubtitle => 'Mulai perjalanan mengasuh si kecil 🌟';

  @override
  String get parentFullName => 'Nama lengkap orang tua';

  @override
  String get passwordConfirmMismatch => 'Konfirmasi kata sandi tidak cocok';

  @override
  String get usernameTaken => 'Nama pengguna sudah dipakai';

  @override
  String get createChildAccount => 'Buat akun anak';

  @override
  String get createChildSubtitle => 'Mulai perjalanan bersama si kecil';

  @override
  String get usernameLabelCaps => 'NAMA PENGGUNA';

  @override
  String get childUsernameHint => 'nama atau panggilan anak';

  @override
  String get passwordLabelCaps => 'KATA SANDI';

  @override
  String get confirmPasswordLabelCaps => 'KONFIRMASI KATA SANDI';

  @override
  String get startNow => 'MULAI SEKARANG →';

  @override
  String get callDad => 'Ayah';

  @override
  String get connecting => 'Menghubungkan...';

  @override
  String get micOn => 'Nyalakan mik';

  @override
  String get micOff => 'Matikan mik';

  @override
  String get speaker => 'Speaker';

  @override
  String get video => 'Video';

  @override
  String get endCall => 'Akhiri panggilan';

  @override
  String toldParents(String status) {
    return 'Sudah kasih tahu Ayah & Ibu: $status';
  }

  @override
  String get zoneSchool => 'Sekolah';

  @override
  String get zonePlayground => 'Taman bermain';

  @override
  String get zoneHome => 'Rumah';

  @override
  String get howAreYouToday => 'Hari ini kamu sedang apa?';

  @override
  String get pickButtonToTell =>
      'Tekan satu tombol untuk kasih tahu Ayah & Ibu!';

  @override
  String get statusGoSchool => 'Berangkat sekolah';

  @override
  String get statusGoPlay => 'Pergi main';

  @override
  String get statusArrived => 'Sudah sampai';

  @override
  String get statusBackHome => 'Sudah pulang';

  @override
  String get callParents => 'TELEPON AYAH & IBU';

  @override
  String get callParentsHint =>
      'Tekan tombol hijau kalau butuh bantuan segera!';

  @override
  String get helloCaps => 'HALO';

  @override
  String childGreeting(String name) {
    return 'Hai, $name! 👋';
  }

  @override
  String get statusLabelSchool => 'Di sekolah';

  @override
  String get statusLabelPlaying => 'Sedang bermain';

  @override
  String get statusLabelHome => 'Sudah pulang';

  @override
  String get statusLabelArrived => 'Sudah sampai';

  @override
  String get statusLabelLeft => 'Meninggalkan';

  @override
  String get linkCodeFormatError => 'Masukkan kode 6 karakter (mis. ABC-123)';

  @override
  String get notSignedIn => 'Belum masuk';

  @override
  String get linkSuccessTitle => 'Berhasil ditautkan!';

  @override
  String get linkSuccessMessage =>
      'Akun sudah ditautkan. Mulai gunakan sekarang?';

  @override
  String get linkAccountTitle => 'Tautkan akun';

  @override
  String get enterLinkCode => 'Masukkan kode tautan';

  @override
  String get enterLinkCodeDescription =>
      'Masukkan kode 6 karakter milik orang tua atau anak untuk menautkan kedua akun.';

  @override
  String get linkCodeHint => 'mis. ABC-123';

  @override
  String get linkCode => 'Kode tautan';

  @override
  String get linkAction => 'Tautkan';

  @override
  String get errLinkOtherParent =>
      'Kode ini milik akun orang tua lain, tidak bisa ditautkan';

  @override
  String get errLinkNotParent => 'Kode ini bukan milik akun orang tua';

  @override
  String get errOwnAccountNotFound => 'Akun kamu tidak ditemukan';

  @override
  String get errLinkCodeNotFound => 'Kode tautan tidak ditemukan';

  @override
  String get errOwnCode => 'Ini kode milikmu sendiri';

  @override
  String get errMaxZones => 'Maksimal 3 zona aman';

  @override
  String get helloParents => 'Halo, Ayah & Ibu! 👋';

  @override
  String get whatToDoToday => 'Mau melakukan apa hari ini?';

  @override
  String get menuNotificationsTitle => 'Kabar dari anak';

  @override
  String get menuNotificationsDesc =>
      'Lokasi anak, kabar terbaru, panggilan darurat';

  @override
  String get menuMapTitle => 'Peta & zona aman';

  @override
  String get menuMapDesc => 'Tandai sekolah, rumah, dan tempat bermain anak';

  @override
  String get menuTasksTitle => 'Tugas anak';

  @override
  String get menuTasksDesc => 'Beri tugas harian dan cek yang sudah selesai';

  @override
  String get addSafeZone => 'Tambah zona aman';

  @override
  String get zoneNameHint => 'Nama zona (mis. Sekolah)';

  @override
  String get zoneLimitReached => 'Batas 3 zona tercapai';

  @override
  String get childMapTitle => 'Peta aku';

  @override
  String get mapHintParent =>
      'Tekan lama satu titik di peta untuk menambah zona aman.';

  @override
  String get mapHintChild =>
      'Ini tempat-tempat aman yang dipilih Ayah & Ibu untukmu 💛';

  @override
  String get linkCodeLabel => 'Kode tautan: ';

  @override
  String safeZonesCount(String count, String max) {
    return 'Zona aman ($count/$max)';
  }

  @override
  String get noSafeZones => 'Belum ada zona aman.';

  @override
  String deleteZoneSemantic(String name) {
    return 'Hapus zona $name';
  }

  @override
  String get zoneLimitHint =>
      'Batas 3 zona tercapai. Hapus satu untuk menambah yang baru.';

  @override
  String get deleteZoneTitle => 'Hapus zona aman?';

  @override
  String deleteZoneMessage(String name) {
    return 'Zona \"$name\" akan dihapus dari peta.';
  }

  @override
  String get recent => 'Terbaru';

  @override
  String updatedAtToday(String time) {
    return 'Diperbarui pukul $time hari ini';
  }

  @override
  String childIsNear(String name) {
    return '$name sedang di dekat';
  }

  @override
  String get statusSafe => '✅ Aman';

  @override
  String get emergencyCallChild => 'Panggilan darurat ke anak';

  @override
  String get voiceCallVia => 'Panggilan suara via ZegoCloud';

  @override
  String get noNotifications => 'Belum ada notifikasi';

  @override
  String get childNoStatusYet => 'Anak belum mengirim kabar';

  @override
  String get accountSecurity => 'Akun & keamanan';

  @override
  String get logout => 'Keluar';

  @override
  String get logoutSubtitle => 'Keluar dari akun saat ini';

  @override
  String get logoutConfirmTitle => 'Keluar?';

  @override
  String get logoutGuestWarning =>
      'Ini akun percobaan. Kalau keluar, data bisa hilang. Tanya Ayah atau Ibu dulu ya!';

  @override
  String get logoutConfirmMessage => 'Yakin ingin keluar?';

  @override
  String get stay => 'Tetap di sini';

  @override
  String get upgradeAccount => 'Tingkatkan akun';

  @override
  String get upgradeAccountSubtitle =>
      'Tautkan dengan Google agar data tidak hilang';

  @override
  String get accountUpgraded => 'Akun berhasil ditingkatkan!';

  @override
  String get googleAccountInUse => 'Akun Google ini sudah dipakai akun lain';

  @override
  String get yourLinkCode => 'Kode tautanmu';

  @override
  String get copy => 'Salin';

  @override
  String get linkCodeCopied => 'Kode tautan disalin';

  @override
  String get linkedAddMore =>
      'Sudah tertaut — masukkan kode untuk menautkan lagi';

  @override
  String get enterChildCode => 'Masukkan kode anak untuk menautkan';

  @override
  String get enterParentCode => 'Masukkan kode Ayah/Ibu untuk menautkan';

  @override
  String pendingCount(String count) {
    return 'Harus dikerjakan ($count)';
  }

  @override
  String doneCount(String count) {
    return 'Selesai ($count)';
  }

  @override
  String get childTasksLoadError =>
      'Ups, tugasnya belum bisa dimuat 😢\nCoba lagi sebentar lagi ya!';

  @override
  String get myTasksTitle => 'Tugasku 🌟';

  @override
  String get tapTaskWhenDone => 'Ketuk tugas kalau sudah selesai ya!';

  @override
  String doneOfTotalToday(String done, String total) {
    return '$done/$total tugas selesai hari ini!';
  }

  @override
  String greatJobDone(String title) {
    return '🎉 Hebat! \"$title\" selesai!';
  }

  @override
  String dueShort(String date) {
    return 'Batas $date';
  }

  @override
  String doneAt(String time) {
    return 'Selesai pukul $time';
  }

  @override
  String get noTasksYetChild => 'Belum ada tugas!';

  @override
  String get parentWillAssign => 'Ayah atau Ibu akan segera memberi tugas 😊';

  @override
  String parentTasksLoadError(String message) {
    return 'Tidak dapat memuat tugas.\n$message';
  }

  @override
  String get parentTasksTitle => '📋 Tugas anak';

  @override
  String tasksCompleted(String done, String total) {
    return '$done/$total tugas selesai';
  }

  @override
  String get deleteTaskTitle => 'Hapus tugas?';

  @override
  String deleteTaskMessage(String title) {
    return 'Hapus \"$title\"?';
  }

  @override
  String get taskDone => 'Selesai';

  @override
  String get taskPending => 'Menunggu';

  @override
  String get addTask => 'Tambah tugas';

  @override
  String get addNewTask => '✨ Tugas baru';

  @override
  String get chooseIcon => 'Pilih ikon';

  @override
  String get taskNameHint => 'Nama tugas (mis. Mengerjakan PR)';

  @override
  String get taskDescriptionHint => 'Deskripsi (opsional)';

  @override
  String dueDateLabel(String date) {
    return 'Batas: $date';
  }

  @override
  String get pickDueDate => 'Pilih batas waktu (opsional)';

  @override
  String get assignTask => 'Berikan tugas 🚀';

  @override
  String get noTasksYetParent => 'Belum ada tugas';

  @override
  String get tapPlusToAssign => 'Ketuk + untuk memberi tugas ke anak!';

  @override
  String get geofenceChannelName => 'Peringatan zona aman';

  @override
  String get geofenceChannelDesc =>
      'Peringatan saat anak masuk atau keluar zona aman';

  @override
  String geofenceLeft(String name, String zone) {
    return '$name baru saja meninggalkan $zone';
  }

  @override
  String geofenceEntered(String name, String zone) {
    return '$name sudah tiba di $zone';
  }
}
