import 'package:cat_gps/mqtt/state/mqtt_app_state.dart';
import 'package:cat_gps/page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

final shorebirdCodePush = ShorebirdCodePush();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: ChangeNotifierProvider<MQTTAppState>(
        create: (_) => MQTTAppState(),
        child: const HomePage(),
      ),
    );
  }
}
