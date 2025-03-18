
import 'package:app_tim_viec_lam/view/widgets/enterprise_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/providers/account_provider.dart';

class FavEnterpriseView extends StatefulWidget {
  const FavEnterpriseView({super.key});

  @override
  State<FavEnterpriseView> createState() => _FavEnterpriseViewState();
}

class _FavEnterpriseViewState extends State<FavEnterpriseView> {
  @override
  void initState() {
    Provider.of<AccountProvider>(context, listen: false).getFavEnterprises();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(context);
    var enterprises = accountProvider.favEnterprise;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade400,
          title: Text(
            'Doanh nghiệp đang theo dõi',
            style: TextStyle(
              fontSize: 16
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Center(
              child: (enterprises.isEmpty ) ? 
              const EmptyList() :
              ListView.builder(
                itemCount: enterprises.length + 1,
                itemBuilder: (context, index) {
                  return (index != enterprises.length) ? EnterpriseCard(model: enterprises[index]) : const EndOfList();
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
    return const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Text('Không có doanh nghiệp nào', textAlign: TextAlign.center, style: TextStyle(fontSize: 13)));
  }
}

class EndOfList extends StatelessWidget{
  const EndOfList({super.key});
  @override
  Widget build(BuildContext context) {
    return const Padding(padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4), child: Text('Đã đến cuối danh sách', textAlign: TextAlign.center , style: TextStyle(fontSize: 12)));
  }
}