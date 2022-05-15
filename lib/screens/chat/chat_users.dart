import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:lottie/lottie.dart';
import 'package:sanskar_pg_admin_app/animation/fade_and_translate_animation.dart';
import 'package:sanskar_pg_admin_app/controllers/hostel_controller.dart';
import 'package:sanskar_pg_admin_app/models/chat/chat_model.dart';
import 'package:sanskar_pg_admin_app/models/user/user_model.dart';
import 'package:sanskar_pg_admin_app/screens/chat/chat_with_user.dart';
import 'package:sanskar_pg_admin_app/utils/utils.dart';
import 'package:sanskar_pg_admin_app/widgets/image/image_network.dart';

class ChatUsers extends StatelessWidget {
  const ChatUsers({Key? key}) : super(key: key);

  String _getLastSeenTime(ChatModel chatModel) {
    DateTime todayDate = Constants.onlyDateFormat
        .parse(Constants.onlyDateFormat.format(DateTime.now()));
    DateTime chatDate = Constants.onlyDateFormat
        .parse(Constants.onlyDateFormat.format(chatModel.messageSentOn));
    if (todayDate != chatDate) {
      return Constants.onlyTimeFormat.format(chatDate);
    }
    return Constants.onlyTimeFormat.format(chatModel.messageSentOn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_outlined,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Users',
            style: Theme.of(context).textTheme.headline3,
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.more_vert,
                  size: 30.sp,
                  color: Colors.black,
                ))
          ],
        ),
        body: StreamBuilder<Object>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('hostelId',
                    isEqualTo: Get.find<HostelController>().hostel!.hostelId)
                .where('isAccountApproved', isEqualTo: true)
                .where('isAccountRejected', isEqualTo: false)
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              List<UserModel>? users;
              if (snapshot.hasData) {
                users = [];
                for (var element in snapshot.data.docs) {
                  users.add(UserModel.fromJson(element.data()));
                }
                debugPrint('users length : ${users.length}');
              }
              return users == null
                  ? Container(
                      width: double.infinity,
                      height: 50.h,
                      color: Theme.of(context).cardColor,
                    )
                  : users.isEmpty
                      ? SizedBox(
                          width: double.infinity,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 130.h,
                              ),
                              LottieBuilder.asset(
                                ImageStorage.lottieAnimations.notFound,
                                height: 350.h,
                                repeat: false,
                              ),
                              Text(
                                'No Users Found..!',
                                style: Theme.of(context).textTheme.headline3,
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 15.h),
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            return FadeAnimationTranslateY(
                              delay: 1.0 + (index * 0.2),
                              child: InkWell(
                                onTap: () {
                                  Get.to(ChatWithUser(
                                    userId: users![index].userId,
                                  ));
                                },
                                child: StreamBuilder<Object>(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(users![index].userId)
                                        .collection('chats')
                                        // .orderBy('chatId', descending: true)
                                        // .limit(1)
                                        .snapshots(),
                                    builder: (context, AsyncSnapshot snapshot) {
                                      ChatModel? chatModel;
                                      int unReadChats = 0;
                                      bool? isReadByUser;
                                      if (snapshot.hasData) {
                                        for (var element
                                            in snapshot.data.docs) {
                                          chatModel = ChatModel.fromJson(
                                              element.data());
                                        }
                                        if (chatModel != null) {
                                          if (chatModel.sentBy ==
                                                  users![index].userId &&
                                              (chatModel.readBy == null ||
                                                  !chatModel.readBy!
                                                      .contains('admin'))) {
                                            unReadChats++;
                                          } else {
                                            isReadByUser =
                                                chatModel.readBy != null &&
                                                    chatModel.readBy!.contains(
                                                        users[index].userId);
                                          }
                                        }
                                      }
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            Hero(
                                              tag: users![index].userId,
                                              child: ClipOval(
                                                child: ImageNetwork(
                                                  imageUrl: users[index]
                                                      .userProfilePic!,
                                                  width: 50,
                                                  height: 50,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15.w,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        users[index].userName,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline4,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      if (chatModel != null)
                                                        Text(
                                                          _getLastSeenTime(
                                                              chatModel),
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .subtitle2!
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 2.h,
                                                  ),
                                                  if (chatModel != null)
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 5.h),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Row(
                                                              children: [
                                                                if(chatModel.sentBy=='admin')
                                                                isReadByUser !=
                                                                            null &&
                                                                        isReadByUser
                                                                    ? Icon(
                                                                        Icons
                                                                            .done_all,
                                                                        color: Colors
                                                                            .blue
                                                                            .shade300,
                                                                        size: 18
                                                                            .sp,
                                                                      )
                                                                    : Icon(
                                                                        Icons
                                                                            .done,
                                                                        color: ColorPalette
                                                                            .grey,
                                                                        size: 18
                                                                            .sp,
                                                                      ),
                                                                SizedBox(width: 10.w,),
                                                                chatModel
                                                                        .isMedia
                                                                    ? Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.image,
                                                                            size:
                                                                                22.sp,
                                                                            color:
                                                                                ColorPalette.grey,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                10.w,
                                                                          ),
                                                                          Text(
                                                                            'Photo',
                                                                            style:
                                                                                Theme.of(context).textTheme.subtitle1,
                                                                            maxLines:
                                                                                1,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                        ],
                                                                      )
                                                                    : Text(
                                                                        chatModel
                                                                            .message,
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .subtitle1,
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                              ],
                                                            ),
                                                          ),
                                                          if (unReadChats != 0)
                                                            Container(
                                                              width: unReadChats >
                                                                      99
                                                                  ? 35.w
                                                                  : unReadChats >
                                                                          9
                                                                      ? 26.w
                                                                      : 22.w,
                                                              height: 22.w,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration:
                                                                  BoxDecoration(
                                                                      // shape: BoxShape
                                                                      //     .circle,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              100),
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor),
                                                              child: Text(
                                                                unReadChats > 99
                                                                    ? '99+'
                                                                    : unReadChats
                                                                        .toString(),
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .subtitle2!
                                                                    .copyWith(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            14.sp),
                                                              ),
                                                            )
                                                        ],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                            );
                          },
                        );
            }));
  }
}
