import 'package:agenda_contatos/View/busca.dart';
import 'package:agenda_contatos/View/cadastro.dart';
import 'package:agenda_contatos/View/recursos/menu.dart';
import 'package:agenda_contatos/View/recursos/navBar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Titulo do App
      appBar: NavBar(),

      //Menu
      drawer: MenuDrawer(),

      //Corpo do App

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(25),
              child: Column(
                children: [
                  //Titulo
                  Text(
                    "Bem vindo a agenda de contatos!",
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 24,
                    ),
                  ),

                  SizedBox(height: 45),

                  // Botão Buscar Contato
                  Builder(builder: (BuildContext context) {
                    return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[800]),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Busca()));
                        },
                        child: Container(
                          width: 300,
                          padding: EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              new FaIcon(
                                FontAwesomeIcons.search,
                                color: Colors.white,
                                size: 24,
                              ),
                              new Text(
                                "Buscar Contatos",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24),
                              )
                            ],
                          ),
                        ));
                  }),
                  SizedBox(
                    height: 15,
                  ),

                  // Botão cadastrar contato
                  Builder(builder: (BuildContext context) {
                    return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[800]),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Cadastro()));
                        },
                        child: Container(
                          width: 300,
                          padding: EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              new FaIcon(
                                FontAwesomeIcons.plus,
                                color: Colors.white,
                                size: 24,
                              ),
                              new Text(
                                "Cadastrar Contatos",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24),
                              )
                            ],
                          ),
                        ));
                  })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
