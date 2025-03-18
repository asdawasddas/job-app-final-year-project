
import 'package:flutter/material.dart';
import 'package:job_app_admin/utils/enums.dart';
import 'package:job_app_admin/view/widgets/expand_btn.dart';
import 'package:job_app_admin/viewmodel/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../data/base/status_model.dart';
import '../../utils/validators.dart';
import '../MainView/main_view.dart';
import '../widgets/function/alert_dialog.dart';
import '../widgets/password_field.dart';
import '../widgets/text_field.dart';

class LoginView extends StatefulWidget{
  const LoginView({super.key});

  @override
  State<StatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController accountNameCtr = TextEditingController();
  TextEditingController passwordCtr = TextEditingController();

  @override
  void initState() {
    Future<Status> status = Provider.of<AuthProvider>(context, listen:false).authenticate();
    status.then((value) {
      if (value.isSuccess) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainView()));
      }
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã có lỗi xảy ra vui lòng thử lại sau')),
      );
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen:false);
    return Scaffold(
      appBar: null,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: SizedBox(
                            width: 250,
                            height: 250,
                            child: Image(
                              image: AssetImage('assets/images/app_logo.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Text(
                    'Job Market - Admin',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontFamily: 'Raleway',)
                    ,
                  ),
              ],
            ),
          ),
          Form(
            key: formKey,
            child: Container(
              constraints: const BoxConstraints(
                maxHeight: 500,
                maxWidth: 500
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Text(
                        'Đăng nhập',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.blue,)
                      ),
                    ),
                    CustomTextField(
                      icon: Icons.email_rounded,
                      controller: accountNameCtr,
                      label: 'Tên tài khoản',
                      validator: Validator.notNull,
                    ),
                    CustomPasswordField(
                      controller: passwordCtr,
                      label: 'Mật khẩu',
                      validator: Validator.notNull,
                    ),
                    ExpandButton(
                      type: ButtonType.confirm,
                      label: 'Đăng nhập',
                      onPressFunction: () {
                        if (formKey.currentState!.validate()){
                          Map<String, dynamic> data= {
                            'account_name': accountNameCtr.text,
                            'password': passwordCtr.text
                          };
                          Future<Status>  status = authProvider.login(data);         
                          status.then((value) {
                            if (value.isSuccess) {
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainView()));
                            } else {
                              showAlertDialog(AlertType.error, value.failMsg, context);
                            }
                          }).onError((error, stackTrace) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Đã có lỗi xảy ra vui lòng thử lại sau')),
                            );
                          });
                        }
                      }
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}