

// ignore_for_file: prefer_const_constructors, prefer_is_empty, prefer_const_literals_to_create_immutables

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:job_app_admin/data/base/status_model.dart';
import 'package:job_app_admin/view/Admin/forms/admin_create_form.dart';
import 'package:job_app_admin/viewmodel/admin_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/function/alert_dialog.dart';
import 'widgets/admin_data.dart';

class AdminView extends StatefulWidget {
  const AdminView({super.key});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  final key = GlobalKey<PaginatedDataTableState>();

  @override
  void initState() {
    Future<Status> status = Provider.of<AdminProvider>(context, listen: false).getList();
    status.then((value) {
      if (!value.isSuccess) {
        showAlertDialog(AlertType.error, 'Đã có lỗi xảy ra', context);
      }
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã có lỗi xảy ra vui lòng thử lại sau')),
      );
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    AdminProvider adminProvider = Provider.of<AdminProvider>(context);
    DataTableSource data = AdminData(
      data : adminProvider.adminList,
      context : context
    );
    return SingleChildScrollView(
      child: Flexible(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                if (adminProvider.adminList.length == 0) 
                  Padding(padding: EdgeInsets.only(left: 150), child: Text('Không có admin nào trong danh sách', style: TextStyle(fontSize: 25),)) 
                else Container()
              ],
            ),
            Row(
              children: [Expanded(
                child: DataTableTheme(
                  data: DataTableThemeData(
                    dataRowColor: WidgetStatePropertyAll(Colors.white),
                    headingTextStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                    dividerThickness: 2,
                    horizontalMargin: 50
                  ),
                  child: PaginatedDataTable(
                    key: key,
                    dataRowMaxHeight: double.infinity,
                    headingRowColor: WidgetStatePropertyAll(Colors.amber.shade50),
                    source: data,
                    rowsPerPage: 5,
                    columns: [
                      const DataColumn(label: Text('Tên tài khoản')),
                      const DataColumn(label: Text('Họ và tên')),
                      const DataColumn(label: Text('Thao tác',)),
                    ],
                    header: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Danh sách admin thường', style: TextStyle( fontWeight: FontWeight.bold, fontSize: 22),),
                        ElevatedButton.icon(
                          onPressed: (){
                            showDialog(
                              context: context, 
                              builder: (context) =>
                                Dialog(
                                  insetPadding: EdgeInsets.symmetric(horizontal: 400),
                                  child: AdminCreateForm(),
                                )
                            );
                          }, 
                          icon: Icon(Icons.add_circle_rounded),
                          label: const Text('Thêm tài khoản admin', style: TextStyle(),),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(200,50),
                            backgroundColor: Colors.blue.shade100
                          ), 
                        ),
                
                      ]
                      ,),
                    columnSpacing: 50,
                    dragStartBehavior: DragStartBehavior.start,
                  ),
                ),
              ),]
            )
          ],
        ),
      ),
    );
  }
}