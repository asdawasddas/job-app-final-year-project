// ignore_for_file: prefer_const_constructors

import 'package:app_tuyen_dung/utils/enums.dart';
import 'package:app_tuyen_dung/view/widgets/text.dart';
import 'package:app_tuyen_dung/view/widgets/expand_btn.dart';
import 'package:provider/provider.dart';

import '../../data/base/status_model.dart';
import '../../data/models/job_model.dart';
import '../../viewmodel/provider/jobs_provider.dart';
import '../widgets/title.dart';
import '../widgets/forms/confirm_form.dart';
import '../widgets/function/alert_dialog.dart';
import '../widgets/icon_text.dart';
import 'package:flutter/material.dart';

import 'forms/extend_job_form.dart';
import 'forms/job_info_form.dart';


class JobInfoView extends StatelessWidget{
  const JobInfoView({super.key, required this.model});

  final Job model;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        titleSpacing: 0,
        title: Text('Thông tin đăng tuyển', style: TextStyle(color: Colors.black, fontSize: 16),),
      ),
      bottomNavigationBar: (!model.isClosed) ? BottomAppBar(
        shadowColor: Colors.green,
        color: Colors.white,
        height: 60,
        child: Center(
          child: Row(
            children: [
              (model.applicationsCount != 0 || model.isClosed) ?  Container() : 
              Expanded(child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: ExpandButton(
                  label: 'Chỉnh sửa', 
                  onPressFunction: () { Navigator.of(context).push(MaterialPageRoute(builder: (context) => JobInfoForm(model: model,))); }, 
                  type: ButtonType.confirm, 
                  isPadding: false,),
              )
              ),
              (model.isClosed) ? Container() : 
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),     
                  child: ExpandButton(
                    label: 'Gia hạn', 
                    onPressFunction: () {
                      showDialog(
                        context: context, 
                        builder: (context) => Dialog(
                          insetPadding: EdgeInsets.all(5),
                          child: ExtendJobForm(model: model),
                        ));
                    }, 
                    type: ButtonType.confirm, 
                    isPadding: false,),
                )
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: ExpandButton(
                    label: 'Đóng', 
                    onPressFunction: () { 
                      showDialog(
                        context: context, 
                        builder: (context) => Dialog(
                          child: ConfirmForm(
                            label: 'Sau khi đóng tin bạn sẽ không thể gia hạn hay chỉnh sửa \nBạn vẫn muốn đóng tin tuyển dụng này?', 
                            buttonLabel: 'Đóng tin',
                            isDelete: true,
                            onPressFunction: () {
                              Future<Status> status = Provider.of<JobsProvider>(context).closeJob(model.id);
                              status.then((value) {
                              if (value.isSuccess) {
                                Navigator.pop(context);
                                showAlertDialog(AlertType.success, 'Đóng tin tuyển dụng thành công', context);
                              } else {
                                showAlertDialog(AlertType.error, 'Đã có lỗi xảy ra', context);
                              }
                            });
                        },
                      ),
                    ));
                                }, type: ButtonType.delete, isPadding: false,),
                ))
            ])),
      ): null,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTitle(label: 'Tiêu đề tin đăng tuyển:'),
              CustomText(value: model.title),
          
              CustomTitle(label: 'Thông tin chung:'),
              IconText(label: 'Mức lương', icon: Icons.monetization_on_outlined, value: model.salary),
              IconText(label: 'Khu vực', icon: Icons.location_on_outlined, value: model.area),
              IconText(label: 'Kinh nghiệm', icon: Icons.hourglass_empty_rounded, value: model.exp,),
              IconText(label: 'Hình thức', icon: Icons.calendar_month_outlined, value: model.workingType),
              IconText(label: 'Số lượng tuyển', icon: Icons.people_alt_outlined, value: '${model.amount} người'),
              IconText(label: 'Cấp bậc', icon: Icons.badge_outlined, value: model.position),
              IconText(label: 'Hạn nộp CV', icon: Icons.calendar_today_outlined, value: model.expiredDate),
          
              CustomTitle(label: 'Mô tả công việc:'),
              CustomText(value: model.descriptions),
          
              CustomTitle(label: 'Yêu cầu ứng viên:'),
              CustomText(value: model.requirements),
          
              CustomTitle(label: 'Quyền lợi:'),
              CustomText(value: model.benefits),
          
              CustomTitle(label: 'Địa điểm làm việc:'),
              CustomText(value: model.addresses),
          
              CustomTitle(label: 'Thời gian làm việc:'),
              CustomText(value: model.workingTime),
          
              CustomTitle(label: 'Ngành nghề:'),
              Padding(
                padding: EdgeInsets.only(left: 10, bottom: 20),
                child: Wrap(
                      spacing: 4,
                      runSpacing: 3,
                      children: List<Widget>.generate(
                        model.occupations.length, // place the length of the array here
                        (int index) {
                          return Chip(
                            label: Text(model.occupations[index], style: TextStyle(fontSize: 7),)
                          );
                        }
                      ).toList()
                ),
              )
        
          ]),
        ),
      ),
    );
  }
}