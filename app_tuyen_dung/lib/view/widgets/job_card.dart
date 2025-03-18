// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:app_tuyen_dung/data/base/status_model.dart';
import 'package:app_tuyen_dung/data/models/job_model.dart';
import 'package:app_tuyen_dung/view/Applications/applications_view.dart';
import 'package:app_tuyen_dung/view/Jobs/forms/extend_job_form.dart';
import 'package:app_tuyen_dung/view/Jobs/job_info_view.dart';
import 'package:app_tuyen_dung/view/widgets/forms/confirm_form.dart';
import 'package:app_tuyen_dung/viewmodel/provider/applications_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/provider/jobs_provider.dart';
import 'function/alert_dialog.dart';
import 'icon_button.dart';
import 'text_span.dart';

class JobCard extends StatelessWidget {
  const JobCard({ super.key, required this.model});
  final Job model;

  @override
  Widget build(BuildContext context) {
    var jobsProvider = Provider.of<JobsProvider>(context);
    return GestureDetector(
      onTap: (){
        Provider.of<ApplicationsProvider>(context, listen: false).setJob(model);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ApplicationsView()));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 15, 10),
          width: MediaQuery.of(context).size.width,
          constraints: const BoxConstraints(
            minHeight: 200
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(
              Radius.circular(12.0),),
            border: Border.all(
              color: Color.fromARGB(255, 250, 250, 250),
              width: 2,),
            boxShadow: const [
              BoxShadow(
                // color: Color.fromARGB(100, 0, 0, 0),
                color: Colors.green,
                blurRadius: 5,
              ),
            ],
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children:  [
                CardTitle(title: model.title, ),
                CustomTextSpan(title: 'Ngày tạo tin:', value: model.createdDate),
                CustomTextSpan(title: 'Ngày hết hạn nộp hồ sơ:', value: model.expiredDate),
                CustomTextSpan(title: 'Tổng số hồ sơ ứng viên:', value: model.applicationsCount.toString()),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      (model.isClosed) ? Container() : 
                      Expanded(
                        child: CustomIconButton(
                          icon: Icon(Icons.calendar_month, color: Colors.green, size: 19), 
                          label: 'Gia hạn', 
                          onPressFunction: (){
                            showDialog(
                              context: context, 
                              builder: (context) => Dialog(
                                insetPadding: EdgeInsets.all(5),
                                child: ExtendJobForm(model: model),
                              ));
                          },)
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: model.isClosed ? 20 : 0),
                          child: CustomIconButton(
                            icon: Icon(Icons.remove_red_eye_outlined, color: Colors.blue, size: 19,), 
                            label: 'Chi tiết', 
                            onPressFunction: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => JobInfoView(model: model,)));
                            },))
                      ),
                      (model.isClosed) ? Container() : 
                      Expanded(
                        child: CustomIconButton(
                        icon: Icon(Icons.do_disturb_alt, color: Colors.red, size: 19), 
                        label: 'Đóng tin', 
                        onPressFunction: (){
                          showDialog(
                            context: context, 
                            builder: (context) => Dialog(
                              child: ConfirmForm(
                                label: 'Sau khi đóng tin bạn sẽ không thể gia hạn hay chỉnh sửa \nBạn vẫn muốn đóng tin tuyển dụng này?', 
                                buttonLabel: 'Đóng tin',
                                isDelete: true,
                                onPressFunction: () {
                                  Future<Status> status = jobsProvider.closeJob(model.id);
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
                        },)
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ),
      )
    );
  }
}

class CardTitle extends StatelessWidget {
  const CardTitle({super.key, required this.title,});
  final String title;

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: 
        Text(
              textAlign: TextAlign.left,
              title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 9.5,fontWeight: FontWeight.bold,),
            ),
    );
  }
}



// enum Size {
//   big(15.5),
//   small(15);

//   final double font;

//   const Size(this.font);
// }