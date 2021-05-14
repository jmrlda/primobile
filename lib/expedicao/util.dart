import 'package:flutter/widgets.dart';
import 'package:primobile/expedicao/bloc/bloc.dart';
import 'package:primobile/expedicao/models/expedicao.dart';

List<Expedicao> listaExpedicaoSelecionado = List<Expedicao>();
List<Expedicao> listaExpedicao = List<Expedicao>();
ExpedicaoBloc expedicaoBloc;

TextEditingController expedicaoPesquisarController = TextEditingController();
