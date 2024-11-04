import '../Model/banco_de_dados.dart';
import '../Model/contato.dart';
import 'package:sqflite/sqflite.dart';

class ContatoService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Função para cadastrar um novo contato associado ao user_id do usuário logado
  Future<String> cadastrarContato(Contato contato, int userId) async {
    final db = await _dbHelper.database;
    await db.insert('contatos', {
      ...contato.toMap(),
      'user_id': userId, // Associa o contato ao usuário logado
    });
    return "Novo contato: ${contato.nome} ${contato.sobrenome}";
  }

  // Função para listar todos os contatos de um usuário específico (filtrado pelo user_id)
  Future<List<Contato>> listarContatosDoUsuario(int userId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'contatos',
      where: 'user_id = ?', // Filtra pelo user_id do usuário logado
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) {
      return Contato.fromMap(maps[i]);
    });
  }

  // Função para atualizar um contato existente
  Future<void> atualizarContato(Contato contatoAtualizado) async {
    final db = await _dbHelper.database;
    await db.update(
      'contatos',
      contatoAtualizado.toMap(),
      where: 'id = ?',
      whereArgs: [contatoAtualizado.id],
    );
  }

  // Função para excluir um contato
  Future<String> excluirContato(int id) async {
    final db = await _dbHelper.database;
    int count = await db.delete(
      'contatos',
      where: 'id = ?',
      whereArgs: [id],
    );
    return count > 0
        ? "Contato excluído com sucesso."
        : "Contato não encontrado.";
  }

  // Função para buscar um contato pelo ID
  Future<Contato?> buscarContato(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'contatos',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Contato.fromMap(maps.first);
    }
    return null;
  }

  // Função para cadastrar um novo usuário
  Future<void> cadastrarUsuario(String username, String password) async {
    final db = await _dbHelper.database;
    try {
      await db.insert(
        'login',
        {'username': username, 'password': password},
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    } catch (e) {
      throw Exception('Erro ao cadastrar usuário: $e');
    }
  }

  // Função para autenticar o usuário pelo username e password e retornar seus dados
  Future<Map<String, dynamic>?> fetchUsuario(
      String username, String password) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.query(
      'login',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty ? result.first : null;
  }
}
