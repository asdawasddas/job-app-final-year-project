
import 'package:flutter/material.dart';
import 'package:job_app_admin/view/widgets/text_field.dart';
import 'package:provider/provider.dart';

import '../../../data/base/status_model.dart';
import '../../../utils/enums.dart';
import '../../../utils/validators.dart';
import '../../../viewmodel/auth_provider.dart';
import '../../widgets/expand_btn.dart';
import '../../widgets/function/alert_dialog.dart';

class UpdateForm extends StatefulWidget{
  const UpdateForm({super.key});
  @override
  State<UpdateForm> createState() => _UpdateFormState();
}

class _UpdateFormState extends State<UpdateForm> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController fullNameCtr = TextEditingController();

  @override
  void initState() {
    fullNameCtr.text = Provider.of<AuthProvider>(context, listen: false).model.fullName;
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
                  Text('Đổi tên tài khoản ', textAlign: TextAlign.center, style: TextStyle(fontSize: 30),),
                  Padding(padding: EdgeInsets.symmetric(vertical: 20), child: CustomTextField(controller: fullNameCtr, label: 'Họ và tên', validator: Validator.nameValidator,)),
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
                          label:  'Lưu',
                          type: ButtonType.confirm,
                          onPressFunction: () async {
                            if (formKey.currentState!.validate()) {
                              Map<String, dynamic> data = {
                                'full_name' : fullNameCtr.text
                              };
                            
                              Future<Status> status = authProvider.update(data);
                              status.then((value) {
                              if (value.isSuccess) {
                                Navigator.pop(context);
                                showAlertDialog(AlertType.success, 'Thay đổi thành công', context);
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