import 'package:app_tuyen_dung/view/Account/forms/change_password_form.dart';
import 'package:app_tuyen_dung/view/Account/forms/hirer_info_form.dart';
import 'package:app_tuyen_dung/view/Authentication/auth_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/enums.dart';
import '../../viewmodel/provider/account_provider.dart';
import '../../viewmodel/provider/auth_provider.dart';
import '../widgets/button.dart';
import '../widgets/container.dart';
import '../widgets/title.dart';
import '../widgets/forms/confirm_form.dart';
import 'widgets/account_card.dart';
import '../widgets/title_button.dart';



class AccountView extends StatefulWidget {
  const AccountView({Key? key}) : super (key : key);

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  // var viewmodel = AccountViewModel();

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(31, 110, 139, 201),
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.only(left: 5,right: 5),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AccountCard(model: accountProvider.model,),
              CustomContainer(
                child: Column(
                      children: [
                        const CustomTitle(label: 'Cài đặt tài khoản'),
                        TitleButton(label: 'Thông tin cá nhân', icon: Icons.person, function: () { showDialog(barrierDismissible: false, context: context, builder: (context) {return const Dialog(insetPadding: EdgeInsets.all(5), child: HirerInfoForm());});},),
                        TitleButton(label: 'Thay đổi mật khẩu', icon: Icons.lock_open, function: () { showDialog(barrierDismissible: false, context: context, builder: (context) {return const Dialog(insetPadding: EdgeInsets.all(5), child: ChangePasswordForm());});},),
                        const TitleButton(label: 'Cài đặt thông báo', icon: Icons.notifications_outlined,),

                        const Divider(),
    
                        const CustomTitle(label: 'Chính sách và hỗ trợ'),
                        const TitleButton(label: 'Về ứng dụng', icon: Icons.app_shortcut ,),
                        const TitleButton(label: 'Chính sách bảo mật', icon: Icons.shield ,),
                        const TitleButton(label: 'Trợ giúp', icon: Icons.phone_in_talk_outlined ,),
                      ],
                    ),
              )
              ,CustomButton(
                type: ButtonType.cancel,
                label: 'Đăng xuất',
                onPressFunction: () {
                  showDialog(context: context, builder: (context) => 
                        Dialog(
                          child: ConfirmForm(
                            label: 'Bạn muốn thoát tài khoản?', 
                            buttonLabel: 'Đăng xuất',
                            isDelete: true,
                            onPressFunction: () {
                              Provider.of<AuthProvider>(context, listen:false).logOut();
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AuthenticationView()));
                            },
                            ),
                        ));
                },
                ),
            ],
          ),
        ),
      ),
    );
  }}

  