
import 'package:flutter_test/flutter_test.dart';
import 'package:province/models/addressinfo.dart';
import 'package:province/models/district.dart';
import 'package:province/models/povince.dart';
import 'package:province/models/ward.dart';


void main() {
  AddressInfo? addressInfo;

  group('AddressInfo', () {
    test('Test AddressInfo', () {
      addressInfo = AddressInfo(
        province: Province(
          id: "01",
          name: "Thành phố Hà Nội",
          level: "Thành phố Trung ương",
        ),
        district: District(
          id: "001",
          name: "Quận Hoàn Kiếm",
          level: "Quận",
          provinceId: "01",
        ),
        ward: Ward(
          id: "0001",
          name: "Phường Phúc Tân",
          level: "Phường",
          districtId: "001",
          provinceId: "01",
        ),
        street: "Phạm Văn Đồng",
      );

      expect(addressInfo?.province?.id, "01");
      expect(addressInfo?.province?.name, "Thành phố Hà Nội");
      expect(addressInfo?.province?.level, "Thành phố Trung ương");

      expect(addressInfo?.district?.id, "001");
      expect(addressInfo?.district?.name, "Quận Hoàn Kiếm");
      expect(addressInfo?.district?.level, "Quận");

      expect(addressInfo?.ward?.id, "0001");
      expect(addressInfo?.ward?.name, "Phường Phúc Tân");
      expect(addressInfo?.ward?.level, "Phường");

      expect(addressInfo?.street, "Phạm Văn Đồng");
    });
  });
}
