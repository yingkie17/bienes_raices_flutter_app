import 'package:bienes_raices_app/assets/colors/colors.dart';
import 'package:flutter/material.dart';

class NoDataWidets extends StatelessWidget {
  String text;
  NoDataWidets({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Image.asset(
              'lib/assets/images/no-data-found.jpg',
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: ColorsTheme.primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
