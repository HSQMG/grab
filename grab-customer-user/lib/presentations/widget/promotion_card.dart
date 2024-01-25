import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grab/data/model/promotion_model.dart';
class PromotionCard extends StatelessWidget {
  final PromotionModel promotion;

  const PromotionCard({Key? key, required this.promotion}) : super(key: key);

  String formartValidDate(Timestamp date) {
    return "${date.toDate().day}/${date.toDate().month}/${date.toDate().year}";
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Ensure content starts from the top
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            padding: EdgeInsets.symmetric(vertical: 35.0, horizontal: 25.0),
            child: CircleAvatar(
              backgroundColor: Color.fromRGBO(238, 75, 69, 0.18),
              radius: 30.0,
              child: Icon(
                Icons.card_giftcard,
                color: _theme.primaryColor,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  left: BorderSide(
                    color: const Color.fromARGB(255, 126, 126, 126),
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    promotion.description,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    "Valid up-to ${formartValidDate(promotion.endDate)}",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    "Discount ${promotion.percent}% for your next ride",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                       Navigator.pop(context, promotion.percent);
                      },
                      child: Text(
                        "Use now",
                        style: TextStyle(
                          color: _theme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}