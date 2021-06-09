import 'package:flutter/widgets.dart';
import 'package:primobile/expedicao/bloc/bloc.dart';
import 'package:primobile/expedicao/models/expedicao.dart';

List<Expedicao> listaExpedicaoSelecionado = List<Expedicao>();
List<Expedicao> listaExpedicaoDisplay = List<Expedicao>();
List<ArtigoExpedicao> listaArtigoExpedicaoDisplayFiltro =
    List<ArtigoExpedicao>();
List<ArtigoExpedicao> listaArtigoExpedicaoDisplay = List<ArtigoExpedicao>();
ExpedicaoBloc expedicaoBloc;
Map<String, List<String>> expedicaoListaArmazemDisplay =
    Map<String, List<String>>();
TextEditingController expedicaoPesquisarController = TextEditingController();
List<ArtigoExpedicao> lista_artigo_expedicao = List<ArtigoExpedicao>();

List<DataRow> buildInventarioDataRow(String artigo, {ArtigoExpedicao artigoObj}) {
