import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomFAB extends StatefulWidget {
  const CustomFAB({
    super.key,
    required this.webViewController,
  });
  final WebViewController webViewController;

  @override
  State<CustomFAB> createState() => _CustomFABState();
}

class _CustomFABState extends State<CustomFAB> {
  var renderOverlay = true;
  var visible = true;
  var switchLabelPosition = false;
  var extend = false;
  var mini = false;
  var closeManually = false;
  var useRAnimation = true;
  var isDialOpen = ValueNotifier<bool>(false);
  var speedDialDirection = SpeedDialDirection.up;
  var buttonSize = const Size(56.0, 56.0);
  var childrenButtonSize = const Size(56.0, 56.0);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.more_vert,
      activeIcon: Icons.close,
      spacing: 3,
      openCloseDial: isDialOpen,
      childPadding: const EdgeInsets.all(5),
      spaceBetweenChildren: 4,

      /// Transition Builder between label and activeLabel, defaults to FadeTransition.
      /// The below button size defaults to 56 itself, its the SpeedDial childrens size
      childrenButtonSize: childrenButtonSize,
      visible: visible,
      direction: speedDialDirection,
      switchLabelPosition: switchLabelPosition,

      /// If true user is forced to close dial manually
      closeManually: closeManually,

      /// If false, backgroundOverlay will not be rendered.
      renderOverlay: false,

      useRotationAnimation: useRAnimation,
      tooltip: 'Open Options',
      elevation: 8.0,
      animationCurve: Curves.elasticInOut,
      isOpenOnStart: false,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.home),
          backgroundColor: Colors.purple.shade50,
          label: 'Home',
          onTap: () {
            widget.webViewController.loadRequest(
              Uri.parse("https://flipstercentral.fkinternal.com/#/home"),
            );
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.refresh),
          backgroundColor: Colors.purple.shade50,
          label: 'Refresh',
          onTap: () {
            widget.webViewController.reload();
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.arrow_back),
          backgroundColor: Colors.purple.shade50,
          label: 'Back',
          visible: true,
          onTap: () async {
            if (await widget.webViewController.canGoBack()) {
              widget.webViewController.goBack();
            }
          },
        ),
      ],
    );
  }
}
