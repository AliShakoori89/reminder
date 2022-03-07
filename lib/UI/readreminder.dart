import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/Model/notes.dart';
import 'dart:ui' as ui;

import 'addreminder.dart';
import 'homepage.dart';

class ReadReminder extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  ReadReminder({Key key, this.scaffoldKey}) : super(key: key);

  @override
  _ReadReminderState createState() => _ReadReminderState();
}

class _ReadReminderState extends State<ReadReminder> {

  ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);//the listener for up and down.
    super.initState();
  }

  _scrollListener() {
    if(_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange){
      setState (
              () { //you can do anything here
          });
    }
    if(_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange){
      setState (
              () { //you can do anything here
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/note.jpg'),
              colorFilter:
              ColorFilter.mode(Colors.grey.withOpacity(0.6),
                  BlendMode.dstATop),
              fit: BoxFit.fill
          ),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: (){
                  Navigator.push(
                      context, new MaterialPageRoute(builder: (context) => new HomePage()));
                }),
          ),
          SizedBox(height: 20,),
          Consumer<Todos>(
            builder: (context, Todos builder, child) {
              if (builder.todosLength == 0) {
                return Center(
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.subtitle1,
                      children: [
                        TextSpan(text: ' There are no notes '),
                      ],
                    ),
                  ),
                );
              }
              return Flexible(
                child: ListView.builder(
                  controller: _controller,
                  scrollDirection: Axis.vertical,
                  itemCount: builder.todosLength,
                  shrinkWrap: true,
                  itemExtent: 170,
                  itemBuilder: (context, index) {
                    final row = builder.todos[index];
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: OpenContainer(
                        closedColor: const Color(0xFF00000).withOpacity(0.0),
                        closedElevation: 20,
                        openElevation: 30,
                        closedBuilder: (context, action) => NoteWidget(
                          row,
                        ),
                        openBuilder: (context, action) => AddReminder(
                          row: row,
                          scaffold: widget.scaffoldKey,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      )
    )
    );
  }
}

//new note widget
class NoteWidget extends StatelessWidget {
  final Todo todo;

  NoteWidget(Map<String, dynamic> row, {Key key})
      : todo = Todo.fromRow(row),
        assert(row != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          child: CustomPaint(
            painter: NoteWidgetPainter(todo, descriptionFontSize: 15, dateFontSize: 10),
            size: Size(double.maxFinite, 100),
          ),
      ),
    );
  }
}

class NoteWidgetPainter extends CustomPainter {
  final Todo todo;
  final _circlePaint = Paint();

//  final _whitePaint = Paint()..color = Colors.white;

  final double descriptionFontSize;
  final double dateFontSize;

  NoteWidgetPainter(this.todo,
      {Listenable repaint, this.descriptionFontSize = 25, this.dateFontSize = 25})
      : super(repaint: repaint) {
    switch (todo.priority) {
      case 0:
        _circlePaint.color = Colors.green;
        break;
      case 1:
        _circlePaint.color = Colors.yellow;
        break;
      default:
        _circlePaint.color = Colors.red;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final diameter = descriptionFontSize;

    final rrect = RRect.fromLTRBR(
      diameter,
      0,
      size.width,
      size.height,
      const Radius.circular(10),
    );

    canvas.drawShadow(Path()..addRRect(rrect), _circlePaint.color, 2.5, true);

    final circleCenter = Offset(diameter, size.height / 2);

    canvas.drawCircle(circleCenter, diameter, _circlePaint);
    if (todo.priority == 2) {
      const icon = Icons.whatshot;
      final builder = ui.ParagraphBuilder(
        ui.ParagraphStyle(fontFamily: icon.fontFamily, fontSize: diameter),
      )..addText(String.fromCharCode(icon.codePoint));

      final para = builder.build();

      para.layout(const ui.ParagraphConstraints(width: 0));
      canvas.drawParagraph(
          para,
          Offset(
            circleCenter.dx - (para.height / 2),
            circleCenter.dy - (para.height / 2),
          ));
    }

    //Draw "!"
    else if (todo.priority == 1) {
      final tp = TextPainter(
        text: TextSpan(
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: diameter * 1.5,
          ),
          text: '!',
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      //to draw the "!" at the center of the circle.
      tp.layout(minWidth: 0, maxWidth: 0);
      final position = Offset(
        circleCenter.dx,
        circleCenter.dy - (tp.height / 2),
      );

      tp.paint(canvas, position);
    } else {
      const icon = Icons.spa;
      final builder = ui.ParagraphBuilder(
        ui.ParagraphStyle(fontFamily: icon.fontFamily, fontSize: diameter),
      )..addText(String.fromCharCode(icon.codePoint));

      final para = builder.build();

      para.layout(const ui.ParagraphConstraints(width: 0));
      canvas.drawParagraph(
          para,
          Offset(
            circleCenter.dx - (para.height / 2),
            circleCenter.dy - (para.height / 2),
          ));
    }

    //Draw The title of note.
    {
      final tp = TextPainter(
        text: TextSpan(
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
          text: todo.title,
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );


      tp.layout(maxWidth: size.width / 1.5);
      final position = Offset(
        size.width / 6 - (tp.width / 4),
        circleCenter.dy - (tp.height / 0.3),
      );

      tp.paint(canvas, position);
    }

    //Draw The description of note.
        {
      final tp = TextPainter(
        text: TextSpan(
          style: TextStyle(
            color: Colors.white,
            fontSize: descriptionFontSize
          ),
          text: todo.description,
        ),
        textAlign: TextAlign.justify,
        textDirection: TextDirection.ltr,
      );


      tp.layout(maxWidth: size.width / 1.35);
      final position = Offset(
        size.width / 3 - (tp.width / 6),
        circleCenter.dy - (tp.height / 2),
      );

      tp.paint(canvas, position);
    }

    //Draw The date of note.
    {
      final tp = TextPainter(
        maxLines: 1,
        text: TextSpan(
          style: TextStyle(
            color: Colors.white,
            fontSize: dateFontSize,
          ),
          text: todo.getFormatedDate,
        ),
        textDirection: TextDirection.ltr,
      );

      tp.layout(maxWidth: size.width / 1.5);
      final position = Offset(
        260,
        size.height - (tp.height) - 4,
      );

      tp.paint(canvas, position);
    }
  }

  @override
  bool shouldRepaint(NoteWidgetPainter old) {
    return old.todo != todo;
  }
}
