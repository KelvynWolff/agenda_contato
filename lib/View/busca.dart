import 'package:agenda_contatos/Model/contato.dart';
import 'package:agenda_contatos/Controller/contato_rep.dart';
import 'package:agenda_contatos/View/cadastro.dart';
import 'package:agenda_contatos/View/recursos/navBar.dart';
import 'package:agenda_contatos/View/recursos/menu.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Busca extends StatefulWidget {
  const Busca({super.key});

  @override
  State createState() => BuscaState();
}

class BuscaState extends State<Busca> {
  final ContatoService service = ContatoService();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  Future<List<Contato>>? contatosFuture;

  @override
  void initState() {
    super.initState();
    _loadContatos();
  }

  // Função para carregar contatos do usuário logado
  Future<void> _loadContatos() async {
    String? userIdStr = await _secureStorage.read(key: 'user_id');
    int? userId = userIdStr != null ? int.parse(userIdStr) : null;

    if (userId != null) {
      setState(() {
        contatosFuture = service.listarContatosDoUsuario(userId);
      });
    } else {
      setState(() {
        contatosFuture =
            Future.value([]); // Retorna lista vazia se não há user_id
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(),
      drawer: MenuDrawer(),
      body: FutureBuilder<List<Contato>>(
        future: contatosFuture,
        builder: (BuildContext context, AsyncSnapshot<List<Contato>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar contatos'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum contato encontrado'));
          } else {
            List<Contato> contatos = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.fromLTRB(8, 8, 8, 75),
              itemCount: contatos.length,
              itemBuilder: (BuildContext context, int index) {
                Contato contato = contatos[index];

                return Container(
                  color: Colors.grey.shade800,
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${contato.nome} ${contato.sobrenome}',
                              style: TextStyle(
                                  color: Colors.grey.shade400, fontSize: 24),
                            ),
                            SizedBox(height: 10),
                            Text(contato.telefone),
                          ],
                        ),
                        SizedBox(width: 15),
                      ],
                    ),
                    trailing: IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.circleChevronRight,
                        color: Colors.grey,
                        size: 32,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Cadastro(contato: contato),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: FaIcon(FontAwesomeIcons.plus, size: 32),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Cadastro()),
          );
        },
      ),
    );
  }
}
