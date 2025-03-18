
import 'package:flutter/material.dart';
import 'package:job_app_admin/view/widgets/password_field.dart';
import 'package:job_app_admin/viewmodel/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../../data/base/status_model.dart';
import '../../../utils/enums.dart';
import '../../../utils/validators.dart';
import '../../widgets/expand_btn.dart';
import '../../widgets/function/alert_dialog.dart';

class PasswordForm extends StatefulWidget{
  const PasswordForm({super.key});
  @override
  State<PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController newPasswordCtr = TextEditingController();
  TextEditingController oldPasswordCtr = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
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
                  Text('Đổi mật khẩu tài khoản ', textAlign: TextAlign.center, style: TextStyle(fontSize: 30),),
                  CustomPasswordField(controller: oldPasswordCtr, label: 'Mật khẩu hiện tại', validator: Validator.passwordValidator,),
                  CustomPasswordField(controller: newPasswordCtr, label: 'Mật khẩu mới', validator: Validator.passwordValidator,),
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
                            if (formKey.currentState!.validate()) {
                              Map<String, dynamic> data = {
                                'old_password' : oldPasswordCtr.text,
                                'new_password' : newPasswordCtr.text
                              };
                            
                              Future<Status> status = authProvider.changePassword(data);
                              status.then((value) {
                              if (value.isSuccess) {
                                Navigator.pop(context);
                                showAlertDialog(AlertType.success, 'Đổi mật khẩu thành công', context);
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