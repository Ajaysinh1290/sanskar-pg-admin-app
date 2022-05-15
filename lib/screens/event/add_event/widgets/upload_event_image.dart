import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:sanskar_pg_admin_app/screens/event/add_event/controller/add_event_controller.dart';
import 'package:sanskar_pg_admin_app/screens/hostel/add_hostel/controller/add_hostel_controller.dart';
import 'package:sanskar_pg_admin_app/widgets/image/image_network.dart';
import 'package:sanskar_pg_admin_app/widgets/image/pick_image.dart';
import 'dart:io';

class UploadEventImage extends StatelessWidget {
  const UploadEventImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddEventController>(builder: (addEventController) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upload Event Photo',
            style: Theme.of(context).textTheme.headline2,
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            'Attach event image',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(
            height: 30.h,
          ),
          addEventController.eventImage != null ||
                  addEventController.eventImageUrl != null
              ? Stack(
                  children: [
                    Container(
                      height: 300.h,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: addEventController.eventImage != null
                          ? Image.file(
                              addEventController.eventImage!,
                              fit: BoxFit.cover,
                            )
                          : ImageNetwork(
                              imageUrl: addEventController.eventImageUrl!,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Positioned(
                      top: 10,
                      right: 0,
                      child: Container(
                        alignment: Alignment.topRight,
                        width: 200,
                        height: 150,
                        child: IconButton(
                          icon: Icon(
                            Icons.clear,
                            size: 30.sp,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            addEventController.eventImage = null;
                            addEventController.eventImageUrl = null;
                          },
                        ),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.black38, Colors.transparent],
                              begin: Alignment.topRight,
                              end: Alignment.center),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(35)),
                        ),
                      ),
                    )
                  ],
                )
              : InkWell(
                  onTap: () async {
                    File? image = await pickImage();
                    if (image != null) {
                      addEventController.eventImage = image;
                    }
                  },
                  child: Container(
                    height: 300.h,
                    width: double.infinity,
                    alignment: Alignment.center,
                    color: Theme.of(context).cardColor,
                    child: Icon(
                      Icons.add,
                      size: 30.sp,
                    ),
                  ),
                )
        ],
      );
    });
  }
}
