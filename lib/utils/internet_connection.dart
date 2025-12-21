import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<bool> checkNet(BuildContext context) async {

  // var connectivityResult = await (Connectivity().checkConnectivity());
  // if (connectivityResult == ConnectivityResult.mobile ||
  //     connectivityResult == ConnectivityResult.wifi) {
  //   // I am connected to a mobile network.
  //   return true;
  // } else {
  //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //     content: Text("Check Your Internet Connection"),
  //   ));
  // }
  //
  //   return false;

  return true;
}

// class InternetConnection extends StatefulWidget {
//   @override
//   _InternetConnectionState createState() => _InternetConnectionState();
// }
//
// class _InternetConnectionState extends State<InternetConnection> {
//   String _strConnectionStatus = 'Unknown';
//   final Connectivity _connectivity = Connectivity();
//   StreamSubscription<ConnectivityResult>? _connectivitySubscription;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text('Internet Not Connected'),
//       ),
//       body: Center(child: Text(_strConnectionStatus)),
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     initConnectivity();
//     _connectivitySubscription =
//         _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
//   }
//
//   @override
//   void dispose() {
//     _connectivitySubscription!.cancel();
//     super.dispose();
//   }
//
//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initConnectivity() async {
//     ConnectivityResult result = ConnectivityResult.none;
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     try {
//       result = await _connectivity.checkConnectivity();
//     } on PlatformException catch (e) {
//       print(e.toString());
//     }
//
//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) {
//       return Future.value(null);
//     }
//
//     return _updateConnectionStatus(result);
//   }
//
//   Future<void> _updateConnectionStatus(ConnectivityResult result) async {
//     print("akash connection status $result");
//     switch (result) {
//       case ConnectivityResult.wifi:
//       case ConnectivityResult.mobile:
//         Navigator.pop(context,"");
//         break;
//       case ConnectivityResult.none:
//         setState(() => _strConnectionStatus = "Please Connect Wifi or Mobile Data");
//         break;
//       default:
//         setState(() => _strConnectionStatus = 'Failed to get connectivity.');
//         break;
//     }
//   }
// }
