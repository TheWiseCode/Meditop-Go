import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:meditop_go/src/models/user.dart';
import 'package:meditop_go/src/services/auth.dart';
import 'package:provider/provider.dart';

class ConsultPage extends StatefulWidget {
  String link;

  ConsultPage(this.link);

  @override
  _ConsultPageState createState() => _ConsultPageState();
}

class _ConsultPageState extends State<ConsultPage> {
  @override
  void initState() {
    super.initState();
    JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError));
    _joinMeeting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: Text("Consulta")),
        body: Center(
            child: RaisedButton(
              child: Text('Atras'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )));
  }

  _joinMeeting() async {
    String server = "https://meet.jit.si/";
    String room = widget.link.substring(server.length, widget.link.length);
    User? user = Provider
        .of<Auth>(context, listen: false)
        .user;
    String name = user!.name + " " + user.lastName;
    String email = user.email;

    Map<FeatureFlagEnum, bool> featureFlags = {
      FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
    };
    if (Platform.isAndroid) {
      featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      featureFlags[FeatureFlagEnum.INVITE_ENABLED] = false;
      featureFlags[FeatureFlagEnum.RECORDING_ENABLED] = false;
      featureFlags[FeatureFlagEnum.ADD_PEOPLE_ENABLED] = false;
    } else if (Platform.isIOS) {
      featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
    } else {
      featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
    }
    // Define meetings options here
    var options = JitsiMeetingOptions(room: room)
      ..serverURL = "https://meet.jit.si"
      ..subject = "Consulta medica"
      ..userDisplayName = name
      ..userEmail = email
    //..iosAppBarRGBAColor = iosAppBarRGBAColor.text
      ..audioOnly = false
      ..audioMuted = false
      ..videoMuted = false
      ..featureFlags.addAll(featureFlags);

    debugPrint("JitsiMeetingOptions: $options");
    await JitsiMeet.joinMeeting(
      options,
      listener: JitsiMeetingListener(
          onConferenceWillJoin: (message) {
            debugPrint("${options.room} will join with message: $message");
          },
          onConferenceJoined: (message) {
            debugPrint("${options.room} joined with message: $message");
            print(options.userDisplayName);
          },
          onConferenceTerminated: (message) {
            debugPrint("${options.room} terminated with message: $message");
          },
          genericListeners: [
            JitsiGenericListener(
                eventName: 'readyToClose',
                callback: (dynamic message) {
                  debugPrint("readyToClose callback");
                }),
          ]),
    );
  }

  void _onConferenceWillJoin(message) {
    debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined(message) {
    debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated(message) {
    debugPrint("_onConferenceTerminated broadcasted with message: $message");
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }
}
