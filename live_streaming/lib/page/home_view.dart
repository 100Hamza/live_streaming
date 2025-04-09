import 'dart:math';

import 'package:flutter/material.dart';
import 'package:live_streaming/page/live_page_view.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String userId = Random().nextInt(1000).toString();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home'), centerTitle: true,),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {

              if (ZegoUIKitPrebuiltLiveStreamingController().minimize.isMinimizing) {
                /// when the application is minimized (in a minimized state),
                /// disable button clicks to prevent multiple PrebuiltLiveStreaming components from being created.
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => LivePage(liveID: 'testLiveId',userId: userId ,isHost: true),
                ),
              );
            },
            child: Text('Live'),
          ),
          SizedBox(height: 18),
          ElevatedButton(
            onPressed: () {
              if (ZegoUIKitPrebuiltLiveStreamingController().minimize.isMinimizing) {
                /// when the application is minimized (in a minimized state),
                /// disable button clicks to prevent multiple PrebuiltLiveStreaming components from being created.
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LivePage(liveID: 'testLiveId',userId: userId),
                ),
              );
            },
            child: Text('Watch'),
          ),
        ],
      ),
    );
  }
}
