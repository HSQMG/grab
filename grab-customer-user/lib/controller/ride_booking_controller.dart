import 'package:grab/data/model/payment_method_model.dart';
import 'package:grab/data/model/service_model.dart';
import 'package:grab/data/repository/customer_repository.dart';
import 'package:grab/config/injection.dart';
import 'package:grab/data/repository/payment_method_repository.dart';
import 'package:grab/data/repository/service_repository.dart';

class RideBookingController {
  final PaymentMethodRepository paymentMethodRepo =
      getIt.get<PaymentMethodRepository>();
   Future<List<PaymentMethodModel>> getAllPaymentMethods() {
    return paymentMethodRepo.getAllPaymentMethods();
  }

   final ServiceRepository serviceRepo =
      getIt.get<ServiceRepository>();
   Future<List<ServiceModel>> getAllServices() {
    return serviceRepo.getAllServices();
  }
  
   Future<void> addService(ServiceModel serviceModel) {
    return serviceRepo.createService(serviceModel);
  }
}
