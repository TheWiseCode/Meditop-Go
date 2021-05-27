import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet/jitsi_meet.dart';

class MyAppJitsi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Meeting());
  }
}

class Meeting extends StatefulWidget {
  @override
  _MeetingState createState() => _MeetingState();
}

class _MeetingState extends State<Meeting> {
  final serverText = TextEditingController();
  final roomText = TextEditingController(text: "willy.room");
  final subjectText = TextEditingController(text: "Test de Reunion con Jitsi");
  final nameText = TextEditingController(text: "Usuario Tester");
  final emailText = TextEditingController(text: "user@email.com");
  final iosAppBarRGBAColor =
      TextEditingController(text: "#0080FF80"); //transparent blue
  var isAudioOnly = true;
  var isAudioMuted = true;
  var isVideoMuted = true;

  @override
  void initState() {
    super.initState();
    JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError));
  }

  @override
  void dispose() {
    super.dispose();
    JitsiMeet.removeAllListeners();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Jitsi Meet Example'),
          backgroundColor: Color.fromRGBO(0x1c, 0x4e, 0x91, 1),//#004e91
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: kIsWeb
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: width * 0.30,
                      child: meetConfig(),
                    ),
                    Container(
                        width: width * 0.60,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                              color: Colors.white54,
                              child: SizedBox(
                                width: width * 0.60 * 0.70,
                                height: width * 0.60 * 0.70,
                                child: JitsiMeetConferencing(
                                  extraJS: [
                                    // extraJs setup example
                                    '<script>function echo(){console.log("echo!!!")};</script>',
                                    '<script src="https://code.jquery.com/jquery-3.5.1.slim.js" integrity="sha256-DrT5NfxfbHvMHux31Lkhxg42LY6of8TaYyK50jnxRnM=" crossorigin="anonymous"></script>'
                                  ],
                                ),
                              )),
                        ))
                  ],
                )
              : meetConfig(),
        ),
      );
  }

  Widget meetConfig() {
    TextField colorIos = new TextField(
      controller: iosAppBarRGBAColor,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "AppBar Color(IOS only)",
          hintText: "Introducir color en RGBA Formato(HEX)"),
    );
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 16.0,
          ),
          TextField(
            controller: serverText,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "URL del servidor",
                hintText: "Dejar vacio para meet.jitsi.si"),
          ),
          SizedBox(
            height: 14.0,
          ),
          TextField(
            controller: roomText,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Nombre de la Sala",
            ),
          ),
          SizedBox(
            height: 14.0,
          ),
          TextField(
            controller: subjectText,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Tema",
            ),
          ),
          SizedBox(
            height: 14.0,
          ),
          TextField(
            controller: nameText,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Nombre a Mostrar",
            ),
          ),
          SizedBox(
            height: 14.0,
          ),
          TextField(
            controller: emailText,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Correo",
            ),
          ),
          SizedBox(
            height: 14.0,
          ),
          if (Platform.isIOS) colorIos,
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Solo audio", style: TextStyle(fontSize: 16),),
                Switch(
                  value: isAudioOnly,
                  onChanged: _onAudioOnlyChanged,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Sin Audio", style: TextStyle(fontSize: 16),),
                Switch(
                  value: isAudioMuted,
                  onChanged: _onAudioMutedChanged,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Sin Video", style: TextStyle(fontSize: 16),),
                Switch(
                  value: isVideoMuted,
                  onChanged: _onVideoMutedChanged,
                ),
              ],
            ),
          ),
          Divider(
            height: 48.0,
            thickness: 2.0,
          ),
          SizedBox(
            height: 64.0,
            width: double.maxFinite,
            child: ElevatedButton(
              onPressed: () {
                _joinMeeting();
              },
              child: Text(
                "Unirse o Crear Reunion",
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateColor.resolveWith((states) => Theme.of(context).primaryColor)),
            ),
          ),
          SizedBox(
            height: 24.0,
          ),
        ],
      ),
    );
  }

  _onAudioOnlyChanged(var value) {
    setState(() {
      isAudioOnly = value;
    });
  }

  _onAudioMutedChanged(var value) {
    setState(() {
      isAudioMuted = value;
    });
  }

  _onVideoMutedChanged(var value) {
    setState(() {
      isVideoMuted = value;
    });
  }

  _joinMeeting() async {
    String serverUrl = serverText.text.trim().isEmpty ? "" : serverText.text;

    // Enable or disable any feature flag here
    // If feature flag are not provided, default values will be used
    // Full list of feature flags (and defaults) available in the README
    Map<FeatureFlagEnum, bool> featureFlags = {
      FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
    };
    if (!kIsWeb) {
      // Here is an example, disabling features for each platform
      if (Platform.isAndroid) {
        // Disable ConnectionService usage on Android to avoid issues (see README)
        featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      } else if (Platform.isIOS) {
        // Disable PIP on iOS as it looks weird
        featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
      }
    }

    String servURL = serverUrl;
    if(servURL.isNotEmpty){
      if(!servURL.startsWith("https://"))
        servURL = "https://" + servURL;
    }else{
      servURL ="https://meet.jit.si";
    }
    // Define meetings options here
    var options = JitsiMeetingOptions(room: roomText.text)
      ..serverURL = servURL
      //..serverURL = "https://meet.jit.si"
      //..serverURL = "https://meet.golem.de"
      ..subject = subjectText.text
      ..userDisplayName = nameText.text
      ..userEmail = emailText.text
      ..iosAppBarRGBAColor = iosAppBarRGBAColor.text
      ..audioOnly = isAudioOnly
      ..audioMuted = isAudioMuted
      ..videoMuted = isVideoMuted
      ..featureFlags.addAll(featureFlags)
      ..webOptions = {
        "roomName": roomText.text,
        "width": "100%",
        "height": "100%",
        "enableWelcomePage": false,
        "chromeExtensionBanner": null,
        "userInfo": {"displayName": nameText.text}
      };

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
