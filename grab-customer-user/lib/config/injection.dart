import 'package:get_it/get_it.dart';
import 'package:grab/data/model/customer_model.dart';
import 'package:grab/data/model/driver_model.dart';
import 'package:grab/data/repository/customer_repository.dart';
import 'package:grab/data/repository/driver_repository.dart';
import 'package:grab/data/repository/payment_method_repository.dart';
import 'package:grab/data/repository/payment_repository.dart';
import 'package:grab/data/repository/promotion_repository.dart';
import 'package:grab/data/repository/ride_repository.dart';
import 'package:grab/data/repository/service_repository.dart';
import 'package:grab/data/repository/vehicle_repository.dart';

final getIt = GetIt.instance;

void configureDependencies() async {
    getIt.registerSingleton<CustomerRepository>(CustomerRepository());
    getIt.registerSingleton<DriverRepository>(DriverRepository());
    getIt.registerSingleton<PaymentRepository>(PaymentRepository());
    getIt.registerSingleton<PaymentMethodRepository>(PaymentMethodRepository());
    getIt.registerSingleton<PromotionRepository>(PromotionRepository());
    getIt.registerSingleton<RideRepository>(RideRepository());
    getIt.registerSingleton<VehicleRepository>(VehicleRepository());
    getIt.registerSingleton<ServiceRepository>(ServiceRepository());
}

