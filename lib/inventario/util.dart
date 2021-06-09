import 'package:flutter/widgets.dart';
import 'package:primobile/inventario/bloc/bloc.dart';

import 'models/models.dart';

List<Inventario> listaInventarioSelecionado = List<Inventario>();
List<Inventario> listaInventarioDisplay = List<Inventario>();
List<ArtigoInventario> listaInventarioDisplayFiltro = List<ArtigoInventario>();
Map<String, List<String>> inventarioListaArmazemDisplay =
    Map<String, List<String>>();

List<ArtigoInventario> linhaInventario = List<ArtigoInventario>();
List<ArtigoInventario> lista_artigo_inventario = List<ArtigoInventario>();

TextEditingController inventarioPesquisarController = TextEditingController();
InventarioBloc inventarioBloc;
