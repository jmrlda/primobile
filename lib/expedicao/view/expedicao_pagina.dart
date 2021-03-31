import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:primobile/expedicao/bloc/bloc.dart';
import 'package:primobile/expedicao/widgets/expedicao_appbar.dart';
import 'package:primobile/expedicao/widgets/widgets.dart';

class ExpedicaoPage extends StatelessWidget {
  final bool isSelected;
  ExpedicaoPage({this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    ExpedicaoBloc _expedicaoBloc = ExpedicaoBloc(httpClient: http.Client())
      ..add(ExpedicaoFetched());
    return Scaffold(
      appBar: expedicaoAppBar(context),
      body: BlocProvider(
        create: (BuildContext context) => _expedicaoBloc,
        // ArtigoBloc(httpClient: http.Client())..add(ArtigoFetched()),
        child: expedicaoBody(context, _expedicaoBloc, this.isSelected),
      ),
    );
  }
}
