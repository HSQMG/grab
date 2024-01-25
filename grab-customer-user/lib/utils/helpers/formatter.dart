import 'package:intl/intl.dart';

class Formatter{

  static String VNDFormatter(int money){
    
     final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return formatter.format(money);
  }
}