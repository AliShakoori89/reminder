import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:reminder/PinCode/circle.dart';
import 'package:reminder/UI/homepage.dart';
import 'package:reminder/PinCode/keyboard.dart';
import 'package:reminder/PinCode/passcodescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

var radius=10.0;
class LoginPage extends StatefulWidget {
  static const String id = "/LoginPage";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {

  AnimationController controller;
  Animation sizeAnimation;
  final StreamController<bool> _verificationNotifier =
    StreamController<bool>.broadcast();
  bool isAuthenticated = false;


  final Shader linearGradient = LinearGradient(
      colors: [Color.fromRGBO(0, 0, 0, 1),Color.fromRGBO(999, 999, 999, 1)],
  ).createShader(Rect.fromLTRB(0.0, 0.0, 200.0, 70.0));

  // 2. created object of localauthentication class
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  // 3. variable for track whether your device support local authentication means
  //    have fingerprint or face recognization sensor or not
  bool _hasFingerPrintSupport = false;
  // 4. we will set state whether user authorized or not
  String _authorizedOrNot = "Not Authorized";
  // 5. list of avalable biometric authentication supports of your device will be saved in this array
  List<BiometricType> _availableBuimetricType = List<BiometricType>();

  _LoginPageState();

  Future<void> _getBiometricsSupport() async {
    // 6. this method checks whether your device has biometric support or not
    bool hasFingerPrintSupport = false;
    try {
      hasFingerPrintSupport = await _localAuthentication.canCheckBiometrics;
    } catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _hasFingerPrintSupport = hasFingerPrintSupport;
    });
  }

  Future<void> _getAvailableSupport() async {
    // 7. this method fetches all the available biometric supports of the device
    List<BiometricType> availableBuimetricType = List<BiometricType>();
    try {
      availableBuimetricType =
      await _localAuthentication.getAvailableBiometrics();
    } catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _availableBuimetricType = availableBuimetricType;
    });
  }

  Future<void> _authenticateMe() async {
    // 8. this method opens a dialog for fingerprint authentication.
    //    we do not need to create a dialog nut it popsup from device natively.
    bool authenticated = false;
    try {
      authenticated = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Scan your fingerprint to authenticate", // message for dialog
        useErrorDialogs: true,// show error in dialog
        stickyAuth: true,// native process
      );
    } catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      authenticated
          ? Navigator.push(context, new MaterialPageRoute(builder: (context) => new HomePage()))
          : print('Do nothing');
    });
  }

  @override
  void initState() {
    _getBiometricsSupport();
    _getAvailableSupport();
    super.initState();

    controller =  AnimationController(vsync: this, duration: Duration(seconds: 2));
    sizeAnimation = Tween<double>(begin: 100.0, end: 200.0)
        .animate(CurvedAnimation(parent: controller, curve: Curves.bounceOut));

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays ([]);
    return Scaffold(
        body: Container(
            height: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/note.jpg'),
                    fit: BoxFit.fill
                )
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10,
                  bottom: 15),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height / 2.8,
                  // color: Colors.black26,
                  decoration: BoxDecoration(
                      color: Colors.black38,
                      border: Border.all(
                        color: Colors.black26,
                      ),
                      borderRadius: BorderRadius.circular(25.0)
                  ),
                  child: ClipPath(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height/60),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: TypewriterAnimatedTextKit(
                              isRepeatingAnimation: false,
                              speed: Duration(milliseconds: 100),
                              text: [
                                ' Press fingerprint Icon'
                              ],
                              textStyle: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 18.0,
                                  fontFamily: "Agne"
                              ),
                              textAlign: TextAlign.start,
                              alignment: AlignmentDirectional.topStart // or Alignment.topLeft
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height/80,
                              bottom: MediaQuery.of(context).size.height/50),
                        ),
                        Center(
                            child: Container(
                                height: sizeAnimation.value,
                                width: sizeAnimation.value,
                                child: IconButton(
                                  iconSize: 80.0,
                                  icon: Icon(Icons.fingerprint),
                                  onPressed: _authenticateMe,
                                )
                            )
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.only(
                            //       left: 10.0,
                            //       bottom: 10.0),
                            // ),
                            Flexible(
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: InkWell(
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                        left: MediaQuery.of(context).size.height/4,
                                        right: MediaQuery.of(context).size.height/80,
                                        bottom: MediaQuery.of(context).size.height/80,),
                                      child: Text('Enter Pincode',
                                        style: TextStyle(color: Colors.white60),)
                                  ),
                                  onTap: (){
                                    _showLockScreen(
                                      context,
                                      circleUIConfig: CircleUIConfig(borderColor: Colors.blue, fillColor: Colors.blue, circleSize: 30),
                                      keyboardUIConfig: KeyboardUIConfig(digitBorderWidth: 2, primaryColor: Colors.blue),
                                      opaque: false,
                                      cancelButton: Text(
                                        'Cancel',
                                        style: const TextStyle(fontSize: 16, color: Colors.white),
                                        semanticsLabel: 'Cancel',
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    clipper: MyShape(),
                  ),
                ),
              ),
            )
        )
    );
  }

  _showLockScreen(BuildContext context,
      {bool opaque,
        CircleUIConfig circleUIConfig,
        KeyboardUIConfig keyboardUIConfig,
        Widget cancelButton,
        List<String> digits}) {
    Navigator.push(
        context,
        PageRouteBuilder(
          opaque: opaque,
          pageBuilder: (context, animation, secondaryAnimation) =>
              PasscodeScreen(
            title: Text(
              'Enter App Passcode',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
            circleUIConfig: circleUIConfig,
            keyboardUIConfig: keyboardUIConfig,
            passwordEnteredCallback: _onPasscodeEntered,
            cancelButton: cancelButton,
            deleteButton: Text(
              'Delete',
              style: const TextStyle(fontSize: 16, color: Colors.white),
              semanticsLabel: 'Delete',
            ),
            shouldTriggerVerification: _verificationNotifier.stream,
            backgroundColor: Colors.black.withOpacity(0.8),
            cancelCallback: _onPasscodeCancelled,
            digits: digits,
            passwordDigits: 6,
            bottomWidget: _buildPasscodeRestoreButton(),
          ),
        ));
  }

  _onPasscodeEntered(String enteredPasscode) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String pinCode = pref.getString('pinCode');
    if (enteredPasscode == pinCode) {
      Navigator.popAndPushNamed(context, HomePage.id);
      }else{
      _errorpage();
    }
    }

  _onPasscodeCancelled() {
    Navigator.maybePop(context);
  }


  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }

  _buildPasscodeRestoreButton() => Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      margin: const EdgeInsets.only(bottom: 10.0, top: 20.0),
      child: FlatButton(
        child: Text(
          "Reset passcode",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w300),
        ),
        splashColor: Colors.white.withOpacity(0.4),
        highlightColor: Colors.white.withOpacity(0.2),
        onPressed: _resetAppPassword,
      ),
    ),
  );

  _errorpage() {
    Navigator.maybePop(context).then((result) {
      if (!result) {
        return;
      }
    });
  }

  _resetAppPassword() {
    Navigator.maybePop(context).then((result) {
      if (!result) {
        return;
      }
      _showRestoreDialog(() {
        Navigator.maybePop(context);
        //TODO: Clear your stored passcode here
      });
    });
  }

  _showRestoreDialog(VoidCallback onAccepted) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Reset passcode",
            style: const TextStyle(color: Colors.black87),
          ),
          content: Text(
            "Passcode reset is a non-secure operation!\n\nConsider removing all user data if this action performed.",
            style: const TextStyle(color: Colors.black87),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text(
                "Cancel",
                style: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.maybePop(context);
              },
            ),
            FlatButton(
              child: Text(
                "I understand",
                style: const TextStyle(fontSize: 18),
              ),
              onPressed: onAccepted,
            ),
          ],
        );
      },
    );
  }

}

class MyShape extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(radius, 0.0);
    path.arcToPoint(Offset(0.0, radius),
        clockwise: true, radius: Radius.circular(radius));
    path.lineTo(0.0, size.height - radius);
    path.arcToPoint(Offset(radius, size.height),
        clockwise: true, radius: Radius.circular(radius));
    path.lineTo(size.width - radius, size.height);
    path.arcToPoint(Offset(size.width, size.height - radius),
        clockwise: true, radius: Radius.circular(radius));
    path.lineTo(size.width, radius);
    path.arcToPoint(Offset(size.width - radius, 0.0),
        clockwise: true, radius: Radius.circular(radius));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }

}