import 'package:flutter_test/flutter_test.dart';
import 'package:province/models/district.dart';

void main() {
  District? district;
  group('District', () {
    test('test District', () {
      var district = District(id: "001", name: "Quận Hoàn Kiếm", level: "Quận", provinceId: "01");
      expect(district.id, "001");
      expect(district.name, "Quận Hoàn Kiếm");
      expect(district.level, "Quận");
    });
  });
  group('Test District:', () {
    setUp(() {
      district = District(
        id: "01",
        name: "Quận Hoàn Kiếm",
        level: "Quận",
      );
    });

    test('test Province?', () {
      expect(district?.id, equals("01"));
      expect(district?.name, equals("Quận Hoàn Kiếm"));
      expect(district?.level, equals("Quận"));
    });
  });
}
