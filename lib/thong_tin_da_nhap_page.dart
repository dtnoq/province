import 'package:flutter/material.dart';
import 'package:province/models/district.dart';
import 'package:province/models/povince.dart';
import 'package:province/models/ward.dart';

class ThongTinDaNhap extends StatelessWidget {
  final String name;
  final String email;
  final String phoneNumber;
  final DateTime birthDate;
  final Province selectedProvince;
  final District selectedDistrict;
  final Ward selectedWard;
  final String street;

  const ThongTinDaNhap({
    super.key, 
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.birthDate,
    required this.selectedProvince,
    required this.selectedDistrict,
    required this.selectedWard,
    required this.street,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin đã nhập'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text('Họ và tên: $name'),
            ),
            ListTile(
              title: Text('Email: $email'),
            ),
            ListTile(
              title: Text('Số điện thoại: $phoneNumber'),
            ),
            ListTile(
              title: Text('Ngày sinh: ${birthDate.day}/${birthDate.month}/${birthDate.year}'),
            ),
            ListTile(
              title: Text('Tỉnh: ${selectedProvince.name}'),
            ),
            ListTile(
              title: Text('Thành phố: ${selectedDistrict.name}'),
            ),
            ListTile(
              title: Text('Phường: ${selectedWard.name}'),
            ),
            ListTile(
              title: Text('Địa chỉ chi tiết: $street'),
            ),
          ],
        ),
      ),
    );
  }
}
