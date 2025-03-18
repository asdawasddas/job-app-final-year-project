import 'package:app_tuyen_dung/data/base/status_model.dart';
import 'package:app_tuyen_dung/viewmodel/auth_viewmodel.dart';
import 'package:app_tuyen_dung/view/widgets/function/alert_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../widgets/loading_button.dart';
import '../../widgets/text_field.dart';
import '../../widgets/password_field.dart';
import '../../../utils/validators.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key, required this.changeMode});
  final VoidCallback changeMode;

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  var viewModel = AuthViewModel();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // TextEditingController enterpriseNameCtrl = TextEditingController();
  // TextEditingController taxCodeCtrl = TextEditingController();
  TextEditingController fullNameCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // CustomTextField(controller: enterpriseNameCtrl, label: 'Tên doanh nghiệp', validator: Validator.enterpriseNameValidator, icon: Icons.business_rounded,),
              // CustomTextField(controller: taxCodeCtrl, label: 'Mã số thuế', validator: Validator.taxCodeValidator, icon: Icons.payment_rounded,),
              CustomTextField(controller: fullNameCtrl, label: 'Họ tên nhà tuyển dụng', validator: Validator.nameValidator, icon: Icons.person),
              CustomTextField(controller: phoneCtrl, label: 'Số điện thoại', validator: Validator.phoneValidator, icon: Icons.phone),
              CustomTextField(controller: emailCtrl, label: 'Email đăng nhập', validator: Validator.emailValidator, icon: Icons.email_rounded),
              CustomPasswordField(controller: passwordCtrl, label: 'Mật khẩu', validator: Validator.passwordValidator,),
              ListenableBuilder(listenable: viewModel, builder: (context, Widget? child) {
                return CustomLoadingButton(
                  loading: viewModel.isLoading,
                  label: 'Đăng ký',
                  onPressFunction: () {
                    if (formKey.currentState!.validate()){
                      var data = <String, dynamic>{
                        'email' : emailCtrl.text,
                        'password' : passwordCtrl.text,
                        'full_name' : fullNameCtrl.text,
                        'phone_number' : phoneCtrl.text
                      };

                      Future<Status> status = viewModel.signUp(data);
                      status.then((value) {
                        if (!value.isSuccess) {
                          showAlertDialog(AlertType.error, value.failMsg, context);
                        } else {
                          showAlertDialog(AlertType.success, 'Đăng ký thành công', context);
                        }
                      }).onError((error, stackTrace) {
                          showAlertDialog(AlertType.error, 'Đã có lỗi xảy ra vui lòng thử lại sau', context);
                      });
                    }
                  });
                }),
                

              RichText(text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Đã có tài khoản? ',
                    style: TextStyle(color: Colors.black),),
                  TextSpan(
                    text: 'đăng nhập',
                    style: const TextStyle(color: Colors.blue),
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