import 'package:flutter/material.dart';
import 'package:grab/utils/helpers/formatter.dart';

class VehicleCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final int fare;

  const VehicleCard({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.fare,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: const Color.fromARGB(255, 252, 251, 236),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(
          width: 2.0,
          color: Color.fromARGB(255, 255, 255, 47),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 30, left: 30, top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image(
                  image: AssetImage(imagePath),
                  width: 70,
                  height: 70,
                ),
              ],
            ),
            const SizedBox(height: 8), // Add spacing between text and icon
            Text(
              Formatter.VNDFormatter(fare),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
