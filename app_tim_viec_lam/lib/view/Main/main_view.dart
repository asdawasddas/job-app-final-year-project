import 'package:app_tim_viec_lam/view/List/user_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/base/status_model.dart';
import '../../viewmodel/providers/account_provider.dart';
import '../Home/home_view.dart';
import '../Account/account_view.dart';
import '../widgets/function/alert_dialog.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int currentPageIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    Future<Status> status = Provider.of<AccountProvider>(context, listen: false).getAccountInfo();
    status.then((value) {
      if (!value.isSuccess) {
        showAlertDialog(AlertType.error, 'Đã có lỗi xảy ra', context);
      }
    })
    .onError((error, stackTrace) {
      showAlertDialog(AlertType.error, 'Đã có lỗi xảy ra', context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        resizeToAvoidBottomInset: false,
        appBar: null,
        bottomNavigationBar: NavigationBarTheme(
          data: const NavigationBarThemeData(
            labelTextStyle: WidgetStatePropertyAll(TextStyle(
              fontSize: 9, fontWeight: FontWeight.bold
            ))
          ),
          child: NavigationBar(
            elevation: 10,
            height: 75,
            backgroundColor: Colors.blue.shade50,
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            selectedIndex: currentPageIndex,
            destinations: const <Widget>[
              NavigationDestination(
                selectedIcon: Icon(Icons.home, color: Colors.blue,),
                icon: Icon(Icons.home_outlined),
                label: 'Trang chủ',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.content_paste_search_outlined, color: Colors.blue,),
                icon: Icon(Icons.content_paste_search),
                label: 'Danh sách',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.account_circle, color: Colors.blue,),
                icon: Icon(Icons.account_circle_outlined),
                label: 'Tài khoản',
              ),
            ],
          ),
        ),
        body: <Widget>[const HomeView(), const UserListView(), const AccountView()][currentPageIndex]
      ),
    );
  }
}
