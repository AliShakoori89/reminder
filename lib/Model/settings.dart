import 'package:flutter/foundation.dart' show ChangeNotifier;

///Control user preferences settings.
///
///[color] : app primary color.
class Settings extends ChangeNotifier {

  void changeAppColor() async {
    notifyListeners();
  }
}
