import 'dart:convert';

class Cliente {
  String cliente;
  String nome;
  String nomeFiscal;
  int numContrib;
  Endereco endereco;
  bool anulado;
  int tipoCred;
  double totalDeb;
  double encomendaPendente;
  double vendaNaoConvertida;
  double limiteCredito;
  String imagemBuffer;

  Cliente(
      {this.cliente,
      this.nome,
      this.nomeFiscal,
      this.numContrib = 0,
      this.endereco,
      this.anulado,
      this.tipoCred,
      this.totalDeb,
      this.encomendaPendente,
      this.vendaNaoConvertida,
      this.limiteCredito,
      this.imagemBuffer});

  factory Cliente.fromMap(Map<String, dynamic> json) => new Cliente(
      cliente: json['Cliente'],
      nome: json['Nome'],
      nomeFiscal: json['Nome Fiscal'],
      numContrib:
          int.parse(json['N.º Contribuinte'].toString().replaceAll(" ", "")),
      endereco: new Endereco(descricao: json['Morada']),
      anulado: false,
      tipoCred: 0,
      totalDeb: 0,
      encomendaPendente: 0,
      vendaNaoConvertida: 0,
      limiteCredito: 0,
      // imagemBuffer: json['imagemBuffer']
      imagemBuffer:
          json['imagemBuffer'].length <= 0 ? null : json['imagemBuffer']);

  Map<String, dynamic> toJson() => {
        'cliente': cliente,
        'nome': nome,
        'numContrib': numContrib,
        'endereco': endereco.toJson(),
        'anulado': anulado,
        'tipoCred': tipoCred,
        'totalDeb': totalDeb,
        'encomendaPendente': encomendaPendente,
        'vendaNaoConvertida': vendaNaoConvertida,
        'limiteCredito': limiteCredito,
        'imagemBuffer': imagemBuffer
      };

  Map<String, dynamic> imagemToMap() =>
      {'cliente': this.cliente, 'imagemBuffer': this.imagemBuffer};

  factory Cliente.fromJson(Map<String, dynamic> json) {
    // String numContrib = json['numContrib'] == "" ? "0" : data['numContrib'];
    // numContrib = numContrib.replaceAll(" ", "");
    return Cliente(
        cliente: json['Cliente'] ?? json['cliente'],
        nome: json['Nome'] ?? json['nome'],
        nomeFiscal: json['Nome Fiscal'] ?? json['nomeFiscal'],
        // numContrib:
        //     int.parse(json['N.º Contribuinte'].toString().replaceAll(" ", "")),
        endereco: Endereco.fromJson(json['endereco']),
        anulado: false,
        tipoCred: 0,
        totalDeb: 0,
        encomendaPendente: 0,
        vendaNaoConvertida: 0,
        limiteCredito: 0,
        imagemBuffer: null);
    // data['imagemBuffer'] == null ? null : data['imagemBuffer']);
  }

  List<Cliente> parseUsuarios(String response) {
    final parsed = json.decode(response).cast<Map<String, dynamic>>();
    return parsed.map<Cliente>((json) => Cliente.fromJson(json)).toList();
  }
}

class Endereco {
  String pais;
  String provincia;
  String ruaAv;
  String bairro;
  String descricao;
  Endereco(
      {this.pais = "",
      this.provincia = "",
      this.ruaAv = "",
      this.bairro = "",
      this.descricao = ""});

  Map<String, dynamic> toJson() => {
        'pais': pais,
        'provincia': provincia,
        'ruaAv': ruaAv,
        'bairro': bairro,
        'descricao': descricao,
      };

  factory Endereco.fromJson(Map<String, dynamic> json) => new Endereco(
        bairro: json['bairro'],
        descricao: json['descricao'],
        pais: json['pais'],
        provincia: json['provincia'],
        ruaAv: json['ruaAv'],
      );
}
