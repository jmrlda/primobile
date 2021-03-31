import 'package:primobile/artigo/models/models.dart';
import 'package:primobile/encomenda/models/encomenda.dart';

class EncomendaItem {
  Encomenda encomenda;
  int encomendaPk;
  Artigo artigo;
  String artigoPk;
  double valorUnit;
  double quantidade;
  double valorTotal;

  EncomendaItem(
      {this.encomenda,
      this.artigo,
      this.valorUnit,
      this.quantidade,
      this.valorTotal,
      this.encomendaPk = 0,
      this.artigoPk = ""});

  factory EncomendaItem.fromMap(Map<String, dynamic> json) {
    return new EncomendaItem(
      encomendaPk: json['encomenda'],
      artigoPk: json['artigo'],
      valorUnit: json['valor_unit'],
      quantidade: json['quantidade'],
      valorTotal: json['valor_total'],
    );
  }

  Map<String, dynamic> toMap() => {
        'encomenda': encomenda.id,
        'artigo': artigo.artigo,
        'valor_unit': artigo.preco,
        'quantidade': artigo.quantidade,
        'valor_total': artigo.preco * artigo.quantidade
      };

  void setEncomendaObject() async {
    // this.encomenda = await DBProvider.db.getEncomenda(this.encomendaPk);
  }

  void setArtigoObject() async {
    // this.artigo = await DBProvider.db.getArtigo(this.artigoPk);
  }
}
