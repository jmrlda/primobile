import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:primobile/rececao/bloc/bloc.dart';
import 'package:primobile/rececao/widgets/rececao_appbar.dart';
import 'package:primobile/rececao/widgets/widgets.dart';

class RececaoPage extends StatelessWidget {
  final bool isSelected;
  RececaoPage({this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    RececaoBloc _rececaoBloc = RececaoBloc(httpClient: http.Client())
      ..add(RececaoFetched());
    return Scaffold(
      appBar: rececaoAppBar(context),
      body: BlocProvider(
        create: (BuildContext context) => _rececaoBloc,
        // ArtigoBloc(httpClient: http.Client())..add(ArtigoFetched()),
        child: rececaoBody(context, _rececaoBloc, this.isSelected),
      ),
    );
  }
}
