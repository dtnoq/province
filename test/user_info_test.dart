import 'package:flutter_test/flutter_test.dart';
import 'package:province/models/addressinfo.dart';
import 'package:province/models/district.dart';
import 'package:province/models/povince.dart';
import 'package:province/models/userInfo.dart';
import 'package:province/models/ward.dart';

void main() {
  UserInfo? userInfo;

  group('UserInfo', () {
    test('Test UserInfo', () {
      userInfo = UserInfo(
        name: "Phạm Tiến Dũng",
        email: "phamdung@gmail.com",
        phoneNumber: "123456789",
        birthDate: DateTime(2003, 5, 20),
        address: AddressInfo(
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
        ),
      );

      expect(userInfo?.name, "Phạm Tiến Dũng");
      expect(userInfo?.email, "phamdung@gmail.com");
      expect(userInfo?.phoneNumber, "123456789");
      expect(userInfo?.birthDate, DateTime(2003, 5, 20));

      expect(userInfo?.address?.province?.id, "01");
      expect(userInfo?.address?.province?.name, "Thành phố Hà Nội");
      expect(userInfo?.address?.province?.level, "Thành phố Trung ương");

      expect(userInfo?.address?.district?.id, "001");
      expect(userInfo?.address?.district?.name, "Quận Hoàn Kiếm");
      expect(userInfo?.address?.district?.level, "Quận");

      expect(userInfo?.address?.ward?.id, "0001");
      expect(userInfo?.address?.ward?.name, "Phường Phúc Tân");
      expect(userInfo?.address?.ward?.level, "Phường");

      expect(userInfo?.address?.street, "Phạm Văn Đồng");
    });
  });
}
