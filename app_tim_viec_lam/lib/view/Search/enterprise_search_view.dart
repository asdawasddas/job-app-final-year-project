
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/providers/enterprise_provider.dart';
import '../widgets/enterprise_card.dart';

class EnterpriseSearchView extends StatefulWidget {
  const EnterpriseSearchView({super.key});

  @override
  State<EnterpriseSearchView> createState() => _EnterpriseSearchViewState();
}

class _EnterpriseSearchViewState extends State<EnterpriseSearchView> {
    TextEditingController searchCtr = TextEditingController();
    @override
    initState(){
      Provider.of<EnterpriseProvider>(context, listen: false).search('');
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    EnterpriseProvider enterpriseProvider = Provider.of<EnterpriseProvider>(context);
    var searchList = enterpriseProvider.searchList;
    return Scaffold(
      appBar: null,
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                leading: null,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.blueGrey.shade900,
                toolbarHeight: kToolbarHeight + 20,
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
                          child: TextField(
                          style: TextStyle(fontSize: 12),
                          maxLines: null,
                          controller: searchCtr,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Điền tên hoặc mã số thuế',
                            hintStyle: TextStyle(
                              fontSize: 12
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                enterpriseProvider.search(searchCtr.text);
                                FocusScope.of(context).unfocus();
                              },
                            ),
                            focusedBorder:OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            border: OutlineInputBorder(
                              // borderSide: BorderSide(color: Colors.blueGrey.shade900, width: 2.0),
                              borderRadius: BorderRadius.all(Radius.circular(25))
                            ),
                          ),
                          onSubmitted: (data) {
                            enterpriseProvider.search(searchCtr.text);
                          },
                          onTapOutside: (value) {
                            FocusScope.of(context).unfocus();
                          },
                                                ),
                        ),]
                    ),
                ],),
              ),
            ],
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Center(
              child: (searchList.isEmpty ) ? 
              const EmptyList() :
              ListView.builder(
                itemCount: searchList.length + 1,
                itemBuilder: (context, index) {
                  return (index != searchList.length) ? EnterpriseCard(model: searchList[index]) : const EndOfList();
                }
              ),
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
    return const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Text('Không tìm thấy kết quả', textAlign: TextAlign.center, style: TextStyle(fontSize: 13)));
  }
}

class EndOfList extends StatelessWidget{
  const EndOfList({super.key});
  @override
  Widget build(BuildContext context) {
    return const Padding(padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4), child: Text('Đã đến cuối danh sách', textAlign: TextAlign.center , style: TextStyle(fontSize: 12)));
  }
}