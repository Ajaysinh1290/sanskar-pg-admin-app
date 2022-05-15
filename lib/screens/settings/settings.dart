import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:sanskar_pg_admin_app/animation/fade_and_translate_animation.dart';
import 'package:sanskar_pg_admin_app/controllers/auth_controller.dart';
import 'package:sanskar_pg_admin_app/controllers/hostel_controller.dart';
import 'package:sanskar_pg_admin_app/screens/hostel/add_hostel/add_hostel.dart';
import 'package:sanskar_pg_admin_app/screens/settings/your_profile.dart';
import 'package:sanskar_pg_admin_app/screens/settings/widgets/settings_tile.dart';
import 'package:sanskar_pg_admin_app/utils/utils.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  navigate(Widget widget) {
    Get.to(
      () => widget,
      transition: Transition.rightToLeftWithFade,
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }

  showDeleteConfirmationDialog() {
    Get.dialog(AlertDialog(
      title: Text(
        'Do you really want to delete this Hostel ?',
        style: Theme.of(context).textTheme.headline5,
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.black),
          ),
        ),
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Theme.of(context).primaryColor)),
          onPressed: () async {
            Get.back();
            Get.dialog(SimpleDialog(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Text(
                        'Deleting Hostel...',
                        style: Theme.of(context).textTheme.headline5,
                      )
                    ],
                  ),
                )
              ],
            ));
            await Get.find<HostelController>().deleteHostel();
            Get.back();
          },
          child: const Text('Delete'),
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    HostelController hostelController = Get.find<HostelController>();
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        padding: Constants.scaffoldPadding(context),
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            FadeAnimationTranslateY(
              delay: 1.0,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: Container(
                      width: 86.w,
                      height: 86.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        hostelController
                            .hostels[hostelController.currentHostel].hostelName
                            .substring(0, 1),
                        style: Theme.of(context)
                            .textTheme
                            .headline1!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 18.w,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hostelController.hostel!.hostelName,
                          style: Theme.of(context).textTheme.headline3,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(hostelController.hostel!.emailId,
                            style:
                                Theme.of(context).textTheme.headline5!.copyWith(
                                      color: ColorPalette.grey,
                                    ))
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            FadeAnimationTranslateY(
              delay: 1,
              child: Container(
                height: 2,
                width: double.infinity,
                color: Theme.of(context).cardColor,
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            FadeAnimationTranslateY(
              delay: 1.2,
              child: InkWell(
                  onTap: () {
                    navigate(AddHostel(
                      hostel: Get.find<HostelController>().hostel,
                    ));
                  },
                  child: SettingsTile(
                    title: 'Edit Hostel',
                    icon: Icons.edit_outlined,
                  )),
            ),
            FadeAnimationTranslateY(
              delay: 1.4,
              child: InkWell(
                onTap: () {
                  showDeleteConfirmationDialog();
                },
                child: SettingsTile(
                  title: 'Delete Hostel',
                  icon: CupertinoIcons.delete,
                ),
              ),
            ),
            FadeAnimationTranslateY(
              delay: 1.5,
              child: SettingsTile(title: 'About Us', icon: CupertinoIcons.info),
            ),
            FadeAnimationTranslateY(
              delay: 1.6,
              child: SettingsTile(
                title: 'Terms & Conditions',
                icon: CupertinoIcons.bookmark,
              ),
            ),
            FadeAnimationTranslateY(
              delay: 1.7,
              child: Container(
                height: 2,
                margin: EdgeInsets.symmetric(vertical: 15.h),
                width: double.infinity,
                color: Theme.of(context).cardColor,
              ),
            ),
            FadeAnimationTranslateY(
              delay: 1.8,
              child: InkWell(
                onTap: () {
                  Get.find<AuthController>().signOut();
                },
                child: SettingsTile(
                  title: 'Logout',
                  icon: CupertinoIcons.power,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
