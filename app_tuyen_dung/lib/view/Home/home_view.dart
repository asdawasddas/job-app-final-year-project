

// ignore_for_file: prefer_const_constructors

import 'package:app_tuyen_dung/view/Enterprise/enterprise_search_view.dart';
import 'package:app_tuyen_dung/view/Enterprise/widgets/enterprise_detail.dart';
import 'package:app_tuyen_dung/view/Jobs/forms/job_info_form.dart';
import 'package:app_tuyen_dung/view/widgets/function/alert_dialog.dart';
import 'package:app_tuyen_dung/view/widgets/title.dart';
import 'package:app_tuyen_dung/view/widgets/expand_btn.dart';
import 'package:app_tuyen_dung/viewmodel/provider/enterprise_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/enums.dart';
import '../../viewmodel/provider/account_provider.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/title_button.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(context);
    final enterpriseProvider = Provider.of<EnterpriseProvider>(context);

    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 6;
    final double itemWidth = size.width / 2;
    return 
      Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [const CustomAppbar()],
          body: SingleChildScrollView(
            child: Column(
              children: [
                Row(children: [
                  Expanded(child: CustomTitle(label: 'Thống kê tổng quát')),
                  Padding(
                    padding: EdgeInsets.only(right: 3), 
                    child: IconButton(
                      onPressed: () { accountProvider.getStatistic(); }, 
                      icon: Icon(Icons.replay_circle_filled_outlined)))
                ]),
                
                GridView.count(
                  childAspectRatio: (itemWidth / itemHeight),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  children: [
                    CustomBox(title: 'Tin đã đăng', value: accountProvider.statistic.totalJob.toString()),
                    CustomBox(title: 'Tin đang chạy', value: accountProvider.statistic.runningJob.toString()),
                    CustomBox(title: 'Tổng số CV', value: accountProvider.statistic.totalCV.toString()),
                    CustomBox(title: 'CV mới', value: accountProvider.statistic.newCV.toString()),
                  ]
                ),
                
                Padding(padding: EdgeInsets.symmetric(horizontal: 20),child:Divider()),
                
                CustomTitle(label: 'Thêm tin tuyển dụng'),
          
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: ExpandButton(label: 'Tạo tin tuyển dụng mới', onPressFunction: (){
                    if (accountProvider.model.isBlocked) {
                      showAlertDialog(AlertType.alert, 'Bạn đã bị chặn, vui lòng liên hệ với bộ phận hỗ trợ', context);
                    } else if (accountProvider.model.statusInt == 0 || accountProvider.model.statusInt == 1) {
                      showAlertDialog(AlertType.alert, 'Bạn chưa được xác nhận, vui lòng liên hệ bộ phận hỗ trợ', context);
                    } else if (enterpriseProvider.enterpriseId == '' || !enterpriseProvider.model.isValid) {
                      showAlertDialog(AlertType.alert, 'Bạn chưa cập nhật đầy đủ thông tin doanh nghiệp', context);
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const JobInfoForm()));
                    }
                  }, type: ButtonType.confirm,),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 20),child:Divider()),
                CustomTitle(label: 'Doanh nghiệp'),
                TitleButton(
                  label: 'Tìm kiếm doanh nghiệp', 
                  icon: Icons.search, 
                  function: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => EnterpriseSearchView()));
                  }
                ),
                TitleButton(
                  label: 'Thông tin doanh nghiệp', 
                  icon: Icons.business_sharp, function: () {
                    if (accountProvider.model.statusInt == 0) {
                      showAlertDialog(AlertType.alert, 'Bạn chưa chọn doanh nghiệp hoạt động', context);
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const EnterpriseDetail()));
                    }
                  }
                ),
              ],
            ),
          ),
        ),
      );
  
  
  }
}

class CustomBox extends StatelessWidget {
  const CustomBox({super.key, required this.title, required this.value,});
  final String title;
  final String value;

  @override
  Widget build(BuildContext context){
    return 
      Padding(
        padding: EdgeInsets.all(8),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
          borderRadius: const BorderRadius.all(
            Radius.circular(12.0),),
          border: Border.all(
            color: const Color.fromARGB(255, 106, 154, 236),
            width: 1,),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(100, 0, 0, 0),
              blurRadius: 5,
            ),
          ],),
          constraints: const BoxConstraints(
            maxHeight: 20,
          ),
          height: 10,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: TextStyle(fontSize: 10),),
                Text(value, style: TextStyle(fontSize: 10),)
              ],
            ),
          ),
        ),
      );
  }
}