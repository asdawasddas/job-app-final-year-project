
import 'package:app_tim_viec_lam/viewmodel/providers/enterprise_provider.dart';
import 'package:app_tim_viec_lam/viewmodel/providers/job_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'view/Splash/splash_view.dart';
import 'viewmodel/providers/account_provider.dart';
import 'viewmodel/providers/auth_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () {},),
      ),
      body: const Center(
        child: Text(
          'Đã có lỗi xảy ra'
        ),
      ),
    );
  } ;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<JobProvider>(create: (_) => JobProvider()),
        ChangeNotifierProvider<EnterpriseProvider>(create: (_) => EnterpriseProvider()),
        ChangeNotifierProxyProvider<AuthProvider, AccountProvider>(
          create: (ctx) => AccountProvider(), 
          update: (ctx, authProvider, accountProvider) => accountProvider!
            ..setUserId(authProvider.applicantId) ),
      ],
      child: const MyApp()
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
  WidgetsFlutterBinding.ensureInitialized();
    return 
        MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(2)), 
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
            // home: MainView()
          )
        );
  }
}