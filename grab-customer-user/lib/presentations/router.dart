import 'package:flutter/material.dart';
import 'package:grab/controller/middlewares/authentication.dart';
import 'package:grab/presentations/screens/driver/home_driver_screen.dart';
import 'package:grab/presentations/screens/home_screen.dart';
import 'package:grab/presentations/screens/login_screen.dart';
import 'package:grab/presentations/screens/splash_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static final pages = [
    GetPage(
      name: AppLinks.SPLASH,
      page: () => SplashScreen(),


    ),
    GetPage(
      name: AppLinks.LOGIN,
      page: () => LoginScreen(),



    ),
    GetPage(
      name: AppLinks.HOME,
      page: () => HomeScreen(),



    ),
    GetPage(
      name: AppLinks.CHECKAUTH,
      page: () => Container(), // A placeholder, won't actually be shown
      middlewares: [AuthGuard()],
    ),
     GetPage(
      name: AppLinks.HOMEDRIVER,
      page: () => HomeDriverScreen(),



    ),
    ];
}

class AppLinks {
  static const String SPLASH = "/splash";
  static const String LOGIN = "/login";
  static const String HOME = "/home";
  static const String HOMEDRIVER = "/home-driver";
  static const String CHECKAUTH = '/check-auth';
  
}