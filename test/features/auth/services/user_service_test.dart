import 'package:flutter_test/flutter_test.dart';
import 'package:kids_care/models/user_model.dart';

void main() {
  group('UserModel', () {
    test('UserModel should be created correctly', () {
      final user = UserModel(
        uid: 'test-uid-123',
        name: 'Test User',
        photoUrl: 'https://example.com/photo.jpg',
        fcmToken: 'test-fcm-token',
        role: 'parent',
      );

      expect(user.uid, 'test-uid-123');
      expect(user.name, 'Test User');
      expect(user.photoUrl, 'https://example.com/photo.jpg');
      expect(user.fcmToken, 'test-fcm-token');
      expect(user.role, 'parent');
    });

    test('UserModel should serialize to JSON', () {
      final user = UserModel(
        uid: 'test-uid-123',
        name: 'Test User',
        photoUrl: 'https://example.com/photo.jpg',
        fcmToken: 'test-fcm-token',
        role: 'parent',
      );

      final json = user.toJson();
      expect(json['uid'], 'test-uid-123');
      expect(json['name'], 'Test User');
      expect(json['photoUrl'], 'https://example.com/photo.jpg');
      expect(json['fcmToken'], 'test-fcm-token');
      expect(json['role'], 'parent');
    });

    test('UserModel should deserialize from JSON', () {
      final json = {
        'uid': 'test-uid-456',
        'name': 'Another User',
        'photoUrl': 'https://example.com/photo2.jpg',
        'fcmToken': 'test-fcm-token-2',
        'role': 'child',
      };
      final user = UserModel.fromJson(json);
      expect(user.uid, 'test-uid-456');
      expect(user.name, 'Another User');
      expect(user.photoUrl, 'https://example.com/photo2.jpg');
      expect(user.fcmToken, 'test-fcm-token-2');
      expect(user.role, 'child');
    });

    test('UserModel should have default role as child', () {
      final user = UserModel(
        uid: 'test-uid-789',
        name: 'Default User',
      );
      expect(user.role, 'child');
    });

    test('UserModel should handle null optional fields', () {
      final user = UserModel(
        uid: 'test-uid-999',
        name: 'Minimal User',
      );
      expect(user.photoUrl, isNull);
      expect(user.fcmToken, isNull);
    });

    test('UserModel should handle parent role', () {
      final user = UserModel(
        uid: 'parent-uid',
        name: 'Parent User',
        role: 'parent',
      );
      expect(user.role, 'parent');
    });

    test('UserModel should handle child role', () {
      final user = UserModel(
        uid: 'child-uid',
        name: 'Child User',
        role: 'child',
      );
      expect(user.role, 'child');
    });

    test('UserModel should handle empty strings for optional fields', () {
      final json = {
        'uid': 'test-uid',
        'name': 'Test User',
        'photoUrl': '',
        'fcmToken': '',
        'role': 'child',
      };
      final user = UserModel.fromJson(json);
      expect(user.photoUrl, '');
      expect(user.fcmToken, '');
    });
  });
}
