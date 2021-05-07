import 'package:flutter/widgets.dart';
import 'package:primobile/fornecedor/bloc/fornecedor_bloc.dart';
import 'package:primobile/fornecedor/models/fornecedor.dart';
import 'package:http/http.dart' as http;

List<Fornecedor> fornecedorLista = new List<Fornecedor>();
List<Fornecedor> fornecedorListaSelecionado = List<Fornecedor>();
bool isSelected = false;

String baseUrl = "";
String url = "";

TextEditingController fornecedorPesquisaController = TextEditingController();
FornecedorBloc fornecedorBloc = FornecedorBloc(httpClient: http.Client());

// funcoes e classes
void opcaoAcao(String opcao) async {
  if (opcao == 'sincronizar') {}
}

// metodo para busca de artigos na lista
List<Fornecedor> fornecedorPesquisar(
    String query, List<Fornecedor> listaFornecedor) {
  List<Fornecedor> resultado = List<Fornecedor>();

  if (query.trim().isNotEmpty) {
    listaFornecedor.forEach((item) {
      if (item.fornecedor
              .toLowerCase()
              .contains(query.toString().toLowerCase()) ||
          item.nome.toLowerCase().contains(query.toString().toLowerCase()) ||
          item.nomeFiscal
              .toLowerCase()
              .contains(query.toString().toLowerCase())) {
        resultado.add(item);
      }
    });
  }
  return resultado;
}

// ao selecionar um artigo, adicionar a lista
// de artigos selecionados, se o artigo ja tiver
// sido selecionado remover da lista.
bool adicionarFornecedor(Fornecedor a) {
  bool existe = false;
  for (var i = 0; i < fornecedorListaSelecionado.length; i++) {
    if (fornecedorListaSelecionado[i].fornecedor == a.fornecedor) {
      existe = true;
      fornecedorListaSelecionado.removeAt(i);
    }
  }

  if (!existe) {
    fornecedorListaSelecionado.add(a);
  }

  return existe;
}

bool existeFornecedorSelecionado(Fornecedor f) {
  bool existe = false;

  for (var i = 0; i < fornecedorListaSelecionado.length; i++) {
    if (fornecedorListaSelecionado[i].fornecedor == f.fornecedor) {
      existe = true;
    }
  }
  return existe;
}
