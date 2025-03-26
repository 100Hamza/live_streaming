import 'package:flutter/material.dart';
import 'package:live_streaming/page/home_view.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ZegoUIKit().initLog().then((value) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: ZegoUIKitPrebuiltLiveStreamingMiniPopScope(

          child: const HomeView()),
      navigatorKey: navigatorKey,
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            ///  Step 3/3: Insert ZegoUIKitPrebuiltLiveStreamingMiniOverlayPage into Overlay, and return the context of NavigatorState in contextQuery.
            ZegoUIKitPrebuiltLiveStreamingMiniOverlayPage(
              contextQuery: () {
                return navigatorKey.currentState!.context;
              },
            ),
          ],
        );
      },
    );
  }
}
