import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'central_provider.dart';
import 'widgets/floating_action_button.dart';

class CentralWeb extends StatefulWidget {
  const CentralWeb({super.key});

  @override
  State<CentralWeb> createState() => _CentralWebState();
}

class _CentralWebState extends State<CentralWeb> {
  late final WebViewController webViewController;

  @override
  void initState() {
    super.initState();
    CentralProvider centralProvider = Provider.of(context, listen: false);
    webViewController = WebViewController(
      onPermissionRequest: (request) async {
        await request.grant();
      },
    )
      ..loadRequest(
        Uri.parse("https://flipstercentral.fkinternal.com/#/login"),
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            centralProvider.loadingProgressIndicator = 0.0;
          },
          onProgress: (progress) {
            centralProvider.loadingProgressIndicator = progress.toDouble();
          },
          onPageFinished: (url) async {
            print(" ------------ ${url} ----------- ");
            centralProvider.loadingProgressIndicator = 100.0;
            if (url.contains("/#/login")) {
              centralProvider.fabVisibility = false;
            } else {
              centralProvider.fabVisibility = true;
            }
            centralProvider.notify();
          },
          onUrlChange: (change) async {
            print(" ------------ ${change.url} ----------- ");
          },
          onWebResourceError: (error) async {
            print(error.description);
            print(error.errorCode);
            print(error.errorType);
            print(error.isForMainFrame);
            print(error.url);
          },
        ),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Selector<CentralProvider, bool>(
        builder: (context, fabVisibility, child) => fabVisibility
            ? Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: CustomFAB(
                  webViewController: webViewController,
                ),
              )
            : const SizedBox.shrink(),
        selector: (p0, p1) => p1.fabVisibility,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: SafeArea(
                          child: WebViewWidget(
                            controller: webViewController,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Selector<CentralProvider, double>(
                    builder: (context, loadingProgressIndicator, child) =>
                        loadingProgressIndicator > 0.0 &&
                                loadingProgressIndicator < 100.0
                            ? LinearProgressIndicator(
                                value: loadingProgressIndicator / 100,
                                color: Colors.green,
                              )
                            : const SizedBox.shrink(),
                    selector: (p0, p1) => p1.loadingProgressIndicator,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


// InAppWebView(
//                   initialUrlRequest: URLRequest(
//                     url: WebUri(
//                       "https://flipstercentral.fkinternal.com/#/login",
//                     ),
//                   ),
//                   onWebViewCreated: (controller) {
//                     _webViewController = controller;
//                   },
//                   onLoadStart: (controller, url) {
//                     print("------ Page Load Started -------");
//                     setState(() {
//                       loading = true;
//                     });
//                   },
//                   onLoadStop: (controller, url) {
//                     print("------ Page Load Completed -------");
//                     setState(() {
//                       loading = false;
//                     });
//                   },
//                   onProgressChanged: (controller, progress) {
//                     print("--- This is the progress : ${progress}");
//                   },
//                   onReceivedError: (controller, request, error) {
//                     print(
//                         "Error while loading the page ---- ${error} and Request : ${request}");
//                   },
//                   // onConsoleMessage: (controller, consoleMessage) {
//                   //   print(consoleMessage);
//                   // },

//                   onPermissionRequest: (controller, permissionRequest) async {
//                     return PermissionResponse(
//                       resources: permissionRequest.resources,
//                       action: PermissionResponseAction.GRANT,
//                     );
//                   },
//                   onReceivedServerTrustAuthRequest:
//                       (controller, challenge) async {
//                     print(challenge);
//                     return ServerTrustAuthResponse(
//                       action: ServerTrustAuthResponseAction.CANCEL,
//                     );
//                   },
//                 )