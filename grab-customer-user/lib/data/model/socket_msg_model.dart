import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grab/data/model/customer_model.dart';
import 'package:grab/data/model/driver_model.dart';

class SocketMsgModel {
  String? customerId;
  String? driverId;
  String? rideId;
  String? customerSocketId;
  String? driverSocketId;
  LatLng? pickupPoint;
  LatLng? destinationPoint;
  String? pickupAddress;
  String? destinationAddress;
  LatLng? customerPosition;
  LatLng? driverPosition;
  String? distance;
  String? driverName;
  String? customerName;
  String? customerPhoneNumber;
  String? driverPhoneNumber;
  String? driverLicense;
  int? price;
  String? paymentMethod;
  String? service;

  SocketMsgModel({
    this.driverName,
    this.customerName,
    this.customerPhoneNumber,
    this.driverPhoneNumber,
    this.driverLicense,
    this.rideId,
    this.customerId,
    this.driverId,
    this.customerSocketId,
    this.driverSocketId,
    this.pickupPoint,
    this.destinationPoint,
    this.pickupAddress,
    this.destinationAddress,
    this.customerPosition,
    this.driverPosition,
    this.distance,
    this.price,
    this.paymentMethod,
    this.service,
  });

  static SocketMsgModel fromJson(Map<String, dynamic> json) {
    return SocketMsgModel(
      service: json['service'] ?? '',
      paymentMethod: json['paymentMethod'] ?? '',
      price: json['price'] ?? 0,
      driverName: json['driverName'] ?? '',
      customerName: json['customerName'] ?? '',
      customerPhoneNumber: json['customerPhoneNumber'] ?? '',
      driverPhoneNumber: json['driverPhoneNumber'] ?? '',
      driverLicense: json['driverLicense'] ?? '',
      distance: json['distance'] ?? '',
      rideId: json['rideId'] ?? '',
      customerId: json['customerId'] ?? '',
      driverId: json['driverId'] ?? '',
      customerSocketId: json['customerSocketId'] ?? '',
      driverSocketId: json['driverSocketId'] ?? '',
      pickupPoint: json['pickupPoint'] != null
          ? LatLng(
              json['pickupPoint']['latitude'], json['pickupPoint']['longitude'])
          : null,
      destinationPoint: json['destinationPoint'] != null
          ? LatLng(json['destinationPoint']['latitude'],
              json['destinationPoint']['longitude'])
          : null,
      pickupAddress: json['pickupAddress'] ?? '',
      destinationAddress: json['destinationAddress'] ?? '',
      customerPosition: json['customerPosition'] != null
          ? LatLng(json['customerPosition']['latitude'],
              json['customerPosition']['longitude'])
          : null,
      driverPosition: json['driverPosition'] != null
          ? LatLng(json['driverPosition']['latitude'],
              json['driverPosition']['longitude'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'service': service,
      'paymentMethod': paymentMethod,
      'price': price,
      'driverName': driverName,
      'customerName': customerName,
      'driverPhoneNumber': driverPhoneNumber,
      'customerPhoneNumber': customerPhoneNumber,
      'driverLicense': driverLicense,
      'distance': distance,
      'rideId': rideId,
      'customerId': customerId,
      'driverId': driverId,
      'customerSocketId': customerSocketId,
      'driverSocketId': driverSocketId,
      'pickupPoint': pickupPoint != null
          ? {
              'latitude': pickupPoint!.latitude,
              'longitude': pickupPoint!.longitude
            }
          : null,
      'destinationPoint': destinationPoint != null
          ? {
              'latitude': destinationPoint!.latitude,
              'longitude': destinationPoint!.longitude
            }
          : null,
      'pickupAddress': pickupAddress,
      'destinationAddress': destinationAddress,
      'customerPosition': customerPosition != null
          ? {
              'latitude': customerPosition!.latitude,
              'longitude': customerPosition!.longitude
            }
          : null,
      'driverPosition': driverPosition != null
          ? {
              'latitude': driverPosition!.latitude,
              'longitude': driverPosition!.longitude
            }
          : null,
    };
  }
}
