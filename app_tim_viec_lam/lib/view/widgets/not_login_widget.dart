// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/enums.dart';
import '../../viewmodel/providers/account_provider.dart';
import '../Authentication/auth_view.dart';
import 'button.dart';

class NotLoginWidget extends StatelessWidget {
  const NotLoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(context);
    return (accountProvider.applicantId == '') ? Dialog.fullscreen(
          backgroundColor: Colors.black.withOpacity(0.5),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Container(
                constraints: BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                  Radius.circular(12.0),)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Bạn chưa đăng nhập?', style: TextStyle(fontSize: 12), textAlign: TextAlign.center,),
                    CustomButton(
                      label: 'Đăng nhập để tiếp tục', 
                      type: ButtonType.confirm,
                      onPressFunction: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AuthenticationView()));
                      },),
                      ]
                ),
              ),
            ),),
        ) : Container() ;
  }

}