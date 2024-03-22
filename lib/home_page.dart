// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:localstore/localstore.dart';

import 'package:province/models/addressinfo.dart';
import 'package:province/models/district.dart';
import 'package:province/models/povince.dart';
import 'package:province/models/userInfo.dart';
import 'package:province/models/ward.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final step1FormKey = GlobalKey<FormState>();
  final step2FormKey = GlobalKey<FormState>();
  int currentStep = 0;
  UserInfo userInfo = UserInfo();
  bool isLoaded = false;
  Future<UserInfo> init() async {
    if (isLoaded) return userInfo;
    var value = await loadUserInfo();
    if (value != null) {
      try {
        isLoaded = true;
        return UserInfo.fromMap(value);
      } catch (e) {
        debugPrint(e.toString());
        return UserInfo();
      }
    }
    return UserInfo();
  }

  @override
  Widget build(BuildContext context) {
    void updateStep(int value) {
      if (currentStep == 0) {
        if (step1FormKey.currentState!.validate()) {
          step1FormKey.currentState!.save();
          setState(() {
            currentStep = value;
          });
        }
      } else if (currentStep == 1) {
        if (value > currentStep) {
          if (step2FormKey.currentState!.validate()) {
            step2FormKey.currentState!.save();
            setState(() {
              currentStep = value;
            });
          }
        } else if (currentStep == 2) {
          setState(
            () {
              if (value < currentStep) {
                currentStep = value;
              } else {
                saveUserInfo(userInfo).then(
                  (value) {
                    showDialog<void>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Thông báo'),
                          content: const SingleChildScrollView(
                            child: ListBody(
                              children: [
                                Text('Hồ sơ người dùng được lưu thành công'),
                                Text('Bạn có thể quay lại các bước để cập nhật'),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: const Text('Đóng'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      },
                    );
                  },
                );
              }
            },
          );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cập nhật hồ sơ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Xác nhận'),
                    content: Text('Bạn có muốn xóa thông tin đã lưu?'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Hủy'),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      TextButton(
                        child: Text('Đồng ý'),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ],
                  );
                },
              ).then(
                (value) {
                  if (value != null && value == true) {
                    setState(() {
                      userInfo = UserInfo();
                    });
                    saveUserInfo(userInfo);
                  }
                },
              );
            },
          )
        ],
      ),
      body: FutureBuilder<UserInfo>(
        future: init(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            userInfo = snapshot.data!;
            return Stepper(
              type: StepperType.horizontal,
              currentStep: currentStep,
              controlsBuilder: (context, details) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      children: [
                        if (currentStep == 2)
                          FilledButton(
                            child: Text('Lưu'),
                            onPressed: details.onStepContinue,
                          )
                        else
                          FilledButton.tonal(
                            onPressed: details.onStepContinue,
                            child: Text('Tiếp'),
                          ),
                        if (currentStep > 0)
                          TextButton(
                            onPressed: details.onStepCancel,
                            child: Text('Quay lại'),
                          ),
                      ],
                    ),
                    if (currentStep == 2)
                      OutlinedButton(
                        onPressed: () {},
                        child: Text('Đóng'),
                      )
                  ],
                );
              },
              onStepTapped: (value) {
                updateStep(value);
              },
              onStepContinue: () {
                updateStep(currentStep + 1);
              },
              onStepCancel: () {
                if (currentStep > 0) {
                  setState(() {
                    currentStep--;
                  });
                }
              },
              steps: [
                Step(
                    title: Text('Cơ bản'),
                    content: Step1Form(
                      formKey: step1FormKey,
                      userInfo: userInfo,
                    ),
                    isActive: currentStep == 0),
                Step(
                    title: Text('Địa chỉ'),
                    content: Step2Form(
                      formKey: step2FormKey,
                      userInfo: userInfo,
                    ),
                    isActive: currentStep == 1),
                Step(
                    title: Text('Xác nhận'),
                    content: ConfirmInfo(
                      userInfo: userInfo,
                    ),
                    isActive: currentStep == 2),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Lỗi: ${snapshot.error}"),
            );
          } else {
            return const Center(child: LinearProgressIndicator());
          }
        },
      ),
    );
  }
}

class Step1Form extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final UserInfo userInfo;
  const Step1Form({super.key, required this.formKey, required this.userInfo});

  @override
  State<Step1Form> createState() => _Step1FormState();
}

