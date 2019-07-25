import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:store_stockroom/home_screen.dart';

import '../env.dart';
import '../themes/helpers/buttons.dart';
import '../themes/helpers/theme_colors.dart';
import 'done_dialog.dart';

class DeleteDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 10,
      contentPadding:
          const EdgeInsets.only(top: 20.0, right: 40, left: 40, bottom: 20.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: SingleChildScrollView(
        child: Container(
          width: Environment().getWidth(width: 10.0),
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Icon(
                    Icons.warning,
                    size: 50,
                    color: Colors.orange,
                  ),
                  Text(
                    'Are you sure?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontFamily: 'Avenir'),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CustomButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      textButton: 'Cancel',
                      colorButton: cancelColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    CustomButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageTransition(
                              child: HomeScreen(),
                              type: PageTransitionType.fade,
                            ));
                      },
                      textButton: 'Yes',
                      colorButton: removeColor,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}