import 'package:agenda_contatos/View/login.dart';
import 'package:agenda_contatos/View/home.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({super.key});

  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  String usuario = "Usuário";

  @override
  void initState() {
    super.initState();
    _loadUsuario();
  }

  Future<void> _loadUsuario() async {
    String? nome = await secureStorage.read(key: 'username');
    if (nome != null && mounted) {
      setState(() {
        usuario = nome;
      });
    }
  }

  Future<void> _logout(BuildContext context) async {
    await secureStorage.deleteAll();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
  }

  Text mostrarTitulo(String texto) {
    return Text(texto, style: TextStyle(fontSize: 18));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(usuario),
            accountEmail: null,
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.orange,
              child: Text(
                usuario.isNotEmpty ? usuario[0].toUpperCase() : '?',
                style: TextStyle(fontSize: 40),
              ),
            ),
          ),
          ListTile(
            title: mostrarTitulo("Home"),
            subtitle: Text("Página inicial"),
            trailing: FaIcon(FontAwesomeIcons.chevronRight),
            leading: FaIcon(FontAwesomeIcons.house,
                color: Colors.orange.shade400, size: 32),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
            },
          ),
          ListTile(
            title: mostrarTitulo("Logout"),
            subtitle: Text("Sair do Sistema"),
            trailing: FaIcon(FontAwesomeIcons.chevronRight),
            leading: FaIcon(FontAwesomeIcons.rightFromBracket,
                color: Colors.grey, size: 32),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}
