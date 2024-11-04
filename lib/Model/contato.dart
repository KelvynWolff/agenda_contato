class Contato {
  int? id;
  String nome;
  String sobrenome; // Adicionando o sobrenome
  String telefone;
  String email;

  Contato(
      {this.id,
      required this.nome,
      required this.sobrenome,
      required this.telefone,
      required this.email});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'sobrenome': sobrenome, // Adicionando sobrenome ao mapa
      'telefone': telefone,
      'email': email,
    };
  }

  factory Contato.fromMap(Map<String, dynamic> map) {
    return Contato(
      id: map['id'],
      nome: map['nome'],
      sobrenome: map['sobrenome'], // Extraindo o sobrenome do mapa
      telefone: map['telefone'],
      email: map['email'],
    );
  }
}
