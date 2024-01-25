import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:grab/data/model/payment_method_model.dart';
import 'package:grab/presentations/screens/cancle_ride_screen.dart';
import 'package:grab/presentations/widget/confirm_button.dart';
import 'package:grab/presentations/widget/dashed_line_vertical_painter.dart';
import 'package:flutter/material.dart';
import 'package:grab/presentations/widget/progress_bar.dart';
import 'package:grab/utils/constants/icons.dart';
import 'package:grab/utils/constants/styles.dart';
import 'package:grab/utils/constants/themes.dart';
import 'package:nb_utils/nb_utils.dart';

class InforDriverSearch extends StatelessWidget {
  InforDriverSearch({Key? key}) : super(key: key) {
    List<String> stParts = getFirstAndSencondPartDestination(startDestination);
    List<String> endParts = getFirstAndSencondPartDestination(endDestination);
    firstNameSt = stParts.first;
    secondNameSt = stParts.last;
    firstNameEnd = endParts.first;
    secondNameEnd = endParts.last;
  }

  String? firstNameSt, secondNameSt, firstNameEnd, secondNameEnd;
  List<String> getFirstAndSencondPartDestination(String des) {
    List<String> parts = des.split(',');
    return [parts.first.trim(), parts.skip(1).join(',').trim()];
  }

  // fake data

  PaymentMethodModel paymentMethod = PaymentMethodModel(
      id: "1233",
      name: "momo",
      description: "MoMo",
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
      isDeleted: false);
  String startDestination =
      "The Global City, Đỗ Xuân Hợp, An Phú, Thủ Đức, Thành phố Hồ chí Minh";
  String endDestination = "419/25 Cách mạng tháng 8, P.13, Q.10, TPHCM";

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 10,
      right: 10,
      bottom: 20,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(8.0), // Adjust the radius as needed
            ),
            child: const Column(
              children: [
                Center(child: ProgressBar(width: 30, height: 5)),
                Row(
                  children: [
                    Image(
                      image: AssetImage('assets/icons/grab_bike.png'),
                      width: 30,
                      height: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Text(
                      "Đang tìm tài xế...",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                  ],
                ),
                ProgressBar(
                  width: double.infinity,
                  height: 5,
                  color: MyTheme.splash,
                  value: 0.3,
                )
              ],
            )),
        const SizedBox(
          height: 30,
        ),
        Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(8.0), // Adjust the radius as needed
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Image(
                      image: AssetImage('assets/icons/raise_hand.png'),
                      width: 30,
                      height: 30,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          firstNameSt!,
                          style: MyStyles.boldTextStyle,
                        ),
                        Text(
                          secondNameSt!,
                          style: MyStyles.moreTinyTextStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Image(
                      image: AssetImage('assets/icons/location2.png'),
                      width: 30,
                      height: 30,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          firstNameEnd!,
                          style: MyStyles.boldTextStyle,
                        ),
                        Text(
                          secondNameEnd!,
                          style: MyStyles.moreTinyTextStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Image(
                      image: AssetImage(IconPath.payment[paymentMethod.name]!),
                      width: 30,
                      height: 30,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(paymentMethod.description)
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          // Add your close icon onPressed logic here
                          print('Close icon pressed');
                          // Get.to(const CancleRideScreen());
                        }),
                    const Text("Hủy chuyến")
                  ],
                )
              ],
            ))
      ]),
    );
  }
}
