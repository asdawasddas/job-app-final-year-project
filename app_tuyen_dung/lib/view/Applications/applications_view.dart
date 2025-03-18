// ignore_for_file: prefer_const_constructors

import 'package:app_tuyen_dung/viewmodel/provider/applications_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/application_card.dart';

class ApplicationsView extends StatefulWidget {
  const ApplicationsView({super.key});


  @override
  State<ApplicationsView> createState() => _ApplicationsViewState();
}

class _ApplicationsViewState extends State<ApplicationsView> {
  //0: mới , 1: cũ
  int sort = 0;
  bool showMissed = false;

  @override
  Widget build(BuildContext context) {

    var applicationsProvider = Provider.of<ApplicationsProvider>(context);
    var filterList = List.from(applicationsProvider.modelList.where(
      (model) => (showMissed && model.status == 1) || (!showMissed && model.status == 0 ) ));

    var interviewList = List.from(applicationsProvider.modelList.where(
      (model) => (showMissed && model.status > 1 && model.status == 3) || (!showMissed && model.status == 2) ));

    var qualifiedList = List.from(applicationsProvider.modelList.where(
      (model) => model.status == 4 ));
    
    var map = {
    };
    for (var element in applicationsProvider.modelList) {
      if(!map.containsKey(element.status.toString())) {
        map[element.status.toString()] = 1;
      } else {
        map[element.status.toString()] += 1;
      }
    }

    for (var element in ['0','1','2','3','4']) {
      if(!map.containsKey(element)) {
        map[element] = 0;
      }
    }
    
    return SafeArea(
      child: Scaffold(
        appBar: null,
        body: DefaultTabController(
            initialIndex: 0,
            length: 4, 
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  leading: null,
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.blueGrey.shade900,
                  toolbarHeight: 90 + kToolbarHeight,
                  // toolbarHeight: kToolbarHeight + 20,
                  pinned: false,
                  centerTitle: true,
                  floating: true,
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 13,),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Expanded(
                            child: TabBar(
                              tabAlignment: TabAlignment.start,
                              dragStartBehavior: DragStartBehavior.start,
                              dividerHeight: 0,
                              padding: EdgeInsets.all(5),
                              indicatorColor: Colors.white,
                              isScrollable: true,
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              labelColor: Colors.amber,
                              unselectedLabelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.5,
                                color: Colors.white
                              ),
                              tabs: [
                                Tab(
                                    icon: Icon(Icons.remove_red_eye_outlined),
                                    text: ' Tổng quát',
                                ),
                                Tab(
                                  icon: Icon(Icons.search_outlined),
                                  text: 'Lọc CV',
                                ),
                                Tab(
                                  icon: Icon(Icons.calendar_month),
                                  text: 'Phỏng vấn',
                                ),
                                Tab(
                                  icon: Icon(Icons.history),
                                  text: 'Ứng viên đạt',
                              ),
                            ]
                            ),
                          ),
                        
                        ]
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 19),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            
                            Text('Hiện CV bị loại:', style: TextStyle(fontSize: 13, color: Colors.white70),),
                            SizedBox(
                              height: 15,
                              width: 15,
                              child: Checkbox(
                                checkColor: Colors.red,
                                fillColor: WidgetStateProperty.all(Colors.grey.shade400),
                                value: showMissed, 
                                onChanged: (bool? value) {
                                  setState(() {
                                    showMissed = !showMissed;
                                  });
                                }),
                            ),
                            Text('Sắp xếp:', style: TextStyle(fontSize: 13, color: Colors.white70),),
                            GestureDetector(
                              child: Text((sort == 0) ? 'Mới nhất' : 'Cũ nhất', style: TextStyle(fontSize: 13, color: Colors.white)),
                              onTap: () {
                                sort = (sort == 0) ? 1 : 0;
                                applicationsProvider.getApplications(sort);
                              },
                            ),
                          ],
                        ),
                      ),
                  ],),
                ),
              ],
              body: TabBarView(
                children: [
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextRow(label: 'Tổng số ứng viên', value: applicationsProvider.modelList.length.toString()),
                        TextRow(label: 'Số ứng viên chưa đánh giá', value: map['0'].toString()),
                        TextRow(label: 'Số ứng viên không đạt vòng loại CV', value: map['1'].toString()),
                        TextRow(label: 'Số ứng viên đạt vòng loại CV', value: map['2'].toString()),
                        TextRow(label: 'Số ứng viên không đạt vòng phỏng vấn', value: map['3'].toString()),
                        TextRow(label: 'Số ứng viên đạt yêu cầu', value: map['4'].toString()),
                      ],
                    ),
                  ),
                  Center(
                      child: (filterList.isEmpty ) ? 
                      const EmptyList() :
                      ListView.builder(
                        itemCount: filterList.length + 1,
                        itemBuilder: (context, index) {
                          return (index != filterList.length) ? ApplicationCard(model: filterList[index]) : const EndOfList();
                        }
                      ),
                  ),
                  Center(
                    child: (interviewList.isEmpty ) ? 
                    const EmptyList() :
                    ListView.builder(
                      itemCount: interviewList.length + 1,
                      itemBuilder: (context, index) {
                        return (index != interviewList.length) ? ApplicationCard(model: interviewList[index]) : const EndOfList();
                      }
                    ),
                  ),
                  Center(
                    child: (qualifiedList.isEmpty ) ? 
                    const EmptyList() :
                    ListView.builder(
                      itemCount: qualifiedList.length + 1,
                      itemBuilder: (context, index) {
                        return (index != qualifiedList.length) ? ApplicationCard(model: qualifiedList[index]) : const EndOfList();
                      }
                    ),
                  ),
                ],
              ),
            )
        
        )
      ),
    );
  }
}

class EmptyList extends StatelessWidget{
  const EmptyList({super.key});
  @override
  Widget build(BuildContext context) {
    return const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Text('Không có hồ sơ nào trong danh mục này', textAlign: TextAlign.center, style: TextStyle(fontSize: 13)));
  }
}

class EndOfList extends StatelessWidget{
  const EndOfList({super.key});
  @override
  Widget build(BuildContext context) {
    return const Padding(padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4), child: Text('Đã đến cuối danh sách', textAlign: TextAlign.center , style: TextStyle(fontSize: 12)));
  }
}

class TextRow extends StatelessWidget{
  const TextRow({super.key, required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), 
        child: Text('$label: $value', textAlign: TextAlign.start , style: TextStyle(fontSize: 10)));
  }
}