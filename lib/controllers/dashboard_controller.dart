import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanskar_pg_admin_app/screens/chat/chat_with_user.dart';
import 'package:sanskar_pg_admin_app/screens/chat/group_chat.dart';
import 'package:sanskar_pg_admin_app/screens/event/event_details.dart';
import 'package:sanskar_pg_admin_app/screens/fees/transaction_details.dart';
import 'package:sanskar_pg_admin_app/screens/fees/transactions.dart';
import 'package:sanskar_pg_admin_app/services/local_notification_service.dart';
import 'package:sanskar_pg_admin_app/services/notification_service.dart';

import '../main.dart';

class DashboardController extends GetxController {
  int currentScreenIndex = 0;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final RxBool _showAllHostel = false.obs;

  set showAllHostel(bool value) => _showAllHostel.value = value;

  bool get showAllHostel => _showAllHostel.value;

  void changeScreen(int index) {
    currentScreenIndex = index;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    NotificationService.startService();
  }
}
