import 'package:app_tuyen_dung/viewmodel/provider/enterprise_provider.dart';
import 'package:app_tuyen_dung/view/widgets/expand_btn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/base/status_model.dart';
import '../../../utils/enums.dart';
import '../../../utils/functions_util.dart';
import '../../widgets/text_field.dart';
import '../../widgets/function/alert_dialog.dart';

class LogoUrlForm extends StatefulWidget{
  const LogoUrlForm({super.key});

  @override
  State<LogoUrlForm> createState() => _LogoUrlFormState();
}

class _LogoUrlFormState extends State<LogoUrlForm> {
  TextEditingController textController = TextEditingController();
  bool isCheck = false;
  bool enable = false;

  @override
  Widget build(BuildContext context) {
    final enterpriseProvider = Provider.of<EnterpriseProvider>(context);
    return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            padding: const EdgeInsets.all(5),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Nhập đường liên kết tới ảnh',
                    maxLines: null,
                    style: TextStyle(
                      fontSize: 20
                    ),),
                  CustomTextField(
                    controller: textController, 
                    label:  ' Url ', 
                    icon: Icons.image,
                    onChangedFunction: (value) {
                      isCheck = false;
                      enable = false;
                      setState((){});
                    },),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ExpandButton(
                          label: 'Kiểm tra', 
                          type: ButtonType.confirm,
                          onPressFunction: () async {
                            isCheck = true;
                            enable = await FunctionsUtil.checkUrl(textController.text);
                            setState(() {});
                          },
                        ),
                      ),
                      Expanded(
                        child: ExpandButton(
                          label: 'Lưu logo', 
                          type: ButtonType.confirm,
                          onPressFunction: enable ? () async {
                            Future<Status> status = enterpriseProvider.changeLogoUrl({'logo_url' : textController.text});
                            status.then((value) {
                            if (value.isSuccess) {
                              Navigator.pop(context);
                              showAlertDialog(AlertType.success, 'Thay logo thành công', context);
                            } else {
                              showAlertDialog(AlertType.error, 'Đã có lỗi xảy ra', context);
                            }});
                          } : null,
                          ),
                      )
                    ],
                  ),
                  (isCheck && enable) ?
                  Container(
                    padding: const EdgeInsets.all(3), // Border width
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(75), 
                      child: Image(
                        fit: BoxFit.cover,
                        image: NetworkImage(textController.text),
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                          return const Text('Đường dẫn không hợp lệ');
                        },
                        ),
                    ),) : Container(child: const Center(child: Text('Đường dẫn không hợp lệ'),))
                ],
              ),
            ),
          ),
        );
  }
}