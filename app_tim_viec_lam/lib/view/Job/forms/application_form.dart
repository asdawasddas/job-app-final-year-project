
import 'dart:io';

import 'package:app_tim_viec_lam/view/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/base/status_model.dart';
import '../../../utils/enums.dart';
import '../../../utils/functions_util.dart';
import '../../../viewmodel/providers/account_provider.dart';
import '../../widgets/expand_btn.dart';
import '../../widgets/function/alert_dialog.dart';
import '../../widgets/title.dart';

class ApplicationForm extends StatefulWidget{
  const ApplicationForm({super.key, required this.jobId});
  final String jobId;

  @override
  State<ApplicationForm> createState() => _ApplicationFormState();
}

class _ApplicationFormState extends State<ApplicationForm> {
  TextEditingController controller = TextEditingController();
  File? fileCV;

  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(context);
    return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const CustomTitle(label: 'Chọn file CV định dạng PDF'),
                CustomTextField(
                  controller: controller, 
                  label: (fileCV == null) ? 'Chạm để chọn' : 'Chạm để chọn lại', editable : false, 
                  onTapFunction: () async {
                    fileCV = await FunctionsUtil.getFile();
                    controller.text = fileCV!.path;
                    setState(() {});
                  }
                ),
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
                        label: 'Ứng tuyển ngay',
                        type: ButtonType.confirm,
                        onPressFunction: (fileCV == null) ?
                        null :
                        () {                            
                          Future<Status> status = accountProvider.apply(widget.jobId, fileCV!);
                          status.then((value) {
                          if (value.isSuccess) {
                            Navigator.pop(context);
                            showAlertDialog(AlertType.success, 'Ứng tuyển thành công', context);
                          } else {
                            showAlertDialog(AlertType.error, 'Đã có lỗi xảy ra', context);
                          }});
                        },
                      )
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
  }
}