import 'package:app_tuyen_dung/data/models/hirer_account_model.dart';
import 'package:app_tuyen_dung/utils/validators.dart';
import 'package:app_tuyen_dung/view/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/base/status_model.dart';
import '../../../utils/enums.dart';
import '../../../viewmodel/provider/account_provider.dart';
import '../../widgets/text_field.dart';
import '../../widgets/expand_btn.dart';
import '../../widgets/function/alert_dialog.dart';

class HirerInfoForm extends StatefulWidget{
  const HirerInfoForm({super.key});

  @override
  State<HirerInfoForm> createState() => _HirerInfoFormState();
}

class _HirerInfoFormState extends State<HirerInfoForm> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController fullNameCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  bool editable = false;

  @override
  void initState() {
    HirerAccountModel model = Provider.of<AccountProvider>(context, listen: false).model;
    fullNameCtrl.text = model.fullName;
    phoneCtrl.text = model.phoneNumber;
    emailCtrl.text = model.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(context);
    return Form(
      key: formKey,
      child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              padding: const EdgeInsets.all(5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const CustomTitle(label: 'Thông tin cá nhân'),
                  CustomTextField(controller: emailCtrl, label: 'Email', icon: Icons.email_rounded, editable: false),
                  CustomTextField(controller: fullNameCtrl, label: 'Họ và tên', validator: Validator.nameValidator, icon: Icons.person, editable: editable,),
                  CustomTextField(controller: phoneCtrl, label: 'Số điện thoại', validator: Validator.phoneValidator, icon: Icons.phone, editable: editable,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ExpandButton(
                          label: 'Đóng',
                          type: ButtonType.cancel,
                          onPressFunction: () async {
                            Navigator.pop(context);},
                        )
                      ),
                      Expanded(
                        child: ExpandButton(
                          label: editable ? 'Lưu thay đổi' : 'Sửa',
                          type: ButtonType.confirm,
                          onPressFunction: editable ? () async {
                            if (formKey.currentState!.validate()) {
                              Map<String, dynamic> data = {
                                'full_name' : fullNameCtrl.text,
                                'phone_number' : phoneCtrl.text,
                              };
                            
                              Future<Status> status = accountProvider.updateInfo(data);
                              status.then((value) {
                              if (value.isSuccess) {
                                Navigator.pop(context);
                                showAlertDialog(AlertType.success, 'Cập nhật thành công', context);
                              } else {
                                showAlertDialog(AlertType.error, (value.failMsg != '') ? value.failMsg : 'Đã có lỗi xảy ra', context);
                              }});}
                          } : () {
                            setState(() {
                              editable = true;
                            });
                          },
                        )
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }
}