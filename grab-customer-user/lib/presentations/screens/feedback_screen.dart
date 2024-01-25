import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grab/controller/ride_controller.dart';
import 'package:grab/data/model/feedback_model.dart';
import 'package:grab/data/model/socket_msg_model.dart';
import 'package:grab/presentations/widget/confirm_button.dart';
import 'package:grab/presentations/widget/dashed_line_vertical_painter.dart';
import 'package:flutter/material.dart';
import 'package:grab/presentations/widget/infor_driver_search.dart';
import 'package:grab/presentations/widget/progress_bar.dart';
import 'package:nb_utils/nb_utils.dart';

class FeedBackScreen extends StatefulWidget {
  SocketMsgModel msg;
  FeedBackScreen({Key? key, required this.msg}) : super(key: key);

  @override
  State<FeedBackScreen> createState() => _BookingRideScreenState();
}

class _BookingRideScreenState extends State<FeedBackScreen> {
  int selectedStar = 0;
  RideController rideController = RideController();
  final commentController = TextEditingController();
  String getFeedbackText() {
    switch (selectedStar) {
      case 1:
        return "Tệ";
      case 2:
        return "Tạm được";
      case 3:
        return "Tốt";
      case 4:
        return "Rất tốt";
      case 5:
        return "Tuyệt vời";
      default:
        return "Hãy đánh giá";
    }
  }

  void sendFeedBack() {
    FeedbackModel feedback = FeedbackModel(
        rating: selectedStar,
        comment: commentController.text,
        createdAt: Timestamp.now());

    rideController.updateFeedBackById(widget.msg.rideId as String, feedback);
    Navigator.popUntil(context, ModalRoute.withName('/home'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(children: [
            Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (context) => Positioned(
                    top: 0,
                    left: 0,
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: const Color.fromARGB(95, 128, 128, 144),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 200,
              left: -4,
              right: -4,
              bottom: -30,
              child: Container(
                  child: DefaultTextStyle(
                      style: const TextStyle(
                          fontSize: 16, color: Color.fromARGB(255, 66, 66, 66)),
                      child: Card(
                        color: white, // Make card background transparent
                        elevation: 0, // Remove card shadow
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              18.0), // Optional: Add border radius
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(children: [
                            Row(
                              children: [
                                const SizedBox(
                                  width: 50,
                                ),
                                const Expanded(
                                    child: ProgressBar(width: 30, height: 5)),
                                const SizedBox(
                                  width: 50,
                                ),
                                IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      // Add your close icon onPressed logic here
                                      print('Close icon pressed');
                                    }),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const SizedBox(width: 20.0),
                                ...List.generate(5, (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedStar = index + 1;
                                      });
                                    },
                                    child: Icon(
                                      Icons.star,
                                      size: 40,
                                      color: index < selectedStar
                                          ? Colors.yellow
                                          : Colors.grey,
                                    ),
                                  );
                                }),
                                const SizedBox(width: 20.0),
                              ],
                            ),
                            Text(
                              getFeedbackText(),
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              selectedStar > 0
                                  ? "Bạn đã đánh giá $selectedStar sao"
                                  : "Hãy cho chúng tôi biêt độ hài lòng của bạn",
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    8.0), // Adjust the radius as needed
                                border: Border.all(color: Colors.grey),
                              ),
                              child: TextFormField(
                                controller: commentController,
                                decoration: const InputDecoration(
                                  hintText: "Nhận xét...",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ConfirmButton(
                                    onPressed: () => {sendFeedBack()},
                                    text: "Gửi")
                              ],
                            )),
                            const SizedBox(
                              height: 30,
                            )
                          ]),
                        ),
                      ))),
            ),
          ]),
        ));
  }
}
