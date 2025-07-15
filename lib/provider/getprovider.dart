import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../screens/login_screen/provider/auth_provider.dart';
import '../screens/profile_screen/provider/profile_provider.dart';
import '../screens/user_screens/home/provider/markmeal_provider.dart';

List<SingleChildWidget> getProvider() {
  return [
    ChangeNotifierProvider(create: (context) => AuthProvider()),
    ChangeNotifierProvider(create: (context) => ProfileProvider()),
    ChangeNotifierProvider(create: (context) => MarkMealProvider()),
  ];
}