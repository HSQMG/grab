import 'package:grab/data/model/address_model.dart';

class RouteModel {
  final AddressModel pickup;
  final AddressModel destination;

  RouteModel({
    required this.pickup,
    required this.destination,
  });
}
