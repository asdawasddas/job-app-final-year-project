// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:app_tim_viec_lam/view/widgets/job_card.dart';
import 'package:app_tim_viec_lam/view/widgets/logo_card.dart';
import 'package:app_tim_viec_lam/view/widgets/icon_button.dart';
import 'package:app_tim_viec_lam/view/widgets/text.dart';
import 'package:app_tim_viec_lam/view/widgets/title.dart';
import 'package:app_tim_viec_lam/viewmodel/enterprise_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/base/status_model.dart';
import '../../viewmodel/providers/account_provider.dart';
import '../widgets/function/alert_dialog.dart';
import '../widgets/icon_text.dart';

class EnterpriseDetailView extends StatefulWidget {
  const EnterpriseDetailView({super.key, required this.enterpriseId});
  final String enterpriseId; 

  @override
  State<EnterpriseDetailView> createState() => _EnterpriseDetailViewState();
}

class _EnterpriseDetailViewState extends State<EnterpriseDetailView> {
  EnterpriseDetailProvider viewModel = EnterpriseDetailProvider();

  @override
  void initState() {
    viewModel.setID(widget.enterpriseId);
    Future<Status> status = viewModel.getEnterpriseDetail();
    status.then((value) {
      if (!value.isSuccess) {
        showAlertDialog(AlertType.error, 'Đã có lỗi xảy ra', context);
      }
    })
    .onError((error, stackTrace) {
      showAlertDialog(AlertType.error, 'Đã có lỗi xảy ra', context);
    });
    viewModel.getEnterpriseJobs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () { Navigator.pop(context);}, 
            icon: Icon(Icons.arrow_back_ios_new), 
            style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.blue.shade100)),)
        ),
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          child: ListenableBuilder(
            listenable: viewModel,
            builder: (context, Widget? child) { 
              return Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    LogoCard(logoUrl: viewModel.model.logoUrl),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Text(
                        viewModel.model.name ,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold
                        ),),
                    ),
                    Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(padding: EdgeInsets.only(right: 5), child: Icon(Icons.people_outline, size: 20, weight: 20,)),
                                Text(
                                  viewModel.model.totalFollower.toString() + ' người theo dõi',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 7,
                                    fontWeight: FontWeight.bold
                                ),),
                              ],
                            )
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomIconButton(
                            label: (accountProvider.isFavEnterprise(widget.enterpriseId)) ? 'Đang theo dõi' : 'Theo dõi doanh nghiệp', 
                            icon: (accountProvider.isFavEnterprise(widget.enterpriseId)) ? Icon(Icons.check, color: Colors.blue,) : Icon(Icons.add, color: Colors.green,), 
                            onPressFunction: () {
                              if (accountProvider.applicantId == '') {
                                showAlertDialog(AlertType.alert, 'Đăng nhập để theo dõi doanh nghiệp này', context);
                              } else {
                                Future<Status> status = accountProvider.toggleAddEnterPrise(widget.enterpriseId);
                                status.then((value) {
                                if (value.isSuccess) {
                                  viewModel.getEnterpriseDetail();
                                  showAlertDialog(AlertType.success, 'Cập nhật thành công', context);
                                } else {
                                  showAlertDialog(AlertType.error, (value.failMsg != '') ? value.failMsg : 'Đã có lỗi xảy ra', context);
                                }});
                              }
                            },))]
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTitle(label: 'Thông tin chung:'),
                        IconText(label: 'Lĩnh vực kinh doanh:', icon: Icons.factory, value: viewModel.model.industry),
                        IconText(label: 'Quy mô nhân sự:', icon: Icons.people, value: viewModel.model.employeeAmount),
                        Divider(),
                        CustomTitle(label: 'Địa chỉ doanh nghiệp:'),
                        CustomText(value: viewModel.model.address),
                        Divider(),
                        CustomTitle(label: 'Giới thiệu doanh nghiệp:'),
                        CustomText(value: viewModel.model.infomation),                        
                      ],
                    ),
                    CustomTitle(label: 'Tin tuyển dụng: ${viewModel.enterpriseJobs.length}'),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: viewModel.enterpriseJobs.length,
                      itemBuilder: (context, index) {
                        return JobCard(model: viewModel.enterpriseJobs[index]);
                    }
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}