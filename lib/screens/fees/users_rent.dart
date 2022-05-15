import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:sanskar_pg_admin_app/models/user/user_model.dart';
import 'package:sanskar_pg_admin_app/screens/fees/pay_fees.dart';
import 'package:sanskar_pg_admin_app/screens/user/user_details.dart';
import 'package:sanskar_pg_admin_app/utils/constants/constants.dart';
import 'package:sanskar_pg_admin_app/widgets/image/image_network.dart';
import 'package:sanskar_pg_admin_app/widgets/text-field/text_field.dart';
import 'package:shimmer/shimmer.dart';

class UsersRent extends StatelessWidget {
  final ValueNotifier<String> searchText = ValueNotifier<String>('');

  UsersRent({Key? key}) : super(key: key);

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
          'Select User',
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
                        itemCount: 10,
                        shrinkWrap: true,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    ? Text(
                        'No Users Found',
                        style: Theme.of(context).textTheme.headline5,
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
                              return Column(
                                children:
                                    List.generate(sortedUsers.length, (index) {
                                  UserModel user = sortedUsers[index];
                                  return ListTile(
                                    onTap: () {
                                      Get.to(PayFees(
                                        userModel: sortedUsers[index],
                                      ));
                                    },
                                    leading: Hero(
                                      tag: user.userId,
                                      child: ClipOval(
                                        child: ImageNetwork(
                                          imageUrl: user.userProfilePic!,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      user.userName,
                                      style:
                                          Theme.of(context).textTheme.headline4,
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
                                    trailing: InkWell(
                                      onTap: () {
                                        Get.to(UserDetails(
                                          userId: user.userId,
                                        ));
                                      },
                                      child: Ink(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.h, horizontal: 12.w),
                                        decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(5.r)),
                                        child: Text(
                                          'View Profile',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6!
                                              .copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              );
                            },
                          ),
                        ],
                      );
          }),
    );
  }
}
