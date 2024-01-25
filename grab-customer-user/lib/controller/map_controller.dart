import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grab/data/mock/polyline.dart';
import 'package:grab/data/model/address_model.dart';
import 'package:grab/data/model/search_place_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:grab/utils/constants/key.dart';

class MapController {
  Future<String> getPlaceId(String address) async {
    String encodedAddress = Uri.encodeQueryComponent(address);
    String url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$encodedAddress&key=${MyKey.apiMapKey}';

    try {
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'OK') {
          return data['results'][0]['place_id'];
        } else {
          throw Exception('Failed to get place ID');
        }
      } else {
        throw Exception('Failed to connect to the server');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<Map<String, dynamic>> getPlaceCoordinateById(String id) async {
    final String url =
        'https://rsapi.goong.io/Place/Detail?place_id=$id&api_key=${MyKey.apiGOONGMapKey}';

    try {
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'OK') {
          return data['result']['geometry']['location'];
        } else {
          throw Exception('Failed to get place ID');
        }
      } else {
        throw Exception('Failed to connect to the server');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<List<LatLng>> getPolylinePoints(
      GeoPoint _currentP, GeoPoint _destinationP) async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    var url =
        'https://rsapi.goong.io/Direction?origin=${_currentP.latitude},${_currentP.longitude}&destination=${_destinationP.latitude},${_destinationP.longitude}&vehicle=bike&api_key=${MyKey.apiGOONGMapKey}';
    try {
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> steps = data['routes'][0]['legs'][0]['steps'];
        for (var step in steps) {
          polylineCoordinates.add(LatLng(
              step['start_location']['lat'], step['start_location']['lng']));
          polylineCoordinates.add(
              LatLng(step['end_location']['lat'], step['end_location']['lng']));
        }
        return polylineCoordinates;
      } else {
        return PolylineMock.mockRoutePolyline;
      }
    } catch (e) {
      print(e);
    }
    return polylineCoordinates;
  }

  Future<List<SearchPlaceModel>> searchPlaces(String address) async {
    if (address.isEmpty) return [];
    String encodedAddress = Uri.encodeQueryComponent(address);
    String url =
        'https://rsapi.goong.io/Place/AutoComplete?api_key=${MyKey.apiGOONGMapKey}&input=$encodedAddress';
    try {
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'OK') {
          List<SearchPlaceModel> addresses = [];
          data['predictions'].forEach((result) {
            addresses.add(SearchPlaceModel.fromJson(result));
          });
          return addresses;
        } else {
          throw Exception('Failed to get place ID');
        }
      } else {
        throw Exception('Failed to connect to the server');
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<Map<String, dynamic>> getDistance(
      String pickupId, String destinationId) async {
    try {
      Map<String, dynamic> pickup = await getPlaceCoordinateById(pickupId);
      Map<String, dynamic> destination =
          await getPlaceCoordinateById(destinationId);

      String url =
          'https://rsapi.goong.io/DistanceMatrix?origins=${pickup["lat"]},${pickup["lng"]}&destinations=${destination["lat"]},${destination["lng"]}&vehicle=bike&api_key=${MyKey.apiGOONGMapKey}';

      http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        for (var element in data['rows'][0]['elements']) {
          if (element['status'] == 'OK') {
            return {
              'duration': element['duration']['text'],
              'distance': element['distance']['text'],
            };
          }
        }
        return {
          'duration': '0',
          'distance': '0',
        };
      } else {
        throw Exception('Failed to connect to the server');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<List<GeoPoint>> getGeoPoints(
      String pickupId, String destinationId) async {
    Map<String, dynamic> pickup = await getPlaceCoordinateById(pickupId);
    Map<String, dynamic> destination =
        await getPlaceCoordinateById(destinationId);

    return [
      GeoPoint(pickup['lat'], pickup['lng']),
      GeoPoint(destination['lat'], destination['lng']),
    ];
  }

  Future<Polyline> generatePolylineFromPoint(
      List<LatLng> polylineCoordinates) async {
    PolylineId id = PolylineId('poly');
    return Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );
  }
}
