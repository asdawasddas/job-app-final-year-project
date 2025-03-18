import 'package:flutter/material.dart';
import 'forms/login_view.dart';
import 'forms/sign_up_view.dart';

class AuthenticationView extends StatefulWidget {
  const AuthenticationView({super.key});

  @override
  State<AuthenticationView> createState() => _AuthenticationViewState();
}

class _AuthenticationViewState extends State<AuthenticationView> {
  bool loginMode = true;
  // AuthViewModel viewmodel = AuthViewModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final isKeyBoard = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      appBar: null,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [ 
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 15),
                child: SizedBox(
                        width: 180,
                        height: 180,
                        child: Image(
                          image: AssetImage('assets/images/app_logo.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              const Text(
                'Job Market - Tuyển dụng',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontFamily: 'Raleway',)
                ,
              ),
              loginMode ? 
                LoginView(changeMode: () => {setState((){loginMode = false;})},) : 
                SignUpView(changeMode: () => {setState((){loginMode = true;})},)
            ],
          ),
        ),
      )
    );
  }
}
