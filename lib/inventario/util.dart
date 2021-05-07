import 'package:flutter/widgets.dart';
import 'package:primobile/inventario/bloc/bloc.dart';

import 'models/models.dart';

List<Inventario> listaInventarioSelecionado = List<Inventario>();
List<Inventario> listaInventario = List<Inventario>();
TextEditingController inventarioPesquisarController = TextEditingController();
InventarioBloc inventarioBloc;
