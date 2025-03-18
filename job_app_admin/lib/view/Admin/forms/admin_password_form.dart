
import 'package:flutter/material.dart';
import 'package:job_app_admin/data/model/admin_model.dart';
import 'package:job_app_admin/view/widgets/password_field.dart';
import 'package:job_app_admin/viewmodel/admin_provider.dart';
import 'package:provider/provider.dart';

import '../../../data/base/status_model.dart';
import '../../../utils/enums.dart';
import '../../../utils/validators.dart';
import '../../widgets/expand_btn.dart';
import '../../widgets/function/alert_dialog.dart';

class AdminPasswordForm extends StatefulWidget{
  const AdminPasswordForm({super.key, required this.model});
  final Admin model;
  @override
  State<AdminPasswordForm> createState() => _AdminPasswordFormState();
}

class _AdminPasswordFormState extends State<AdminPasswordForm> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController passwordCtr = TextEditingController();
  TextEditingController passwordRetypeCtr = TextEditingController();

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
                  Text('Đổi mật khẩu tài khoản ' + widget.model.accountName, textAlign: TextAlign.center, style: TextStyle(fontSize: 30),),
                  CustomPasswordField(controller: passwordCtr, label: 'Mật khẩu', validator: Validator.passwordValidator,),
                  CustomPasswordField(controller: passwordRetypeCtr, label: 'Nhập lại mật khẩu', validator: Validator.notNull,),
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
                          label:  'Đổi mật khẩu',
                          type: ButtonType.confirm,
                          onPressFunction: () async {
                            if (formKey.currentState!.validate() && passwordCtr.text == passwordRetypeCtr.text) {
                              Map<String, dynamic> data = {
                                'new_password' : passwordCtr.text
                              };
                            
                              Future<Status> status = adminProvider.changePassword(widget.model.id,data);
                              status.then((value) {
                              if (value.isSuccess) {
                                Navigator.pop(context);
                                showAlertDialog(AlertType.success, 'Đổi mật khẩu thành công', context);
                              } else {
                                showAlertDialog(AlertType.error, (value.failMsg != '') ? value.failMsg : 'Đã có lỗi xảy ra', context);
                              }});}

                              if (formKey.currentState!.validate() && passwordCtr.text != passwordRetypeCtr.text) {
                                showAlertDialog(AlertType.alert, 'Mật khẩu và mật khẩu nhập lại phải giống nhau', context);
                              }
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