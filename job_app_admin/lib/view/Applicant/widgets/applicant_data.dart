import 'package:flutter/material.dart';
import 'package:job_app_admin/data/model/applicant_model.dart';
import 'package:job_app_admin/viewmodel/applicant_provider.dart';
import 'package:provider/provider.dart';

import '../../../data/base/status_model.dart';
import '../../widgets/forms/confirm_form.dart';
import '../../widgets/function/alert_dialog.dart';
import 'avatar.dart';


class ApplicantData extends DataTableSource{
  List<ApplicantModel> data;
  BuildContext context;
  ApplicantData({required this.data, required this.context});

  @override
  DataRow? getRow(int index) {
    return DataRow(
      color: WidgetStatePropertyAll(index.isOdd ? Colors.grey.shade200 : Colors.grey.shade100),
      cells: [
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10), 
            constraints: const BoxConstraints(maxWidth: 200), 
            child: Avatar(model: data[index]))
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10), 
            constraints: const BoxConstraints(maxWidth: 200), 
            child: Text(data[index].email, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),))
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10), 
            constraints: const BoxConstraints(maxWidth: 200), 
            child: Text(data[index].fullName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),))
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10), 
            constraints: const BoxConstraints(maxWidth: 150), 
            child: Text(data[index].phoneNumber, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),))
        ),
        DataCell(
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10,top: 3),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(context: context, builder: (context) => 
                      Dialog(
                        insetPadding: EdgeInsets.symmetric(horizontal: 550),
                        child: ConfirmForm(
                          label: (!data[index].isBlocked) ? 'Chặn tài khoản này?' : 'Bỏ chặn tài khoản này?',
                          isDelete: true,
                          buttonLabel: 'Cập nhật',
                          onPressFunction: () async{
                            Map<String, dynamic> json = {
                              'is_blocked' : (data[index].isBlocked) ? false : true
                            };
                            Status status = await Provider.of<ApplicantProvider>(context, listen: false).update(data[index].id, json);
                            if (status.isSuccess) {
                              Navigator.pop(context);
                              showAlertDialog(AlertType.success, 'Cập nhật thành công', context);
                            } else {
                              showAlertDialog(AlertType.error, 'Đã có lỗi xảy ra', context);
                            }
                          },
                        ),
                      )
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150,40),
                    backgroundColor: (!data[index].isBlocked) ? Colors.red : Colors.lime.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),)
                  ), 
                  child: Text(
                    (!data[index].isBlocked) ? 'Chặn' : 'Bỏ chặn', style: TextStyle(color: Colors.white),),),
              ),
            
            ],
          )
        )
    ]);
  }
  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}