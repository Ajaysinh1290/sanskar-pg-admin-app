import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:lottie/lottie.dart';
import 'package:sanskar_pg_admin_app/animation/fade_and_translate_animation.dart';
import 'package:sanskar_pg_admin_app/controllers/hostel_controller.dart';
import 'package:sanskar_pg_admin_app/models/room/room.dart';
import 'package:sanskar_pg_admin_app/screens/room/room_details.dart';
import 'package:sanskar_pg_admin_app/utils/constants/constants.dart';
import 'package:sanskar_pg_admin_app/utils/images/image_storage.dart';
import 'package:shimmer/shimmer.dart';

class RoomsScreen extends StatelessWidget {
  const RoomsScreen({Key? key}) : super(key: key);

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
            'Rooms',
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
                .collection('hostels')
                .doc(Get.find<HostelController>().hostel!.hostelId)
                .collection('rooms')
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              List<Room>? rooms;
              if (snapshot.hasData) {
                rooms = [];
                for (var element in snapshot.data.docs) {
                  rooms.add(Room.fromJson(element.data()));
                }
                rooms.sort((a, b) => '${a.wing}-${a.floor}-${a.roomNumber}'
                    .compareTo('${b.wing}-${b.floor}-${b.roomNumber}'));
              }
              return rooms == null
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey[100]!,
                      highlightColor: Colors.grey[200]!,
                      child: GridView.builder(
                        itemCount: 10,
                        padding: Constants.scaffoldPaddingWithoutSafeArea,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                            mainAxisSpacing: 20.w,
                            crossAxisSpacing: 20.w),
                        itemBuilder: (context, index) => Container(
                          color: Theme.of(context).cardColor,
                        ),
                      ),
                    )
                  : rooms.isEmpty
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
                                'No Rooms Found..!',
                                style: Theme.of(context).textTheme.headline3,
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        )
                      : GridView.builder(
                          itemCount: rooms.length,
                          padding: Constants.scaffoldPaddingWithoutSafeArea,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1,
                                  mainAxisSpacing: 20.w,
                                  crossAxisSpacing: 20.w),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Get.to(
                                    RoomDetails(roomId: rooms![index].roomId));
                              },
                              child: FadeAnimationTranslateY(
                                delay: 1.0 + (index * 0.2),
                                child: Container(
                                  padding: EdgeInsets.all(10.0.w),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Theme.of(context).cardColor,
                                          width: 2)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Hero(
                                        tag: rooms![index].roomId,
                                        child: Container(
                                            alignment: Alignment.center,
                                            width: 50.w,
                                            height: 50.w,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: Theme.of(context)
                                                    .primaryColor),
                                            child: Text(
                                              rooms[index].wing.substring(
                                                  0,
                                                  rooms[index].wing.length >= 2
                                                      ? 2
                                                      : 1),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4!
                                                  .copyWith(
                                                      color: Colors.white),
                                            )),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Text(
                                        '${rooms[index].wing}-${rooms[index].floor}-${rooms[index].roomNumber}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Text(
                                        '${rooms[index].roomType} | ${(rooms[index].users?.length) ?? 0}/${rooms[index].capacity}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
            }));
  }
}
