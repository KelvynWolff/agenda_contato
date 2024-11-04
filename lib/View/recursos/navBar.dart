import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavBar extends AppBar {
  NavBar({super.key})
      : super(
          automaticallyImplyLeading: false, //Esconde o icone original do (menu)
          centerTitle: true,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: FaIcon(FontAwesomeIcons.bars),
                //Abre o menu
                onPressed: () => Scaffold.of(context).openDrawer(),
              );
            },
          ),
          //Titulo
          title: Text(
            "Agenda de Contatos",
            style: TextStyle(color: Colors.orange.shade400, fontSize: 28),
          ),
          iconTheme: IconThemeData(color: Colors.orange.shade400),
        );
}
