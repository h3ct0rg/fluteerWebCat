import 'package:flutter/material.dart';
import 'routes.dart';
import './services/db_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbService = DbService();
  await dbService.init(); // Inicializa Hive
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plataforma de Gatitos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: AppRoutes.welcome,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
