import 'package:flutter/material.dart';
import 'package:job_app_admin/view/Account/forms/password_form.dart';
import 'package:job_app_admin/view/Account/forms/update_form.dart';
import 'package:provider/provider.dart';
import '../../../utils/enums.dart';
import '../../viewmodel/auth_provider.dart';
import '../widgets/expand_btn.dart';
import '../widgets/icon_text.dart';

class AccountInfo extends StatelessWidget{
  const AccountInfo({super.key,});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Stack(
      alignment: Alignment.topRight,
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(padding: EdgeInsets.symmetric(vertical: 30), child: Text('Thông tin tài khoản', textAlign: TextAlign.center, style: TextStyle(fontSize: 30),)),
                IconText(label: 'Tên tài khoản:', icon: Icons.key, value: authProvider.model.accountName),
                IconText(label: 'Họ và tên:', icon: Icons.person, value: authProvider.model.fullName),
                IconText(label: 'Loại tài khoản:', icon: Icons.type_specimen, value: authProvider.model.type),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ExpandButton(
                        label: 'Đổi tên', 
                        type: ButtonType.confirm,
                        onPressFunction: () {
                          showDialog(context: context, builder: (context) =>
                          Dialog(
                            insetPadding: EdgeInsets.symmetric(horizontal: 500),
                            child: UpdateForm(),
                          )
                        );
                        },  
                      ),
                    ),
                    Expanded(
                      child: ExpandButton(
                        label: 'Đổi mật khẩu', 
                        type: ButtonType.confirm,
                        onPressFunction: () {
                          showDialog(context: context, builder: (context) =>
                          Dialog(
                            insetPadding: EdgeInsets.symmetric(horizontal: 500),
                            child: PasswordForm(),
                          )
                        );
                        },  
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 10,right: 10), child: IconButton(onPressed: (){ Navigator.pop(context); }, icon: Icon(Icons.close_sharp)))
      ]
    );
  }
}