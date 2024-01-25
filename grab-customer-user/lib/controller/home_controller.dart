import 'package:grab/data/repository/customer_repository.dart';
import 'package:grab/config/injection.dart';

class HomeController{
final CustomerRepository cusRepo = getIt.get<CustomerRepository>();
}  