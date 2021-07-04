import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gradient_input_border/gradient_input_border.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:reminder/Model/notes.dart';
import '../controlNotification.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';


class AddReminder extends StatelessWidget {

  final String appBarTitle;

  final Todo todo;
  final Map<String, dynamic> row;
  final GlobalKey<ScaffoldState> scaffold;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final reminderController = TextEditingController();

  AddReminder({Key key, this.row, this.scaffold}) :
        appBarTitle = row == null ? 'Add Note' : 'Edit Note',
        todo = row == null ? Todo() : Todo.fromRow(row),
        super(key: key){
    titleController.text = todo.title;
    descriptionController.text = todo.description;
    reminderController.text = todo.getFormatedDate;
  }

  final _formKey = GlobalKey<FormState>();



  Future<void> saveTodo(BuildContext context) async {

    Todos builder = context.read<Todos>();

    todo
      ..title = titleController.text
      ..description = descriptionController.text;

    int id;

    if (appBarTitle == 'Add Note')
      id = await builder.add(todo);
    else
      id = await builder.update(todo);

    if (todo.reminder != null) {
      final dateTime = DateTime.tryParse(todo.reminder);
      final controlNotification = ControlNotification(context);
      controlNotification.pushScheduledNotification(
        id: id,
        title: todo.title,
        body: todo.description,
        dateTime: dateTime,
      );
    } else {
      final controlNotification = ControlNotification(context);
      controlNotification.cancelNotification(todo.id);
    }

    Navigator.pop(context);

    scaffold?.currentState?.showSnackBar(
      SnackBar(
        content: Text('Saved'),
      ),
    );
  }

