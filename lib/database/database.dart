import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:primobile/artigo/models/models.dart';
import 'package:primobile/cliente/models/models.dart';
import 'package:primobile/encomenda/models/models.dart';
import 'package:primobile/regras_negocio/models/regras_negocio.dart';
import 'package:primobile/usuario/models/models.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart' as _;

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static _.Database _database;

  Future<_.Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "primobile.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (_.Database db, int version) async {
      try {
        await db.execute(" CREATE TABLE Artigo ("
            "artigo TEXT PRIMARY KEY, "
            "descricao TEXT, "
            "preco REAL, "
            "quantidadeStock REAL, "
            "quantidade REAL, "
            "iva REAL, "
            "civa REAL, "
            "unidade TEXT,"
            "imagemBuffer TEXT,"
            "pvp1 REAL,"
            "pvp1Iva INTEGER,"
            "pvp2 REAL,"
            "pvp2Iva INTEGER,"
            "pvp3 REAL,"
            "pvp3Iva INTEGER,"
            "pvp4 REAL,"
            "pvp4Iva INTEGER,"
            "pvp5 REAL,"
            "pvp5Iva INTEGER,"
            "pvp6 REAL,"
            "pvp6Iva INTEGER"
            ")");

        await db.execute(" CREATE TABLE Cliente ("
            "cliente TEXT PRIMARY KEY, "
            "nome TEXT, "
            "numContrib INTEGER, "
            "endereco TEXT, "
            "anulado BOOLEAN,"
            "tipoCred INTEGER,"
            "totalDeb REAL,"
            "encomendaPendente REAL,"
            "vendaNaoConvertida REAL,"
            "limiteCredito REAL,"
            "imagemBuffer TEXT"
            ")");

        await db.execute(" CREATE TABLE Usuario ("
            "usuario TEXT, "
            "nome TEXT, "
            "senha TEXT, "
            "documento TEXT, "
            "nivel TEXT "
            ")");

        await db.execute(" CREATE TABLE Encomenda ("
            "encomenda INTEGER PRIMARY KEY AUTOINCREMENT, "
            "cliente TEXT, "
            "vendedor TEXT, "
            "data_hora TEXT, "
            "valor REAL,"
            "documento TEXT,"
            "estado TEXT,"
            "encomenda_id TEXT,"
            "longitude TEXT,"
            "latitude TEXT,"
            "assinaturaImagemBuffer TEXT"
            ")");

        await db.execute(" CREATE TABLE EncomendaItem ("
            "encomenda INTEGER , "
            "artigo TEXT, "
            "valor_unit REAL, "
            "quantidade REAL, "
            "valor_total REAL, "
            "constraint encomenda_fk foreign key (encomenda) references Encomenda(encomenda), "
            "constraint artigo_fk foreign key (artigo) references Artigo(artigo) , "
            "constraint itemEncomenda_pk primary key (encomenda, artigo)"
            ")");

        await db.execute(" CREATE TABLE RegraPreco ("
            "encomenda TEXT , "
            "regra TEXT, "
            "artigo TEXT, "
            "cliente TEXT, "
            "validade INTEGER, "
            "dataInicial TEXT, "
            "dataFinal TEXT, "
            "preco REAL, "
            "tipoPreco INTEGER, "
            "desconto REAL, "
            "constraint encomenda_fk foreign key (encomenda) references Encomenda(encomenda), "
            "constraint artigo_fk foreign key (artigo) references Artigo(artigo) , "
            "constraint regrapreco_pk primary key (encomenda, artigo, cliente)"
            ")");
      } catch (e) {
        print('[initDB] Erro: $e.message');
      }
    });
  }

  novoArtigo(Artigo artigo) async {
    final db = await database;
    var res = await db.insert(
      "Artigo",
      artigo.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return res;
  }

  Future<Artigo> getArtigo(String artigo) async {
    final db = await database;
    var res =
        await db.query('Artigo', where: "artigo = ?", whereArgs: [artigo]);

    return res.isEmpty ? Artigo.fromJson(res.first) : Artigo;
  }

  Future<Cliente> getCliente(String cliente) async {
    final db = await database;
    var res =
        await db.query('Cliente', where: "cliente = ?", whereArgs: [cliente]);
    return res.length > 0 ? Cliente.fromMap(res[0]) : Cliente();
  }

  Future<Usuario> getUsuario(String usuario) async {
    final db = await database;
    var res =
        await db.query('Usuario', where: "usuario = ?", whereArgs: [usuario]);

    return res.length > 0 ? Usuario.fromMap(res[0]) : Usuario();
  }

  Future<Usuario> getUsuarioByName(String nome) async {
    final db = await database;
    var res = await db.query('Usuario', where: "nome = ?", whereArgs: [nome]);

    return res.length > 0 ? Usuario.fromMap(res[0]) : Usuario();
  }

  Future<Usuario> login(String nomeEmail, String senha) async {
    final db = await database;
    var res = await db.query('Usuario',
        where: "nome = ? and senha = ?", whereArgs: [nomeEmail, senha]);

    return res.length > 0 ? Usuario.fromMap(res[0]) : null;
  }

  Future<List<Artigo>> getTodosArtigos() async {
    final db = await database;
    var res = await db.query('Artigo');
    List<Artigo> artigos =
        res.isNotEmpty ? res.map((c) => Artigo.fromJson(c)).toList() : null;

    return artigos;
  }

  getTodosUsuarios() async {
    final db = await database;
    var res = await db.query('Usuario');
    List<Usuario> usuarios =
        res.isNotEmpty ? res.map((c) => Usuario.fromMap(c)).toList() : [];

    return usuarios;
  }

  Future<List<Cliente>> getTodosClientes() async {
    final db = await database;
    var res = await db.query('Cliente');
    return res.isNotEmpty ? res.map((c) => Cliente.fromMap(c)).toList() : [];
    // return clientes;
  }

  Future<List<Encomenda>> getTodasEncomendas() async {
    final db = await database;
    var res = await db.query('Encomenda', orderBy: 'data_hora');
    List<Encomenda> encomenda =
        res.isNotEmpty ? res.map((c) => Encomenda.fromMap(c)).toList() : [];

    return encomenda;
  }

  Future<Encomenda> getEncomenda(int encomenda) async {
    final db = await database;
    var res =
        await db.query('Encomenda', where: "id = ?", whereArgs: [encomenda]);

    return res.isEmpty ? Encomenda.fromMap(res.first) : Encomenda();
  }

  Future<List<EncomendaItem>> getTodasEncomendaItens() async {
    List<EncomendaItem> enc;
    try {
      final db = await database;
      var res = await db.query('EncomendaItem');
      enc = res.isNotEmpty
          ? res.map((c) => EncomendaItem.fromMap(c)).toList()
          : [];
    } catch (e) {
      throw e;
    }

    return enc;
  }

  Future<List<EncomendaItem>> getEncomendaItem(int encomenda) async {
    final db = await database;
    var res = await db
        .query('EncomendaItem', where: "encomenda = ?", whereArgs: [encomenda]);

    List<EncomendaItem> enc =
        res.isNotEmpty ? res.map((c) => EncomendaItem.fromMap(c)).toList() : [];

    return enc;
  }

  Future<List<RegraPrecoDesconto>> getEncomendaRegra(String encomenda) async {
    final db = await database;

    var res = await db
        .query('RegraPreco', where: "encomenda = ?", whereArgs: [encomenda]);

    List<RegraPrecoDesconto> regra = res.isNotEmpty
        ? res.map((c) => RegraPrecoDesconto.fromMap(c)).toList()
        : [];

    return regra;
  }

//
  Future<List<RegraPrecoDesconto>> getEncomendaRegra1() async {
    final db = await database;
    var res = await db.query('RegraPreco');

    List<RegraPrecoDesconto> regra = res.isNotEmpty
        ? res.map((c) => RegraPrecoDesconto.fromMap(c)).toList()
        : [];

    return regra;
  }

  void actualizarArtigo(Artigo artigo, callback) {
    // final db = null;
    database.then((value) {
      final db = value;
      db.update('Artigo', artigo.toJson(),
          where: "artigo = ?", whereArgs: [artigo.artigo]).then((value) {
        print("alterado com sucesso!");
      });
    });
  }

  actualizarUsuario(Usuario usuario) async {
    final db = await database;
    var res = await db.update('Usuario', usuario.toJson(),
        where: "usuario = ?", whereArgs: [usuario.usuario]);
    return res;
  }

  actualizarCliente(Cliente cliente) async {
    final db = await database;
    var res = await db.update('Artigo', cliente.toJson(),
        where: "cliente = ?", whereArgs: [cliente.cliente]);
    return res;
  }

  apagarArtigo(String artigo) async {
    final db = await database;
    db.delete('Artigo', where: 'artigo = ?', whereArgs: [artigo]);
  }

  apagarUsuario(String usuario) async {
    final db = await database;
    db.delete('Usuario', where: 'usuario = ?', whereArgs: [usuario]);
  }

  apagarCliente(String cliente) async {
    final db = await database;
    db.delete('Cliente', where: 'cliente = ?', whereArgs: [cliente]);
  }

  apagarTodasEncomenda() async {
    final db = await database;
    db.rawDelete('Delete * from EncomendaItem');
    db.rawDelete('Delete * from Encomenda');
  }

  apagarTodosArtigo() async {
    final db = await database;
    db.rawDelete('Delete * from Artigo');
  }

  apagarTodosUsuarios() async {
    final db = await database;
    db.rawDelete('Delete * from Usuario');
  }

  apagarTodosClientes() async {
    final db = await database;
    db.rawDelete('Delete * from Cliente');
  }

  Future<dynamic> insertArtigo(Artigo artigo) async {
    final db = await database;
    var res;
    try {
      db.transaction((txn) {
        return txn.insert(
          "Artigo",
          artigo.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });

      // res = await db.insert(
      //   "Artigo",
      //   artigo.toMapDb(),
      //   conflictAlgorithm: ConflictAlgorithm.replace,
      // );
    } catch (e) {
      print('[insertArtigo] Ocorreu um erro');
      print(e.message);
    }

    return res;
  }

  Future insertArtigoAll(List<Artigo> artigos) async {
    // final db = await database;
    // var res;
    // try {
    //   db.transaction((txn) {
    //     txn.insert(
    //       "Artigo",
    //       artigo.toMapDb(),
    //       conflictAlgorithm: ConflictAlgorithm.replace,
    //     );
    //   });

    //   // res = await db.insert(
    //   //   "Artigo",
    //   //   artigo.toMapDb(),
    //   //   conflictAlgorithm: ConflictAlgorithm.replace,
    //   // );
    // } catch (e) {
    //   print('[insertArtigo] Ocorreu um erro');
    //   print(e.message);
    // }

    final db = await database;
    Batch batch = db.batch();
    try {
      for (Artigo artigo in artigos) {
        batch.insert("Artigo", artigo.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
    } catch (e) {
      print('[insertArtigoAll] Ocorreu um erro');
      print(e.message());
    }
  }

  insertCliente(Cliente cliente) async {
    final db = await database;
    var res;
    try {
      res = await db.insert(
        "Cliente",
        cliente.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('[insertCliente] Ocorreu um erro');
      print(e.message());
    }

    return res;
  }

  insertClienteAll(List<Cliente> clientes) async {
    final db = await database;
    var res;
    Batch batch = db.batch();
    try {
      for (Cliente cliente in clientes) {
        batch.insert("Cliente", cliente.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      res = await batch.commit(noResult: true);
    } catch (e) {
      print('[insertClienteAll] Ocorreu um erro');
      print(e.message());
    }

    return res;
  }

  Future<int> insertUsuario(Usuario usuario) async {
    try {
      final db = await database;
      var res = await db.insert(
        "Usuario",
        usuario.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return res;
    } catch (e) {
      throw e;
    }
  }

  insertEncomenda(Encomenda encomenda) async {
    int res;
    try {
      final db = await database;
      res = await db.insert(
        "Encomenda",
        encomenda.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      insertEncomendaItem(encomenda.artigos, res);
      if (encomenda.regrasPreco != null)
        await insertEncomendaRegra(
            encomenda.encomenda_id, encomenda.regrasPreco);
    } catch (e) {
      throw e;
    }

    return res;
  }

  insertEncomendaAll(List<Encomenda> encomendas) async {
    final db = await database;
    var res;
    Batch batch = db.batch();
    for (Encomenda enc in encomendas) {
      batch.insert("Encomenda", enc.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      try {
        // res = await db.insert(
        //   "Cliente",
        //   cliente.toJson(),
        //   conflictAlgorithm: ConflictAlgorithm.replace,
        // );
        res = await batch.commit(noResult: true);
      } catch (e) {
        print('[insertEncomendaAll] Ocorreu um erro');
        print(e.message());
      }
    }

    return res;
  }

  void insertEncomendaItem(List<Artigo> artigos, int encomendaPk) async {
    try {
      final db = await database;
      artigos.forEach((artigo) async {
        var rv = await db.insert(
          "EncomendaItem",
          {
            'encomenda': encomendaPk,
            'artigo': artigo.artigo,
            'valor_unit': artigo.preco,
            'quantidade': artigo.quantidade,
            'valor_total': artigo.preco * artigo.quantidade
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        print(rv);
      });
    } catch (e) {
      throw e;
    }
  }

  void insertEncomendaItemAll(List<Artigo> artigos, int encomendaPk) async {
    try {
      final db = await database;
      artigos.forEach((artigo) async {
        db.batch().insert(
              "EncomendaItem",
              {
                'encomenda': encomendaPk,
                'artigo': artigo.artigo,
                'valor_unit': artigo.preco,
                'quantidade': artigo.quantidade,
                'valor_total': artigo.preco * artigo.quantidade
              },
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
      });

      await db.batch().commit(noResult: true);
    } catch (e) {
      throw e;
    }
  }

  Future<int> insertEncomendaRegra(
      String encomenda, List<RegraPrecoDesconto> regras) async {
    int res;
    try {
      for (int i = 0; i < regras.length; i++) {
        RegraPrecoDesconto regra = regras[i];
        final db = await database;
        res = await db.insert(
          "regraPreco",
          {
            'encomenda': encomenda,
            'regra': regra.regra,
            'artigo': regra.artigo,
            'cliente': regra.cliente,
            'validade': regra.validade == true ? 1 : 0,
            'dataInicial': regra.dataInicial,
            'dataFinal': regra.dataFinal,
            'preco': regra.preco,
            'tipoPreco': regra.tipoPreco,
            'desconto': regra.desconto
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    } catch (e) {
      throw e;
    }

    return res;
  }

  Future<void> removeEncomenda() async {
    try {
      final db = await database;
      await db.delete('EncomendaItem');
      await db.delete('Encomenda');
      print("[removeEncomenda]   Sucesso");
    } catch (ex) {
      print("[removeEncomenda]   Erro");
      print(ex);
    }
  }

  Future<bool> removeEncomendaById(int id) async {
    bool rv = false;
    try {
      final db = await database;
      await db.delete('EncomendaItem', where: 'encomenda', whereArgs: [id]);
      await db.delete('Encomenda', where: 'id', whereArgs: [id]);
      print("[removeEncomenda]   Sucesso");
      rv = true;
    } catch (ex) {
      print("[removeEncomenda]   Erro");
      print(ex);
      rv = false;
    }

    return rv;
  }

  void removeCliente() async {
    try {
      final db = await database;
      await db.delete('Cliente');
      print("[removeCliente]   Sucesso");
    } catch (ex) {
      print("[removeCliente]   Erro");
      print(ex);
    }
  }

  void removeArtigo() async {
    try {
      final db = await database;
      await db.delete('Artigo');
      print("[removeArtigo]   Sucesso");
    } catch (ex) {
      print("[removeArtigo]   Erro");
      print(ex);
    }
  }

  void removeAll() async {
    try {
      final db = await database;
      await db.delete('Artigo');
      await db.delete('Cliente');
      await db.delete('EncomendaItem');
      await db.delete('Encomenda');
      print("[removeAll]   Sucesso");
    } catch (ex) {
      print("[removeAll]   Erro");
      print(ex);
    }
  }
}
