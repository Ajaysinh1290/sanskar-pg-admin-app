import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:lottie/lottie.dart';
import 'package:sanskar_pg_admin_app/animation/fade_and_translate_animation.dart';
import 'package:sanskar_pg_admin_app/controllers/hostel_controller.dart';
import 'package:sanskar_pg_admin_app/models/user/user_model.dart';
import 'package:sanskar_pg_admin_app/screens/user/user_details.dart';
import 'package:sanskar_pg_admin_app/utils/constants/constants.dart';
import 'package:sanskar_pg_admin_app/utils/images/image_storage.dart';
import 'package:sanskar_pg_admin_app/widgets/image/image_network.dart';
import 'package:sanskar_pg_admin_app/widgets/text-field/text_field.dart';
import 'package:shimmer/shimmer.dart';

class UsersScreen extends StatelessWidget {
  final ValueNotifier<String> searchText = ValueNotifier<String>('');

  UsersScreen({Key? key}) : super(key: key);

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
              }
              return users == null
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.white,
                      child: ListView.builder(
                          itemCount: 7,
                          padding: Constants.scaffoldPaddingWithoutSafeArea,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 20.h),
                              child: Row(
                                children: [
                                  Container(
                                    width: 50.w,
                                    height: 50.w,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        shape: BoxShape.circle),
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 150.w,
                                        height: 15.w,
                                        color: Theme.of(context).cardColor,
                                      ),
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                      Container(
                                        width: 250.w,
                                        height: 15.w,
                                        color: Theme.of(context).cardColor,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          }),
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
                      : Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20.w,
                                  right: 20.w,
                                  bottom: 15.h,
                                  top: 5.h),
                              child: AnimatedUnderlineTextField(
                                hintText: 'Search',
                                prefixIconData: Icons.search,
                                onChanged: (value) => searchText.value = value,
                              ),
                            ),
                            ValueListenableBuilder<String>(
                                valueListenable: searchText,
                                builder: (context, value, _) {
                                  List sortedUsers = users!;
                                  if (value.trim().isNotEmpty) {
                                    sortedUsers = users
                                        .where((element) =>
                                    element.userName.toLowerCase().contains(
                                        value.trim().toLowerCase()) ||
                                        element.email.toLowerCase().contains(
                                            value.trim().toLowerCase()) ||
                                        element.mobileNumber!
                                            .toLowerCase()
                                            .contains(
                                            value.trim().toLowerCase()))
                                        .toList();
                                  }
                                  return ListView.builder(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.h, horizontal: 15.h),
                                    itemCount: sortedUsers.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      UserModel user = sortedUsers[index];
                                      return FadeAnimationTranslateY(
                                        delay: 1.0 + (index * 0.2),
                                        child: ListTile(
                                          onTap: () {
                                            Get.to(UserDetails(
                                              userId: user.userId,
                                            ));
                                          },
                                          leading: Hero(
                                            tag: user.userId,
                                            child: ClipOval(
                                              child: ImageNetwork(
                                                imageUrl: user
                                                    .userProfilePic!,
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            user.userName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          subtitle: Padding(
                                            padding: EdgeInsets.only(top: 5.h),
                                            child: Text(
                                              user.email,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          trailing: GestureDetector(
                                            onTap: () async {
                                              user.isAccountBlocked =
                                                  !(user
                                                          .isAccountBlocked ??
                                                      false);
                                              await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(user.userId)
                                                  .update(
                                                  user.toJson());
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: user
                                                              .isAccountBlocked ??
                                                          false
                                                      ? Colors.white
                                                      : Theme.of(context)
                                                          .primaryColor,
                                                  border: Border.all(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.r)),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5.h,
                                                  horizontal: 10.w),
                                              child: Text(
                                                user.isAccountBlocked ??
                                                        false
                                                    ? 'Unblock'
                                                    : 'Block',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6!
                                                    .copyWith(
                                                        color: user
                                                                    .isAccountBlocked ??
                                                                false
                                                            ? Theme.of(context)
                                                                .primaryColor
                                                            : Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }),
                          ],
                        );
            }));
  }
}
