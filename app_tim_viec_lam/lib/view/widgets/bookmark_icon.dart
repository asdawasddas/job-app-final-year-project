import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/base/status_model.dart';
import '../../viewmodel/providers/account_provider.dart';
import 'function/alert_dialog.dart';

class BookMarkIcon extends StatelessWidget {
  final String jobId;

  const BookMarkIcon({super.key, required this.jobId});

  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(context);
    return GestureDetector(
      onTap: () {
        if (accountProvider.applicantId == '') {
          showAlertDialog(AlertType.alert, 'Đăng nhập để theo dõi doanh nghiệp này', context);
        } else {
          Future<Status> status = accountProvider.toggleAddJob(jobId);
          status.then((value) {
          if (value.isSuccess) {
            showAlertDialog(AlertType.success, 'Cập nhật thành công', context);
          } else {
            showAlertDialog(AlertType.error, (value.failMsg != '') ? value.failMsg : 'Đã có lỗi xảy ra', context);
          }});
        }
      },
      child: Icon(
        accountProvider.isFavJob(jobId) ? Icons.bookmark_outlined : Icons.bookmark_border_outlined,
        color: Colors.blue.shade400,
        size: 40,
      ));
  }
}