class _Step1FormState extends State<Step1Form> {
  final nameCtl = TextEditingController();
  final dateCtl = TextEditingController();
  final emailCtl = TextEditingController();
  final phoneCtl = TextEditingController();
  bool isEmailValid(String email) {
    String pattern = r"^[a-zA-Z0-9._%+-]+@[a-z0-9.-]+\.[a-zA-Z]{2,4}";
    final emailRegex = RegExp(pattern);
    return emailRegex.hasMatch(email);
  }

  // bool isMobileValid(String value) {
  //   String pattern =
  //   "(03|05|07|08|09|01[2|6|8|9])+([0-9]{8})\b";
  //   r"^[0-9]{3} [0-9]{3} [0-9]{4}";
  //   final regExp = RegExp(pattern);
  //   return regExp.hasMatch(value);
  // }

  @override
  Widget build(BuildContext context) {
    nameCtl.text = widget.userInfo.name ?? '';
    dateCtl.text = widget.userInfo.birthDate != null ? DateFormat('dd/MM/yyyy').format(widget.userInfo.birthDate!) : '';
    emailCtl.text = widget.userInfo.email ?? '';
    phoneCtl.text = widget.userInfo.phoneNumber ?? '';
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Form(
        key: widget.formKey,
        child: Column(children: [
          TextFormField(
            controller: nameCtl,
            decoration: InputDecoration(
              labelText: 'Họ và Tên',
            ),
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập Họ và Tên';
              }
              return null;
            },
            onChanged: (value) => widget.userInfo.name = value,
          ),
          TextFormField(
            controller: dateCtl,
            decoration: InputDecoration(
              labelText: 'Ngày sinh',
              hintText: 'Nhập ngày sinh',
            ),
            onTap: () async {
              DateTime? date = DateTime(1900);
              FocusScope.of(context).requestFocus(FocusNode());
              date = await showDatePicker(context: context, initialEntryMode: DatePickerEntryMode.calendarOnly, initialDate: widget.userInfo.birthDate ?? DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime(2100));
              if (date != null) {
                widget.userInfo.birthDate = date;
                dateCtl.text = DateFormat('dd/MM/yyyy').format(date);
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return ' Vui lòng nhập ngày  sinh';
              }
              try {
                DateFormat("dd/MM/yyyy").parse(value);
                return null;
              } catch (e) {
                return 'Ngày sinh không hợp lệ';
              }
            },
          ),
          TextFormField(
            controller: emailCtl,
            decoration: InputDecoration(
              labelText: ('Email'),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập email';
              } else if (!isEmailValid(value)) {
                return 'Định dạnh email không hộp lệ !';
              }
              return null;
            },
            onChanged: (value) => widget.userInfo.email = value,
          ),
          TextFormField(
            controller: phoneCtl,
            decoration: InputDecoration(labelText: ' Số điện thoại'),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập số điện thoại';
              }
              // else if (!isMobileValid(value)) {
              //   return 'Định dạng số điện thoại không hợp lê';
              // }
              return null;
            },
            onChanged: (value) => widget.userInfo.phoneNumber = value,
          )
        ]),
      ),
    );
  }
}

class Step2Form extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final UserInfo userInfo;
  const Step2Form({
    super.key,
    required this.formKey,
    required this.userInfo,
  });

  @override
  State<Step2Form> createState() => _Step2FormState();
}

