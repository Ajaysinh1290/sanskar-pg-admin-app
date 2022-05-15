import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:sanskar_pg_admin_app/screens/chat/chat_with_user.dart';
import 'package:sanskar_pg_admin_app/screens/chat/group_chat.dart';
import 'package:sanskar_pg_admin_app/screens/event/event_details.dart';
import 'package:sanskar_pg_admin_app/screens/fees/transactions.dart';
import 'package:sanskar_pg_admin_app/services/server_key.dart';
import 'package:http/http.dart' as http;

import 'local_notification_service.dart';

class NotificationService {
  static startService() {
    LocalNotificationService.initialize();
    //gives you the message on which user taps and it opened the app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        Future.delayed(const Duration(milliseconds: 100)).then((value) {
          onNotificationClick(json.encode(message.data));
        });      }
    });

    //Foreground work
    FirebaseMessaging.onMessage.listen((message) {
      LocalNotificationService.display(message);
    });

    //When user tap on notification when app is in background but app not terminated

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      onNotificationClick(json.encode(message.data));
    });
  }

  static Future<void> onNotificationClick(String? dataFromNotification) async {
    if (dataFromNotification != null) {
      Map data = json.decode(dataFromNotification);
      String screen = data['screen'];
      if (screen == 'chat_with_user') {
        String userId = data['user_id'];
        Get.to(ChatWithUser(userId: userId));
      } else if (screen == 'group_chat') {
        Get.to(const GroupChat());
      } else if (screen == 'new_event') {
        String eventId = data['event_id'];
        Get.to(EventDetails(eventId: eventId));
      } else if (screen == 'transaction') {
        Get.to(const Transactions());
      }
    }
  }

  static Future<void> sendNotification(String title, String body,
      Map<String, dynamic> externalData, String topic,
      {String? imageUrl}) async {
    const postUrl = 'https://fcm.googleapis.com/fcm/send';

    Map<String, dynamic> notifications = {
      "body": body,
      "title": title,
    };
    notifications.addAll(imageUrl != null ? {'image': imageUrl} : {});
    externalData.addAll({
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "1",
      "sound": 'default',
      "android_channel_id": "high_importance_channel",
    });
    final data = {
      "notification": notifications,
      "priority": "high",
      "data": externalData,
      "to": '/topics/$topic'
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=$FCM_SERVER_KEY'
    };

    final response = await http.post(Uri.parse(postUrl),
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
// on success do
      print("Notification sent successfully");
    } else {
// on failure do
      print("Error" + response.body);
    }
  }
}
