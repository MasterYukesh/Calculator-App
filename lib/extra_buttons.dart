import 'package:flutter/material.dart';

class ExtraButtons extends StatelessWidget {
  final bool isvisible;
  final String text;
  final Function expandfn;
  const ExtraButtons({
    Key? key,
    required this.isvisible,
    required this.text,
    required this.expandfn,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: isvisible,
        child:
         SizedBox(
          height: 70,
          width: 70,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              alignment: Alignment.center,
              primary: Colors.transparent,
              onPrimary: Colors.white12,
            ),
            onPressed: () => expandfn(text),
            child: Text(
              text,
              style: const TextStyle(
                  color: Colors.lightGreen,
                  fontSize: 15,
                  backgroundColor: Colors.black),
            ),
          ),
        ));
  }
}
