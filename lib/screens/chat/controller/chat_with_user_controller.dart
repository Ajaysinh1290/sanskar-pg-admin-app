import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatWithUserController extends GetxController {
  final TextEditingController chatController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  String? userId;

}