
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/providers/account_provider.dart';
import '../Application/applications_view.dart';
import '../Enterprise/fav_enterprise_view.dart';
import '../Job/fav_job_view.dart';

class UserListView extends StatefulWidget {
  const UserListView({super.key});

  @override
  State<UserListView> createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  @override
  void initState() {
    Provider.of<AccountProvider>(context, listen: false).getFavEnterPriseJob();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 4;
    final double itemWidth = size.width / 2;
    final accountProvider = Provider.of<AccountProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade400,
          title: Text(
            'Danh sách doanh nghiệp, tin tuyển dụng',
            style: TextStyle(
              fontSize: 16
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: GridView.count(
                      childAspectRatio: (itemWidth / itemHeight),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      children: [
                        CustomBox(
                          title: 'Việc làm đang theo dõi',
                          value: accountProvider.model.favJobs.length.toString(),
                          function: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => FavJobView()));
                          },
                        ),
                        CustomBox(
                          title: 'Doanh nghiệp đang theo dõi', 
                          value: accountProvider.model.favEnterprise.length.toString(),
                          function: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => FavEnterpriseView()));
                          },),
                        CustomBox(
                          title: 'Việc làm đã ứng tuyển', 
                          value: accountProvider.model.appliedJobs.length.toString(),
                          function: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ApplicationsView()));
                          },
                        ),
                      ]
                    ),
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

class CustomBox extends StatelessWidget {
  const CustomBox({super.key, required this.title, required this.function, required this.value,});
  final String title;
  final String value;
  final VoidCallback? function;

  @override
  Widget build(BuildContext context){
    return 
      GestureDetector(
        onTap: function,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Container(
            padding: EdgeInsets.all(8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade100,
            borderRadius: const BorderRadius.all(
              Radius.circular(12.0),),
            border: Border.all(
              color: const Color.fromARGB(255, 106, 154, 236),
              width: 1,),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(100, 0, 0, 0),
                blurRadius: 5,
              ),
            ],),
            constraints: const BoxConstraints(
              maxHeight: 20,
            ),
            height: 10,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: TextStyle(fontSize: 10),),
                  Text(value, style: TextStyle(fontSize: 10),),
                ],
              ),
            ),
          ),
        ),
      );
  }
}