import 'package:flutter/material.dart';
import 'package:job_app_admin/data/model/hirer_model.dart';
import 'package:job_app_admin/view/Hirer/widgets/avatar.dart';
import 'package:job_app_admin/viewmodel/hirer_provider.dart';
import 'package:provider/provider.dart';

import '../../../data/base/status_model.dart';
import '../../widgets/forms/confirm_form.dart';
import '../../widgets/function/alert_dialog.dart';
import 'enterprise_detail.dart';


class HirerData extends DataTableSource{
  List<HirerModel> data;
  BuildContext context;
  HirerData({required this.data, required this.context});

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
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10), 
            constraints: const BoxConstraints(maxWidth: 150), 
            child: Text(data[index].status, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),))
        ),
        DataCell(
          Column(
            children: [
              (data[index].enterpriseId == '') ? Material() :
              Padding(
                padding: const EdgeInsets.only(top: 10,bottom: 3),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context, 
                      builder: (context) =>
                        Dialog(
                          insetPadding: EdgeInsets.symmetric(horizontal: 400, vertical: 30),
                          child: EnterpriseDetail(enterpriseId: data[index].enterpriseId,),
                        )
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150,40),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),)
                  ), 
                  child: const Text('Doanh nghiệp', style: TextStyle(color: Colors.white),),),
              ),
              (data[index].statusInt != 3 && data[index].statusInt != 0) ?
              Padding(
                padding: const EdgeInsets.only(top: 3, bottom: 3),
                child: 
                  ElevatedButton(
                    onPressed: () {
                      showDialog(context: context, builder: (context) => 
                        Dialog(
                          insetPadding: EdgeInsets.symmetric(horizontal: 550),
                          child: ConfirmForm(
                            label: (data[index].statusInt == 1) ? 'Xác nhận tài khoản này?' : 'Bỏ xác nhận tài khoản này?',
                            isDelete: false,
                            buttonLabel: 'Cập nhật',
                            onPressFunction: () async{
                              Status status =  (data[index].statusInt == 1) ? 
                              await Provider.of<HirerProvider>(context, listen: false).update(data[index].id, { 'is_confirmed' : 2, 'enterprise_id': data[index].enterpriseId })
                              : await Provider.of<HirerProvider>(context, listen: false).update(data[index].id, { 'is_confirmed' : 1 });
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
                      backgroundColor: (data[index].statusInt == 1) ? Colors.green.shade700 : Colors.indigo.shade400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),)
                    ), 
                    child: Text((data[index].statusInt == 1) ? 'Xác nhận' : 'Bỏ xác nhận', style: TextStyle(color: Colors.white),),
                  ),
              ) : Material(),
              Padding(
                padding: const EdgeInsets.only(bottom: 10,top: 3),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(context: context, builder: (context) => 
                        Dialog(
                          insetPadding: EdgeInsets.symmetric(horizontal: 550),
                          child: ConfirmForm(
                            label: (data[index].statusInt != 3) ? 'Chặn tài khoản này?' : 'Bỏ chặn tài khoản này?',
                            isDelete: true,
                            buttonLabel: 'Xác nhận',
                            onPressFunction: () async{
                              Status status =  (data[index].statusInt != 3) ? 
                              await Provider.of<HirerProvider>(context, listen: false).update(data[index].id, { 'is_blocked' : true })
                              : await Provider.of<HirerProvider>(context, listen: false).update(data[index].id, { 'is_blocked' : false });
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
                    backgroundColor: (data[index].statusInt != 3) ? Colors.red : Colors.lime.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),)
                  ), 
                  child: Text(
                    (data[index].statusInt != 3) ? 'Chặn' : 'Bỏ chặn', style: TextStyle(color: Colors.white),),),
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