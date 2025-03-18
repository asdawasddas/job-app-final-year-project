
// ignore_for_file: prefer_const_constructors

import 'package:app_tuyen_dung/view/widgets/job_card.dart';
import 'package:app_tuyen_dung/viewmodel/provider/jobs_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/base/status_model.dart';
import '../widgets/function/alert_dialog.dart';


class JobsView extends StatefulWidget {
  const JobsView({super.key});

  @override
  State<JobsView> createState() => _JobsViewState();
}

class _JobsViewState extends State<JobsView> {
  //0: mới , 1: cũ
  int sort = 0;

  @override
  initState() {
    Future<Status> status = Provider.of<JobsProvider>(context, listen: false).getJobs(sort);
    status.then((value) {
      if (!value.isSuccess) {
        showAlertDialog(AlertType.error, 'Đã có lỗi xảy ra', context);
      }
    })
    .onError((error, stackTrace) {
      showAlertDialog(AlertType.error, 'Đã có lỗi xảy ra', context);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var jobsProvider = Provider.of<JobsProvider>(context);
    var isRunningList = List.from(jobsProvider.modelList.where((model) => !model.isClosed && !model.isExpired));
    var isExpiredList = List.from(jobsProvider.modelList.where((model) => !model.isClosed && model.isExpired));
    var isClosedList = List.from(jobsProvider.modelList.where((model) => model.isClosed));

    return Scaffold(
      body: DefaultTabController(
          initialIndex: 0,
          length: 3,
          child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                leading: null,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.blueGrey.shade900,
                toolbarHeight: 75 + kToolbarHeight,
                // toolbarHeight: kToolbarHeight + 20,
                pinned: false,
                centerTitle: true,
                floating: true,
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TabBar(
                      tabAlignment: TabAlignment.start,
                      dragStartBehavior: DragStartBehavior.start,
                      dividerHeight: 0,
                      padding: const EdgeInsets.all(5),
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
                      tabs: const [
                        Tab(
                            icon: Icon(Icons.search_outlined),
                            text: ' Tin đang chạy',
                          ),
                          Tab(
                            icon: Icon(Icons.calendar_month),
                            text: 'Tin hết hạn',
                          ),
                          Tab(
                            icon: Icon(Icons.history),
                            text: 'Tin đã đóng',
                          ),
                      ]
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 19),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Sắp xếp:', style: TextStyle(fontSize: 13, color: Colors.white70),),
                          GestureDetector(
                            child: Text((sort == 0) ? 'Mới nhất' : 'Cũ nhất', style: TextStyle(fontSize: 14, color: Colors.white)),
                            onTap: () {
                              sort = (sort == 0) ? 1 : 0;
                              jobsProvider.getJobs(sort);
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
                Center(
                    child: (isRunningList.isEmpty ) ? 
                    const EmptyList() :
                    ListView.builder(
                      itemCount: isRunningList.length + 1,
                      itemBuilder: (context, index) {
                        return (index != isRunningList.length) ? JobCard(model: isRunningList[index]) : const EndOfList();
                      }
                    ),
                ),
                Center(
                  child: (isExpiredList.isEmpty ) ? 
                  const EmptyList() :
                  ListView.builder(
                    itemCount: isExpiredList.length + 1,
                    itemBuilder: (context, index) {
                      return (index != isExpiredList.length) ? JobCard(model: isExpiredList[index]) : const EndOfList();
                    }
                  ),
                ),
                Center(
                  child: (isClosedList.isEmpty ) ? 
                  const EmptyList() :
                  ListView.builder(
                    itemCount: isClosedList.length + 1,
                    itemBuilder: (context, index) {
                      return (index != isClosedList.length) ? JobCard(model: isClosedList[index]) : const EndOfList();
                    }
                  ),
                ),
              ],
            ),
          )
        ),
    );
  }
}

class EmptyList extends StatelessWidget{
  const EmptyList({super.key});
  @override
  Widget build(BuildContext context) {
    return const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Text('Không có tin tuyển dụng nào trong danh mục này', textAlign: TextAlign.center, style: TextStyle(fontSize: 13)));
  }
}

class EndOfList extends StatelessWidget{
  const EndOfList({super.key});
  @override
  Widget build(BuildContext context) {
    return const Padding(padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4), child: Text('Đã đến cuối danh sách', textAlign: TextAlign.center , style: TextStyle(fontSize: 12)));
  }
}