import 'package:flutter_test/flutter_test.dart';
import 'package:kids_care/models/user_model.dart';

void main() {
  group('UserModel', () {
    test('serializes new guest fields to/from JSON', () {
      const model = UserModel(
        uid: 'test-uid',
        name: 'Test',
        isGuest: true,
        linkCode: 'ABC-123',
        linkedParentId: 'parent-uid',
        linkedChildIds: ['child-uid-1'],
        role: 'child',
      );
      final json = model.toJson();
      expect(json['isGuest'], true);
      expect(json['linkCode'], 'ABC-123');
      expect(json['linkedParentId'], 'parent-uid');
      expect(json['linkedChildIds'], ['child-uid-1']);

      final restored = UserModel.fromJson(json);
      expect(restored, model);
    });

    test('defaults: isGuest=false, linkCode=null, empty linkedChildIds', () {
      const model = UserModel(uid: 'u', name: 'N');
      expect(model.isGuest, false);
      expect(model.linkCode, null);
      expect(model.linkedChildIds, isEmpty);
    });
  });
}
