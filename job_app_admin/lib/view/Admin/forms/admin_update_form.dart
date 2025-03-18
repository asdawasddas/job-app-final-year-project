
import 'package:flutter/material.dart';
import 'package:job_app_admin/data/model/admin_model.dart';
import 'package:job_app_admin/view/widgets/text_field.dart';
import 'package:job_app_admin/viewmodel/admin_provider.dart';
import 'package:provider/provider.dart';

import '../../../data/base/status_model.dart';
import '../../../utils/enums.dart';
import '../../../utils/validators.dart';
import '../../widgets/expand_btn.dart';
import '../../widgets/function/alert_dialog.dart';

class AdminUpdateForm extends StatefulWidget{
  const AdminUpdateForm({super.key, required this.model});
  final Admin model;
  @override
  State<AdminUpdateForm> createState() => _AdminUpdateFormState();
}

class _AdminUpdateFormState extends State<AdminUpdateForm> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController fullNameCtr = TextEditingController();

  @override
  void initState() {
    fullNameCtr.text = widget.model.fullName;
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
                  Text('Đổi tên tài khoản ' + widget.model.accountName, textAlign: TextAlign.center, style: TextStyle(fontSize: 30),),
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
                            
                              Future<Status> status = adminProvider.update(widget.model.id,data);
                              status.then((value) {
                              if (value.isSuccess) {
                                Navigator.pop(context);
                                showAlertDialog(AlertType.success, 'Cập nhật thánh công thành công', context);
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