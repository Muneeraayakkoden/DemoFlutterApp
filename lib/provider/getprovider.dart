import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../screens/login_screen/provider/login_provider.dart';

List<SingleChildWidget> getProvider() {
  return [
    ChangeNotifierProvider(create: (context) => LoginProvider()),
  ];
}