  Future<void> onPop(BuildContext context) async {

    await showDialog(
        context: context, builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text('Do you want to save changes ?'),
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
            if (_formKey.currentState.validate()) {
            await saveTodo(context);
            Navigator.of(context).pop();
            }else{
              Navigator.of(context).pop();
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text('Save Data')));
            }
          },
        ),
      ],
    )
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await onPop(context);
        return true;
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.black45,
          body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/note.jpg'),
                    colorFilter:
                    ColorFilter.mode(Colors.grey.withOpacity(0.3),
                        BlendMode.dstATop),
                    fit: BoxFit.fill
                ),
                gradient: LinearGradient(
                    colors: [Color.fromRGBO(0, 0, 0, 1),Color.fromRGBO(999, 999, 999, 1)],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp)
            ),
            child:ListView(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/30),
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.arrow_back),
                      onPressed: () async {
                        onPop(context);
                      },
                    ),
                    Text(appBarTitle,
                        style:
                        TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0)
                    ),
                    if (row != null)
                      IconButton(
                        color: Colors.white,
                        icon: Icon(Icons.delete_forever),
                        onPressed: () async {
                          await showDialog(
                            context: context, builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            title: Text('Do you want to delete this note ?'),
                            actions: [
                              FlatButton(
                                child: Text('Yes', style: TextStyle(color: Colors.black)),
                                onPressed: () async {
                                  await Provider.of<Todos>(context, listen: false)
                                      .remove(todo);
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text('No' , style: TextStyle(color: Colors.black),),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          ),
                          );
                          Navigator.pop(context);
                        },
                      ),
                    if (row != null) SizedBox(width: 5),
                    IconButton(
                      icon: Icon(
                        Icons.save,
                        color: Colors.black54,
                      ),
                      onPressed: () async{
                        if (_formKey.currentState.validate()) {
                          await saveTodo(context);
                          // Navigator.of(context)..pop()..pop();
                        }else{
                          Scaffold.of(context)
                              .showSnackBar(SnackBar(content: Text('Save Data')));
                          // Navigator.of(context)..pop()..pop();
                        }
                      }
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height/20,
                      left: MediaQuery.of(context).size.height/80,
                      bottom: MediaQuery.of(context).size.height/50
                  ),
                  child: Row(
                    children: [
                      Text( 'Title',
                        style: TextStyle(fontSize: 14 , color: Colors.white70, fontWeight: FontWeight.w700, ),
                      ),
                      Text( ' *',
                        style: TextStyle(fontSize: 14 , color: Colors.red, fontWeight: FontWeight.w700, ),
                      ),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.height/60,
                    right: MediaQuery.of(context).size.height/60
                ),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      style: TextStyle(color: Colors.white70),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter title';
                        }
                        return null;
                      },
                      controller: titleController,
                      decoration: InputDecoration(
                        fillColor: Colors.white70,
                        labelText: 'Enter the Title',
                        labelStyle: TextStyle(color: Colors.white.withOpacity(0.4) ),
                        border: GradientOutlineInputBorder(
                          focusedGradient: LinearGradient(
                            colors: [Color.fromRGBO(999, 999, 999, 1),Color.fromRGBO(0, 0, 0, 1)],),
                          unfocusedGradient: LinearGradient(
                            colors: [Color.fromRGBO(999, 999, 999, 1),Color.fromRGBO(0, 0, 0, 1)],),
                        ),
                      ),
                      cursorColor: Colors.white70,
                      cursorHeight: 25,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height/20,
                      left: MediaQuery.of(context).size.height/80,
                      bottom: MediaQuery.of(context).size.height/50
                  ),
                  child: Text( 'Description',
                    style: TextStyle(fontSize: 14 , color: Colors.white70, fontWeight: FontWeight.w700, ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.height/60,
                    right: MediaQuery.of(context).size.height/60
                ),
                  child: TextField(
                    style: TextStyle(color: Colors.white70),
                    controller: descriptionController,
                    decoration: InputDecoration(
                      fillColor: Colors.white70,
                      border: GradientOutlineInputBorder(
                        focusedGradient: LinearGradient(
                          colors: [Color.fromRGBO(999, 999, 999, 1),Color.fromRGBO(0, 0, 0, 1)],),
                        unfocusedGradient: LinearGradient(
                          colors: [Color.fromRGBO(999, 999, 999, 1),Color.fromRGBO(0, 0, 0, 1)],),
                      ),
                    ),
                    cursorColor: Colors.white70,
                    cursorHeight: 25,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height/20,
                      left: MediaQuery.of(context).size.height/80,
                      bottom: MediaQuery.of(context).size.height/50
                  ),
                  child: Text(
                    'Reminde me at :',
                    style: TextStyle(fontSize: 14 , color: Colors.white70, fontWeight: FontWeight.w700,),
                  ),
                ),
                DateAndTimePicker(
                  todo,
                  controller: reminderController,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height/20,
                      left: MediaQuery.of(context).size.height/80,
                      bottom: MediaQuery.of(context).size.height/50
                  ),
                  child: Text(
                    'Priority',
                    style: TextStyle(fontSize: 14 , color: Colors.white70),
                  ),
                ),
                MyToggleButtons(todo),
              ],
            ),
          )
      ),
    );
  }
}

class MyToggleButtons extends StatefulWidget {
  final Todo todo;

  MyToggleButtons(this.todo, {Key key})
      : assert(todo != null),
        super(key: key);
  @override
  _MyToggleButtonsState createState() => _MyToggleButtonsState();
}

class SelectedButton extends StatelessWidget {
  final bool isEnabled;
  final Color disabledColor;
  final String label;
  final IconData iconData;
  final int index;
  final Function(int index) setValue;

  const SelectedButton({
    Key key,
    @required this.index,
    @required this.setValue,
    @required this.iconData,
    this.label = '',
    this.isEnabled = false,
    this.disabledColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
        side: BorderSide(width: 1, color: Colors.grey),
      ),
      color: isEnabled ? Colors.black26 : Colors.white,
      icon: Icon(
        iconData,
        color: isEnabled ? Colors.white : disabledColor,
      ),
      label: Text(
        label,
        style: TextStyle(color: isEnabled ? Colors.white : Colors.black),
      ),
      onPressed: () => setValue(index),
    );
  }
}

