import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class LivePage extends StatelessWidget {
  final String liveID;
  final bool isHost;
  final String userId;

  const LivePage({
    Key? key,
    required this.liveID,
    this.isHost = false,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: 2010646916,
        // Fill in the appID that you get from ZEGOCLOUD Admin Console.
        appSign:
            'appSign',
        // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
        userID: userId,
        userName: 'user_name_$userId',
        liveID: liveID,
        events: ZegoUIKitPrebuiltLiveStreamingEvents(
          topMenuBar: ZegoLiveStreamingTopMenuBarEvents(
            onHostAvatarClicked: (ZegoUIKitUser host) {
              // showHostInfomation(host);
            },
          ),
          onStateUpdated: (state) {
            debugPrint('+++++++++++state: $state');
          },

          // onEnded: (event, defaultAction) {
          //   Navigator.of(context).pop();
          //   debugPrint('+========event: $event');
          // },
          coHost: ZegoLiveStreamingCoHostEvents(
            onUpdated: (coHosts) {
              debugPrint('coHosts: $coHosts');
            },
            audience: ZegoLiveStreamingCoHostAudienceEvents(
              onRequestSent: () {
                debugPrint('Request sent');
              },
            ),
            onMaxCountReached: (count) {
              debugPrint('onMaxCountReached:$count');
            },
          ),

          onEnded: (
            ZegoLiveStreamingEndEvent event,
            VoidCallback defaultAction,
          ) {
            if (ZegoLiveStreamingEndReason.hostEnd == event.reason) {
              if (event.isFromMinimizing) {
                /// now is minimizing state, no need to navigate, just switch to idle
                ZegoUIKitPrebuiltLiveStreamingController().minimize.hide();
              } else {
                Navigator.pop(context);
              }
            } else {
              defaultAction.call();
            }
          },

          onLeaveConfirmation: (
            ZegoLiveStreamingLeaveConfirmationEvent event,
            Future<bool> Function() defaultAction,
            // Not needed in this case
          ) async {
            bool? shouldExit = await await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Colors.blue[900]!.withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 🟡 Icon at the top for better visual appeal
                        const Icon(
                          Icons.exit_to_app,
                          size: 50,
                          color: Colors.white70,
                        ),

                        const SizedBox(height: 16),
                        // Space between icon and title

                        // 🏷 Title
                        const Text(
                          "Exit Live Stream",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 12),
                        // Space between title and content

                        // 📄 Message
                        const Text(
                          "Are you sure you want to leave the live stream?",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 24),
                        // Space between text and buttons

                        // Buttons Row (Cancel & Exit)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                              ),
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),

                            // Exit Button
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text(
                                "Exit",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );

            if (shouldExit == true && !isHost) {
              shouldExit = false;
              Navigator.of(context).pop();
            }

            return shouldExit ?? false;
          },
        ),

        config:
            (isHost
                  ? ZegoUIKitPrebuiltLiveStreamingConfig.host(
                    plugins: [ZegoUIKitSignalingPlugin()],
                  )
                  : ZegoUIKitPrebuiltLiveStreamingConfig.audience(
                    plugins: [ZegoUIKitSignalingPlugin()],
                  ))
              // ..audioVideoView.foregroundBuilder = foregroundBuilder
              // ..foreground = Stack(
              //   children: [Positioned(child: Text('your custom widgets'))],
              // )
              ..pip.enableWhenBackground
              ..topMenuBar.buttons = [
                // ZegoLiveStreamingMenuBarButtonName.pipButton,
                ZegoLiveStreamingMenuBarButtonName.minimizingButton,
                ZegoLiveStreamingMenuBarButtonName.coHostControlButton,
                // ZegoLiveStreamingMenuBarButtonName.leaveButton,
              ]
              ..duration.isVisible = true
              ..coHost.inviteTimeoutSecond = 10
              ..coHost.maxCoHostCount = 2
              ..coHost.disableCoHostInvitationReceivedDialog = false
              ..innerText.startLiveStreamingButton = 'Start Live'
              ..innerText.noHostOnline = 'No host online',
      ),
    );
  }
}
