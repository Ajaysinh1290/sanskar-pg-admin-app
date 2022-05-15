import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:sanskar_pg_admin_app/screens/hostel/add_hostel/controller/add_hostel_controller.dart';
import 'package:sanskar_pg_admin_app/widgets/image/image_network.dart';
import 'package:sanskar_pg_admin_app/widgets/image/pick_image.dart';
import 'dart:io';

class HostelImages extends StatelessWidget {
  const HostelImages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddHostelController>(builder: (addHostelController) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hostel Images',
            style: Theme.of(context).textTheme.headline2,
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            'Attach hostel images',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(
            height: 30.h,
          ),
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: addHostelController.hostelImageUrls.length +
                  addHostelController.hostelImages.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      height: 300.h,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: index >= addHostelController.hostelImageUrls.length
                          ? Image.file(
                              addHostelController.hostelImages[index -
                                  addHostelController.hostelImageUrls.length],
                              fit: BoxFit.cover,
                            )
                          : ImageNetwork(
                              imageUrl:
                                  addHostelController.hostelImageUrls[index],
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
                            if (index >=
                                addHostelController.hostelImageUrls.length) {
                              addHostelController.removeImage(
                                  addHostelController.hostelImages[index -
                                      addHostelController
                                          .hostelImageUrls.length]);
                            } else {
                              addHostelController.removeImageUrl(index);
                            }
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
                );
              }),
          SizedBox(
            height: 30.h,
          ),
          InkWell(
            onTap: () async {
              File? image = await pickImage();
              if (image != null) {
                addHostelController.setHostelImage(image);
              }
            },
            child: Container(
              width: double.infinity,
              height: 70.h,
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
