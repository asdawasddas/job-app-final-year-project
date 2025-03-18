
import 'package:app_tim_viec_lam/view/widgets/job_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/providers/account_provider.dart';

class FavJobView extends StatefulWidget {
  const FavJobView({super.key});

  @override
  State<FavJobView> createState() => _FavJobViewState();
}

class _FavJobViewState extends State<FavJobView> {
  @override
  void initState() {
    Provider.of<AccountProvider>(context, listen: false).getFavJobs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(context);
    // var jobs = accountProvider.favJobs;
    var openJobs = List.from(accountProvider.favJobs.where(
      (model) => !model.isClosed && !model.isExpired));
    var expiredJobs = List.from(accountProvider.favJobs.where(
      (model) => !model.isClosed && model.isExpired));
    var closedJobs = List.from(accountProvider.favJobs.where(
      (model) => model.isClosed));
    return SafeArea(
      child: DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue.shade400,
            title: const Text(
              'Việc làm đang theo dõi',
              style: TextStyle(
                fontSize: 18
              ),
            ),
            bottom: TabBar(
              labelStyle: const TextStyle(
                // fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              labelColor: Colors.grey.shade100,
              unselectedLabelStyle: TextStyle(
                // fontWeight: FontWeight.bold,
                fontSize: 10,
                color: Colors.grey.shade300
              ),
              indicatorColor: Colors.blueGrey.shade100,
              // ignore: prefer_const_literals_to_create_immutables
              tabs: <Widget>[
                const Tab(
                  text: 'Đang mở',
                ),
                const Tab(
                  text: 'Hết hạn',
                ),
                const Tab(
                  text: 'Đã đóng',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Center(
                    child: (openJobs.isEmpty ) ? 
                    const EmptyList() :
                    ListView.builder(
                      itemCount: openJobs.length + 1,
                      itemBuilder: (context, index) {
                        return (index != openJobs.length) ? JobCard(model: openJobs[index]) : const EndOfList();
                      }
                    ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Center(
                    child: (expiredJobs.isEmpty ) ? 
                    const EmptyList() :
                    ListView.builder(
                      itemCount: expiredJobs.length + 1,
                      itemBuilder: (context, index) {
                        return (index != expiredJobs.length) ? JobCard(model: expiredJobs[index]) : const EndOfList();
                      }
                    ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Center(
                    child: (closedJobs.isEmpty ) ? 
                    const EmptyList() :
                    ListView.builder(
                      itemCount: closedJobs.length + 1,
                      itemBuilder: (context, index) {
                        return (index != closedJobs.length) ? JobCard(model: closedJobs[index]) : const EndOfList();
                      }
                    ),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}

class EmptyList extends StatelessWidget{
  const EmptyList({super.key});
  @override
  Widget build(BuildContext context) {
    return const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Text('Không có tin tuyển dụng nào', textAlign: TextAlign.center, style: TextStyle(fontSize: 13)));
  }
}

class EndOfList extends StatelessWidget{
  const EndOfList({super.key});
  @override
  Widget build(BuildContext context) {
    return const Padding(padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4), child: Text('Đã đến cuối danh sách', textAlign: TextAlign.center , style: TextStyle(fontSize: 12)));
  }
}