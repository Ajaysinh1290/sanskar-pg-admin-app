import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:sanskar_pg_admin_app/widgets/image/image_network.dart';
import 'package:sanskar_pg_admin_app/widgets/image/pick_image.dart';
import 'dart:io';

import '../controller/add_user_controller.dart';

class UploadDocuments extends StatelessWidget {
  const UploadDocuments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddUserController>(builder: (addUserController) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upload Documents',
            style: Theme.of(context).textTheme.headline2,
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            'Attach User images',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(
            height: 30.h,
          ),
          Text(
            'Profile Pic',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(
            height: 30.h,
          ),
          addUserController.profilePic != null ||
                  addUserController.profilePicUrl != null
              ? Stack(
                  children: [
                    Container(
                      height: 120.w,
                      width: 120.w,
                      padding: const EdgeInsets.all(10),
                      child: addUserController.profilePic != null
                          ? Image.file(
                              addUserController.profilePic!,
                              fit: BoxFit.cover,
                            )
                          : ImageNetwork(
                              imageUrl: addUserController.profilePicUrl!,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        alignment: Alignment.topRight,
                        width: 20.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(100)),
                        child: InkWell(
                          onTap: () {
                            addUserController.profilePic = null;
                            addUserController.profilePicUrl = null;
                          },
                          child: Icon(
                            Icons.clear,
                            size: 20.sp,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : GestureDetector(
                  onTap: () async {
                    File? image = await pickImage();
                    if (image != null) {
                      addUserController.profilePic = image;
                    }
                  },
                  child: Container(
                    width: 120.w,
                    height: 120.w,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).cardColor, width: 2)),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.add,
                      size: 30.sp,
                    ),
                  ),
                ),
          SizedBox(
            height: 30.h,
          ),
          Text(
            'ID Proof',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(
            height: 15.h,
          ),
          SizedBox(
            height: 125.w,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: addUserController.documentsUrls.length +
                  addUserController.documents.length +
                  1,
              itemBuilder: (context, index) {
                bool isUrl = index < addUserController.documentsUrls.length;

                debugPrint('isUrl : $isUrl');
                debugPrint('index : $index');
                debugPrint(
                    'addUserController.documentsUrls.length : ${addUserController.documentsUrls.length}');
                debugPrint(
                    'addUserController.documents.length : ${addUserController.documents.length}');

                return index ==
                        addUserController.documents.length +
                            addUserController.documentsUrls.length
                    ? GestureDetector(
                        onTap: () async {
                          File? image = await pickImage();
                          if (image != null) {
                            addUserController.addDocument(image);
                          }
                        },
                        child: Container(
                          width: 100.w,
                          margin: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).cardColor,
                                  width: 2)),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.add,
                            size: 30.sp,
                          ),
                        ),
                      )
                    : Stack(
                        children: [
                          Container(
                            height: 140.w,
                            width: 100.w,
                            decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                border: Border.all(
                                    color: Theme.of(context).dividerColor,
                                    width: 0.5)),
                            margin: const EdgeInsets.all(10),
                            child: isUrl
                                ? ImageNetwork(
                                    imageUrl:
                                        addUserController.documentsUrls[index],
                                    fit: BoxFit.contain,
                                  )
                                : Image.file(
                                    addUserController.documents[index -
                                        addUserController.documentsUrls.length],
                                    fit: BoxFit.contain,
                                  ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              alignment: Alignment.topRight,
                              width: 20.w,
                              height: 20.w,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.circular(100)),
                              child: InkWell(
                                onTap: () {
                                  if (isUrl) {
                                    addUserController.removeImageUrl(index);
                                  } else {
                                    addUserController.removeImage(index -
                                        addUserController.documentsUrls.length);
                                  }
                                },
                                child: Icon(
                                  Icons.clear,
                                  size: 20.sp,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          )
                        ],
                      );
              },
            ),
          )
        ],
      );
    });
  }
}
