// ignore_for_file: prefer_const_constructors

import 'package:app_tim_viec_lam/view/Search/job_search_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/providers/account_provider.dart';
import '../Search/enterprise_search_view.dart';
import '../widgets/job_card.dart';
import '../widgets/title.dart';
import '../widgets/title_button.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    Provider.of<AccountProvider>(context, listen: false).getFavEnterPriseJob();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController searchCtr = TextEditingController();
    var accountProvider = Provider.of<AccountProvider>(context);

    // final accountProvider = Provider.of<AccountProvider>(context);
    var jobs = accountProvider.favEnterpriseJobs;
    return Scaffold(
        appBar: null,
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
                leading: null,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.blue,
                toolbarHeight: kToolbarHeight + 20,
                pinned: true,
                centerTitle: true,
                floating: true,
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                          autofocus: false,
                          style: TextStyle(fontSize: 12),
                          maxLines: 1,
                          controller: searchCtr,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Tìm kiếm việc làm',
                            hintStyle: TextStyle(
                              fontSize: 12
                            ),
                            prefixIcon: Icon(
                              Icons.search
                            ),
                            suffixIcon: TextButton(
                              child: Text('Tìm', style: TextStyle(color: Colors.red.shade700),),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => JobSearchView(seartchTxt: searchCtr.text,)));
                              },
                            ),
                            focusedBorder:OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            border: OutlineInputBorder(
                              // borderSide: BorderSide(color: Colors.blueGrey.shade900, width: 2.0),
                              borderRadius: BorderRadius.all(Radius.circular(25))
                            ),
                          ),
                          onSubmitted: (data) {

                          },
                          onTapOutside: (value) {
                            // FocusScope.of(context).unfocus();
                            // FocusScope.of(context).requestFocus(FocusNode());
                            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                          },
                          ),
                        ),]
                    ),
                ],),
              ),
          
          ],
          body: SingleChildScrollView(
            child: Column(
              children: [
                CustomTitle(label: 'Tìm kiếm thông tin doanh nghiệp'),
                TitleButton(
                  label: 'Bấm vào đây để tìm kiếm', 
                  icon: Icons.search, 
                  function: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => EnterpriseSearchView()));
                  }
                ),
                Divider(),
                CustomTitle(label: 'Tin doanh nghiệp đang theo dõi: ${jobs.length}'),
                (jobs.isNotEmpty) ?
                ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: jobs.length,
                      itemBuilder: (context, index) {
                        return JobCard(model: jobs[index]);
                    }
                ) :   EmptyList()
              ],
            ),
          ),
        )
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