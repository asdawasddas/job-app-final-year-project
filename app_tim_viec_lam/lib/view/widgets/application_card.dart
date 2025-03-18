// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:app_tim_viec_lam/view/Job/job_detail_view.dart';
import 'package:flutter/material.dart';
import '../../data/model/application_model.dart';
import '../CV/cv_pdf_view.dart';
import 'icon_button.dart';
import 'text_span.dart';

class ApplicationCard extends StatelessWidget {
  const ApplicationCard({ super.key, required this.model});
  final Application model;

  @override
  Widget build(BuildContext context) {
    // var applicationsProvider = Provider.of<ApplicationsProvider>(context);
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
              CardTitle(title: model.jobTitle),
              Divider(),
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(right: 5), child: Icon(Icons.calendar_month_outlined, size: 16,)),
                  CustomTextSpan(title: 'Ngày nộp CV: ', value: model.appliedTime),
                ],
              ),
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(right: 5), child: Icon(Icons.mode_edit_outlined, size: 16,)),
                  CustomTextSpan(title: 'Đánh giá CV: ', value: model.getStatus),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 2),
                child: Center(
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomIconButton(
                          icon: Icon(Icons.remove_red_eye, color: Colors.green, size: 16), 
                          label: 'Thông tin việc làm', 
                          onPressFunction: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => JobDetailView(jobId: model.jobId,)));
                          },),
                      ),
                      Expanded(
                        child: CustomIconButton(
                          icon: Icon(Icons.remove_red_eye_outlined, color: Colors.blue, size: 16), 
                          label: 'Xem CV', 
                          onPressFunction: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CvPdfView(cvUrl: model.cvUrl,)));
                          },),
                      ),
                    ],
                  ),
                ),
              ),
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
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 8.5,fontWeight: FontWeight.bold,),
            ),
    );
  }
}



                        