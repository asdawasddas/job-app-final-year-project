import 'package:flutter/material.dart';
import 'package:job_app_admin/data/model/enterprise_model.dart';
import 'package:provider/provider.dart';
import '../../../data/base/status_model.dart';
import '../../../utils/enums.dart';
import '../../../utils/validators.dart';
import '../../../viewmodel/enterprise_provider.dart';
import '../../widgets/text_field.dart';
import '../../widgets/expand_btn.dart';
import '../../widgets/function/alert_dialog.dart';

class EnterpriseInfoForm extends StatefulWidget{
  const EnterpriseInfoForm({super.key, this.model});
  final EnterpriseModel? model;

  @override
  State<EnterpriseInfoForm> createState() => _EnterpriseInfoFormState();
}

class _EnterpriseInfoFormState extends State<EnterpriseInfoForm> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameCtr = TextEditingController();
  TextEditingController taxCodeCtr = TextEditingController();

  @override
  void initState() {
    if (widget.model != null) {
      nameCtr.text = widget.model!.name;
      taxCodeCtr.text = widget.model!.taxCode;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final enterpriseProvider = Provider.of<EnterpriseProvider>(context);
    return Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(padding: EdgeInsets.symmetric(vertical: 30), child: Text((widget.model == null) ? 'Tạo thông tin doanh nghiệp' : 'Thay đổi thông tin doanh nghiệp', textAlign: TextAlign.center, style: TextStyle(fontSize: 30),)),
                CustomTextField(controller: nameCtr, label: 'Tên doanh nghiệp',validator: Validator.enterpriseNameValidator, icon: Icons.business_sharp,),
                CustomTextField(controller: taxCodeCtr, label: 'Mã số thuế', validator: Validator.taxCodeValidator, icon: Icons.payment_rounded, hintText: 'Mã số thuế đăng ký',),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ExpandButton(
                        label: 'Cancel', 
                        type: ButtonType.cancel,
                        onPressFunction: () {Navigator.pop(context);},  
                      ),
                    ),
                    Expanded(
                      child: ExpandButton(
                        label: 'Lưu', 
                        type: ButtonType.confirm,
                        onPressFunction: () {
                          if (formKey.currentState!.validate()) {
                            Map<String, dynamic> data = {
                              'name': nameCtr.text,
                              'tax_code': taxCodeCtr.text,
                            };

                            Future<Status> status = (widget.model == null) ? enterpriseProvider.create(data) : enterpriseProvider.update(widget.model!.id, data);
                            status.then((value) {
                            if (value.isSuccess) {
                              Navigator.pop(context);
                              if (widget.model == null) {
                                enterpriseProvider.search('');
                              }
                              showAlertDialog(AlertType.success,(widget.model == null) ? 'Tạo thành công' : 'Cập nhật thành công', context);
                            } else {
                              showAlertDialog(AlertType.error, (value.failMsg != '') ? value.failMsg : 'Đã có lỗi xảy ra', context);
                          }});}
                        },  
                      ),
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