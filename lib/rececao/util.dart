import 'package:flutter/widgets.dart';
import 'package:primobile/rececao/bloc/bloc.dart';
import 'package:primobile/rececao/models/models.dart';

List<Rececao> listaRececaoSelecionado = List<Rececao>();
List<Rececao> listaRececaoDisplay = List<Rececao>();
RececaoBloc rececaoBloc;
TextEditingController rececaoPesquisarController = TextEditingController();

List<ArtigoRececao> listaArtigoRececaoDisplayFiltro = List<ArtigoRececao>();
List<ArtigoRececao> listaArtigoRececaoDisplay = List<ArtigoRececao>();
List<ArtigoRececao> lista_artigo_rececao = List<ArtigoRececao>();
Map<String, List<String>> rececaoListaArmazemDisplay =
    Map<String, List<String>>();