import 'package:agenda_contatos/Model/contato.dart';
import 'package:agenda_contatos/Controller/contato_rep.dart';
import 'package:agenda_contatos/View/cadastro.dart';
import 'package:agenda_contatos/View/recursos/navBar.dart';
import 'package:agenda_contatos/View/recursos/menu.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Perfil extends StatelessWidget {
  // Guarda o ID do Contato selecionado
  final int id;

  // Construtor com o Atributo obrigatório
  Perfil({super.key, required this.id});

  // Objeto da classe que contém a Busca dos contatos
  final ContatoService service = ContatoService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra de Título
      appBar: NavBar(),

      // Menu (hambúrguer)
      drawer: MenuDrawer(),

      // Corpo do App
      body: FutureBuilder<Contato?>(
        future:
            service.buscarContato(id), // Função para buscar o contato pelo ID
        builder: (BuildContext context, AsyncSnapshot<Contato?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child:
                    CircularProgressIndicator()); // Exibe um loader enquanto carrega
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar contato'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Contato não encontrado'));
          } else {
            Contato contato = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        SizedBox(height: 25),

                        // Nome
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '${contato.nome} ${contato.sobrenome}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                letterSpacing: 3,
                                wordSpacing: 3,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 10),

                        // Telefone e E-mail
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Telefone
                            Text(
                              contato.telefone,
                              style: TextStyle(
                                  color: Colors.grey.shade400, fontSize: 18),
                            ),
                            // E-mail
                            Text(
                              contato.email,
                              style: TextStyle(
                                  color: Colors.grey.shade400, fontSize: 18),
                            ),
                          ],
                        ),

                        Container(
                          padding: EdgeInsets.only(top: 25, bottom: 25),
                          child: Divider(height: 5),
                        ),

                        // Ações
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Ligar
                            Column(
                              children: [
                                FaIcon(FontAwesomeIcons.phoneAlt,
                                    color: Colors.orange.shade400, size: 28),
                                SizedBox(height: 15),
                                Text("Ligar",
                                    style: TextStyle(
                                        color: Colors.orange.shade400,
                                        fontSize: 18)),
                              ],
                            ),
                            // Mensagem
                            Column(
                              children: [
                                FaIcon(FontAwesomeIcons.solidCommentDots,
                                    color: Colors.orange.shade400, size: 28),
                                SizedBox(height: 15),
                                Text("Mensagem",
                                    style: TextStyle(
                                        color: Colors.orange.shade400,
                                        fontSize: 18)),
                              ],
                            ),
                            // Vídeo
                            Column(
                              children: [
                                FaIcon(FontAwesomeIcons.video,
                                    color: Colors.orange.shade400, size: 28),
                                SizedBox(height: 15),
                                Text("Vídeo",
                                    style: TextStyle(
                                        color: Colors.orange.shade400,
                                        fontSize: 18)),
                              ],
                            ),
                            // E-mail
                            Column(
                              children: [
                                FaIcon(FontAwesomeIcons.solidEnvelope,
                                    color: Colors.orange.shade400, size: 28),
                                SizedBox(height: 15),
                                Text("E-mail",
                                    style: TextStyle(
                                        color: Colors.orange.shade400,
                                        fontSize: 18)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Botão flutuante (Editar) dentro do FutureBuilder
                FloatingActionButton(
                  child: FaIcon(FontAwesomeIcons.pen),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Cadastro(contato: contato),
                      ),
                    );
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
