import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rgb_bulb_app/database/theme.dart';

import '../database/mqtt.dart' as mqtt;
import '../database/variables.dart';

class ConnectScreen extends StatelessWidget {
  const ConnectScreen({Key? key}) : super(key: key);

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
                  const ConnectBox(),
                  StreamBuilder<Object>(
                    stream: connectionStream,
                    builder: (context, snapshot) {
                      if (snapshot.data == true) {
                        return const ControlBox();
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
              StatusBox(),
            ],
          ),
        ],
      ),
    );
  }
}

class StatusBox extends StatelessWidget {
  const StatusBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: connectionStream,
      builder: (context, snapshot) {
        return Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.only(right: 16, left: 16),
          height: 40,
          decoration: BoxDecoration(
            color: (snapshot.data == true) ? appYellow : appLightGrey,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Text(
                (snapshot.data == true) ? "Connected" : "Not Connected",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: (snapshot.data == true) ? appDarkGrey : appGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: textSize,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ConnectBox extends StatelessWidget {
  const ConnectBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(18)),
        color: bgColor2,
      ),
      child: StreamBuilder<Object>(
        stream: connectionStream,
        builder: (context, snapshot) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  child: Text(
                    (snapshot.data == true)
                        ? "Bulb is connected!"
                        : "Connect to bulb",
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
                onTap: () async {
                  dynamic state;
                  if (snapshot.data == true) {
                    mqtt.disconnect();
                    connectionController.add(false);
                  } else {
                    try {
                      state = await mqtt.connect().timeout(
                            const Duration(seconds: 5),
                          );
                    } catch (e) {
                      state = false;
                    }

                    if (state == true) {
                      mqtt.subscribeToTopic("bulb");
                      connectionController.add(true);
                    } else {
                      connectionController.add(false);
                    }
                    connectionController.add(true);
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
                    (snapshot.data == true) ? "DISCONNECT" : "CONNECT",
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

class ControlBox extends StatelessWidget {
  const ControlBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(18)),
        color: bgColor2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8),
              child: Text(
                "Control the bulb",
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
              Navigator.pushReplacementNamed(context, '/controlscreen');
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
              child: Text(
                "CONTROL",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: appDarkGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: textSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
