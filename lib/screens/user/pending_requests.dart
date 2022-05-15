import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:lottie/lottie.dart';
import 'package:sanskar_pg_admin_app/controllers/hostel_controller.dart';
import 'package:sanskar_pg_admin_app/models/user/user_model.dart';
import 'package:sanskar_pg_admin_app/utils/constants/constants.dart';
import 'package:sanskar_pg_admin_app/utils/utils.dart';
import 'package:sanskar_pg_admin_app/widgets/cards/my_card.dart';
import 'package:sanskar_pg_admin_app/widgets/image/image_network.dart';
import 'package:shimmer/shimmer.dart';

class PendingRequests extends StatelessWidget {
  const PendingRequests({Key? key}) : super(key: key);

  acceptRequest(String userId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .set({'isAccountApproved': true}, SetOptions(merge: true));
  }

  rejectRequest(String userId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .set({'isAccountRejected': true}, SetOptions(merge: true));
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
          'Pending Requests',
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
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('hostelId',
                  isEqualTo: Get.find<HostelController>().hostel!.hostelId)
              .where('isAccountApproved', isEqualTo: false)
              .where('isAccountRejected', isEqualTo: false)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            List<UserModel>? users;
            if (snapshot.hasData) {
              List data = snapshot.data.docs;
              users = [];
              for (var element in data) {
                users.add(UserModel.fromJson(element.data()));
              }
            }
            return users == null
                ? ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[100]!,
                        highlightColor: Colors.grey[200]!,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15.h),
                          width: double.infinity,
                          height: 100.h,
                          color: Theme.of(context).primaryColor,
                        ),
                      );
                    })
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
                              'No Pending Requests Found..!',
                              style: Theme.of(context).textTheme.headline3,
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 15.h),
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              const SizedBox(
                                height: 5.10,
                              ),
                              ListTile(
                                leading: Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      shape: BoxShape.circle),
                                  child: ClipOval(
                                    child: ImageNetwork(
                                      imageUrl: users![index].userProfilePic!,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  users[index].userName,
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                subtitle: Text(
                                  users[index].email,
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: InkWell(
                                      onTap: () =>
                                          rejectRequest(users![index].userId),
                                      child: Container(
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 5),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.h, horizontal: 10.h),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        child: Text('Reject',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5),
                                      ),
                                    )),
                                    Expanded(
                                        child: InkWell(
                                      onTap: () =>
                                          acceptRequest(users![index].userId),
                                      child: Container(
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 5),
                                        decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.h, horizontal: 10.h),
                                        child: Text(
                                          'Accept',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5!
                                              .copyWith(color: Colors.white),
                                        ),
                                      ),
                                    )),
                                  ],
                                ),
                              )
                            ],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 5.h),
                            width: double.infinity,
                            height: 2,
                            color: Theme.of(context).cardColor,
                          );
                        },
                      );
          }),
    );
  }
}
