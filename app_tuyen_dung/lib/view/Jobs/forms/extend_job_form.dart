import 'package:app_tuyen_dung/utils/validators.dart';
import 'package:app_tuyen_dung/viewmodel/provider/jobs_provider.dart';
import 'package:app_tuyen_dung/view/widgets/title.dart';
import 'package:app_tuyen_dung/view/widgets/expand_btn.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../data/base/status_model.dart';
import '../../../data/models/job_model.dart';
import '../../../utils/enums.dart';
import '../../widgets/text_field.dart';
import '../../widgets/function/alert_dialog.dart';

class ExtendJobForm extends StatefulWidget{
  const ExtendJobForm({super.key, required this.model});
  final Job model;
  @override
  State<ExtendJobForm> createState() => _ExtendJobFormState();
}

class _ExtendJobFormState extends State<ExtendJobForm> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController expiredDateCtrl = TextEditingController();

  @override
  void initState() {
    expiredDateCtrl.text = widget.model.expiredDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final jobsProvider = Provider.of<JobsProvider>(context);
    Job model = widget.model;
    return Form(
      key: formKey,
      child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              padding: const EdgeInsets.all(5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const CustomTitle(label: 'Gia hạn tin đăng tuyển'),
                  CustomTextField(controller: expiredDateCtrl, label: 'Ngày hết hạn tuyển dụng', icon: Icons.calendar_month_outlined, editable: false, validator: Validator.notNull,
                  onTapFunction: 
                    () async{
                          DateTime? picked = await showDatePicker(
                            locale: const Locale('vi', 'VI'),
                            context: context,
                            initialDate: DateTime.now().subtract(const Duration(days: -7)), 
                            firstDate: DateTime.now().subtract(const Duration(days: -7)), 
                            lastDate: DateTime(2100),
                            initialEntryMode: DatePickerEntryMode.calendarOnly
                            );
                                              
                          if (picked != null) {
                            setState(() {
                              final DateFormat formatter = DateFormat('dd-MM-yyyy');
                              final String formatted = formatter.format(picked);
                              expiredDateCtrl.text = formatted.toString().split(" ")[0];
                            });
                          }}
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
                          label: 'Gia hạn',
                          type: ButtonType.confirm,
                          onPressFunction: () {
                            if (formKey.currentState!.validate()) {

                            Map<String, dynamic> data = {
                              'expired_date' : expiredDateCtrl.text,
                            };
                            
                            Future<Status> status = jobsProvider.updateJob( model.id, data);
                            status.then((value) {
                            if (value.isSuccess) {
                              Navigator.pop(context);
                              showAlertDialog(AlertType.success, 'Gia hạn tin thành công', context);
                            } else {
                              showAlertDialog(AlertType.error, 'Đã có lỗi xảy ra', context);
                            }});}
                          },
                        )
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }
}