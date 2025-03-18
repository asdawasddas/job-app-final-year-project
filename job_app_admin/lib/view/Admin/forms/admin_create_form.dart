
import 'package:flutter/material.dart';
import 'package:job_app_admin/view/widgets/password_field.dart';
import 'package:job_app_admin/viewmodel/admin_provider.dart';
import 'package:provider/provider.dart';

import '../../../data/base/status_model.dart';
import '../../../utils/enums.dart';
import '../../../utils/validators.dart';
import '../../widgets/text_field.dart';
import '../../widgets/expand_btn.dart';
import '../../widgets/function/alert_dialog.dart';

class AdminCreateForm extends StatefulWidget{
  const AdminCreateForm({super.key});

  @override
  State<AdminCreateForm> createState() => _AdminCreateFormState();
}

class _AdminCreateFormState extends State<AdminCreateForm> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController accountNameCtr = TextEditingController();
  TextEditingController passwordCtr = TextEditingController();
  TextEditingController fullNameCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);
    return Form(
      key: formKey,
      child: Padding(
            padding: const EdgeInsets.all(50),
            child: Container(
              padding: const EdgeInsets.all(5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Tạo tài khoản admin mới', textAlign: TextAlign.center, style: TextStyle(fontSize: 30),),
                  CustomTextField(controller: accountNameCtr, label: 'Tên tài khoản', validator: Validator.accountNameValidator, icon: Icons.email_rounded,),
                  CustomTextField(controller: fullNameCtrl, label: 'Họ và tên', validator: Validator.nameValidator, icon: Icons.person,),
                  CustomPasswordField(controller: passwordCtr, label: 'Mật khẩu', validator: Validator.passwordValidator,),
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
                          label:  'Tạo tài khoản',
                          type: ButtonType.confirm,
                          onPressFunction: () async {
                            if (formKey.currentState!.validate()) {
                              Map<String, dynamic> data = {
                                'account_name' : accountNameCtr.text,
                                'full_name' : fullNameCtrl.text,
                                'password' : passwordCtr.text
                              };
                            
                              Future<Status> status = adminProvider.create(data);
                              status.then((value) {
                              if (value.isSuccess) {
                                Navigator.pop(context);
                                showAlertDialog(AlertType.success, 'Tạo tài khoản thành công', context);
                              } else {
                                showAlertDialog(AlertType.error, (value.failMsg != '') ? value.failMsg : 'Đã có lỗi xảy ra', context);
                              }});}
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