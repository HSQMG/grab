import 'package:grab/data/model/service_model.dart';

class FareCaculator {
  static double calc(double distance, double time, ServiceModel serviceModel) {
    return distance * serviceModel.pricePerKm +
        time * serviceModel.pricePerKm +
        serviceModel.minimunFare;
  }
}
