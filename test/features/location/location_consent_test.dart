import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kids_care/features/auth/providers/auth_providers.dart';
import 'package:kids_care/features/location/location_consent.dart';
import 'package:kids_care/l10n/app_localizations.dart';
import 'package:kids_care/l10n/app_localizations_en.dart';
import 'package:kids_care/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _linkedChild = UserModel(
  uid: 'c',
  name: 'Mia',
  role: 'child',
  linkedParentIds: ['p'],
);
const _unlinkedChild = UserModel(uid: 'c', name: 'Mia', role: 'child');
const _parent = UserModel(
  uid: 'p',
  name: 'Alex',
  role: 'parent',
  linkedChildIds: ['c'],
);

ProviderContainer _container(UserModel? user) {
  final container = ProviderContainer(
    overrides: [
      currentUserProvider.overrideWith((ref) => Stream.value(user)),
    ],
  );
  addTearDown(container.dispose);
  container.listen(currentUserProvider, (_, _) {});
  return container;
}

Future<void> _settle(ProviderContainer container) async {
  await container.read(currentUserProvider.future);
  await container.read(locationConsentProvider.notifier).loaded;
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('locationConsentProvider', () {
    test('chưa đọc xong là null, chưa đồng ý là false', () async {
      final container = _container(_linkedChild);
      expect(container.read(locationConsentProvider), isNull);
      await _settle(container);
      expect(container.read(locationConsentProvider), isFalse);
    });

    test('đồng ý được lưu lại cho lần mở sau', () async {
      final first = _container(_linkedChild);
      await _settle(first);
      await first.read(locationConsentProvider.notifier).accept();
      expect(first.read(locationConsentProvider), isTrue);

      final second = _container(_linkedChild);
      await _settle(second);
      expect(second.read(locationConsentProvider), isTrue);
    });

    test('reset xoá đồng ý (khi xoá tài khoản)', () async {
      final first = _container(_linkedChild);
      await _settle(first);
      final consent = first.read(locationConsentProvider.notifier);
      await consent.accept();
      await consent.reset();
      expect(first.read(locationConsentProvider), isFalse);

      final second = _container(_linkedChild);
      await _settle(second);
      expect(second.read(locationConsentProvider), isFalse);
    });
  });

  group('needsLocationDisclosureProvider', () {
    Future<bool> needs(UserModel? user) async {
      final container = _container(user);
      await _settle(container);
      return container.read(needsLocationDisclosureProvider);
    }

    test('hỏi bé đã liên kết mà chưa đồng ý', () async {
      expect(await needs(_linkedChild), isTrue);
    });

    test('không hỏi khi chưa liên kết, chưa đăng nhập, hoặc là bố/mẹ', () async {
      expect(await needs(_unlinkedChild), isFalse);
      expect(await needs(null), isFalse);
      expect(await needs(_parent), isFalse);
    });

    test('không hỏi lại sau khi đã đồng ý', () async {
      SharedPreferences.setMockInitialValues({
        'location_disclosure_accepted': true,
      });
      expect(await needs(_linkedChild), isFalse);
    });

    test('chưa đọc xong thì chưa hỏi (tránh hiện nhầm)', () {
      final container = _container(_linkedChild);
      expect(container.read(needsLocationDisclosureProvider), isFalse);
    });
  });

  group('showLocationDisclosure', () {
    Future<(ProviderContainer, BuildContext)> pump(WidgetTester tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      late BuildContext captured;
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            locale: const Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Consumer(
              builder: (context, ref, _) {
                captured = context;
                return const Scaffold();
              },
            ),
          ),
        ),
      );
      await tester.runAsync(
        () => container.read(locationConsentProvider.notifier).loaded,
      );
      return (container, captured);
    }

    Future<bool?> open(
      WidgetTester tester,
      ProviderContainer container,
      BuildContext context,
      String button,
    ) async {
      bool? result;
      showLocationDisclosure(
        context,
        container.read(locationConsentProvider.notifier),
      ).then((v) => result = v);
      await tester.pumpAndSettle();
      await tester.tap(find.text(button));
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pumpAndSettle();
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      return result;
    }

    testWidgets('Tiếp tục: lưu đồng ý', (tester) async {
      final (container, context) = await pump(tester);
      final result = await open(tester, container, context, 'Continue');
      expect(result, isTrue);
      expect(container.read(locationConsentProvider), isTrue);
    });

    testWidgets('Để sau: không đồng ý, không lưu', (tester) async {
      final (container, context) = await pump(tester);
      final result = await open(tester, container, context, 'Not now');
      expect(result, isFalse);
      expect(container.read(locationConsentProvider), isFalse);
    });

    testWidgets('không đóng được bằng cách bấm ra ngoài', (tester) async {
      final (container, context) = await pump(tester);
      showLocationDisclosure(
        context,
        container.read(locationConsentProvider.notifier),
      );
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(4, 4));
      await tester.pumpAndSettle();
      expect(find.text('Continue'), findsOneWidget);
    });
  });

  test('thông báo có đủ nội dung Google Play yêu cầu', () {
    final body = AppLocalizationsEn().locationDisclosureBody;
    expect(body, contains('location'));
    expect(body, contains('even when the app is closed or not in use'));
    expect(body, contains('safe zone'));
  });
}
