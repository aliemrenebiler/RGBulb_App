import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../database/methods.dart';
import '../database/theme.dart';
import '../database/variables.dart';

class ControlScreen extends StatelessWidget {
  const ControlScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor1,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        primary: false,
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const TopHeader(),
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const OpenBox(),
                  StreamBuilder<Object>(
                    stream: statusStream,
                    builder: (context, snapshot) {
                      if (snapshot.data == true) {
                        return const SetBox();
                      } else {
                        return Container();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopHeader extends StatelessWidget {
  const TopHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 2 / 5,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            child: Text(
              "CONNECTION",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: headerColor1,
                fontWeight: FontWeight.bold,
                fontSize: headerSize,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              GoBackButton(),
            ],
          ),
        ],
      ),
    );
  }
}

class GoBackButton extends StatelessWidget {
  const GoBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacementNamed(context, '/connectscreen');
      },
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.only(right: 16, left: 16),
        height: 40,
        decoration: BoxDecoration(
          color: appYellow,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Text(
              "GO BACK",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: appDarkGrey,
                fontWeight: FontWeight.bold,
                fontSize: textSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OpenBox extends StatelessWidget {
  const OpenBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(18)),
        color: bgColor2,
      ),
      child: StreamBuilder<Object>(
        stream: statusStream,
        builder: (context, snapshot) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  child: Text(
                    (snapshot.data == true) ? "Bulb is ON" : "Bulb is OFF",
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: headerColor1,
                      fontWeight: FontWeight.bold,
                      fontSize: textSize,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (snapshot.data == true) {
                    turnOffBulb();
                  } else {
                    turnOnBulb();
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.only(right: 16, left: 16),
                  height: 40,
                  decoration: BoxDecoration(
                    color: (snapshot.data == true) ? appRed : appYellow,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    (snapshot.data == true) ? "TURN OFF" : "TURN ON",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: (snapshot.data == true) ? appWhite : appDarkGrey,
                      fontWeight: FontWeight.bold,
                      fontSize: textSize,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class SetBox extends StatelessWidget {
  const SetBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(18)),
        color: bgColor2,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            alignment: Alignment.bottomLeft,
            child: Text(
              "Current Color",
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: headerColor1,
                fontWeight: FontWeight.bold,
                fontSize: textSize,
              ),
            ),
          ),
          ColorPicker(
            enableAlpha: false,
            // ignore: deprecated_member_use
            showLabel: false,
            colorPickerWidth: MediaQuery.of(context).size.width,
            paletteType: PaletteType.hueWheel,
            pickerColor: pickerColor,
            onColorChanged: changeColor,
          ),
        ],
      ),
    );
  }
}
