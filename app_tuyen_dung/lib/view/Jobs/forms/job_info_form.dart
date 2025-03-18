// ignore_for_file: prefer_const_constructors

import 'package:app_tuyen_dung/data/models/job_model.dart';
import 'package:app_tuyen_dung/utils/constans.dart';
import 'package:app_tuyen_dung/utils/validators.dart';
import 'package:app_tuyen_dung/view/widgets/button.dart';
import 'package:app_tuyen_dung/viewmodel/provider/account_provider.dart';
import 'package:app_tuyen_dung/viewmodel/provider/jobs_provider.dart';
import 'package:app_tuyen_dung/view/widgets/dropdown_btn.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../data/base/status_model.dart';
import '../../../utils/enums.dart';
import '../../widgets/text_field.dart';
import '../../widgets/expand_btn.dart';
import '../../widgets/function/alert_dialog.dart';

class JobInfoForm extends StatefulWidget{
  const JobInfoForm({super.key, this.model});
  final Job? model;

  @override
  State<JobInfoForm> createState() => _JobInfoFormState();
}

class _JobInfoFormState extends State<JobInfoForm> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController titleCtrl = TextEditingController();
  TextEditingController minSalaryCtrl = TextEditingController();
  TextEditingController maxSalaryCtrl = TextEditingController();
  List areasCtrl = [];
  TextEditingController experienceCtrl = TextEditingController();
  String? position;
  TextEditingController amountCtrl = TextEditingController();
  String? workingType;
  List occupationsCtrl = [];
  TextEditingController descriptionsCtrl = TextEditingController();
  TextEditingController requirementsCtrl = TextEditingController();
  TextEditingController benefitsCtrl = TextEditingController();
  TextEditingController addressesCtrl = TextEditingController();
  TextEditingController workingTimeCtrl = TextEditingController();
  TextEditingController expiredDateCtrl = TextEditingController();

  var positions = Constants.positions.map((value) => 
    DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    )
  ).toList();


  var workingTypes = Constants.workingTypes.map((value) => 
    DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    )
  ).toList();
  
  bool isInAreas(String area) {
    if (areasCtrl.contains(area)) {
      return true;
    } else {
      return false;
    }
  }

  bool isInOcupations(String occupation) {
    if (occupationsCtrl.contains(occupation)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    var model = widget.model;
    if (model != null) {
      titleCtrl.text = model.title;
      minSalaryCtrl.text = model.minSalary.toString();
      maxSalaryCtrl.text = model.maxSalary.toString();
      areasCtrl = model.areas;
      experienceCtrl.text = model.experience.toString();
      if (Constants.positions.contains(model.position)) {
        position = model.position;
      }
      amountCtrl.text = model.amount.toString();
      if (Constants.workingTypes.contains(model.workingType)) {
        workingType = model.workingType;
      }
      occupationsCtrl = model.occupations;
      descriptionsCtrl.text = model.descriptions;
      requirementsCtrl.text = model.requirements;
      benefitsCtrl.text = model.benefits;
      addressesCtrl.text = model.addresses;
      workingTimeCtrl.text = model.workingTime;
      expiredDateCtrl.text = model.expiredDate;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AccountProvider accountProvider = Provider.of<AccountProvider>(context);
    final JobsProvider jobsProvider = Provider.of<JobsProvider>(context);
    Job? model = widget.model;
    return Scaffold(
      appBar: AppBar(
        title:  Text((widget.model == null) ? 'Thêm tin tuyển dụng' : 'Sửa tin tuyển dụng', style: TextStyle(fontSize: 16),),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(onPressed: () { showAlertDialog(AlertType.alert, 'Lương đơn vị là triệu VNĐ, ví dụ lương là 5 triệu nhập 5, có thể không nhập lương tối thiểu hoặc lương tối đa hoặc cả hai', context); }, icon: Icon(Icons.question_mark_rounded), style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.white)),)
        ],
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5 ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomTextField(controller: titleCtrl, label: 'Tiêu đề tin tuyển dụng',validator: Validator.notNull,),
                CustomTextField(controller: minSalaryCtrl, label: 'Lương tối thiểu',validator: Validator.salaryValidator, icon: Icons.monetization_on, isNumKeyboard: true,),
                CustomTextField(controller: maxSalaryCtrl, label: 'Lương tối đa',validator: Validator.salaryValidator, icon: Icons.monetization_on, isNumKeyboard: true,),

                //khu vuc
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 11),
                  child: ExpansionTile(
                    collapsedShape: Border.all(width: 1,color: Colors.grey),
                    shape: Border.all(
                      width: 1.5,
                      color: Colors.blue
                    ),
                    leading: Icon(Icons.location_city, color: Colors.green,),
                    title: Text(
                      'Khu vực làm việc',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 10
                      ),),
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200
                        ),
                        constraints: const BoxConstraints(
                          maxHeight: 400
                        ),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Wrap(
                              spacing: 8.0,
                              runSpacing: 7,
                              children: Constants.areas.map((area) {
                                bool check = isInAreas(area);
                                return ActionChip(
                                  shape: StadiumBorder(side: check ? BorderSide(width: 1.5, color: Colors.green.shade400) : BorderSide(width: 1.5, color: Colors.grey.shade300)),
                                  label: SizedBox(
                                    width: 110,
                                    child: Text(area, style: TextStyle(fontSize: 6.5), )),
                                  onPressed: () {
                                    if (check) {
                                      areasCtrl.removeWhere((item) => item == area);
                                    } else {
                                      areasCtrl.add(area);
                                    }
                                    setState(() {});
                                  },
                                );
                              }
                              ).toList()
                              ,
                            ),
                          ),
                        ),
                      ),
                      CustomButton(label: 'Đặt lại', type: ButtonType.cancel, onPressFunction: () { setState(() {
                        areasCtrl = [];
                      }); },)
                    ],
                  ),
                ),
                
                CustomTextField(controller: experienceCtrl, label: 'Kinh nghiệm',validator: Validator.expValidator, icon: Icons.hourglass_full_rounded, isNumKeyboard: true, hintText: 'Số năm kinh nghiệm',),
                CustomTextField(controller: amountCtrl, label: 'Số lượng',validator: Validator.numberValidator, icon: Icons.people, isNumKeyboard: true,),

                CustomDropdownBtn( label: 'Vị trí', value: position, values: positions, icon: Icons.person,
                  onChangeF: (value) {
                        setState(() {
                          position = value.toString();
                        });
                  }, 
                ),

                CustomDropdownBtn( label: 'Hình thức làm việc', value: workingType, values: workingTypes, icon: Icons.punch_clock_rounded,
                  onChangeF: (value) {
                        setState(() {
                          workingType = value.toString();
                        });
                      }, 
                ),
                
                // ngành nghề
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 11),
                  child: ExpansionTile(
                    collapsedShape: Border.all(width: 1,color: Colors.grey),
                    shape: Border.all(
                      width: 1.5,
                      color: Colors.blue
                    ),
                    leading: Icon(Icons.location_city, color: Colors.green,),
                    title: Text(
                      'Ngành nghề (tối đa 5)',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 10
                      ),
                    ),
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200
                        ),
                        constraints: const BoxConstraints(
                          maxHeight: 400
                        ),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Wrap(
                              spacing: 8.0,
                              runSpacing: 7,
                              children: Constants.occupations.map((occupation) {
                                bool check = isInOcupations(occupation);
                                return ActionChip(
                                  shape: StadiumBorder(side: check ? BorderSide(width: 1.5, color: Colors.green.shade400) : BorderSide(width: 1.5, color: Colors.grey.shade300)),
                                  label: Text(occupation, style: TextStyle(fontSize: 6.5),),
                                  onPressed: () {
                                    if (check) {
                                      occupationsCtrl.removeWhere((item) => item == occupation);
                                      setState(() {});
                                    } else {
                                      if (occupationsCtrl.length < 5) {
                                        occupationsCtrl.add(occupation);
                                        setState(() {});
                                      }
                                    }
                                  },
                                );
                              }
                              ).toList()
                              ,
                            ),
                          ),
                        ),
                      ),
                      CustomButton(label: 'Đặt lại', type: ButtonType.cancel, onPressFunction: () { setState(() {
                        occupationsCtrl = [];
                      }); },)
                    ],
                  ),
                ),

                CustomTextField(controller: expiredDateCtrl, label: 'Ngày hết hạn tuyển dụng', icon: Icons.calendar_month_outlined, editable: false, validator: Validator.notNull,
                  onTapFunction: 
                    () async{
                          DateTime? picked = await showDatePicker(
                            locale: const Locale('vi', 'VI'),
                            context: context,
                            initialDate: DateTime.now().subtract(const Duration(days: -7)), 
                            firstDate: DateTime.now().subtract(const Duration(days: -7)), 
                            lastDate: DateTime(2100),
                            initialEntryMode: DatePickerEntryMode.calendarOnly
                            );
                                              
                          if (picked != null) {
                            setState(() {
                              final DateFormat formatter = DateFormat('dd-MM-yyyy');
                              final String formatted = formatter.format(picked);
                              expiredDateCtrl.text = formatted.toString().split(" ")[0];
                            });
                          }}
                ),
                
                CustomTextField(controller: descriptionsCtrl, label: 'Mô tả công việc', icon: Icons.info_outline, validator: Validator.notNull,),
                CustomTextField(controller: requirementsCtrl, label: 'Yêu cầu ứng viên', icon: Icons.info_outline, validator: Validator.notNull,),
                CustomTextField(controller: benefitsCtrl, label: 'Quyền lợi', icon: Icons.info_outline, validator: Validator.notNull,),
                CustomTextField(controller: addressesCtrl, label: 'Địa điểm làm việc', icon: Icons.location_on, validator: Validator.notNull,),
                CustomTextField(controller: workingTimeCtrl, label: 'Thời gian làm việc', icon: Icons.calendar_month, validator: Validator.notNull,),


                
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shadowColor: Colors.green,
        color: Colors.white,
        height: 60,
        child: Center(
          child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ExpandButton(
                        label: 'Cancel', 
                        type: ButtonType.cancel,
                        onPressFunction: () {Navigator.pop(context);},
                        isPadding: false,  
                      ),
                    ),
                    VerticalDivider(),
                    Expanded(
                      child: ExpandButton(
                        label: 'Lưu', 
                        type: ButtonType.confirm,
                        isPadding: false,
                        onPressFunction: () {
                          if (formKey.currentState!.validate() && (!areasCtrl.isNotEmpty || !occupationsCtrl.isNotEmpty)) {
                              showAlertDialog(AlertType.error,'Chọn ít nhất 1 Khu vực và ngành nghề', context);
                          }
                          if (formKey.currentState!.validate() && areasCtrl.isNotEmpty && occupationsCtrl.isNotEmpty) {
                            Map<String, dynamic> data = {
                              'title': titleCtrl.text,
                              'enterprise_id' : accountProvider.model.enterpriseId,
                              'min_salary': (minSalaryCtrl.text == '') ? 0 : int.parse(minSalaryCtrl.text),
                              'max_salary': (maxSalaryCtrl.text == '') ? 0 : int.parse(maxSalaryCtrl.text),
                              'areas': areasCtrl,
                              'experience': (experienceCtrl.text == '') ? 0 : int.parse(experienceCtrl.text),
                              'position': position,
                              'amount': int.parse(amountCtrl.text),
                              'working_type': workingType,
                              'occupations': occupationsCtrl,
                              'descriptions': descriptionsCtrl.text,
                              'requirements': requirementsCtrl.text,
                              'benefits': benefitsCtrl.text,
                              'addresses': addressesCtrl.text,
                              'working_time': workingTimeCtrl.text,
                              'expired_date' : expiredDateCtrl.text,
                            };
                        
                            Future<Status> status = (model == null) ? jobsProvider.createJob(data) : jobsProvider.updateJob(model.id , data) ;
                            status.then((value) {
                            if (value.isSuccess) {
                              showAlertDialog(AlertType.success,(model == null) ? 'Thêm tin đăng tuyển thành công' : 'Cập nhật tin đăng tuyển thành công', context);
                            } else {
                              showAlertDialog(AlertType.error, (value.failMsg != '') ? value.failMsg : 'Đã có lỗi xảy ra', context);
                          }});
                          }
                        },  
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

