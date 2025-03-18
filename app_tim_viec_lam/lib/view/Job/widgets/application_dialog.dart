

import 'package:app_tim_viec_lam/data/model/application_model.dart';
import 'package:flutter/material.dart';

import '../../../utils/enums.dart';
import '../../CV/cv_pdf_view.dart';
import '../../widgets/expand_btn.dart';
import '../../widgets/text_span.dart';
import '../../widgets/title.dart';

class ApplicationDialog extends StatelessWidget {
  final Application model;

  const ApplicationDialog({super.key, required this.model});
  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const CustomTitle(label: 'Thông tin CV', isCenter: true,),
                Row(
                  children: [
                    const Padding(padding: EdgeInsets.only(right: 5), child: Icon(Icons.calendar_month_outlined, size: 16,)),
                    CustomTextSpan(title: 'Ngày nộp CV: ', value: model.appliedTime),
                  ],
                ),
                Row(
                  children: [
                    const Padding(padding: EdgeInsets.only(right: 5), child: Icon(Icons.mode_edit_outlined, size: 16,)),
                    CustomTextSpan(title: 'Đánh giá CV: ', value: model.getStatus),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    Expanded(
                      child: ExpandButton(
                        label: 'Đóng',
                        type: ButtonType.cancel,
                        onPressFunction: () async {
                          Navigator.pop(context);},
                      )
                    ),
                    Expanded(
                      child: ExpandButton(
                        label: 'Xem CV đã nộp',
                        type: ButtonType.confirm,
                        onPressFunction: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CvPdfView(cvUrl: model.cvUrl,)));
                        },
                      )
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
  }

}