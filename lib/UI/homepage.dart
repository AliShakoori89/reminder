import 'dart:async';
import 'dart:io';
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
      child: Scaffold(
        floatingActionButton: Container(
          width: 100,
          height: 40,
          child: FloatingActionButton.extended(
            label: Text('set pine code',
            style: TextStyle(fontSize: 12),),
            onPressed: (){
              _showLockScreen(
                context,
                circleUIConfig: CircleUIConfig(
                    borderColor: Colors.blue,
                    fillColor: Colors.blue,
                    circleSize: 30),
                keyboardUIConfig: KeyboardUIConfig(
                    digitBorderWidth: 2,
                    primaryColor: Colors.blue),
                opaque: false,
                setButton: Text(
                  'Set',
                  style: const TextStyle(
                      fontSize: 16, color: Colors.white),
                  semanticsLabel: 'Set',
                ),
                cancelButton: Text(
                  'Cancel',
                  style: const TextStyle(
                      fontSize: 16, color: Colors.white),
                  semanticsLabel: 'Cancel',
                ),
              );
            },
          ),
        ),
        backgroundColor: Colors.grey[200],
        body: Column(
          children: [
            FadeAnimation(
              3,
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 2,
                decoration: ShapeDecoration(
                  shadows: [
                      BoxShadow(
                        offset: Offset(0, 0),
                        blurRadius: 40,
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ],
                    color: Colors.white,
                  shape: AppBarBorder(),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      maxRadius: 120,
                      backgroundImage: AssetImage('assets/images/reminder.jpg')),
                    Text('Reminder', style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Molle'
                    ),)
                  ],
                ),
              ),
            ),
              Column(
                children: [
                  FadeAnimation(
                    4,
                    SizedBox(
                      width: 250,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0),
                          ),
                        ),
                        child: Text(
                          'Read Reminder',
                          style: TextStyle(fontFamily: 'Pacifico', fontSize: 15),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  child: ReadReminder()));
                        },
                      ),
                    ),
                  ),
                  FadeAnimation(
                      5,
                      SizedBox(
                        width: 250,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0)
                            )
                          ),
                          child: Text(
                            'Add Reminder',
                            style: TextStyle(fontFamily: 'Pacifico', fontSize: 15),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    child: AddReminder()));
                          },
                        ),
                      ),
                      ),
                ],
              )

              // Container(
            //   decoration: ShapeDecoration(
            //     color: Colors.blue,
            //     // shape: AppBarBorder(),
            //     /// You can also specify some neat shadows to cast on widgets scrolling under this one
            //     shadows: [
            //       BoxShadow(
            //         color: Colors.black.withOpacity(0.7),
            //         blurRadius: 18.0,
            //         spreadRadius: 2.0,
            //       ),
            //     ],
            //   ),
            //   // decoration: BoxDecoration(
            //   //   color: Colors.black,
            //   //   image: DecorationImage(
            //   //       image: AssetImage('assets/images/note.jpg'),
            //   //       fit: BoxFit.fill
            //   //   ),
            //   // ),
            // ),
            // Column(
            //   children: [
            //     Column(
            //       children: [
            //         FadeAnimation(
            //             2,
            //             InkWell(
            //               child: Text(
            //                 'Read Reminder',
            //                 style: TextStyle(
            //                     fontFamily: 'Pacifico',
            //                     fontSize: 15),
            //               ),
            //               onTap: () {
            //                 Navigator.push(
            //                     context,
            //                     PageTransition(
            //                         type: PageTransitionType.fade,
            //                         child: ReadReminder()));
            //               },
            //             )),
            //         FadeAnimation(
            //             3,
            //             InkWell(
            //               child: Text(
            //                 'Add Reminder',
            //                 style: TextStyle(
            //                     fontFamily: 'Pacifico', fontSize: 15),
            //               ),
            //               onTap: () {
            //                 Navigator.push(
            //                     context,
            //                     PageTransition(
            //                         type: PageTransitionType.fade,
            //                         child: AddReminder()));
            //               },
            //             )),
            //       ],
            //     ),
            //     InkWell(
            //       child: Text(
            //         'Set Pin code',
            //         style: TextStyle(fontSize: 15),
            //       ),
            //       onTap: () {
            //         _showLockScreen(
            //           context,
            //           circleUIConfig: CircleUIConfig(
            //               borderColor: Colors.blue,
            //               fillColor: Colors.blue,
            //               circleSize: 30),
            //           keyboardUIConfig: KeyboardUIConfig(
            //               digitBorderWidth: 2,
            //               primaryColor: Colors.blue),
            //           opaque: false,
            //           setButton: Text(
            //             'Set',
            //             style: const TextStyle(
            //                 fontSize: 16, color: Colors.white),
            //             semanticsLabel: 'Set',
            //           ),
            //           cancelButton: Text(
            //             'Cancel',
            //             style: const TextStyle(
            //                 fontSize: 16, color: Colors.white),
            //             semanticsLabel: 'Cancel',
            //           ),
            //         );
            //       },
            //     )
            //   ],
            // )
          ],
        )
        ),
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

class AppBarBorder extends ShapeBorder {
  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    Offset controllPoint1 = Offset(0, rect.size.height - 100);
    Offset endPoint1 = Offset(100, rect.size.height - 100);
    Offset controllPoint2 = Offset(rect.size.width, rect.size.height - 100);
    Offset endPoint2 = Offset(rect.size.width, rect.size.height - 200);

    return Path()
      ..lineTo(0, rect.size.height)
      ..quadraticBezierTo(
          controllPoint1.dx, controllPoint1.dy, endPoint1.dx, endPoint1.dy)
      ..lineTo(rect.size.width - 100, rect.size.height - 100)
      ..quadraticBezierTo(
          controllPoint2.dx, controllPoint2.dy, endPoint2.dx, endPoint2.dy)
      ..lineTo(rect.size.width, 0);
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(bottom: 0);

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) => null;

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}