
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/base/status_model.dart';
import '../../../utils/enums.dart';
import '../../../utils/validators.dart';
import '../../../viewmodel/providers/account_provider.dart';
import '../../widgets/expand_btn.dart';
import '../../widgets/function/alert_dialog.dart';
import '../../widgets/password_field.dart';
import '../../widgets/title.dart';

class ChangePasswordForm extends StatefulWidget{
  const ChangePasswordForm({super.key});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController oldPwController = TextEditingController();
  TextEditingController newPwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(context);
    return Form(
      key: formKey,
      child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              padding: const EdgeInsets.all(5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const CustomTitle(label: 'Đổi mật khẩu'),
                  CustomPasswordField(controller: oldPwController, label: 'Mật khẩu hiện tại', validator: Validator.passwordValidator,),
                  CustomPasswordField(controller: newPwController, label: 'Mật khẩu mới', validator: Validator.passwordValidator,),
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
                          label: 'Lưu thay đổi',
                          type: ButtonType.confirm,
                          onPressFunction: () {
                            if (formKey.currentState!.validate()) {
                            Map<String, dynamic> data = {
                              'old_password' : oldPwController.text,
                              'new_password' : newPwController.text,
                            };
                          
                            Future<Status> status = accountProvider.changePassword(data);
                            status.then((value) {
                            if (value.isSuccess) {
                              Navigator.pop(context);
                              showAlertDialog(AlertType.success, 'Đổi mật khẩu thành công', context);
                            } else {
                              showAlertDialog(AlertType.error, (value.failMsg != '') ? value.failMsg : 'Mật khẩu hiện tại không chính xác', context);
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