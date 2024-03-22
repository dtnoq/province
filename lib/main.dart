// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:province/models/povince.dart';
// import 'package:province/page/step_1.dart';
// import 'package:province/thong_tin_da_nhap_page.dart';

// import 'models/district.dart';

// import 'models/ward.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: HomePage(),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   HomePageState createState() => HomePageState();
// }

// class HomePageState extends State<HomePage> {
//   Province? selectedProvince;
//   District? selectedDistrict;
//   Ward? selectedWard;
//   String? email;
//   String? name;
//   String? phoneNumber;
//   DateTime? birthDate;
//   String? street;

//   List<Province> provinceList = [];
//   List<District> districtList = [];
//   List<Ward> wardList = [];
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   loadLocationData();
//   // }

//   // Future<void> loadLocationData() async {
//   //   try {
//   //     String data = await rootBundle.loadString('assets/don_vi_hanh_chinh.json');
//   //     Map<String, dynamic> jsonData = json.decode(data);
//   //     List<dynamic> provinceData = jsonData['province'];
//   //     provinceList = provinceData.map((json) => Province.fromMap(json)).toList();
//   //     List<dynamic> districtData = jsonData['district'];
//   //     districtList = districtData.map((json) => District.fromMap(json)).toList();
//   //     List<dynamic> wardData = jsonData['ward'];
//   //     wardList = wardData.map((json) => Ward.fromMap(json)).toList();
//   //   } catch (e) {
//   //     debugPrint('Error loading location data: $e');
//   //   }
//   //   setState(() {});
//   // }

//   @override
//    Widget build(BuildContext context) {
//     int currentStep = 0;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Thông tin cá nhân'),
//       ),
//       body: Stepper(
//         currentStep: currentStep,

//         onStepContinue: () {

//           setState(() {

//             currentStep += 1;
//           });
//         },
//         steps: [
//           Step(

//             title: Text("Cơ bản"),
//             content: CoBan(),
//             isActive: currentStep == 0,
//           ),
//           Step(
//             title: Text("Địa chỉ"),
//             content: Text("hahaha"),
//             isActive: currentStep == 1,
//           ),
//           Step(
//             title: Text("Xác nhận"),
//             content: Text("hahaha"),
//             isActive: currentStep == 2,
//           ),
//         ],
//         type: StepperType.horizontal,
//         controlsBuilder: (context, details) {

//           return Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [

//            if(currentStep == 2)
//            FilledButton(child:Text('Lưu'),onPressed: details.onStepContinue,)
//            else FilledButton.tonal(child: Text('Tiếp'),onPressed: details.onStepContinue,),
//            if(currentStep >0)
//            TextButton(onPressed: details.onStepCancel,child: Text('Quay lại'),),
//            if(currentStep ==2)OutlinedButton(onPressed: () {

//            },child: Text("Đóng"),)

//             ],

//           );
//         },
//       ),
//     );
//   }
//   // Widget build(BuildContext context) {
//   //   int currentStep = 0;

//   //   return Scaffold(
//   //       appBar: AppBar(
//   //         title: const Text('Thông tin cá nhân'),
//   //       ),
//   //       body: Stepper(
//   //         currentStep: currentStep,
//   //         onStepContinue: () {
//   //           setState(() {
//   //             currentStep += 1;
//   //           });
//   //         },
//   //         onStepCancel: () {
//   //           setState(() {
//   //             currentStep -= 1;
//   //           });
//   //         },
//   //         steps: [
//   //           Step(title: Text("Cơ bản"), content: CoBan(), isActive: currentStep == 0),
//   //           Step(title: Text("Địa chỉ"), content: Text("hahaha"), isActive: currentStep == 1),
//   //           Step(title: Text("Xác nhận"), content: Text("hahaha"), isActive: currentStep == 2)
//   //         ],
//   //         type: StepperType.horizontal,
//   //         controlsBuilder: (context, details) {
//   //           return Row(
//   //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //             children: [
//   //               if (currentStep == 0)
//   //                 FilledButton(
//   //                   onPressed: () {
//   //                     if (_formKey.currentState!.validate()) {
//   //                       _submitData(context);
//   //                     }
//   //                   },
//   //                   child: Text(' Tiếp'),
//   //                 ),
//   //               if (currentStep == 1)
//   //                 FilledButton(
//   //                   onPressed: () {},
//   //                   child: Text(' Tiếp'),
//   //                 ),
//   //               FilledButton(
//   //                 onPressed: () {},
//   //                 child: Text(' Quay lại'),
//   //               ),
//   //             ],
//   //           );
//   //         },
//   //       ));
//   // }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: birthDate ?? DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//     );
//     if (pickedDate != null && pickedDate != birthDate) {
//       setState(() {
//         birthDate = pickedDate;
//       });
//     }
//   }

//   void _submitData(BuildContext context) {
//     if (name == null || email == null || phoneNumber == null || birthDate == null || selectedProvince == null || selectedDistrict == null || selectedWard == null) {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Lỗi'),
//             content: const Text('Vui lòng điền đầy đủ thông tin'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('Đóng'),
//               ),
//             ],
//           );
//         },
//       );
//       return;
//     }

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ThongTinDaNhap(
//           name: name!,
//           email: email!,
//           phoneNumber: phoneNumber!,
//           birthDate: birthDate!,
//           selectedProvince: selectedProvince!,
//           selectedDistrict: selectedDistrict!,
//           selectedWard: selectedWard!,
//           street: street!,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:province/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized;
  runApp(const MyApp());

}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter ',
      home: HomePage(),
     );
  }
}