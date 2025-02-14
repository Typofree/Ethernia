import 'package:flutter/material.dart';

import 'package:ethernia_ar/screens/homes/homeView.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint = (String? message, {int? wrapWidth}) {
    if (message != null && !message.contains("INTERNAL: No point hit")) {
      print(message); // Prints only non-error logs
    }
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter AR App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: ARViewScreen(),
    );
  }
}
