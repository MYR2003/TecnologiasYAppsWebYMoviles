import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'vistas/home.dart';
import 'vistas/login.dart';
import 'servicios/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Verificar si hay una sesión activa guardada
  final auth = AuthService();
  final session = await auth.getSession();

  runApp(MyApp(estaLogueado: session != null));
}

class MyApp extends StatelessWidget {
  final bool estaLogueado;
  const MyApp({super.key, required this.estaLogueado});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión Médica',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'), // Español
        Locale('en', 'US'), // Inglés
      ],
      locale: const Locale('es', 'ES'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF03A9F4)),
        useMaterial3: true,
      ),
      home: estaLogueado ? const HomeView() : const LoginView(),
    );
  }
}
