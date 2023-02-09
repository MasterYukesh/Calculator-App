import 'package:calculator_application/extra_buttons.dart';
import 'package:flutter/material.dart';
import 'calci_buttons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}

class _MyApp extends State<MyApp> {
  int flag1 = 0; // for num1
  int flag2 = 0; // for num2
  int flag3 = 0; // for C
  double fontsize = 25;
  double boxsize = 90;
  bool visibility = false;
  late int x;
  late double num1;
  late double num2;
  String result = ''; // will store the value of intermediate results
  String prevbtn = ''; // will store the last button tapped
  String operation = ''; //holds mathematical operation

  String textodisplay = ''; // the result which will be seen by the user
  String history = ''; // history of all the buttons clickesd
  void expandfunction(String txt) {
    setState(() {
      if (txt == '\u2922') {
        // only if the expand button is clicked!
        visibility = !visibility;
        if (visibility) {
          fontsize = 15;
          boxsize = 75;
        } else {
          fontsize = 25;
          boxsize = 90;
        }
      }
    });
  }

  void calcifunction(String txt) {
    if (txt == 'AC') {
      num1 = 0;
      num2 = 0;
      result = '';
      operation = '';
      textodisplay = '';
      history = '';
      flag1 = 0;
      flag2 = 0;
      prevbtn = '';
    } else if (txt == 'C') {
      flag3 = 1;
      flag1 = 0;
      flag2 = 0;
    } else if (txt == '%' ||
        txt == 'x' ||
        txt == '-' ||
        txt == '+' ||
        txt == '\u00F7') {
      // 3 conditions , either if the operation is performed at the begining or after another operation or in between:
      // for the starting
      if (history == '') {
        if (txt != 'x' && txt != '+' && txt != '%' && txt != '\u00F7') {
          flag1 = 0;
          flag2 = 0;
          history = textodisplay + txt;
          operation = txt;
        }
      } else {
        // after another operation
        if (prevbtn == 'x' ||
            prevbtn == '-' ||
            prevbtn == '+' ||
            prevbtn == '\u00F7') {
          //just change the operation
          history = history.substring(0, history.length - 1) + txt;
        } else {
          // if pressed in between
          //updating all the flags to 0
          flag1 = 0;
          flag2 = 0;
          // if it is not the first operation
          if (result != '') {
            history += txt;
            // storing the result of the first operation as num1 for the next operation (i.e,  the current button)
            num1 = double.parse(result);
            //result = '';
          } else {
            // if it is the first operation
            history += txt;
          }
          // updating the operation value
          operation = txt;
        }
        if (operation == '%') {
          if (prevbtn == 'C') {
            // if the previous button was 'C', then perform the % on the previously achieved result
            result = (double.parse(result) / 100).toStringAsFixed(3).toString();
            // storing the result of the first operation as num1 for the next operation (i.e,  the current button)
            num1 = double.parse(result);
          } else {
            // if the previous button was not 'C'
            if (result == '') {
              // if this is the first operation performed
              result = (num1 / 100).toStringAsFixed(3).toString();
            } else {
              // if it is not the first operation
              result =
                  (double.parse(result) / 100).toStringAsFixed(3).toString();
              num1 = double.parse(result);
            }
          }
        }
      }
    } else if (txt == '=') {
      if (result != '') {
        //updating the history and the num1
        history = result;
        num1 = double.parse(result);
        flag2 = 0;
        flag1= 1;
      }
    } else {
      // if a number or a decimal is pressed.
      if (prevbtn != '=') {
        if (history == '') {
          // if it is the first number
          if (prevbtn == '' || history == '-') {
            // checking again for fisrt number or number after the negative sign
            history += txt;
            num1 = double.parse(history);
            // changing flag1 to make sure the next consecutive number is also in num1 only
            flag1 = 1;
          }
        } else {
          // if it is not the first number
          history += txt;
          if (flag1 == 1) {
            // since it is the first number then the history will have the string of digits of the first num only.
            num1 = double.parse(history);
          }
          if (prevbtn == 'x' ||
              prevbtn == '\u00F7' ||
              prevbtn == '+' ||
              prevbtn == '-' ||
              prevbtn == '%' ||
              prevbtn == 'C') {
                // if the prevbtn is some operator then setting flag2 
                // changing flag2 to make sure the next consecutive number is also in num2 only
            flag2 = 1;
            if (prevbtn != 'C') {
              // if the prevbtn is other than C but some operator then setting x to the index position of the first digit of the 2nd number 
              x = history.length - 1;
            }
          }
          if (flag2 == 1) {
            num2 = double.parse(history.substring(x));
            if (operation == 'x' || prevbtn == '%') {
              if (prevbtn == '%') {
                operation = 'x';
              }
              result = (num1 * num2).toStringAsFixed(3).toString();
            } else if (operation == '-') {
              result = (num1 - num2).toStringAsFixed(3).toString();
            } else if (operation == '+') {
              result = (num1 + num2).toStringAsFixed(3).toString();
            } else if (operation == '\u00F7') {
              result = (num1 / num2).toStringAsFixed(3).toString();
            }
          }
        }
      } else {
        // in case if the previous button was '='
        // clear and start fresh with current button
        history = txt;
        textodisplay = '';
        result = '';
      }
    }
    setState(() {
      history = history;
      if (history.isNotEmpty) {
        // updating the prevbtn
        prevbtn = history[history.length - 1];
      }
      if (flag3 == 1) {
        // if flag3 is 1 then , its means the btn pressed is 'C'
        //clear the text but not the result
        textodisplay = '';
        flag3 = 0;
        prevbtn = 'C';
      } else {
        // else then just update the result.
        textodisplay = result;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text(
            'Calculator',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 45, color: Colors.black),
          ),
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Container(
            child: Text(
              history,
              style: const TextStyle(color: Colors.orangeAccent, fontSize: 35),
              textAlign: TextAlign.end,
            ),
            alignment: const Alignment(1, 0),
          ),
          Container(
            child: Text(textodisplay,
                style: const TextStyle(color: Colors.lightBlue, fontSize: 25),
                textAlign: TextAlign.end),
            alignment: const Alignment(1, 0),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ExtraButtons(
                isvisible: visibility, text: 'cos', expandfn: expandfunction),
            ExtraButtons(
                isvisible: visibility, text: 'log', expandfn: expandfunction),
            ExtraButtons(
                isvisible: visibility, text: '(', expandfn: expandfunction),
            ExtraButtons(
                isvisible: visibility, text: ')', expandfn: expandfunction),
            ExtraButtons(
                isvisible: visibility, text: 'DEG', expandfn: expandfunction),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ExtraButtons(
                isvisible: visibility, text: 'sin', expandfn: expandfunction),
            ExtraButtons(
                isvisible: visibility, text: 'tan', expandfn: expandfunction),
            ExtraButtons(
                isvisible: visibility,
                text: '\u221A',
                expandfn: expandfunction),
            ExtraButtons(
                isvisible: visibility, text: 'ln', expandfn: expandfunction),
            ExtraButtons(
                isvisible: visibility, text: 'INV', expandfn: expandfunction),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CalciButtons(
                text: 'AC',
                callback: calcifunction,
                fontsize: fontsize,
                size: boxsize,
              ),
              CalciButtons(
                text: 'C',
                callback: calcifunction,
                fontsize: fontsize,
                size: boxsize,
              ),
              CalciButtons(
                text: '%',
                callback: calcifunction,
                fontsize: fontsize,
                size: boxsize,
              ),
              ExtraButtons(
                  isvisible: visibility,
                  text: '\u03C0',
                  expandfn: expandfunction),
              CalciButtons(
                text: '\u00F7',
                callback: calcifunction,
                fontsize: fontsize,
                size: boxsize,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CalciButtons(
                text: '7',
                callback: calcifunction,
                fontsize: fontsize,
                size: boxsize,
              ),
              CalciButtons(
                text: '8',
                callback: calcifunction,
                fontsize: fontsize,
                size: boxsize,
              ),
              CalciButtons(
                text: '9',
                callback: calcifunction,
                fontsize: fontsize,
                size: boxsize,
              ),
              ExtraButtons(
                  isvisible: visibility, text: 'e', expandfn: expandfunction),
              CalciButtons(
                text: 'x',
                callback: calcifunction,
                fontsize: fontsize,
                size: boxsize,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CalciButtons(
                text: '4',
                callback: calcifunction,
                fontsize: fontsize,
                size: boxsize,
              ),
              CalciButtons(
                text: '5',
                callback: calcifunction,
                fontsize: fontsize,
                size: boxsize,
              ),
              CalciButtons(
                text: '6',
                callback: calcifunction,
                fontsize: fontsize,
                size: boxsize,
              ),
              ExtraButtons(
                  isvisible: visibility, text: 'n!', expandfn: expandfunction),
              CalciButtons(
                text: '-',
                callback: calcifunction,
                fontsize: fontsize,
                size: boxsize,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CalciButtons(
                text: '1',
                callback: calcifunction,
                fontsize: fontsize,
                size: boxsize,
              ),
              CalciButtons(
                text: '2',
                callback: calcifunction,
                fontsize: fontsize,
                size: boxsize,
              ),
              CalciButtons(
                text: '3',
                callback: calcifunction,
                fontsize: fontsize,
                size: boxsize,
              ),
              ExtraButtons(
                  isvisible: visibility, text: '^', expandfn: expandfunction),
              CalciButtons(
                text: '+',
                callback: calcifunction,
                fontsize: fontsize,
                size: boxsize,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CalciButtons(
                text: '\u2922',
                callback: expandfunction,
                fontsize: fontsize,
                size: boxsize,
              ),
              CalciButtons(
                text: '0',
                callback: calcifunction,
                fontsize: fontsize,
                size: boxsize,
              ),
              CalciButtons(
                text: '.',
                callback: calcifunction,
                fontsize: fontsize,
                size: boxsize,
              ),
              ExtraButtons(
                  isvisible: visibility, text: '', expandfn: expandfunction),
              CalciButtons(
                text: '=',
                callback: calcifunction,
                fontsize: fontsize,
                size: boxsize,
              ),
            ],
          )
        ]),
      ),
    );
  }
}
