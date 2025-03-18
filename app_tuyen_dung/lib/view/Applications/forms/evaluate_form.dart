import 'package:app_tuyen_dung/data/models/application_model.dart';
import 'package:app_tuyen_dung/view/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/base/status_model.dart';
import '../../../utils/enums.dart';
import '../../../viewmodel/provider/applications_provider.dart';
import '../../widgets/expand_btn.dart';
import '../../widgets/function/alert_dialog.dart';

class EvaluateForm extends StatefulWidget{
  const EvaluateForm({super.key, required this.model});
  final Application model;

  @override
  State<EvaluateForm> createState() => _EvaluateFormState();
}

class _EvaluateFormState extends State<EvaluateForm> {
  List value = [
    'Chưa đánh giá',
    'CV không đạt yêu cầu',
    'CV đạt yêu cầu',
    'Phỏng vấn không đạt yêu cầu',
    'Phỏng vấn đạt yêu cầu',
  ];
  int status = 0; 

  @override
  void initState() {
    status = widget.model.status;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const CustomTitle(label: 'Đánh giá ứng viên:'),
                Padding(
                padding: EdgeInsets.only(left: 10, bottom: 10),
                child: Wrap(
                      spacing: 4,
                      runSpacing: 3,
                      children: List<Widget>.generate(
                        value.length,
                        (int index) {
                          return ChoiceChip(
                            selected: status == index,
                            label: Text(value[index], style: TextStyle(fontSize: 7),),
                            onSelected: (bool selected) {
                              setState(() {
                                status = selected ? index : status;
                              });
                            },
                          );
                        }
                      ).toList()
                ),
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
                        label: 'Lưu thay đổi',
                        type: ButtonType.confirm,
                        onPressFunction: () {
                          Future<Status> result = Provider.of<ApplicationsProvider>(context, listen: false).update(widget.model.id, { 'status' : status});
                          result.then((value) {
                            if (value.isSuccess) {
                              Navigator.pop(context);
                              showAlertDialog(AlertType.success, 'Cập nhật thành công', context);
                            } else {
                              showAlertDialog(AlertType.error, 'Đã có lỗi xảy ra', context);
                            }
                          });
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