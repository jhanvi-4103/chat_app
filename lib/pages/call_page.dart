import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kd_chat/components/const.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPage extends StatelessWidget {
  const CallPage({super.key, required this.callID});
  final String callID;

  @override
  Widget build(BuildContext context) {
    int userId = Random().nextInt(100000);

    return ZegoUIKitPrebuiltCall(
      appID: appId, 
      appSign: appSignIn, 
      userID: userId.toString(),
      userName: 'user$userId',
      callID: callID,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
        ..onOnlySelfInRoom = () {
          Navigator.pop(context, callID); 
        },
    );
  }
}

extension on ZegoUIKitPrebuiltCallConfig {
  set onOnlySelfInRoom(Null Function() onOnlySelfInRoom) {}
}
