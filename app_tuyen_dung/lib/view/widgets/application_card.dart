// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:app_tuyen_dung/view/Applications/cv_pdf_view.dart';
import 'package:app_tuyen_dung/view/Applications/forms/evaluate_form.dart';
import 'package:app_tuyen_dung/viewmodel/provider/applications_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/base/status_model.dart';
import '../../data/models/application_model.dart';
import 'function/alert_dialog.dart';
import 'icon_button.dart';
import 'text_span.dart';

class ApplicationCard extends StatelessWidget {
  const ApplicationCard({ super.key, required this.model});
  final Application model;

  @override
  Widget build(BuildContext context) {
    var applicationsProvider = Provider.of<ApplicationsProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 15, 10),
        width: MediaQuery.of(context).size.width,
        constraints: const BoxConstraints(
          minHeight: 225
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
              color: Color.fromARGB(100, 0, 0, 0),
              blurRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children:  [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Container(
                      padding: const EdgeInsets.all(2), // Border width
                      decoration: BoxDecoration(color: Colors.blue.shade100, shape: BoxShape.circle),
                      child: ClipOval(
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(35), // Image radius
                          child: Image(
                            image:  (model.applicantAvatarUrl == '') ?
                              const AssetImage('assets/images/user_avatar.png') :
                              NetworkImage(model.applicantAvatarUrl) as ImageProvider,
                            fit: BoxFit.cover, 
                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                              return const Image(
                                image: AssetImage('assets/images/user_avatar.png'),
                                fit: BoxFit.cover,
                              );
                            },),),)
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CardTitle(title: model.applicantName, ),
                        CustomTextSpan(title: 'Số điện thoại: ', value: model.applicantPhone),
                        CustomTextSpan(title: 'Email: ', value: model.applicantEmail),
                      ],
                    ))
                ],
              ),
              Divider(),
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(right: 5), child: Icon(Icons.calendar_month_outlined, size: 16,)),
                  CustomTextSpan(title: 'Ngày nộp cv: ', value: model.appliedTime),
                ],
              ),
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(right: 5), child: Icon(Icons.mode_edit_outlined, size: 16,)),
                  CustomTextSpan(title: 'Đánh giá: ', value: model.getStatus),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 2),
                child: Center(
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomIconButton(
                          icon: Icon(Icons.edit, color: Colors.green, size: 16), 
                          label: 'Sửa đánh giá', 
                          onPressFunction: (){
                            showDialog(
                              context: context, 
                              builder: (context) =>
                                Dialog(
                                  insetPadding: EdgeInsets.all(5),
                                  child: EvaluateForm(model: model,),
                                )  
                            );
                          },),
                      ),
                      Expanded(
                        child: CustomIconButton(
                          icon: Icon(Icons.remove_red_eye_outlined, color: Colors.blue, size: 16), 
                          label: 'Xem CV', 
                          onPressFunction: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CvPdfView(cvUrl: model.cvUrl, name: model.applicantName,)));
                          },),
                      ),
                    ],
                  ),
                ),
              ),
              ( [1,3,4].contains(model.status) ) ? Container() :
              Padding(
                padding: EdgeInsets.only(top: 2),
                child: Center(
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomIconButton(
                          icon: Icon(Icons.check_box, color: Colors.green, size: 16), 
                          label: switch(model.status) {
                            0 => 'CV đạt',
                            2 => 'Đạt phỏng vấn',
                            _ => ''
                          }, 
                          onPressFunction: (){
                            Future<Status> status = applicationsProvider.update(model.id, { 'status' : (model.status == 0) ? 2 : 4 });
                            status.then((value) {
                              if (value.isSuccess) {
                                showAlertDialog(AlertType.success, 'Cập nhật thành công', context);
                              } else {
                                showAlertDialog(AlertType.error, 'Đã có lỗi xảy ra', context);
                              }
                            });
                          },),
                      ),
                      Expanded(
                        child: CustomIconButton(
                          icon: Icon(Icons.do_disturb_alt, color: Colors.red, size: 16), 
                          label: switch(model.status) {
                            0 => 'CV không đạt',
                            2 => 'Trượt phỏng vấn',
                            _ => ''
                          }, 
                          onPressFunction: (){
                            Future<Status> status = applicationsProvider.update(model.id, { 'status' : (model.status == 0) ? 1 : 3 });
                            status.then((value) {
                              if (value.isSuccess) {
                                showAlertDialog(AlertType.success, 'Cập nhật thành công', context);
                              } else {
                                showAlertDialog(AlertType.error, 'Đã có lỗi xảy ra', context);
                              }
                            });
                          },),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ),
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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 8.5,fontWeight: FontWeight.bold,),
            ),
    );
  }
}



                        