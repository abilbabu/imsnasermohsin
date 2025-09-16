// import 'package:flutter/widgets.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class Webcontroller with ChangeNotifier {
//   late final WebViewController controller;
//   bool isLoading = true;

//   WebViewProvider() {
//     _initController();
//   }

//   void _initController() {
//     controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {},
//           onPageStarted: (String url) {
//             isLoading = true;
//             notifyListeners();
//           },
//           onPageFinished: (String url) {
//             isLoading = false;
//             notifyListeners();
//           },
//           onHttpError: (HttpResponseError error) {
//             isLoading = false;
//             notifyListeners();
//           },
//           onWebResourceError: (WebResourceError error) {
//             isLoading = false;
//             notifyListeners();
//           },
//           onNavigationRequest: (NavigationRequest request) {
//             if (request.url.startsWith('https://www.youtube.com/')) {
//               return NavigationDecision.prevent;
//             }
//             return NavigationDecision.navigate;
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse('https://imsuae.autoversa.com/#/'));
//   }

//   /// Reload current page
//   Future<void> reload() async {
//     await controller.reload();
//   }

//   /// Load a new URL dynamically
//   Future<void> loadUrl(String url) async {
//     isLoading = true;
//     notifyListeners();
//     await controller.loadRequest(Uri.parse(url));
//   }
// }
