import 'package:app_tuyen_dung/view/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/base/status_model.dart';
import '../../../utils/enums.dart';
import '../../../utils/functions_util.dart';
import '../../../viewmodel/provider/account_provider.dart';
import '../../widgets/expand_btn.dart';
import '../../widgets/function/alert_dialog.dart';

class AvatarUrlForm extends StatefulWidget{
  const AvatarUrlForm({super.key});

  @override
  State<AvatarUrlForm> createState() => _AvatarUrlFormState();
}

class _AvatarUrlFormState extends State<AvatarUrlForm> {
  TextEditingController textController = TextEditingController();
  bool isCheck = false;
  bool enable = false;

  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(context);
    return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
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
                      fontSize: 10
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
                              Future<Status> status = accountProvider.changeAvatarUrl({'avatar_url' : textController.text});
                              status.then((value) {
                              if (value.isSuccess) {
                                Navigator.pop(context);
                                showAlertDialog(AlertType.success, 'Thay ảnh đại diện thành công', context);
                              } else {
                                showAlertDialog(AlertType.error, 'Đã có lỗi xảy ra', context);
                              }});
                            } : null,
                            ),
                        )
                    ],
                  ),
                  (isCheck && enable)?
                  Container(
                    padding: const EdgeInsets.all(3), // Border width
                    decoration: BoxDecoration(color: Colors.blue.shade100, shape: BoxShape.circle),
                    child: ClipOval(
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(75), 
                        child: Image(
                          fit: BoxFit.cover, 
                          image: NetworkImage(textController.text),
                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                            return const Center(child: Text('Đường dẫn không hợp lệ'));
                          },
                          ),
                      ),
                    ),) : 
                  Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Container(child: const Center(child: Text('Đường dẫn không hợp lệ', style: TextStyle(fontSize: 10),),)))
                ],
              ),
            ),
          ),
        );
  }
}