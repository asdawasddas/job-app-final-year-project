import 'package:flutter/material.dart';
import 'package:job_app_admin/view/Admin/forms/admin_password_form.dart';
import 'package:job_app_admin/view/Admin/forms/admin_update_form.dart';
import 'package:provider/provider.dart';

import '../../../data/base/status_model.dart';
import '../../../data/model/admin_model.dart';
import '../../../viewmodel/admin_provider.dart';
import '../../widgets/forms/confirm_form.dart';
import '../../widgets/function/alert_dialog.dart';

class AdminData extends DataTableSource{
  List<Admin> data;
  BuildContext context;
  AdminData({required this.data, required this.context});

  @override
  DataRow? getRow(int index) {
    return DataRow(
      color: WidgetStatePropertyAll(index.isOdd ? Colors.grey.shade200 : Colors.grey.shade100),
      cells: [
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10), 
            constraints: const BoxConstraints(maxWidth: 200), 
            child: Text(data[index].accountName, style: const TextStyle(fontSize: 18),))
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10), 
            constraints: const BoxConstraints(maxWidth: 150), 
            child: Text(data[index].fullName, style: const TextStyle(fontSize: 18),))
        ),
        DataCell(
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(context: context, builder: (context) =>
                      Dialog(
                        insetPadding: EdgeInsets.symmetric(horizontal: 500),
                        child: AdminUpdateForm(model: data[index]),
                      )
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150,40),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),)
                  ), 
                  child: const Text('Cập nhật', style: TextStyle(color: Colors.white),),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3, bottom: 3),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(context: context, builder: (context) =>
                      Dialog(
                        insetPadding: EdgeInsets.symmetric(horizontal: 500),
                        child: AdminPasswordForm(model: data[index]),
                      )
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150,40),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),)
                  ), 
                  child: const Text('Đổi mật khẩu', style: TextStyle(color: Colors.white),),),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(context: context, builder: (context) => 
                      Dialog(
                        insetPadding: EdgeInsets.symmetric(horizontal: 550),
                        child: ConfirmForm(
                          label: 'Bạn muốn xóa tài khoản admin này?',
                          isDelete: true,
                          buttonLabel: 'Xóa',
                          onPressFunction: () async{
                            Status status = await Provider.of<AdminProvider>(context, listen: false).delete(data[index].id);
                            if (status.isSuccess) {
                              Navigator.pop(context);
                              showAlertDialog(AlertType.success, 'Xóa tài khoản thành công', context);
                            } else {
                              showAlertDialog(AlertType.success, 'Đã có lỗi xảy ra', context);
                            }
                          },
                        ),
                      )
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150,40),
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),)
                  ), 
                  child: const Text('Xóa', style: TextStyle(color: Colors.white),),),
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