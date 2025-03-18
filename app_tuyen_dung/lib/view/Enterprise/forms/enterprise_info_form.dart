import 'package:app_tuyen_dung/data/models/enterprise_model.dart';
import 'package:app_tuyen_dung/utils/constans.dart';
import 'package:app_tuyen_dung/utils/validators.dart';
import 'package:app_tuyen_dung/viewmodel/provider/enterprise_provider.dart';
import 'package:app_tuyen_dung/view/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/base/status_model.dart';
import '../../../utils/enums.dart';
import '../../widgets/dropdown_btn.dart';
import '../../widgets/text_field.dart';
import '../../widgets/expand_btn.dart';
import '../../widgets/function/alert_dialog.dart';

class EnterpriseInfoForm extends StatefulWidget{
  const EnterpriseInfoForm({super.key});

  @override
  State<EnterpriseInfoForm> createState() => _EnterpriseInfoFormState();
}

class _EnterpriseInfoFormState extends State<EnterpriseInfoForm> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController enterpriseNameCtrl = TextEditingController();
  TextEditingController enterprisePhoneCtrl = TextEditingController();
  TextEditingController enterpriseEmailCtrl = TextEditingController();
  TextEditingController taxCodeCtrl = TextEditingController();
  TextEditingController employeeAmountCtrl = TextEditingController();
  TextEditingController enterpriseAddressCtrl = TextEditingController();
  TextEditingController infomationCtrl = TextEditingController();
  String? industry;

  var industries = Constants.industries.map((value) => 
    DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    )
  ).toList();


  @override
  void initState() {
    EnterpriseModel model = Provider.of<EnterpriseProvider>(context, listen: false).model;
    if (Constants.industries.contains(model.industry)) {
      industry = model.industry;
    }
    enterpriseNameCtrl.text = model.name;
    taxCodeCtrl.text = model.taxCode;
    enterpriseEmailCtrl.text = model.email;
    enterprisePhoneCtrl.text = model.phoneNumber;
    employeeAmountCtrl.text = model.employeeAmount;
    enterpriseAddressCtrl.text = model.address;
    infomationCtrl.text = model.infomation;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final enterpriseProvider = Provider.of<EnterpriseProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cập nhật thông tin doanh nghiệp', style: TextStyle(fontSize: 16),),
        titleSpacing: 0,
        backgroundColor: Colors.blue,
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
                const CustomTitle(label: 'Thông tin Doanh nghiệp'),
                CustomTextField(controller: enterpriseNameCtrl, label: 'Tên doanh nghiệp',validator: Validator.enterpriseNameValidator, icon: Icons.business_sharp, editable: false,),
                CustomTextField(controller: taxCodeCtrl, label: 'Mã số thuế', validator: Validator.taxCodeValidator, icon: Icons.payment_rounded, hintText: 'Mã số thuế đăng ký', editable: false,),
                CustomTextField(controller: enterpriseEmailCtrl, label: 'Email doanh nghiệp', validator: Validator.emailValidator, icon: Icons.email,),
                CustomTextField(controller: enterprisePhoneCtrl, label: 'Số điện thoại', validator: Validator.phoneValidator, icon: Icons.phone,),
                CustomDropdownBtn( label: 'Lĩnh vực kinh doanh', value: industry, values: industries, icon: Icons.factory,
                  onChangeF: (value) {
                        setState(() {
                          industry = value.toString();
                        });
                      }, 
                ),
                CustomTextField(controller: employeeAmountCtrl, label: 'Quy mô doanh nghiệp', validator: Validator.amountValidator, icon: Icons.people_alt, isNumKeyboard: true,),
                CustomTextField(controller: enterpriseAddressCtrl, label: 'Địa chỉ', validator: Validator.addressValidator, icon: Icons.location_on_rounded,),
                CustomTextField(controller: infomationCtrl, label: 'Thông tin doanh nghiệp', icon: Icons.info_outline, validator: Validator.notNull,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ExpandButton(
                        label: 'Cancel', 
                        type: ButtonType.cancel,
                        onPressFunction: () {Navigator.pop(context);},  
                      ),
                    ),
                    Expanded(
                      child: ExpandButton(
                        label: 'Lưu', 
                        type: ButtonType.confirm,
                        onPressFunction: () {
                          if (formKey.currentState!.validate()) {
                            Map<String, dynamic> data = {
                              'email': enterpriseEmailCtrl.text,
                              'phone_number': enterprisePhoneCtrl.text,
                              'industry': industry,
                              'employee_amount': employeeAmountCtrl.text,
                              'address': enterpriseAddressCtrl.text,
                              'infomation': infomationCtrl.text,
                            };
                        
                            Future<Status> status = enterpriseProvider.updateInfo(data);
                            status.then((value) {
                            if (value.isSuccess) {
                              showAlertDialog(AlertType.success, 'Cập nhật thành công', context);
                            } else {
                              showAlertDialog(AlertType.error, (value.failMsg != '') ? value.failMsg : 'Đã có lỗi xảy ra', context);
                          }});}
                        },  
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}