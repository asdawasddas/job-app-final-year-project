
import 'package:flutter/material.dart';
import 'package:job_app_admin/view/Hirer/widgets/logo.dart';
import 'package:provider/provider.dart';

import '../../../viewmodel/hirer_provider.dart';
import '../../widgets/icon_text.dart';

class EnterpriseDetail extends StatefulWidget {
  final String enterpriseId;

  const EnterpriseDetail({super.key, required this.enterpriseId});

  @override
  State<EnterpriseDetail> createState() => _EnterpriseDetailState();
}

class _EnterpriseDetailState extends State<EnterpriseDetail> {

  @override
  void initState() {
    Provider.of<HirerProvider>(context, listen: false).getEnterprise(widget.enterpriseId);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final hirerProvider =  Provider.of<HirerProvider>(context);
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 50
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Logo(model: hirerProvider.enterprise),
                ),
                IconText(label: 'Tên doanh nghiệp:', icon: Icons.business, value: hirerProvider.enterprise.name),
                IconText(label: 'Mã số thuế:', icon: Icons.payment_outlined, value: hirerProvider.enterprise.taxCode),
                IconText(label: 'Email doanh nghiệp:', icon: Icons.email, value: hirerProvider.enterprise.email.isEmpty  ? 'Chưa cập nhật' : hirerProvider.enterprise.email),
                IconText(label: 'Số điện thoại doanh nghiệp:', icon: Icons.phone, value: hirerProvider.enterprise.phoneNumber.isEmpty  ? 'Chưa cập nhật' : hirerProvider.enterprise.phoneNumber),
                IconText(label: 'Lĩnh vực kinh doanh:', icon: Icons.factory, value: hirerProvider.enterprise.industry.isEmpty  ? 'Chưa cập nhật' : hirerProvider.enterprise.industry),
                IconText(label: 'Quy mô nhân sự:', icon: Icons.people, value: hirerProvider.enterprise.employeeAmount.isEmpty  ? 'Chưa cập nhật' : hirerProvider.enterprise.employeeAmount),
                IconText(label: 'Địa chỉ:', icon: Icons.location_on, value: hirerProvider.enterprise.address.isEmpty  ? 'Chưa cập nhật' : hirerProvider.enterprise.address),
                IconText(label: 'Giới thiệu doanh nghiệp:', icon: Icons.info, value: hirerProvider.enterprise.infomation.isEmpty  ? 'Chưa cập nhật' : hirerProvider.enterprise.infomation),
              ]),
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 10,right: 10), child: IconButton(onPressed: (){ Navigator.pop(context); }, icon: Icon(Icons.close_sharp)))
      ]
    );
  }
}