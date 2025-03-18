
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:job_app_admin/view/Account/account_info.dart';
import 'package:job_app_admin/view/Admin/admin_view.dart';
import 'package:job_app_admin/view/Applicant/applicant_view.dart';
import 'package:job_app_admin/view/Authentication/login_view.dart';
import 'package:job_app_admin/view/Enterprise/enterprise_view.dart';
import 'package:job_app_admin/view/Hirer/hirer_view.dart';
import 'package:job_app_admin/view/widgets/icon_button.dart';
import 'package:provider/provider.dart';

import '../../data/base/status_model.dart';
import '../../viewmodel/auth_provider.dart';
import '../widgets/forms/confirm_form.dart';
import '../widgets/function/alert_dialog.dart';

class MainView extends StatefulWidget {
  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int selectedIndex = 0;

  @override
  void initState() {
    Future<Status> status = Provider.of<AuthProvider>(context, listen:false).getInfo();
    status.then((value) {
      if (!value.isSuccess) {
        // showAlertDialog(AlertType.error, 'Đã có lỗi xảy ra', context);
      }
    }).onError((error, stackTrace) {
      showAlertDialog(AlertType.error, 'Đã có lỗi xảy ra', context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = EnterpriseView();
        break;
      case 1:
        page = HirerView();
        break;
      case 2:
        page = ApplicantView();
        break;
      case 3:
        page = AdminView();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      appBar: null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 0),
                      child: Center(
                        child: SizedBox(
                                width: 120,
                                height: 120,
                                child: Image(
                                  image: AssetImage('assets/images/app_logo.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                    Center(child: Text('Admin: ' + authProvider.model.fullName, style: TextStyle(fontSize: 20, color: Colors.white), textAlign: TextAlign.center,)),
                    Divider(color: Colors.white, height: 10, thickness: 1,),
                    Padding(padding: EdgeInsets.only(left: 30), child: Text('Quản lý', style: TextStyle(fontSize: 25, color: Colors.white),)),
                    IntrinsicHeight(
                      child: NavigationRail(
                        backgroundColor: Colors.blueGrey.shade900,
                        minExtendedWidth: 300,
                        extended: true,
                        useIndicator: false,
                        unselectedLabelTextStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.white
                        ),
                        selectedLabelTextStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold
                        ),
                        destinations: [
                          NavigationRailDestination(
                            padding: EdgeInsets.only(bottom: 10),
                            icon: Icon(Icons.business, color: Colors.white),
                            selectedIcon: Icon(Icons.business, color: Colors.blue, size: 30),
                            label: Text('Doanh nghiệp',),
                          ),
                          NavigationRailDestination(
                            padding: EdgeInsets.only(bottom: 10),
                            icon: Icon(Icons.business_center, color: Colors.white),
                            selectedIcon: Icon(Icons.business_center, color: Colors.blue, size: 30),
                            label: Text('Nhà tuyển dụng',),
                          ),
                          NavigationRailDestination(
                            padding: EdgeInsets.only(bottom: 10),
                            icon: Icon(Icons.person, color: Colors.white),
                            selectedIcon: Icon(Icons.person_2, color: Colors.blue, size: 30,),
                            label: Text('Ứng viên',),
                          ),
                          NavigationRailDestination(
                            padding: EdgeInsets.only(bottom: 10),
                            icon: Icon(Icons.people, color: Colors.white),
                            selectedIcon: Icon(Icons.people_alt, color: Colors.blue, size: 30,),
                            label: Text('Admins',),
                          ),
                        ],
                        selectedIndex: selectedIndex,
                        onDestinationSelected: (value) {
                          if (value == 3) {
                            if (authProvider.model.isApexAdmin) {
                              selectedIndex = value;
                            }
                          }
                          if (value != 3) {
                            selectedIndex = value;
                          }
                          setState(() {});
                        },
                      ),
                    ),
                    Divider(color: Colors.white,),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20), 
                      child: Center(
                        child: CustomIconButton(
                          label: 'Thông tin tài khoản', 
                          icon: Icon(Icons.settings),
                          onPressFunction: () {
                            showDialog(
                              context: context, 
                              builder: (context) =>
                                const Dialog(
                                  insetPadding: EdgeInsets.symmetric(horizontal: 530),
                                  child: AccountInfo(),
                                )
                            );
                          },
                        )
                      )
                    ),
                    Center(
                      child: CustomIconButton(
                        label: 'Đăng xuất', 
                        icon: Icon(Icons.logout),
                        onPressFunction: () {
                          showDialog(context: context, builder: (context) => 
                            Dialog(
                              insetPadding: EdgeInsets.symmetric(horizontal: 500),
                              child: ConfirmForm(
                                label: 'Bạn muốn đăng xuất khỏi tài khoản?',
                                isDelete: true,
                                buttonLabel: 'Đăng xuất',
                                onPressFunction: () async{
                                  authProvider.logOut();
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginView()));
                                },
                              ),
                            )
                          );
                        },
                        ))
                  ]
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              constraints: BoxConstraints(minHeight: 800),
              color: Colors.white,
              child: Padding(padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), child: page),
            ),
          ),
        ],
      ),
    );
  }
}