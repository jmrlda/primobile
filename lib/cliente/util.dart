import 'package:flutter/widgets.dart';
// import 'package:gallery_saver/files.dart';
import 'package:http/http.dart' as http;
import 'package:primobile/cliente/models/models.dart';

import 'bloc/bloc.dart';

List<Cliente> clienteLista = new List<Cliente>();
List<Cliente> clienteListaSelecionado = new List<Cliente>();
bool isSelected = false;
String baseUrl = "";
String url = "";
TextEditingController clientePesquisaController = TextEditingController();
ClienteBloc clienteBloc = ClienteBloc(httpClient: http.Client());

void opcaoAcao(String opcao) async {
  if (opcao == 'sincronizar') {}
}

// metodo para busca porclientes na lista
List<Cliente> clientePesquisar(String query, List<Cliente> listaCliente) {
  List<Cliente> resultado = List<Cliente>();

  if (query.trim().isNotEmpty) {
    listaCliente.forEach((cliente) {
      if (cliente.nome.toLowerCase().contains(query.toString().toLowerCase()) ||
          cliente.cliente
              .toLowerCase()
              .contains(query.toString().toLowerCase())) {
        resultado.add(cliente);
      }
    });
  }
  return resultado;
}

// ao selecionar um cliente, adicionar ao cabecalha da
// venda ou encomenda como indentificacaao do comprador
bool adicionarCliente(Cliente c) {
  bool existe = false;
  for (var i = 0; i < clienteListaSelecionado.length; i++) {
    if (clienteListaSelecionado[i].cliente == c.cliente ||
        clienteListaSelecionado[i].nome == c.nome) {
      existe = true;
      clienteListaSelecionado.removeAt(i);
    }
  }

  if (!existe) {
    clienteListaSelecionado.add(c);
  }

  return existe;
}

bool existeClienteSelecionado(Cliente c) {
  bool existe = false;

  for (var i = 0; i < clienteListaSelecionado.length; i++) {
    if (clienteListaSelecionado[i].cliente == c.cliente) {
      existe = true;
    }
  }
  return existe;
}