class _MyToggleButtonsState extends State<MyToggleButtons> {
  List<bool> _values = [false, false, false];

  void setValue(int index) {
    setState(() {
      _values = [false, false, false];
      _values[index] = true;
      widget.todo.priority = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _values[widget.todo.priority] = true;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SelectedButton(
            isEnabled: _values[0],
            iconData: Icons.arrow_downward,
            index: 0,
            disabledColor: Colors.green,
            setValue: setValue,
            label: 'Low',
          ),
        ),
        VerticalDivider(
          width: 10,
        ),
        Expanded(
          flex: 3,
          child: SelectedButton(
            isEnabled: _values[1],
            iconData: MdiIcons.alertOctagonOutline,
            index: 1,
            disabledColor: Colors.yellow,
            setValue: setValue,
            label: 'Medium',
          ),
        ),
        VerticalDivider(
          width: 10,
        ),
        Expanded(
          flex: 2,
          child: SelectedButton(
            isEnabled: _values[2],
            iconData: Icons.arrow_upward_sharp,
            index: 2,
            disabledColor: Colors.red,
            setValue: setValue,
            label: 'High',
          ),
        ),
      ],
    );
  }
}

///Pick a Date & Time for [note.reminder].
class DateAndTimePicker extends StatefulWidget {
  final Todo todo;
  final TextEditingController controller;

  DateAndTimePicker(
      this.todo, {
        Key key,
        TextEditingController controller,
      })  : assert(todo != null),
        this.controller = controller ?? TextEditingController(),
        super(key: key);

  @override
  _DateAndTimePickerState createState() => _DateAndTimePickerState();
}

class _DateAndTimePickerState extends State<DateAndTimePicker> {
  DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.todo.getReminder ?? DateTime.now();
  }

  Future<void> showDateThanTime() async {
    //If the user click the cancel button , the value of [tempDate] will be [null].
    final DateTime tempDate = await showDatePicker(
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light().copyWith(
              primary: Colors.black87,
            ),
          ),
          child: child,
        );
      },
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (tempDate == null) return;

    //If the user click the cancel button , the value of [tempTime] will be [null].
    TimeOfDay tempTime = await showTimePicker(
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light().copyWith(
              primary: Colors.black87,
            ),
          ),
          child: child,
        );
      },
      context: context,
      initialTime: TimeOfDay(
        hour: selectedDate.hour,
        minute: selectedDate.minute,
      ),
    );

    if (tempTime == null) return;

    selectedDate = DateTime(
      tempDate.year,
      tempDate.month,
      tempDate.day,
      tempTime.hour,
      tempTime.minute,
    );

    widget.todo.reminder = selectedDate.toString();

    setState(() {
      widget.controller.text = widget.todo.getFormatedDate;
    });
  }

  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.height/60,
        right: MediaQuery.of(context).size.height/60
    ),
          child: TextField(
            style: TextStyle(color: Colors.white70),
            readOnly: true,
            controller: widget.controller,
            decoration: InputDecoration(
              border: GradientOutlineInputBorder(
                focusedGradient: LinearGradient(
                  colors: [Color.fromRGBO(999, 999, 999, 1),Color.fromRGBO(0, 0, 0, 1)],),
                unfocusedGradient: LinearGradient(
                  colors: [Color.fromRGBO(999, 999, 999, 1),Color.fromRGBO(0, 0, 0, 1)],),
              ),
              suffixIcon:
              Icon((widget.todo.reminder == '' ? Icons.date_range : Icons.close),color: Colors.black54,)),
            onTap: widget.todo.reminder == ''
                ? showDateThanTime
                : () {
              setState(() {
                widget.todo.reminder = '';
                widget.controller.text = '';
                final controlNotification = ControlNotification(context);
                controlNotification.cancelNotification(widget.todo.id);
              }
              );
            },
          ),
    );
  }
}