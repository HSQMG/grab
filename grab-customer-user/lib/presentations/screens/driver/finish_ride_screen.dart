import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grab/config/injection.dart';
import 'package:grab/controller/ride_booking_controller.dart';
import 'package:grab/controller/ride_controller.dart';
import 'package:grab/data/model/customer_model.dart';
import 'package:grab/data/model/payment_method_model.dart';
import 'package:grab/data/model/ride_model.dart';
import 'package:grab/data/model/socket_msg_model.dart';
import 'package:grab/presentations/screens/driver/home_driver_screen.dart';
import 'package:grab/presentations/widget/confirm_button.dart';
import 'package:grab/presentations/widget/dashed_line_vertical_painter.dart';
import 'package:flutter/material.dart';
import 'package:grab/presentations/widget/nav_bar.dart';
import 'package:grab/state.dart';
import 'package:grab/utils/constants/icons.dart';
import 'package:grab/utils/constants/styles.dart';
import 'package:grab/utils/constants/themes.dart';
import 'package:grab/utils/helpers/formatter.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class FinishRideScreen extends StatefulWidget {
  SocketMsgModel? socketMsg;
  IO.Socket? socket;
  FinishRideScreen({Key? key, required this.socket, required this.socketMsg})
      : super(key: key);

  @override
  State<FinishRideScreen> createState() => _FinishRideScreenState();
}

class _FinishRideScreenState extends State<FinishRideScreen> {
  int selectedPayemntMethodIndex = -1;
  final String CASH_PAYMENT_NAME = 'cash';
  PaymentMethodModel? fakerPaymentData;
  CustomerModel? fakerCustomerData;
  RideController rideController = RideController();
  @override
  void initState() {
    super.initState();
    fakerPaymentData = PaymentMethodModel(
        id: "2",
        name: "momo",
        description: 'MoMo',
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        isDeleted: false);
    fakerCustomerData = CustomerModel(
        name: "Nguyễn Văn A",
        id: "213",
        phoneNumber: "0123456789",
        email: "1@1");
  }

  Widget buildCard(String imagePath, String text) {
    return Card(
      elevation: 0,
      color: const Color.fromARGB(255, 252, 251, 236),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
        side: const BorderSide(
            width: 2.0,
            color: Color.fromARGB(
                255, 243, 233, 33) // Border color when the card is selected
            ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 20),
          Image(
            image: AssetImage(imagePath),
            width: 70,
            height: 70,
          ),
          const SizedBox(width: 20),
          Text(
            text,
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);
    return Scaffold(
      body: SafeArea(
          child: Container(
              margin: const EdgeInsets.all(20.0),
              alignment: const Alignment(0.6, 0.6),
              child: DefaultTextStyle(
                style: const TextStyle(
                    fontSize: 16, color: Color.fromARGB(255, 66, 66, 66)),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const NavBar(title: "Hoàn tất chuyến đi"),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.socketMsg?.customerName as String,
                            style: MyStyles.boldTextStyle,
                          ),
                          Text(
                            widget.socketMsg?.customerPhoneNumber as String,
                            style: MyStyles.boldTextStyle,
                          )
                        ],
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        height: 130, // Set the desired height for the Row
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                const Image(
                                  image:
                                      AssetImage('assets/icons/location1.png'),
                                  width: 25,
                                  height: 25,
                                ),
                                CustomPaint(
                                  size: const Size(1, 60),
                                  painter: DashedLineVerticalPainter(),
                                ),
                                const Image(
                                  image:
                                      AssetImage('assets/icons/location2.png'),
                                  width: 25,
                                  height: 25,
                                ),
                              ],
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Vị trí bắt đầu",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(widget.socketMsg?.pickupAddress ??
                                          ""),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Vị trí kết thúc",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                              widget.socketMsg?.distance
                                                  as String,
                                              style: const TextStyle(
                                                fontSize: 20,
                                              )),
                                        ],
                                      ),
                                      Text(widget
                                              .socketMsg?.destinationAddress ??
                                          ""),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Card(
                          elevation: 0,
                          color: const Color.fromARGB(255, 252, 251, 236),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Set the border radius
                            side: const BorderSide(
                                width: 2.0,
                                color: Color.fromARGB(
                                    255, 255, 255, 47)), // Set the border color
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(
                                right: 30, left: 30, top: 10, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Grab Bike",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Image(
                                  image:
                                      AssetImage('assets/icons/grab_bike.png'),
                                  width: 70,
                                  height: 70,
                                )
                              ],
                            ),
                          )),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Tổng",
                                    style: TextStyle(fontSize: 25),
                                  ),
                                  Text(
                                    style: const TextStyle(fontSize: 25),
                                    Formatter.VNDFormatter(
                                        widget.socketMsg?.price as int),
                                  )
                                ]),
                          ]),
                      const SizedBox(
                        height: 30,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Hình thức thanh toán",
                            style: TextStyle(fontSize: 25),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          fakerPaymentData != null
                              ? buildCard(
                                  IconPath.payment[fakerPaymentData!.name]!,
                                  fakerPaymentData!.description)
                              : Container(),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ConfirmButton(
                              onPressed: () => {
                                    widget.socket?.emit('finish_ride',
                                        widget.socketMsg?.toJson()),
                                    rideController.updateFareById(
                                        widget.socketMsg?.rideId as String,
                                        widget.socketMsg?.price as int),
                                    rideController.updateStatusById(
                                        widget.socketMsg?.rideId as String,
                                        RideStatus.completed),
                                    widget.socket?.disconnect(),
                                    Navigator.popUntil(context,
                                        ModalRoute.withName('/home-driver'))
                                  },
                              text: "Xác nhận hoàn tất chuyến đi"),
                          const SizedBox(
                            height: 10,
                          ),
                          ConfirmButton(
                              onPressed: () => {},
                              text: "Báo cáo vấn đề",
                              color: MyTheme.redBtn),
                        ],
                      ))
                    ],
                  ),
                ),
              ))),
    );
  }
}
