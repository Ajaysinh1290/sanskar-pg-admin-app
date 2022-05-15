import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:sanskar_pg_admin_app/screens/chat/controller/chat_with_user_controller.dart';
import 'notification_service.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/ic_launcher'));
    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? data) async {
      NotificationService.onNotificationClick(data);
    });
  }

  static Future<void> display(RemoteMessage message) async {
    if (message.data['screen'] == 'event') {
      return;
    }
    if (message.data['screen'] == 'group_chat' &&
        Get.currentRoute == '/GroupChat') {
      return;
    }
    if (message.data['screen'] == 'chat_with_user' &&
        Get.currentRoute == '/ChatWithUser') {
      String userId = message.data['user_id'];
      if (Get.find<ChatWithUserController>().userId == userId) {
        return;
      }
    }
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
              'high_importance_channel', 'high_importance_channel',
              importance: Importance.high, priority: Priority.high));
      await _notificationsPlugin.show(id, message.notification!.title,
          message.notification!.body, notificationDetails,
          payload: json.encode(message.data));
    } on Exception catch (e) {
      // TODO
      print(e);
    }
  }
}
