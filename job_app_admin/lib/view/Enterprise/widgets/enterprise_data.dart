import 'package:flutter/material.dart';
import 'package:job_app_admin/view/Enterprise/widgets/enterprise_detail.dart';
import 'package:job_app_admin/view/Enterprise/widgets/logo.dart';

import '../../../data/model/enterprise_model.dart';
import '../forms/enterprise_info_form.dart';

class EnterpriseData extends DataTableSource{
  List<EnterpriseModel> data;
  BuildContext context;
  EnterpriseData({required this.data, required this.context});

  @override
  DataRow? getRow(int index) {
    return DataRow(
      color: WidgetStatePropertyAll(index.isOdd ? Colors.grey.shade200 : Colors.grey.shade100),
      cells: [
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10), 
            constraints: const BoxConstraints(maxWidth: 200), 
            child: Logo(model: data[index]))
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10), 
            constraints: const BoxConstraints(maxWidth: 200), 
            child: Text(data[index].name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),))
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10), 
            constraints: const BoxConstraints(maxWidth: 150), 
            child: Text(data[index].taxCode, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),))
        ),
        DataCell(
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context, 
                      builder: (context) =>
                        Dialog(
                          insetPadding: EdgeInsets.symmetric(horizontal: 400, vertical: 30),
                          child: EnterpriseDetail(model: data[index],),
                        )
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200,40),
                    backgroundColor: Colors.green
                  ), 
                  child: const Text('Xem thông tin', style: TextStyle(color: Colors.white),),),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context, 
                      builder: (context) =>
                        Dialog(
                          insetPadding: EdgeInsets.symmetric(horizontal: 400),
                          child: EnterpriseInfoForm(model: data[index],),
                        )
                    );
                  }, 
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200,40),
                    backgroundColor: Colors.blue.shade100
                  ), 
                  child: const Text('Cập nhật')),
              )
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