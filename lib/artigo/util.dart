import 'package:primobile/artigo/models/artigo.dart';

List<Artigo> artigoLista = new List<Artigo>();
List<Artigo> artigosDuplicado = new List<Artigo>();
String baseUrl = "";
String url = "";

void opcaoAcao(String opcao) async {
  if (opcao == 'sincronizar') {
    // if (artigoLista != null && artigoLista.length > 0) {
    //   setState(() {
    //     artigoLista.clear();
    //   });
    // }
    // SincronizarModelo(context, "artigo").then((value) async {
    //   if (value) {
    //     artigoLista = await getArtigos();
    //   }
    // });
  }
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
