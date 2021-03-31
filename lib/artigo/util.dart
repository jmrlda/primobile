import 'package:primobile/artigo/models/artigo.dart';

List<Artigo> artigoLista = new List<Artigo>();
List<Artigo> artigosDuplicado = new List<Artigo>();
List<Artigo> listaArtigoSelecionado = List<Artigo>();
bool isSelected = false;

String baseUrl = "";
String url = "";

void opcaoAcao(String opcao) async {
  if (opcao == 'sincronizar') {}
}

// metodo para busca de artigos na lista
List<Artigo> artigoPesquisar(String query, List<Artigo> listaArtigo) {
  List<Artigo> resultado = List<Artigo>();

  if (query.trim().isNotEmpty) {
    listaArtigo.forEach((item) {
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
bool adicionarArtigo(Artigo a) {
  bool existe = false;
  for (var i = 0; i < listaArtigoSelecionado.length; i++) {
    if (listaArtigoSelecionado[i].artigo == a.artigo) {
      existe = true;
      listaArtigoSelecionado.removeAt(i);
    }
  }

  if (!existe) {
    listaArtigoSelecionado.add(a);
  }

  return existe;
}

bool existeArtigoSelecionado(Artigo a) {
  bool existe = false;

  for (var i = 0; i < listaArtigoSelecionado.length; i++) {
    if (listaArtigoSelecionado[i].artigo == a.artigo) {
      existe = true;
    }
  }
  return existe;
}
