import 'package:flutter_test/flutter_test.dart';
import 'package:province/models/ward.dart';

void main() {
  Ward? ward;

  group('Ward', () {
    test('test Ward', () {
      var ward = Ward(
        id: "0001",
        name: "Phường Phúc Tân",
        level: "Phường",
        districtId: "001",
        provinceId: "01",
      );
      expect(ward.id, "0001");
      expect(ward.name, "Phường Phúc Tân");
      expect(ward.level, "Phường");
      expect(ward.districtId, "001");
      expect(ward.provinceId, "01");
    });
  });
  group('test Ward:', () {
    setUp(
      () {
        ward = Ward(
              id: "0001",
            name: "Phường Phúc Tân",
            level: "Phường",
            districtId: "001",
            provinceId: "01",
        );
      }
    );
    test('test Ward?',(){
       expect(ward?.id, equals("0001"));
      expect(ward?.name, equals("Phường Phúc Tân"));
      expect(ward?.level, equals("Phường"));
      expect(ward?.districtId, equals("001"));
      expect(ward?.provinceId, equals("01"));
    });
  });
}
