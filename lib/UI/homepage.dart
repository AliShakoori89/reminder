import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:reminder/Animation/Fade%20Animation.dart';
import 'package:reminder/Model/notes.dart';
import 'package:reminder/PinCode/circle.dart';
import 'package:reminder/PinCode/keyboard.dart';
import 'package:reminder/PinCode/passcodescreen.dart';
import 'addreminder.dart';
import 'readreminder.dart';


class HomePage extends StatefulWidget {
  static const String id = "/HomePage";


  final Todo todo;
  final bool boolval;

  const HomePage({Key key, this.todo, this.boolval}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(todo,boolval);
}

class _HomePageState extends State<HomePage> {

  final Todo todo;
  final bool boolval;
  final StreamController<bool> _verificationNotifier =
  StreamController<bool>.broadcast();


  _HomePageState(this.todo, this.boolval);


  @override
  Widget build(BuildContext context) {

    Future<void> onPop1(BuildContext context) async {

      await showDialog(
          context: context, builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text('Do you want to exit App ?'),
            actions: [
              TextButton(
                child: Text('No', style: TextStyle(color: Colors.black)),
                onPressed: () {
                  Navigator.of(context)..pop()..pop();
                },
              ),
              TextButton(
                child: Text('Yes', style: TextStyle(color: Colors.black)),
                onPressed: () async {
                  exit(0);
                },
              ),
            ],
          )
      );
    }

    return WillPopScope(
      onWillPop: () async{
        await onPop1(context);
        return true;
      },
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: ClippedPartsWidget(
                top: Container(
                  color: Color.fromRGBO(198,195,188,0.5),
                  child: Opacity(
                    opacity: 0.7,
                    child: Padding(padding: EdgeInsets.only(),
                        child: FadeAnimation(1,Container(
                          height: MediaQuery.of(context).size.height/3,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/reminder1.jpg'),
                                fit: BoxFit.fill
                            ),
                          ),
                        ),
                        )
                    )
                  )
                ),
                bottom: Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/4,),
                  child: Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        image: DecorationImage(
                            image: AssetImage('assets/images/note.jpg'),
                            fit: BoxFit.fill
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height/3.7,
                            left: MediaQuery.of(context).size.height/12,
                          ),
                              child: Column(
                                children: [
                                  FadeAnimation(2, Container(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: InkWell(
                                        child: Text('Read Reminder' , style: TextStyle(fontFamily: 'Pacifico' , fontSize: 15),),
                                        onTap: (){
                                          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: ReadReminder()));
                                        },
                                      ),
                                    ),
                                  )),
                                  FadeAnimation(3, Container(
                                    child: Padding(padding: EdgeInsets.only( top: 20.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: InkWell(
                                            child: Text('Add Reminder' , style: TextStyle(fontFamily: 'Pacifico' , fontSize: 15),),
                                            onTap: (){
                                              Navigator.push(context,
                                                  PageTransition(type: PageTransitionType.fade, child: AddReminder()));
                                            },
                                          ),
                                        )
                                    ),
                                  )
                                  ),
                                ],
                              )
                          ),
                          Padding(padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height/3.5,
                            left: MediaQuery.of(context).size.height/2.8,
                          ),
                              child: Container(
                                child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: InkWell(
                                        child: Text('Set Pin code' , style: TextStyle(fontSize: 15),),
                                        onTap: (){
                                          _showLockScreen(
                                            context,
                                            circleUIConfig: CircleUIConfig(borderColor: Colors.blue, fillColor: Colors.blue, circleSize: 30),
                                            keyboardUIConfig: KeyboardUIConfig(digitBorderWidth: 2, primaryColor: Colors.blue),
                                            opaque: false,
                                            setButton: Text(
                                              'Set',
                                              style: const TextStyle(fontSize: 16, color: Colors.white),
                                              semanticsLabel: 'Set',
                                            ),
                                            cancelButton: Text(
                                              'Cancel',
                                              style: const TextStyle(fontSize: 16, color: Colors.white),
                                              semanticsLabel: 'Cancel',
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                ),
                              )
                        ],
                      ),
                  ),),
                splitFunction: (Size size, double x){
                  final normalizedX = x / size.width * pi;
                  final waveHeight = size.height / 25;
                  final y = size.height / 2.4 - sin (
                      normalizedX ) * waveHeight;
                  return y;
                }
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
        Widget setButton,
        List<String> digits}) {
    Navigator.push(
        context,
        PageRouteBuilder(
          opaque: opaque,
          pageBuilder: (context, animation, secondaryAnimation) => PasscodeScreen(
            title: Text(
              'Enter App Passcode',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
            circleUIConfig: circleUIConfig,
            keyboardUIConfig: keyboardUIConfig,
            setButton : setButton,
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
            passwordEnteredCallback: (String text) {  },
          ),
        ));
  }

  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }

  _onPasscodeCancelled() {
    Navigator.maybePop(context);
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
            TextButton(
              child: Text(
                "Cancel",
                style: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.maybePop(context);
              },
            ),
            TextButton(
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

class ClippedPartsWidget extends StatelessWidget {
  final Widget top;
  final Widget bottom;
  final double Function(Size, double) splitFunction;

  ClippedPartsWidget({
    @required this.top,
    @required this.bottom,
    @required this.splitFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
        child:Stack(
          children: <Widget>[
            top,
            ClipPath(
              clipper: FunctionClipper(splitFunction: splitFunction),
              child: bottom,
            ),
          ],
        ),
    );
  }
}

class FunctionClipper extends CustomClipper<Path> {
  final double Function(Size, double) splitFunction;

  FunctionClipper({@required this.splitFunction}) : super();

  Path getClip(Size size) {
    final path = Path();

    // move to split line starting point
    path.moveTo(0, splitFunction(size, 0));

    // draw split line
    for (double x = 1; x <= size.width; x++) {
      path.lineTo(x, splitFunction(size, x)/1.40);
    }

    // close bottom part of screen
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // I'm returning fixed 'true' value here for simplicity, it's not the part of actual question
    // basically that means that clipping will be redrawn on any changes
    return true;
  }
}