import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grab/data/model/ride_model.dart';
import 'package:grab/utils/helpers/formatter.dart';

class RideCard extends StatelessWidget {
  final RideModel rideModel;

  const RideCard({Key? key, required this.rideModel}) : super(key: key);

  String formatTime(Timestamp time) {
    int hour = time.toDate().hour;
    int minute = time.toDate().minute;
    String formattedMinute = minute < 10 ? '0$minute' : '$minute';
    String formattedTime = '$hour:$formattedMinute';
    return formattedTime;
  }

  String returnMessgae(RideModel rideModel) {
    String message = "";
    if (rideModel.status == RideStatus.waiting) {
      message = "Tài xế đang đến đón bạn";
    } else if (rideModel.status == RideStatus.moving) {
      message = "Tài xế đã đón bạn";
    }
    return message;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    String formattedTime = formatTime(rideModel.startTime);
    String message = returnMessgae(rideModel);

    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      child: Card(
        elevation: 0.0,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
          ),
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "$formattedTime  $message",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                    ),
                  ),
                  // Add a condition to check if the ride is canceled and display the button
                  if (rideModel.status == RideStatus.cancel)
                    TextButton(
                      onPressed: () {
                        // Show dialog box with cancel reason
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Lí do hủy chuyến"),
                              content: Text(rideModel.feedback != null
                                  ? rideModel.feedback!.comment
                                  : ""),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text("Lí do hủy chuyến"),
                    ),
                ],
              ),
              const SizedBox(height: 10.0),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 0.0),
                title: Text(
                  rideModel.serviceId == 'FSpgPjk3VNGDE0HxdxTe'
                      ? 'GrabBike'
                      : 'GrabCar',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 5.0,
                    ),
                    Expanded(
                      child: Text(
                        "",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    const Text(
                      "Giá cước",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      Formatter.VNDFormatter(rideModel.fare.round()),
                      style: TextStyle(
                        fontSize: 24.0,
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Add a new Row widget here
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.pin_drop,
                    color: theme.primaryColor,
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Expanded(
                    child: Text(
                      rideModel.startLocation.stringName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Icon(Icons.pin_drop,
                      color: Color.fromRGBO(255, 127, 0, 1.0)),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Expanded(
                    child: Text(
                      rideModel.endLocation.stringName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
