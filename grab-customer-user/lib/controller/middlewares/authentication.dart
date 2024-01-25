import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/route_middleware.dart';
import 'package:grab/config/injection.dart';
import 'package:grab/controller/auth_controller.dart';
import 'package:grab/data/repository/customer_repository.dart';
import 'package:grab/presentations/router.dart';

class AuthGuard extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final AuthController authController = Get.find();
    bool isLoggedIn = authController.user != null;
    bool isCustomerDataLoaded = authController.customer != null;
    bool isDriverDataLoaded = authController.driver != null;
    if (isLoggedIn) {
      // User is logged in and customer data is loaded
      if (isCustomerDataLoaded) {
        return RouteSettings(name: AppLinks.HOME);
      } else if (isDriverDataLoaded) {
        return RouteSettings(name: AppLinks.HOMEDRIVER);
      } 
    } else {

      // User is not logged in or customer data is not loaded
      return RouteSettings(name: AppLinks.LOGIN);
    }
  }
}
