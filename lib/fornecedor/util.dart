import 'package:primobile/fornecedor/models/fornecedor.dart';

List<Fornecedor> fornecedorLista = new List<Fornecedor>();
List<Fornecedor> fornecedorListaSelecionado = List<Fornecedor>();
bool isSelected = false;

String baseUrl = "";
String url = "";

void opcaoAcao(String opcao) async {
  if (opcao == 'sincronizar') {}
}

// metodo para busca de artigos na lista
List<Fornecedor> fornecedorPesquisar(
    String query, List<Fornecedor> listaFornecedor) {
  List<Fornecedor> resultado = List<Fornecedor>();

  if (query.trim().isNotEmpty) {
    listaFornecedor.forEach((item) {
      if (item.descricao
              .toLowerCase()
              .contains(query.toString().toLowerCase()) ||
          item.artigo.toLowerCase().contains(query.toString().toLowerCase())) {
        resultado.add(item);
      }
    });
  }
  return resultado;
}

// ao selecionar um artigo, adicionar a lista
// de artigos selecionados, se o artigo ja tiver
// sido selecionado remover da lista.
bool adicionarArtigo(Fornecedor a) {
  bool existe = false;
  for (var i = 0; i < fornecedorListaSelecionado.length; i++) {
    if (fornecedorListaSelecionado[i].artigo == a.artigo) {
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
    if (fornecedorListaSelecionado[i].artigo == f.artigo) {
      existe = true;
    }
  }
  return existe;
}
