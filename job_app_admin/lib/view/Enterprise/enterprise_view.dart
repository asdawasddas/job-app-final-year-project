

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:job_app_admin/view/Enterprise/forms/enterprise_info_form.dart';
import 'package:job_app_admin/view/Enterprise/widgets/enterprise_data.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/enterprise_provider.dart';

class EnterpriseView extends StatefulWidget {
  const EnterpriseView({super.key});

  @override
  State<EnterpriseView> createState() => _EnterpriseViewState();
}

class _EnterpriseViewState extends State<EnterpriseView> {
  TextEditingController searchCtr = TextEditingController();
  final key = GlobalKey<PaginatedDataTableState>();

  @override
    initState(){
      Provider.of<EnterpriseProvider>(context, listen: false).search('');
      super.initState();
    }
  @override
  Widget build(BuildContext context) {
    EnterpriseProvider enterpriseProvider = Provider.of<EnterpriseProvider>(context);
    DataTableSource data = EnterpriseData(
      data : enterpriseProvider.searchList,
      context : context
    );
    return SingleChildScrollView(
      child: Flexible(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 30, right: 20),
              child: TextField(
                controller: searchCtr,
                decoration: InputDecoration(
                  hintText: 'Tìm doanh nghiệp bằng tên hoặc mã số thuế',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      enterpriseProvider.search(searchCtr.text);
                      key.currentState?.pageTo(0);
                    },
                  ),
                  focusedBorder:OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  border: const OutlineInputBorder(
                    // borderSide: BorderSide(color: Colors.blueGrey.shade900, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(25))
                  ),
                ),
                onSubmitted: (data) {
                  enterpriseProvider.search(searchCtr.text);
                  key.currentState?.pageTo(0);
                },
              ),
            ),
            Center(
              child: Padding(padding: const EdgeInsets.only(top: 15), 
              child: Text((enterpriseProvider.searchList.isEmpty) ? 'Không tìm thấy kết quả' : 'Tìm thấy ${enterpriseProvider.searchList.length} kết quả', 
              style: const TextStyle(fontSize: 25),)) 
            ),
            Row(
              children: [Expanded(
                child: DataTableTheme(
                  data: const DataTableThemeData(
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
                    columns: const [
                      DataColumn(label: Text('Logo')),
                      DataColumn(label: Text('Tên doanh nghiệp')),
                      DataColumn(label: Text('Mã số thuế')),
                      DataColumn(label: Text('Thao tác',)),
                    ],
                    header: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text('Danh sách doanh nghiệp', style: TextStyle( fontWeight: FontWeight.bold, fontSize: 22),),
                        ElevatedButton.icon(
                          onPressed: (){
                            showDialog(
                              context: context, 
                              builder: (context) =>
                                const Dialog(
                                  insetPadding: EdgeInsets.symmetric(horizontal: 400),
                                  child: EnterpriseInfoForm(),
                                )
                            );
                          }, 
                          icon: const Icon(Icons.add_circle_rounded),
                          label: const Text('Thêm doanh nghiệp', style: TextStyle(),),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(200,50),
                            backgroundColor: Colors.blue.shade100
                          ), 
                        ),
                      ]
                    ),
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
