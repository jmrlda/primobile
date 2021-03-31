import 'package:primobile/cliente/models/models.dart';
import 'package:primobile/encomenda/models/models.dart';
import 'package:primobile/usuario/models/models.dart';

class EncomendaDB {
  List<Encomenda> encomendas;
  List<EncomendaItem> encomendaItens;
  List<Cliente> clientes;
  List<Usuario> vendedores;

  EncomendaDB(
      {this.encomendas, this.encomendaItens, this.clientes, this.vendedores});
}
