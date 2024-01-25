import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grab/data/model/customer_model.dart';
import 'package:grab/data/model/driver_model.dart';
import 'package:grab/data/model/search_place_model.dart';
import 'package:grab/utils/helpers/grab_icon.dart';

class AppState extends ChangeNotifier {
  late SearchPlaceModel _pickupAddress;
  late SearchPlaceModel _destinationAddress;
  late GeoPoint _pickupPoint;
  late GeoPoint _destinationPoint;
  late String distance;
  late CustomerModel customer;
  late DriverModel driver;
  late int price;
  late BitmapDescriptor driverIcon;
  late BitmapDescriptor customerIcon;
  late BitmapDescriptor point;
  late String paymentMethod;
  late String service;

  AppState() {
    getCustomIcon("assets/icons/driver.png").then((icon) {
      driverIcon = icon;
      notifyListeners();
    });
    getCustomIcon("assets/icons/user.png").then((icon) {
      customerIcon = icon;
      notifyListeners();
    });
    getCustomIcon("assets/icons/destination.png").then((icon) {
      point = icon;
      notifyListeners();
    });
  }

  SearchPlaceModel get pickupAddress => _pickupAddress;
  SearchPlaceModel get destinationAddress => _destinationAddress;
  GeoPoint get pickupPoint => _pickupPoint;
  GeoPoint get destinationPoint => _destinationPoint;
  String get getDistance => distance;
  CustomerModel get getCustomer => customer;
  DriverModel get getDriver => driver;
  int get getPrice => price;
  String get getPaymentMethod => paymentMethod;
  String get getService => service;

  void setPickupAddress(SearchPlaceModel address) {
    _pickupAddress = address;
    notifyListeners();
  }

  void setDestinationAddress(SearchPlaceModel address) {
    _destinationAddress = address;
    notifyListeners();
  }

  void setPickupPoint(GeoPoint point) {
    _pickupPoint = point;
//    notifyListeners();
  }

  void setDestinationPoint(GeoPoint point) {
    _destinationPoint = point;
    // notifyListeners();
  }

  void setDistance(String distance) {
    this.distance = distance;
    // notifyListeners();
  }

  void setCustomer(CustomerModel customer) {
    this.customer = customer;
    // notifyListeners();
  }

  void setDriver(DriverModel driver) {
    this.driver = driver;
    // notifyListeners();
  }

  void setPrice(int price) {
    this.price = price;
    // notifyListeners();
  }

  void setPaymentMethod(String paymentMethod) {
    this.paymentMethod = paymentMethod;
    // notifyListeners();
  }

  void setService(String service) {
    this.service = service;
    // notifyListeners();
  }
}
