import 'package:agenda_contatos/Model/contato.dart';
import 'package:agenda_contatos/Controller/contato_rep.dart';
import 'package:agenda_contatos/View/busca.dart';
import 'package:agenda_contatos/View/recursos/navBar.dart';
import 'package:agenda_contatos/View/recursos/menu.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Cadastro extends StatefulWidget {
  final Contato? contato;

  const Cadastro({super.key, this.contato});

  @override
  State createState() => CadastroState();
}

class CadastroState extends State<Cadastro> {
  final ContatoService service = ContatoService();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  final nome = TextEditingController();
  final sobrenome = TextEditingController();
  final email = TextEditingController();
  final telefone = TextEditingController();

  var maskFormatter = MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.contato != null) {
      nome.text = widget.contato!.nome;
      sobrenome.text = widget.contato!.sobrenome;
      email.text = widget.contato!.email;
      telefone.text = widget.contato!.telefone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(),
      drawer: MenuDrawer(),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 35),
          margin: EdgeInsets.symmetric(horizontal: 25, vertical: 35),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade800,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(bottom: 15),
                  child: Text(
                    widget.contato != null
                        ? "Editar Contato"
                        : "Cadastro de Contato",
                    style: TextStyle(color: Colors.grey.shade300, fontSize: 24),
                  ),
                ),
                campoInput("Nome", nome, "Informe o nome"),
                campoInput("Sobrenome", sobrenome, null),
                campoEmail("E-mail", email, "Informe um e-mail válido"),
                campoTelefone(
                    "Telefone", telefone, "Informe um telefone válido"),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (widget.contato != null) {
                            atualizar();
                          } else {
                            cadastrar();
                          }
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        child: Text(
                          widget.contato != null ? "Atualizar" : "Cadastrar",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade600),
                      onPressed: limpar,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        child: Text("Limpar",
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                    widget.contato != null
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent),
                            onPressed: excluir,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 10),
                              child: Text("Excluir",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white)),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> cadastrar() async {
    String? userIdStr = await _secureStorage.read(key: 'user_id');
    int? userId = userIdStr != null ? int.parse(userIdStr) : null;

    if (userId != null) {
      Contato novoContato = Contato(
        nome: nome.text,
        sobrenome: sobrenome.text,
        email: email.text,
        telefone: telefone.text,
      );

      String mensagem = await service.cadastrarContato(novoContato, userId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(mensagem,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade300)),
          duration: Duration(milliseconds: 2000),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.grey.shade800,
        ));

        Future.delayed(Duration(milliseconds: 2500), () {
          if (mounted) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Busca()));
          }
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro: Usuário não autenticado',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red.shade300)),
        duration: Duration(milliseconds: 2000),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  Future<void> atualizar() async {
    Contato contatoAtualizado = Contato(
      id: widget.contato!.id,
      nome: nome.text,
      sobrenome: sobrenome.text,
      email: email.text,
      telefone: telefone.text,
    );

    await service.atualizarContato(contatoAtualizado);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Contato atualizado com sucesso!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade300)),
        duration: Duration(milliseconds: 2000),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.grey.shade800,
      ));

      Future.delayed(Duration(milliseconds: 2500), () {
        if (mounted) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Busca()));
        }
      });
    }
  }

  Future<void> excluir() async {
    String mensagem = await service.excluirContato(widget.contato!.id!);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(mensagem,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade300)),
      duration: Duration(milliseconds: 2000),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.grey.shade800,
    ));

    Future.delayed(Duration(milliseconds: 2500), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Busca()));
    });
  }

  void limpar() {
    nome.clear();
    sobrenome.clear();
    email.clear();
    telefone.clear();
  }

  Container campoInput(String nomeCampo, TextEditingController controlador,
      String? validationMessage) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controlador,
        validator: (value) {
          if (validationMessage != null && (value == null || value.isEmpty)) {
            return validationMessage;
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: nomeCampo,
          labelStyle: TextStyle(color: Colors.grey.shade300, fontSize: 18),
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.orange)),
        ),
      ),
    );
  }

  Container campoTelefone(String nomeCampo, TextEditingController controlador,
      String? validationMessage) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controlador,
        inputFormatters: [maskFormatter],
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (value == null || value.isEmpty || value.length != 15) {
            return validationMessage;
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: nomeCampo,
          labelStyle: TextStyle(color: Colors.grey.shade300, fontSize: 18),
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.orange)),
        ),
      ),
    );
  }

  Container campoEmail(String nomeCampo, TextEditingController controlador,
      String validationMessage) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controlador,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null ||
              value.isEmpty ||
              !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
            return validationMessage;
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: nomeCampo,
          labelStyle: TextStyle(color: Colors.grey.shade300, fontSize: 18),
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.orange)),
        ),
      ),
    );
  }
}
