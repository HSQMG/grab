import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> getCustomIcon(String path) async {
  var icon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(
        size: Size(5, 5),
      ),
      path);
  return icon;
}
