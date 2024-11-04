import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:agenda_contatos/View/busca.dart';
import 'package:agenda_contatos/View/login.dart';
import '/View/recursos/estilo.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' show Platform;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configuração para sqflite_common_ffi em plataformas desktop
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Inicializa o FlutterSecureStorage e verifica o token armazenado
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  String? token = await secureStorage.read(key: 'token');

  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token;
  const MyApp({super.key, this.token});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda Contatos',
      theme: estilo(),
      home: token != null ? Busca() : Login(),
    );
  }
}
