// import 'dart:async';
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:location/location.dart';

// // Use constants to make URLs and keys easier to manage
// const String _baseUrl = "https://imsuae.autoversa.com/";
// const String _dashboardPath = "#/access-module/user-dash";
// const String _sessionKey = "url";

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   late final WebViewController controller;

//   bool _isLoading = true;
//   String? currentUrl;

//   @override
//   void initState() {
//     super.initState();
//     controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onPageStarted: (url) {
//             // Combine setState calls for efficiency
//             setState(() {
//               currentUrl = url;
//               _isLoading = true;
//             });
//           },
//           onPageFinished: (url) async {
//             setState(() {
//               _isLoading = false;
//               currentUrl = url;
//             });
//             // if (url.contains(_dashboardPath)) {
//             //   await _saveCookies(url);
//             // }

//             // log("🍪 Cookies for............ $url");
//             // log("🍪 Cookies for current url $currentUrl");
//             var locationData = await _getLocation();
//             if (locationData != null) {
//               _sendLocationToWebView(locationData);
//             }
//           },
//         ),
//       );
//     _loadStartPage();
//   }

//   // Location code is unchanged as requested
//   Future<LocationData?> _getLocation() async {
//     var status = await Permission.location.request();
//     if (status.isGranted) {
//       Location location = Location();
//       return await location.getLocation();
//     }
//     return null;
//   }

//   // Location code is unchanged as requested
//   void _sendLocationToWebView(LocationData data) {
//     controller.runJavaScript(
//       "window.navigator.geolocation.getCurrentPosition = function(success) {"
//       "success({coords: {latitude: ${data.latitude}, longitude: ${data.longitude}}});"
//       "}",
//     );
//   }

//   Future<void> _loadStartPage() async {
//     final prefs = await SharedPreferences.getInstance();
//     // String? savedCookies = prefs.getString(_sessionKey);
//     // // print("❌❌❌❌❌❌❌❌>>>> $savedCookies");
//     // if (savedCookies != null && savedCookies.contains(_dashboardPath)) {
//     //   // debugPrint("✅ Session cookie found → going to dashboard");
//     //   controller.loadRequest(Uri.parse(_baseUrl + _dashboardPath));
//     // } else {
//     //   // debugPrint("❌ No cookies → going to login");
//     controller.loadRequest(Uri.parse(_baseUrl));
//   }
//   // }

//   Future<void> _saveCookies(String url) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_sessionKey, url);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.all(5),
//         // Replace WillPopScope with PopScope
//         child: PopScope(
//           canPop: false, // Prevent the default pop behavior
//           onPopInvoked: (bool didPop) async {
//             if (didPop) return;
//             String? currentUrl = await controller.currentUrl();
//             // Check if the current page is a root page
//             if (currentUrl != null &&
//                 (currentUrl == "${_baseUrl}#/" ||
//                     currentUrl == "${_baseUrl}${_dashboardPath}")) {
//               // Prevent going back from these pages
//               return;
//             }

//             if (await controller.canGoBack()) {
//               controller.goBack();
//               return; // Stay in the app
//             }

//             // Otherwise, allow the app to be popped (exited)
//             if (mounted) {
//               Navigator.of(context).pop();
//             }
//           },
//           child: Scaffold(
//             body: SizedBox(
//               height: MediaQuery.of(context).size.height,
//               child: Stack(
//                 children: [
//                   WebViewWidget(controller: controller),
//                   if (_isLoading)
//                     Container(
//                       color: Colors.white,
//                       child: Center(
//                         child: LoadingAnimationWidget.twistingDots(
//                           leftDotColor: const Color(0xFDACE3DD),
//                           rightDotColor: const Color(0xFD4262ED),
//                           size: 50,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final WebViewController controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) async {
            setState(() => _isLoading = false);

            var locationData = await _getLocation();
            if (locationData != null) {
              _sendLocationToWebView(locationData);
            }
          },

          onHttpError: (HttpResponseError error) {
            print(" onHttpError Error Is =============>${error.request}");
            print(" onHttpError Error Is =============>${error.response}");
          },
          onWebResourceError: (WebResourceError error) {
            print(
              " onWebResourceError Error Is =============>${error..errorCode}",
            );
            print(
              " onWebResourceError Error Is =============>${error..errorType}",
            );
            print(
              " onWebResourceError Error Is =============>${error.description}",
            );
          },
        ),
      )
      ..loadRequest(Uri.parse('https://imsuae.autoversa.com/'));

    Timer(const Duration(seconds: 0), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  Future<LocationData?> _getLocation() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      Location location = Location();
      return await location.getLocation();
    }
    return null;
  }

  void _sendLocationToWebView(LocationData data) {
    controller.runJavaScript(
      "window.navigator.geolocation.getCurrentPosition = function(success) {"
      "success({coords: {latitude: ${data.latitude}, longitude: ${data.longitude}}});"
      "}",
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Scaffold(
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                WebViewWidget(controller: controller),
                if (_isLoading)
                  Container(
                    color: Colors.white,
                    child: Center(
                      child: LoadingAnimationWidget.twistingDots(
                        leftDotColor: const Color(0xFDACE3DD),
                        rightDotColor: const Color(0xFD4262ED),
                        size: 50,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
