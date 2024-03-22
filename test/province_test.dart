import 'package:flutter_test/flutter_test.dart';
import 'package:province/models/povince.dart';
 

void main() {
  Province? province; 

  group('Province', () {
    test('test Province', () {
      var province = Province(
        id: "01",
        name: "Thành phố Hà Nội",
        level: "Thành phố Trung ương",
      );
      expect(province.id, "01");
      expect(province.name, "Thành phố Hà Nội");
      expect(province.level, "Thành phố Trung ương");
    });
  });

  group('Test Province:', () {
    setUp(() {
      province = Province(
        id: "01",
        name: "Thành phố Hà Nội",
        level: "Thành phố Trung ương",
      );
    });

    test('test Province?', () {
      expect(province?.id, equals("01"));
      expect(province?.name, equals("Thành phố Hà Nội"));
      expect(province?.level, equals("Thành phố Trung ương"));
    });
  });
}
