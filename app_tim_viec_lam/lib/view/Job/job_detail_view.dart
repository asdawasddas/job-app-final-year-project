// ignore_for_file: prefer_const_constructors

import 'package:app_tim_viec_lam/view/Enterprise/enterprise_detail_view.dart';
import 'package:app_tim_viec_lam/view/Job/forms/application_form.dart';
import 'package:app_tim_viec_lam/view/Job/widgets/application_dialog.dart';
import 'package:app_tim_viec_lam/view/widgets/bookmark_icon.dart';
import 'package:app_tim_viec_lam/viewmodel/job_detail_provider.dart';
import 'package:provider/provider.dart';

import '../../data/base/status_model.dart';
import '../../utils/enums.dart';
import '../../viewmodel/providers/account_provider.dart';
import '../widgets/expand_btn.dart';
import '../widgets/logo_card.dart';
import '../widgets/text.dart';
import '../widgets/title.dart';
import '../widgets/function/alert_dialog.dart';
import '../widgets/icon_text.dart';
import 'package:flutter/material.dart';


class JobDetailView extends StatefulWidget{
  const JobDetailView({super.key, required this.jobId});

  final String jobId;

  @override
  State<JobDetailView> createState() => _JobDetailViewState();
}

class _JobDetailViewState extends State<JobDetailView> {
  JobDetailProvider viewModel = JobDetailProvider();

  @override
  void initState() {
    viewModel.setID(widget.jobId);
    Future<Status> status = viewModel.getInfo();
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
  Widget build(BuildContext context){
    final accountProvider = Provider.of<AccountProvider>(context);
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, Widget? child) { 
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            titleSpacing: 0,
            title: Text('Thông tin đăng tuyển', style: TextStyle(color: Colors.black, fontSize: 16),),
          ),
          bottomNavigationBar: BottomAppBar(
            shadowColor: Colors.green,
            color: Colors.grey.shade100,
            height: 60,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BookMarkIcon(jobId: viewModel.model.id),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: (accountProvider.isApplied(widget.jobId)) ? 
                        ExpandButton(
                          label: 'Đã nộp CV, ấn để xem', 
                          onPressFunction: () async {
                            Status status = await viewModel.getUserApplication();
                            if (status.isSuccess) {
                              showDialog(barrierDismissible: false, context: context, builder: (context) {
                                return Dialog(insetPadding: EdgeInsets.all(5), child: ApplicationDialog(model: viewModel.application,));
                              });
                            } else {
                              showAlertDialog(AlertType.error, 'Đã có lỗi xảy ra', context);
                            }
                          }, 
                          type: ButtonType.confirm, 
                          isPadding: false,
                        ) : (viewModel.model.isClosed || viewModel.model.isExpired) ?
                        ExpandButton(
                          label: 'Đã hết hạn ứng tuyển', 
                          type: ButtonType.cancel, 
                          isPadding: false,
                        ) :
                        ExpandButton(
                          label: 'Ứng tuyển ngay', 
                          type: ButtonType.confirm, 
                          isPadding: false,
                          onPressFunction: (accountProvider.model.isBlocked) ? () {
                            showAlertDialog(AlertType.alert, 'Bạn đang bị chặn, vui lòng liên hệ bộ phận hỗ trợ', context);
                          } : 
                          (accountProvider.applicantId == '') ? () {
                            showAlertDialog(AlertType.alert, 'Đăng nhập để tiếp tục', context);
                          } :
                          () { 
                            showDialog(barrierDismissible: false, context: context, builder: (context) 
                            {
                              return Dialog(insetPadding: EdgeInsets.all(5), child: ApplicationForm(jobId: widget.jobId,));
                            });
                          },
                        )
                      ,
                    ))
                ])),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: 
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => EnterpriseDetailView(enterpriseId: viewModel.model.enterpriseId,)));
                      },
                      child: LogoCard(logoUrl: viewModel.model.logoUrl))
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                      child: Text(
                        viewModel.model.title ,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold
                        ),),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                      child: Text(
                        viewModel.model.enterpriseName ,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 10,
                        ),),
                    ),
                  ),
              
                  CustomTitle(label: 'Thông tin chung:'),
                  IconText(label: 'Mức lương', icon: Icons.monetization_on_outlined, value: viewModel.model.salary),
                  IconText(label: 'Khu vực', icon: Icons.location_on_outlined, value: viewModel.model.area),
                  IconText(label: 'Kinh nghiệm', icon: Icons.hourglass_empty_rounded, value:viewModel.model.exp,),
                  IconText(label: 'Hình thức', icon: Icons.calendar_month_outlined, value:viewModel.model.workingType),
                  IconText(label: 'Số lượng tuyển', icon: Icons.people_alt_outlined, value: '${viewModel.model.amount} người'),
                  IconText(label: 'Cấp bậc', icon: Icons.badge_outlined, value:viewModel.model.position),
                  IconText(label: 'Hạn nộp CV', icon: Icons.calendar_today_outlined, value:viewModel.model.expiredDate),
              
                  CustomTitle(label: 'Mô tả công việc:'),
                  CustomText(value: viewModel.model.descriptions),
              
                  CustomTitle(label: 'Yêu cầu ứng viên:'),
                  CustomText(value: viewModel.model.requirements),
              
                  CustomTitle(label: 'Quyền lợi:'),
                  CustomText(value: viewModel.model.benefits),
              
                  CustomTitle(label: 'Địa điểm làm việc:'),
                  CustomText(value: viewModel.model.addresses),
              
                  CustomTitle(label: 'Thời gian làm việc:'),
                  CustomText(value: viewModel.model.workingTime),
              
                  CustomTitle(label: 'Ngành nghề:'),
                  Padding(
                    padding: EdgeInsets.only(left: 10, bottom: 20),
                    child: Wrap(
                          spacing: 4,
                          runSpacing: 3,
                          children: List<Widget>.generate(
                            viewModel.model.occupations.length, // place the length of the array here
                            (int index) {
                              return Chip(
                                label: Text(viewModel.model.occupations[index], style: TextStyle(fontSize: 7),)
                              );
                            }
                          ).toList()
                    ),
                  )
            
              ]),
            ),
          ),
      ); }
    );
  }
}