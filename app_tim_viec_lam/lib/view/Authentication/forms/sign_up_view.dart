import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/base/status_model.dart';
import '../../../utils/validators.dart';
import '../../../viewmodel/providers/auth_provider.dart';
import '../../Main/main_view.dart';
import '../../widgets/function/alert_dialog.dart';
import '../../widgets/loading_button.dart';
import '../../widgets/password_field.dart';
import '../../widgets/text_field.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key, required this.changeMode});
  final VoidCallback changeMode;

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  // final viewModel = AuthViewModel();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return
      Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTextField(icon: Icons.email_rounded,controller: emailController, label: 'Email', validator: Validator.emailValidator,),
              CustomTextField(icon: Icons.email_rounded,controller: nameController, label: 'Họ và tên', validator: Validator.nameValidator,),
              CustomTextField(icon: Icons.email_rounded,controller: phoneController, label: 'Số điện thoại', validator: Validator.phoneValidator,),
              CustomPasswordField(controller: passwordController, label: 'Mật khẩu',),
              CustomLoadingButton(
                  loading: authProvider.isLoading,
                  label: 'Đăng ký',
                  onPressFunction: () {
                    if (formKey.currentState!.validate()){
                      Map<String, dynamic> data= { 
                        'email': emailController.text,
                        'full_name': nameController.text,
                        'phone_number': phoneController.text,
                        'password': passwordController.text
                      };
                      Future<Status>  status = authProvider.signUp(data,);                 
                      status.then((value) {
                        if (value.isSuccess) {
                          showAlertDialog(AlertType.success, 'Đăng ký thành công', context);
                        } else {
                          showAlertDialog(AlertType.error, value.failMsg, context);
                        }
                      }).onError((error, stackTrace) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Đã có lỗi xảy ra vui lòng thử lại sau')),
                        );
                      });
                    }
                  }),
              RichText(text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Đã có tài khoản? ',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  TextSpan(
                    text: 'đăng nhập ngay',
                    style: const TextStyle(color: Colors.blue, fontSize: 14),
                    recognizer: TapGestureRecognizer()..onTap = widget.changeMode
                  ),
                ]
              )),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: RichText(text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Hoặc ',
                      style: TextStyle(color: Colors.black),),
                    TextSpan(
                      text: 'sử dụng không cần đăng nhập',
                      style: const TextStyle(color: Colors.green),
                      recognizer: TapGestureRecognizer()..onTap = () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MainView()));
                      }
                    ),
                  ]
                )),
              )
            ],
          ),
        ),
      );
  }
}
