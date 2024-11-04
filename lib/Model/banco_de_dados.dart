import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'contato.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'contatos.db');
    return await openDatabase(
      path,
      version:
          3, // Incrementar a versão do banco de dados para forçar a atualização
      onCreate: (db, version) async {
        // Criação da tabela contatos
        await db.execute('''
  CREATE TABLE contatos(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT,
    sobrenome TEXT,
    telefone TEXT,
    email TEXT,
    user_id INTEGER
  )
''');

        // Criação da tabela login
        await db.execute('''
        CREATE TABLE login(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT UNIQUE,
          password TEXT
        )
      ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          // Adiciona a coluna user_id à tabela contatos na atualização para a versão 3
          await db.execute('ALTER TABLE contatos ADD COLUMN user_id INTEGER');
        }
      },
    );
  }

  Future<int> insertContato(Contato contato, int userId) async {
    Database db = await database;
    return await db.insert('contatos', {
      ...contato.toMap(),
      'user_id': userId, // Adiciona o user_id ao registro
    });
  }

  Future<List<Contato>> fetchContatos(int userId) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'contatos',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) {
      return Contato.fromMap(maps[i]);
    });
  }

  Future<int> updateContato(Contato contato) async {
    Database db = await database;
    return await db.update(
      'contatos',
      contato.toMap(),
      where: 'id = ?',
      whereArgs: [contato.id],
    );
  }

  Future<int> deleteContato(int id) async {
    Database db = await database;
    return await db.delete(
      'contatos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Função para inserir um novo usuário na tabela login
  Future<int> insertUsuario(String username, String password) async {
    Database db = await database;
    return await db.insert(
      'login',
      {'username': username, 'password': password},
      conflictAlgorithm:
          ConflictAlgorithm.fail, // Garante unicidade do nome de usuário
    );
  }

  // Função para buscar um usuário na tabela login
  Future<Map<String, dynamic>?> fetchUsuario(
      String username, String password) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'login',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty ? result.first : null;
  }
}
