
import 'package:flutter/material.dart';
import 'package:job_app_admin/data/model/enterprise_model.dart';

import '../../widgets/icon_text.dart';

class EnterpriseDetail extends StatelessWidget {
  final EnterpriseModel model;

  const EnterpriseDetail({super.key, required this.model});
  @override
  Widget build(BuildContext context) {
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
                Padding(padding: EdgeInsets.symmetric(vertical: 30), child: Text('Thông tin doanh nghiệp', textAlign: TextAlign.center, style: TextStyle(fontSize: 30),)),
                IconText(label: 'Tên doanh nghiệp:', icon: Icons.business, value: model.name),
                IconText(label: 'Mã số thuế:', icon: Icons.payment_outlined, value: model.taxCode),
                IconText(label: 'Email doanh nghiệp:', icon: Icons.email, value: model.email.isEmpty  ? 'Chưa cập nhật' : model.email),
                IconText(label: 'Số điện thoại doanh nghiệp:', icon: Icons.phone, value: model.phoneNumber.isEmpty  ? 'Chưa cập nhật' : model.phoneNumber),
                IconText(label: 'Lĩnh vực kinh doanh:', icon: Icons.factory, value: model.industry.isEmpty  ? 'Chưa cập nhật' : model.industry),
                IconText(label: 'Quy mô nhân sự:', icon: Icons.people, value: model.employeeAmount.isEmpty  ? 'Chưa cập nhật' : model.employeeAmount),
                IconText(label: 'Địa chỉ:', icon: Icons.location_on, value: model.address.isEmpty  ? 'Chưa cập nhật' : model.address),
                IconText(label: 'Giới thiệu doanh nghiệp:', icon: Icons.info, value: model.infomation.isEmpty  ? 'Chưa cập nhật' : model.infomation),
              ]),
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 10,right: 10), child: IconButton(onPressed: (){ Navigator.pop(context); }, icon: Icon(Icons.close_sharp)))
      ]
    );
  }
}