class _Step2FormState extends State<Step2Form> {
  final streetCtl = TextEditingController();
  List<Province> provinceList = [];
  List<District> districtList = [];
  List<Ward> wardList = [];
  @override
  void initState() {
    loadLocationData().then((value) => setState(
          () {},
        ));
    super.initState();
  }

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
    streetCtl.text = widget.userInfo.address?.street ?? '';
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Form(
        key: widget.formKey,
        child: Column(children: [
          Autocomplete<Province>(
            fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                textEditingController.text = widget.userInfo.address?.province?.name ?? '';
              });
              return TextFormField(
                decoration: InputDecoration(labelText: 'Tỉnh/ Thành phố'),
                controller: textEditingController,
                focusNode: focusNode,
                validator: (value) {
                  if (widget.userInfo.address?.province == null || value!.isEmpty) {
                    return "Vui lòng chọn Tỉnh/Thành phố";
                  }
                  return null;
                },
              );
            },
            displayStringForOption: (option) => option.name!,
            optionsBuilder: (textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return provinceList;
              }
              return provinceList.where(
                (element) {
                  final title = removeDiacritics(element.name ?? '');
                  final keyword = removeDiacritics(textEditingValue.text);
                  final pattern = r'\b(' + keyword + r')\b';
                  final regExp = RegExp(pattern, caseSensitive: false);
                  return title.isNotEmpty && regExp.hasMatch(title);
                },
              );
            },
            onSelected: (option) {
              if (widget.userInfo.address?.province != option) {
                setState(() {
                  widget.userInfo.address = AddressInfo(province: option);
                });
              }
            },
          ),
          Autocomplete<District>(
            fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                textEditingController.text = widget.userInfo.address?.district?.name ?? '';
              });
              return TextFormField(
                decoration: InputDecoration(labelText: 'Quận / Huyện'),
                controller: textEditingController,
                focusNode: focusNode,
                validator: (value) {
                  if (widget.userInfo.address?.district == null || value!.isEmpty) {
                    return "Vui lòng chọn Quận / Huyện";
                  }
                  return null;
                },
              );
            },
            displayStringForOption: (option) => option.name!,
            optionsBuilder: (textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return districtList.where((element) => widget.userInfo.address?.province?.id != null && element.provinceId == widget.userInfo.address?.province?.id);
              }
              return districtList.where(
                (element) {
                  var cond1 = element.provinceId == widget.userInfo.address?.province?.id;
                  final title = removeDiacritics(element.name ?? '');
                  final keyword = removeDiacritics(textEditingValue.text);
                  final pattern = r'\b(' + keyword + r')\b';
                  final regExp = RegExp(pattern, caseSensitive: false);
                  return cond1 && title.isNotEmpty && regExp.hasMatch(title);
                },
              );
            },
            onSelected: (option) {
              if (widget.userInfo.address?.district != option) {
                setState(() {
                  widget.userInfo.address?.district = option;
                  widget.userInfo.address?.ward = null;
                });
              }
            },
          ),
          Autocomplete<Ward>(
            fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                textEditingController.text = widget.userInfo.address?.ward?.name ?? '';
              });
              return TextFormField(
                decoration: InputDecoration(labelText: 'Xã / Phường / Thị Trấn'),
                controller: textEditingController,
                focusNode: focusNode,
                validator: (value) {
                  if (widget.userInfo.address?.ward == null || value!.isEmpty) {
                    return "Vui lòng chọn Xã / Phường / Thị Trấn";
                  }
                  return null;
                },
              );
            },
            displayStringForOption: (option) => option.name!,
            optionsBuilder: (textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return wardList.where((element) => element.districtId == widget.userInfo.address?.district?.id);
              }
              return wardList.where(
                (element) {
                  var cond1 = element.districtId == widget.userInfo.address?.district?.id;
                  final title = removeDiacritics(element.name ?? '');
                  final keyword = removeDiacritics(textEditingValue.text);
                  final pattern = r'\b(' + keyword + r')\b';
                  final regExp = RegExp(pattern, caseSensitive: false);
                  return cond1 && title.isNotEmpty && regExp.hasMatch(title);
                },
              );
            },
            onSelected: (option) {
              widget.userInfo.address?.ward = option;
            },
          ),
          TextFormField(
            controller: streetCtl,
            decoration: InputDecoration(labelText: 'Địa chỉ'),
            keyboardType: TextInputType.streetAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập địa chỉ';
              }
              return null;
            },
            onSaved: (value) {
              widget.userInfo.address?.street = value!;
            },
          )
        ]),
      ),
    );
  }
}

class ConfirmInfo extends StatelessWidget {
  final UserInfo userInfo;
  const ConfirmInfo({
    Key? key,
    required this.userInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(children: [
        _buildInfoItem(' Họ và Tên:', userInfo.name),
        _buildInfoItem(
          'Ngày sinh:',
          userInfo.birthDate != null ? DateFormat('dd/MM/yyyy').format(userInfo.birthDate!) : '',
        ),
        _buildInfoItem('Email:', userInfo.email),
        _buildInfoItem('Số điện thoại:', userInfo.phoneNumber),
        _buildInfoItem('Tỉnh / Thành phố:', userInfo.address?.province?.name),
        _buildInfoItem('Quận / Huyện:', userInfo.address?.district?.name),
        _buildInfoItem('Xã / Phường / Thị Trấn:', userInfo.address?.province?.name),
        _buildInfoItem('Địa chỉ:', userInfo.address?.street),
      ]),
    );
  }
}

Widget _buildInfoItem(String label, String? value) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8.0),
    child: TextField(
      readOnly: true,
      controller: TextEditingController(text: value),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.all(8.0),
      ),
      style: TextStyle(fontSize: 16),
    ),
  );
}

Future<void> saveUserInfo(UserInfo info) async {
  return await Localstore.instance.collection('users').doc('info').set(info.toMap());
}

Future<Map<String, dynamic>?> loadUserInfo() async {
  return await Localstore.instance.collection('users').doc('info').get();
}
