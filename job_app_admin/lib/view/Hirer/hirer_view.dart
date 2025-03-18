import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:job_app_admin/data/model/hirer_model.dart';
import 'package:job_app_admin/view/Hirer/widgets/hirer_data.dart';
import 'package:job_app_admin/viewmodel/hirer_provider.dart';
import 'package:provider/provider.dart';

const List<String> list = <String>['Chưa cập nhật', 'Chờ xác nhận', 'Đã xác nhận', 'Bị chặn', 'Tất cả'];
const List<int> statusList = <int>[4,3,2,1,0];

class HirerView extends StatefulWidget {
  const HirerView({super.key});

  @override
  State<HirerView> createState() => _EnterpriseViewState();
}

class _EnterpriseViewState extends State<HirerView> {
  TextEditingController searchCtr = TextEditingController();
  final key = GlobalKey<PaginatedDataTableState>();
  int filter = 4;

  @override
  initState(){
    Provider.of<HirerProvider>(context, listen: false).search('');
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    HirerProvider hirerProvider = Provider.of<HirerProvider>(context);
    List<HirerModel> hirerList = [];
    switch (filter) {
      case 4:
        hirerList = hirerProvider.hirerList;
      default:
        hirerList = List.from(hirerProvider.hirerList.where((model)
          => model.statusInt == filter
        ));
    }
    DataTableSource data = HirerData(
      data : hirerList,
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
                  hintText: 'Tìm nhà tuyển dụng bằng email, số điện thoại hoặc tên',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      hirerProvider.search(searchCtr.text);
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
                  hirerProvider.search(searchCtr.text);
                  key.currentState?.pageTo(0);
                },
              ),
            ),
            Center(
              child:Padding(
                padding: const EdgeInsets.only(top: 15), 
                child: Text((hirerList.isEmpty) ?'Không tìm thấy kết quả' : 'Tìm thấy ${hirerList.length} kết quả', 
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
                      DataColumn(label: Text('Ảnh đại diện')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Họ và tên')),
                      DataColumn(label: Text('Số điện thoại')),
                      DataColumn(label: Text('Trạng thái')),
                      DataColumn(label: Text('Thao tác',)),
                    ],
                    header: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text('Danh sách nhà tuyển dụng', style: TextStyle( fontWeight: FontWeight.bold, fontSize: 22),),
                        DropdownMenu<int>(
                          initialSelection: filter,
                          onSelected: (int? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              filter = value!;
                              key.currentState?.pageTo(0);
                            });
                          },
                          dropdownMenuEntries: statusList.map<DropdownMenuEntry<int>>((int value) {
                            return DropdownMenuEntry<int>(value: value, label: list[value]);
                          }).toList(),
                        )
                      ]
                    ),
                    columnSpacing: 35,
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
