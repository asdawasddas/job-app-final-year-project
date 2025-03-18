// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/base/status_model.dart';
import '../../viewmodel/providers/auth_provider.dart';
import '../Authentication/auth_view.dart';
import '../Main/main_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  @override
  void initState() {
    Future<Status> status = Provider.of<AuthProvider>(context, listen:false).authenticate();
    status.then((value) {
      if (value.isSuccess) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MainView()));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AuthenticationView()));
      }
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã có lỗi xảy ra, vui lòng thử lại sau')),
      );
    }
      
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 15),
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
                'Job Market - Tìm việc làm',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontFamily: 'Raleway',)
                ,
              ),
          ],
        ),
      )
    );
  }
}
