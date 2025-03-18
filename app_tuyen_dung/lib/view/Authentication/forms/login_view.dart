import 'package:app_tuyen_dung/data/base/status_model.dart';
import 'package:app_tuyen_dung/view/widgets/function/alert_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodel/provider/auth_provider.dart';
import '../../../utils/validators.dart';
import '../../widgets/loading_button.dart';
import '../../widgets/password_field.dart';
import '../../widgets/text_field.dart';
import '../../Main/main_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key, required this.changeMode});
  final VoidCallback changeMode;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // final viewModel = AuthViewModel();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
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
              CustomPasswordField(controller: passwordController, label: 'Mật khẩu',),
              CustomLoadingButton(
                  loading: authProvider.isLoading,
                  label: 'Đăng nhập',
                  onPressFunction: () {
                    if (formKey.currentState!.validate()){
                      Map<String, dynamic> data= { 
                        'email': emailController.text,
                        'password': passwordController.text
                      };
                      Future<Status>  status = authProvider.login(data, context);                 
                      status.then((value) {
                        if (value.isSuccess) {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MainView()));
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
                    text: 'Chưa có tài khoản? ',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  TextSpan(
                    text: 'đăng ký ngay',
                    style: const TextStyle(color: Colors.blue, fontSize: 14),
                    recognizer: TapGestureRecognizer()..onTap = widget.changeMode
                  ),
                ]
              )),
            ],
          ),
        ),
      );
  }
}
