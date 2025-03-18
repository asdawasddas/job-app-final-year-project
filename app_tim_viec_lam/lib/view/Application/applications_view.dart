
import 'package:app_tim_viec_lam/view/widgets/application_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/providers/account_provider.dart';

class ApplicationsView extends StatefulWidget {
  @override
  State<ApplicationsView> createState() => _ApplicationsViewState();
}

class _ApplicationsViewState extends State<ApplicationsView> {
  @override
  void initState() {
    Provider.of<AccountProvider>(context, listen: false).getAppliedJobs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(context);
    var applications = accountProvider.appliedJobs;
    var halfMonthApplications = List.from(accountProvider.appliedJobs.where(
      (model) => model.daysFromAppliedDate <= 15));
    var monthApplications = List.from(accountProvider.appliedJobs.where(
      (model) => model.daysFromAppliedDate <= 30));
    return SafeArea(
      child: DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue.shade400,
            title: Text(
              'Việc làm đã ứng tuyển',
              style: TextStyle(
                fontSize: 18
              ),
            ),
            bottom: TabBar(
              labelStyle: TextStyle(
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
              tabs: <Widget>[
                Tab(
                  text: 'Tất cả',
                ),
                Tab(
                  text: '15 ngày',
                ),
                Tab(
                  text: '30 ngày',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                child: Center(
                    child: (applications.isEmpty ) ? 
                    const EmptyList() :
                    ListView.builder(
                      itemCount: applications.length + 1,
                      itemBuilder: (context, index) {
                        return (index != applications.length) ? ApplicationCard(model: applications[index]) : const EndOfList();
                      }
                    ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Center(
                    child: (halfMonthApplications.isEmpty ) ? 
                    const EmptyList() :
                    ListView.builder(
                      itemCount: halfMonthApplications.length + 1,
                      itemBuilder: (context, index) {
                        return (index != halfMonthApplications.length) ? ApplicationCard(model: halfMonthApplications[index]) : const EndOfList();
                      }
                    ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Center(
                    child: (monthApplications.isEmpty ) ? 
                    const EmptyList() :
                    ListView.builder(
                      itemCount: monthApplications.length + 1,
                      itemBuilder: (context, index) {
                        return (index != monthApplications.length) ? ApplicationCard(model: monthApplications[index]) : const EndOfList();
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
    return const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Text('Bạn chưa nộp đơn ứng tuyển nào', textAlign: TextAlign.center, style: TextStyle(fontSize: 13)));
  }
}

class EndOfList extends StatelessWidget{
  const EndOfList({super.key});
  @override
  Widget build(BuildContext context) {
    return const Padding(padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4), child: Text('Đã đến cuối danh sách', textAlign: TextAlign.center , style: TextStyle(fontSize: 12)));
  }
}