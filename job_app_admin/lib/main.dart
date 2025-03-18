import 'package:flutter/material.dart';
import 'package:job_app_admin/view/Authentication/login_view.dart';
import 'package:job_app_admin/viewmodel/admin_provider.dart';
import 'package:job_app_admin/viewmodel/applicant_provider.dart';
import 'package:job_app_admin/viewmodel/enterprise_provider.dart';
import 'package:job_app_admin/viewmodel/hirer_provider.dart';
import 'package:provider/provider.dart';

import 'viewmodel/auth_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, EnterpriseProvider>(
          create: (ctx) => EnterpriseProvider(), 
          update: (ctx, authProvider, accountProvider) => accountProvider!
            ..reset(authProvider.adminId) ),
        ChangeNotifierProxyProvider<AuthProvider, AdminProvider>(
          create: (ctx) => AdminProvider(), 
          update: (ctx, authProvider, adminProvider) => adminProvider!
            ..reset(authProvider.adminId) ),
        ChangeNotifierProxyProvider<AuthProvider, HirerProvider>(
          create: (ctx) => HirerProvider(), 
          update: (ctx, authProvider, hirerProvider) => hirerProvider!
            ..reset(authProvider.adminId) ),
        ChangeNotifierProxyProvider<AuthProvider, ApplicantProvider>(
          create: (ctx) => ApplicantProvider(), 
          update: (ctx, authProvider, applicantProvider) => applicantProvider!
            ..reset(authProvider.adminId) ),
      ],
      child: const MyApp()
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: const LoginView(),
      // home: MainView(),
    );
  }
}