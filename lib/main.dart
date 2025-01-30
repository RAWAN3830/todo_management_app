import 'package:flutter/material.dart';
import 'package:task_management_app/view/home_screen/home_screen.dart';
import 'package:task_management_app/services/database_connection.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await DatabaseRepo.createDB();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(color: Colors.lightGreen),
      ),
      home: const HomeScreen(),
    );
  }


}