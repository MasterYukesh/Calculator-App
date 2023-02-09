import 'package:flutter/material.dart';

class CalciButtons extends StatelessWidget {
  final String text;
  final Function callback;
  final double fontsize ;
  final double size;

  const CalciButtons({Key? key, required this.text, required this.callback,required this.fontsize,required this.size})
      : super(key: key);
  @override
  Widget build(BuildContext context) {    
    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                 alignment: Alignment.center,
                  primary: Colors.transparent,
                  onPrimary: Colors.white,),
              onPressed: () => {callback(text)},
              child: Text(
                text,
                style: TextStyle(
                    fontSize: fontsize,
                    color: Colors.white,
                    backgroundColor: Colors.black,
                    ),
              ))),
    );
  }
}
