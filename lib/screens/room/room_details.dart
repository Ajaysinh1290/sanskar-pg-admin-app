import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:sanskar_pg_admin_app/animation/fade_and_translate_animation.dart';
import 'package:sanskar_pg_admin_app/controllers/hostel_controller.dart';
import 'package:sanskar_pg_admin_app/models/room/room.dart';
import 'package:sanskar_pg_admin_app/models/user/user_model.dart';
import 'package:sanskar_pg_admin_app/screens/user/user_details.dart';
import 'package:sanskar_pg_admin_app/utils/constants/constants.dart';
import 'package:sanskar_pg_admin_app/widgets/dialog/show_error_dialog.dart';
import 'package:sanskar_pg_admin_app/widgets/dialog/show_successful_dialog.dart';
import 'package:sanskar_pg_admin_app/widgets/image/image_network.dart';
import 'package:shimmer/shimmer.dart';

import 'add_room/add_room.dart';

class RoomDetails extends StatelessWidget {
  final String roomId;

  const RoomDetails({Key? key, required this.roomId}) : super(key: key);

  showOptionsDialog(Room? room) {
    Get.dialog(
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 50, right: 20),
            child: Material(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 200.w,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                          Get.to(AddRoom(
                            room: room,
                          ));
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'Edit',
                            style: Theme.of(Get.context!).textTheme.headline5,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          Get.back();
                          if (room!.users == null || room.users!.isEmpty) {
                            Get.back();
                            await FirebaseFirestore.instance
                                .collection('hostels')
                                .doc(Get.find<HostelController>()
                                    .hostel!
                                    .hostelId)
                                .collection('rooms')
                                .doc(roomId)
                                .delete();

                            showSuccessfulDialog('Room Deleted',
                                'Room has been successfully deleted.');
                          } else {
                            showErrorDialog("Error",
                                'Can\'t delete room because users in room must be zero.');
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(15.0),
                          child: Text('Delete',
                              style:
                                  Theme.of(Get.context!).textTheme.headline5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        barrierColor: Colors.black12);
  }

  @override
  Widget build(BuildContext context) {
    Room? room;
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
            'Room Details',
            style: Theme.of(context).textTheme.headline3,
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  if (room != null) {
                    showOptionsDialog(room);
                  }
                },
                icon: Icon(
                  Icons.more_vert,
                  size: 30.sp,
                  color: Colors.black,
                ))
          ],
        ),
        body: StreamBuilder<Object>(
            stream: FirebaseFirestore.instance
                .collection('hostels')
                .doc(Get.find<HostelController>().hostel!.hostelId)
                .collection('rooms')
                .doc(roomId)
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData && snapshot.data.data() != null) {
                room = Room.fromJson(snapshot.data.data());
              }
              return room == null
                  ? const SizedBox()
                  : SingleChildScrollView(
                      child: Padding(
                        padding: Constants.scaffoldPaddingWithoutSafeArea,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Hero(
                                tag: room!.roomId,
                                child: Container(
                                    alignment: Alignment.center,
                                    width: 100.w,
                                    height: 100.w,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Theme.of(context).primaryColor),
                                    child: Text(
                                      room!.wing.substring(
                                          0, room!.wing.length >= 2 ? 2 : 1),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1!
                                          .copyWith(color: Colors.white),
                                    )),
                              ),
                            ),
                            SizedBox(
                              height: 15.w,
                            ),
                            Center(
                              child: FadeAnimationTranslateY(
                                delay: 1.2,
                                child: Text(
                                  '${room!.wing}-${room!.floor}-${room!.roomNumber}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3!
                                      .copyWith(letterSpacing: 2),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 50.h,
                            ),
                            FadeAnimationTranslateY(
                              delay: 4.0,
                              child: Text(
                                'Room Information',
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            FadeAnimationTranslateY(
                              delay: 4.2,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Wing',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4!
                                        .copyWith(
                                            color:
                                                Theme.of(context).dividerColor),
                                  ),
                                  Text(
                                    room!.wing,
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 25.h,
                            ),
                            FadeAnimationTranslateY(
                              delay: 4.4,
                              child: Container(
                                width: double.infinity,
                                height: 2,
                                color: Theme.of(context).cardColor,
                              ),
                            ),
                            SizedBox(
                              height: 25.h,
                            ),
                            FadeAnimationTranslateY(
                              delay: 4.6,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Floor',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4!
                                        .copyWith(
                                            color:
                                                Theme.of(context).dividerColor),
                                  ),
                                  Text(
                                    room!.floor.toString(),
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 25.h,
                            ),
                            FadeAnimationTranslateY(
                              delay: 4.8,
                              child: Container(
                                width: double.infinity,
                                height: 2,
                                color: Theme.of(context).cardColor,
                              ),
                            ),
                            SizedBox(
                              height: 25.h,
                            ),
                            FadeAnimationTranslateY(
                              delay: 5.0,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Room',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4!
                                        .copyWith(
                                            color:
                                                Theme.of(context).dividerColor),
                                  ),
                                  Text(
                                    room!.roomNumber.toString(),
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 25.h,
                            ),
                            FadeAnimationTranslateY(
                              delay: 4.4,
                              child: Container(
                                width: double.infinity,
                                height: 2,
                                color: Theme.of(context).cardColor,
                              ),
                            ),
                            SizedBox(
                              height: 25.h,
                            ),
                            FadeAnimationTranslateY(
                              delay: 5.0,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Capacity',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4!
                                        .copyWith(
                                            color:
                                                Theme.of(context).dividerColor),
                                  ),
                                  Text(
                                    room!.capacity.toString(),
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 25.h,
                            ),
                            FadeAnimationTranslateY(
                              delay: 4.4,
                              child: Container(
                                width: double.infinity,
                                height: 2,
                                color: Theme.of(context).cardColor,
                              ),
                            ),
                            SizedBox(
                              height: 25.h,
                            ),
                            FadeAnimationTranslateY(
                              delay: 5.0,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Room Type',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4!
                                        .copyWith(
                                            color:
                                                Theme.of(context).dividerColor),
                                  ),
                                  Text(
                                    room!.roomType,
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 25.h,
                            ),
                            FadeAnimationTranslateY(
                              delay: 4.4,
                              child: Container(
                                width: double.infinity,
                                height: 2,
                                color: Theme.of(context).cardColor,
                              ),
                            ),
                            SizedBox(
                              height: 25.h,
                            ),
                            FadeAnimationTranslateY(
                              delay: 5.0,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Available',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4!
                                        .copyWith(
                                            color:
                                                Theme.of(context).dividerColor),
                                  ),
                                  Text(
                                    room!.isActive ?? true ? 'Yes' : 'No',
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 50.h,
                            ),
                            FadeAnimationTranslateY(
                              delay: 4.0,
                              child: Text(
                                'Users',
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            room!.users == null ||
                                    room!.users != null && room!.users!.isEmpty
                                ? FadeAnimationTranslateY(
                                    delay: 7.0,
                                    child: Center(
                                      child: Text(
                                        "No Users Found",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                    ),
                                  )
                                : StreamBuilder<Object>(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .where('userId', whereIn: room!.users)
                                        .snapshots(),
                                    builder: (context, AsyncSnapshot snapshot) {
                                      List<UserModel>? users;
                                      if (snapshot.hasData) {
                                        users = [];
                                        for (var element
                                            in snapshot.data.docs) {
                                          users.add(UserModel.fromJson(
                                              element.data()));
                                        }
                                      }
                                      return ListView.builder(
                                        itemCount: (users?.length) ?? 0,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          UserModel? user = users == null
                                              ? null
                                              : users[index];
                                          return FadeAnimationTranslateY(
                                            delay: 4.2 + (index * 0.2),
                                            child: user == null
                                                ? Shimmer.fromColors(
                                                    baseColor:
                                                        Colors.grey.shade300,
                                                    highlightColor:
                                                        Colors.white,
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: 50.w,
                                                          height: 50.w,
                                                          decoration: BoxDecoration(
                                                              color: Theme.of(
                                                                      context)
                                                                  .cardColor,
                                                              shape: BoxShape
                                                                  .circle),
                                                        ),
                                                        SizedBox(
                                                          width: 15.w,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              width: 150.w,
                                                              height: 15.w,
                                                              color: Theme.of(
                                                                      context)
                                                                  .cardColor,
                                                            ),
                                                            SizedBox(
                                                              height: 15.h,
                                                            ),
                                                            Container(
                                                              width: 250.w,
                                                              height: 15.w,
                                                              color: Theme.of(
                                                                      context)
                                                                  .cardColor,
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                : ListTile(
                                                    onTap: () {
                                                      String userId =
                                                          user.userId;
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  UserDetails(
                                                                      userId:
                                                                          userId)));
                                                    },
                                                    leading: ClipOval(
                                                      child: ImageNetwork(
                                                        imageUrl: user
                                                            .userProfilePic!,
                                                        width: 50.w,
                                                        height: 50.w,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    title: Text(
                                                      user.userName,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline4,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    subtitle: Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 5.h),
                                                      child: Text(
                                                        user.email,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .subtitle1,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                          );
                                        },
                                      );
                                    })
                          ],
                        ),
                      ),
                    );
            }));
  }
}
