import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:province/models/district.dart';
import 'package:province/models/povince.dart';
import 'package:province/models/ward.dart';
import 'package:province/thong_tin_da_nhap_page.dart';

class CoBan extends StatefulWidget {
  const CoBan({super.key});

  @override
  State<CoBan> createState() => _CoBanState();
}

class _CoBanState extends State<CoBan> {
   Province? selectedProvince;
  District? selectedDistrict;
  Ward? selectedWard;
  String? email;
  String? name;
  String? phoneNumber;
  DateTime? birthDate;
  String? street;

  List<Province> provinceList = [];
  List<District> districtList = [];
  List<Ward> wardList = [];
   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    Future<void> loadLocationData() async {
    try {
      String data = await rootBundle.loadString('assets/don_vi_hanh_chinh.json');
      Map<String, dynamic> jsonData = json.decode(data);
      List<dynamic> provinceData = jsonData['province'];
      provinceList = provinceData.map((json) => Province.fromMap(json)).toList();
      List<dynamic> districtData = jsonData['district'];
      districtList = districtData.map((json) => District.fromMap(json)).toList();
      List<dynamic> wardData = jsonData['ward'];
      wardList = wardData.map((json) => Ward.fromMap(json)).toList();
    } catch (e) {
      debugPrint('Error loading location data: $e');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return  
     Form(
            key: _formKey, 
            child: SingleChildScrollView(
                  child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    labelText: 'Họ và tên',
                    hintText: 'Nhập họ và tên của bạn',
                  ),
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập Họ và tên ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    labelText: 'Email',
                    hintText: 'Nhập email của bạn',
                  ),
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                   validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập Email ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    labelText: 'Số điện thoại',
                    hintText: 'Nhập số điện thoại của bạn',
                  ),
                  onChanged: (value) {
                    setState(() {
                      phoneNumber = value;
                    });
                    
                  }, validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập Số điện thoại';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        labelText: 'Ngày sinh',
                        hintText: 'Chọn ngày',
                      ),
                      controller: TextEditingController(text: birthDate != null ? "${birthDate!.day}/${birthDate!.month}/${birthDate!.year}" : ''),
                       validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập ngày sinh';
                    }
                    return null;
                  },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // DropdownButton<Province>(
                //   hint: const Text('Tỉnh'),
                //   value: selectedProvince,
                //   onChanged: (Province? newValue) {
                //     setState(() {
                //       selectedProvince = newValue;
                //       selectedDistrict = null;
                //     });
                //   },
                //   items: provinceList.map<DropdownMenuItem<Province>>((Province province) {
                //     return DropdownMenuItem<Province>(
                //       value: province,
                //       child: Text(province.name ?? ''),
                //     );
                //   }).toList(),
                // ),
                // const SizedBox(height: 8),
                // if (selectedProvince != null)
                //   DropdownButton<District>(
                //     hint: const Text('Thành phố'),
                //     value: selectedDistrict,
                //     onChanged: (District? newValue) {
                //       setState(() {
                //         selectedDistrict = newValue;
                //       });
                //     },
                //     items: districtList.where((district) => district.provinceId == selectedProvince!.id).map<DropdownMenuItem<District>>((District district) {
                //       return DropdownMenuItem<District>(
                //         value: district,
                //         child: Text(district.name ?? ''),
                //       );
                //     }).toList(),
                //   ),
                // const SizedBox(height: 8),
                // if (selectedDistrict != null)
                //   DropdownButton<Ward>(
                //     hint: const Text('Phường'),
                //     value: selectedWard,
                //     onChanged: (Ward? newValue) {
                //       setState(() {
                //         selectedWard = newValue;
                //       });
                //     },
                //     items: wardList.where((ward) => ward.districtId == selectedDistrict!.id).map<DropdownMenuItem<Ward>>((Ward ward) {
                //       return DropdownMenuItem<Ward>(
                //         value: ward,
                //         child: Text(ward.name ?? ''),
                //       );
                //     }).toList(),
                //   ),
                // const SizedBox(height: 8),
                // TextFormField(
                //   decoration: InputDecoration(
                //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                //     labelText: 'Địa chỉ chi tiết ',
                //     hintText: 'Nhập địa chỉ chi tiết của bạn',
                //   ),
                //   onChanged: (value) {
                //     setState(() {
                //       street = value;
                //     });
                //   },
                //    validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Vui lòng nhập địa chỉ chi tiết ';
                //     }
                //     return null;
                //   },
                // ),
                // const SizedBox(height: 8),
                // ElevatedButton(
                //   onPressed: () {
                //     _submitData(context);
                //   },
                //   child: const Text('Gửi'),
                // ),
          //       ElevatedButton(
          //   onPressed: () {
          //     if (_formKey.currentState!.validate()) {
                
          //       _submitData(context);
          //     }
          //   },
          //   child: const Text('Gửi'),
          // ),
              ],
            ),
                  ),
                ),
          );
  }
    Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: birthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != birthDate) {
      setState(() {
        birthDate = pickedDate;
      });
    }
  }void _submitData(BuildContext context) {
    if (name == null || email == null || phoneNumber == null || birthDate == null || selectedProvince == null || selectedDistrict == null || selectedWard == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Lỗi'),
            content: const Text('Vui lòng điền đầy đủ thông tin'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Đóng'),
              ),
            ],
          );
        },
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ThongTinDaNhap(
          name: name!,
          email: email!,
          phoneNumber: phoneNumber!,
          birthDate: birthDate!,
          selectedProvince: selectedProvince!,
          selectedDistrict: selectedDistrict!,
          selectedWard: selectedWard!,
          street: street!,
        ),
      ),
    );
  }

}

 