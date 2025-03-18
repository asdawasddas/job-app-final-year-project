// import 'dart:ui';

// import 'package:app_tuyen_dung/custom_size.dart';
import 'package:app_tuyen_dung/viewmodel/provider/account_provider.dart';
import 'package:app_tuyen_dung/viewmodel/provider/applications_provider.dart';
import 'package:app_tuyen_dung/viewmodel/provider/enterprise_provider.dart';
import 'package:app_tuyen_dung/viewmodel/provider/jobs_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'view/Splash/splash_view.dart';
import 'viewmodel/provider/auth_provider.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
  // Size size = view.physicalSize / view.devicePixelRatio;
  // double resize = view.physicalSize.height / size.height;

  // print(view.physicalSize.height);
  // print(view.devicePixelRatio);

  // Size physicalSize = view.physicalSize;
  // Size size = view.physicalSize / view.devicePixelRatio;
  // double width = physicalSize.width /  size.width;
  // double height = physicalSize.height /  size.height;

  // Size size = view.physicalSize;
  // double width = size.width;
  // double height = size.height;

  // print(resize);
  // print(size.height);

  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, AccountProvider>(
          create: (ctx) => AccountProvider(), 
          update: (ctx, authProvider, accountProvider) => accountProvider!
            ..setUserId(authProvider.hirerId) ),
        ChangeNotifierProxyProvider<AccountProvider, EnterpriseProvider>(
          create: (ctx) => EnterpriseProvider(), 
          update: (ctx, accountProvider, enterpriseProvider) => enterpriseProvider!
            ..setEnterpriseId(accountProvider.model.enterpriseId) ),
        ChangeNotifierProxyProvider<AuthProvider, JobsProvider>(
          create: (ctx) => JobsProvider(), 
          update: (ctx, authProvider, jobsProvider) => jobsProvider!
            ..setUserId(authProvider.hirerId) ),
        ChangeNotifierProvider<ApplicationsProvider>(create: (_) => ApplicationsProvider()), 
      ],
      child: const MyApp()
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
  WidgetsFlutterBinding.ensureInitialized();
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    return 
    // MaterialApp(
    //   builder: (context, child) {
    //     return 
        MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(2)), 
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('vn')
          ],
          theme: ThemeData(
            useMaterial3: true,
          ),
            home: const SplashView(),
          )
        );
      // }
    // );
  }
}