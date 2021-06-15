import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:meditop_go/src/components/rounded_button.dart';
import 'package:meditop_go/src/components/rounded_input_field.dart';
import 'package:meditop_go/src/models/user.dart';
import 'package:meditop_go/src/services/auth.dart';
import 'package:provider/provider.dart';

class MeetPage extends StatefulWidget {
  @override
  _MeetPageState createState() => _MeetPageState();
}

class _MeetPageState extends State<MeetPage> {
  final serverText = TextEditingController();
  final subjectText = TextEditingController(text: "Test de Reunion con Jitsi");
  late TextEditingController nameText;
  late TextEditingController roomText;
  late TextEditingController emailText;
  final iosAppBarRGBAColor =
      TextEditingController(text: "#0080FF80"); //transparent blue
  var isAudioOnly = true;
  var isAudioMuted = true;
  var isVideoMuted = true;

  @override
  void initState() {
    User? user = Provider.of<Auth>(context, listen: false).user;
    nameText = TextEditingController(text: user!.name + " " + user.lastName);
    emailText = TextEditingController(text: user.email);
    //roomText = TextEditingController(text: "room.room");
    roomText = TextEditingController(text: user.name+".room");
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
        title: const Text('Consulta Médica'),
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
        children: [
          SizedBox(
            height: 16.0,
          ),
          RoundedInputField(
              width: double.infinity,
              controller: serverText,
              hintText: 'URL del servidor',
              icon: Icons.link),
          //Text('Nombre de la sala', textAlign: TextAlign.start),
          RoundedInputField(
              width: double.infinity,
              controller: roomText,
              hintText: 'Nombre de la sala',
              icon: Icons.text_fields),
          RoundedInputField(
              width: double.infinity,
              controller: subjectText,
              hintText: 'Tema',
              icon: Icons.subject),
          RoundedInputField(
              width: double.infinity,
              controller: nameText,
              hintText: 'Nombre a mostrar',
              icon: Icons.person),
          RoundedInputField(
              width: double.infinity,
              controller: emailText,
              hintText: 'Correo electronico',
              icon: Icons.alternate_email),
          SizedBox(
            height: 14.0,
          ),
          if (Platform.isIOS) colorIos,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Solo audio",
                  style: TextStyle(fontSize: 16),
                ),
                FlutterSwitch(
                  width: 55.0,
                  height: 25.0,
                  toggleSize: 18,
                  value: isAudioOnly,
                  onToggle: _onAudioOnlyChanged,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Sin Audio",
                  style: TextStyle(fontSize: 16),
                ),
                FlutterSwitch(
                  width: 55.0,
                  height: 25.0,
                  toggleSize: 18,
                  value: isAudioMuted,
                  onToggle: _onAudioMutedChanged,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Sin Video",
                  style: TextStyle(fontSize: 16),
                ),
                FlutterSwitch(
                  width: 55.0,
                  height: 25.0,
                  toggleSize: 18,
                  value: isVideoMuted,
                  onToggle: _onVideoMutedChanged,
                ),
              ],
            ),
          ),
          Divider(
            height: 24.0,
            thickness: 1.0,
          ),
          RoundedButton(
            text: 'Entrar o crear Reunion',
            press: () => _joinMeeting()
          ),
          SizedBox(
            height: 12.0,
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
      }else{
        featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      }
    }

    String servURL = serverUrl;
    if (servURL.isNotEmpty) {
      if (!servURL.startsWith("https://")) servURL = "https://" + servURL;
    } else {
      servURL = "https://meet.jit.si";
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
