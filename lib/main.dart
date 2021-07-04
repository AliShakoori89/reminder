import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reminder/Model/notes.dart';
import 'package:reminder/UI/homepage.dart';
import 'package:reminder/UI/loginapp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Model/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<Settings>(create: (context) => Settings()),
        ChangeNotifierProvider<Todos>(create: (context) => Todos()),
      ],
      child: Consumer<Settings>(
        builder: (context, Settings builder, child) {
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
            ),
          );

          return App();
        },
      ),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        HomePage.id: (context) => HomePage(),
        LoginPage.id: (context) => LoginPage(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  static const String id = "/splashScreen";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future checkPinScreen(BuildContext context) async {
    bool boolSetPinCode = await getBoolValuesSF()??false;
    print("bool pin code is" + boolSetPinCode.toString());
    if (boolSetPinCode) {
      Navigator.popAndPushNamed(context, LoginPage.id);
      print("login page");
    } else {
      Navigator.popAndPushNamed(context, HomePage.id);
      print("home page");
    }
  }

  Future<bool> getBoolValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool boolValue = prefs.getBool('boolValue');
    print('first$boolValue');
    return boolValue;
  }

  @override
  Widget build(BuildContext context) {
    checkPinScreen(context);
    return Container();
  }
}
