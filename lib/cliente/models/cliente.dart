import 'dart:convert';

class Cliente {
  String cliente;
  String nome;
  String nomeFiscal;
  String numContrib;
  Endereco endereco;
  bool anulado;
  int tipoCredito;
  double totalDeb;
  double encomendaPendente;
  double vendaNaoConvertida;
  double limiteCredito;
  double desconto;
  int tipoPreco;
  String telefone;
  String imagemBuffer;

  Cliente(
      {this.cliente,
      this.nome,
      this.nomeFiscal,
      this.numContrib = "0",
      this.endereco,
      this.anulado,
      this.totalDeb,
      this.encomendaPendente,
      this.vendaNaoConvertida,
      this.limiteCredito,
      this.desconto,
      this.tipoCredito,
      this.tipoPreco,
      this.telefone,
      this.imagemBuffer});

  factory Cliente.fromMap(Map<String, dynamic> json) => new Cliente(
      cliente: json['Cliente'],
      nome: json['Nome'],
      nomeFiscal: json['Nome Fiscal'],
      numContrib: json['numcontrib'] ?? 0,
      endereco: new Endereco(descricao: json['Morada']),
      anulado: json['clienteanulado'] ?? false,
      tipoCredito: 0,
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
        'numcontrib': numContrib,
        'endereco': endereco.toJson(),
        'anulado': anulado,
        'totaldeb': totalDeb,
        'telefone': telefone,
        'encomendapendente': encomendaPendente,
        'vendanaoconvertida': vendaNaoConvertida,
        'limitecredito': limiteCredito,
        'desconto': desconto,
        'tipocredito': tipoCredito,
        'tipopreco': tipoCredito,
      };

  Map<String, dynamic> imagemToMap() =>
      {'cliente': this.cliente, 'imagemBuffer': this.imagemBuffer};

  factory Cliente.fromJson(Map<String, dynamic> json) {
    // String numContrib = json['numContrib'] == "" ? "0" : data['numContrib'];
    // numContrib = numContrib.replaceAll(" ", "");
    Endereco endereco = new Endereco(
        bairro: json['morada'],
        descricao: json['morada'],
        pais: "Mocambique",
        provincia: "Maputo",
        ruaAv: json['morada']);
    return Cliente(
        cliente: json['Cliente'] ?? json['cliente'],
        nome: json['Nome'] ?? json['nome'],
        numContrib: json['numcontrib'] ?? "0",
        endereco: endereco,
        anulado: json['clienteanulado'] ?? false,
        tipoCredito: int.tryParse(json['tipocredito'].toString()),
        totalDeb: double.tryParse(json['totaldeb'].toString()),
        encomendaPendente:
            double.tryParse(json['encomendaspendentes'].toString()),
        vendaNaoConvertida:
            double.tryParse(json['vendasnaoconvertidas'].toString()),
        limiteCredito: double.tryParse(json['limitecredito'].toString()),
        desconto: double.tryParse(json['desconto'].toString()),
        tipoPreco: int.tryParse(json['tipopreco']),
        telefone: json['telefone'] ?? "",
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
