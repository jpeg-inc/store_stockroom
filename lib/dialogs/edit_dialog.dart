import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:store_stockroom/env.dart';
import 'package:store_stockroom/themes/helpers/buttons.dart';
import 'package:store_stockroom/themes/helpers/fonts.dart';
import 'package:store_stockroom/themes/helpers/theme_colors.dart';

class EditDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 10,
      contentPadding:
          const EdgeInsets.only(top: 20.0, right: 40, left: 40, bottom: 20.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: Container(
        width: Environment().getWidth(width: 10),
        height: Environment().getHeight(height: 7),
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  "Edit Product",
                  style: font20Black,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: FormBuilderTextField(
                attribute: "quantity",
                style: font15Grey,
                decoration: InputDecoration(
                  labelText: "Quantity",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CustomButton(
                    onPressed: () {},
                    textButton: 'Save',
                    colorButton: confirmColor,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
