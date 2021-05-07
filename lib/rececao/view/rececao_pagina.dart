import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:primobile/rececao/bloc/bloc.dart';
import 'package:primobile/rececao/util.dart';
import 'package:primobile/rececao/view/rececao_lista.dart';
import 'package:primobile/rececao/widgets/rececao_appbar.dart';
import 'package:primobile/rececao/widgets/widgets.dart';

class RececaoPage extends StatefulWidget {
  final bool isSelected;
  RececaoPage({this.isSelected = false});

  @override
  _RececaoPageState createState() => _RececaoPageState();
}

class _RececaoPageState extends State<RececaoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: rececaoAppBar(context),
      body: rececaoBody(context, this.widget.isSelected),

      // BlocProvider(
      //   create: (BuildContext context) => _rececaoBloc,
      //   // ArtigoBloc(httpClient: http.Client())..add(ArtigoFetched()),
      //   child: rececaoBody(context, this.widget.isSelected),
      // ),
    );
  }

  Widget rececaoBody(BuildContext context, bool isSelected) {
    return Container(
        child: BlocProvider(
      create: (BuildContext context) {
        rececaoPesquisarController.text = "";

        rececaoBloc = RececaoBloc(httpClient: http.Client())
          ..add(RececaoFetched());

        return rececaoBloc;
      },
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            decoration:
                BoxDecoration(color: Color.fromRGBO(241, 249, 255, 100)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: 45,
                  padding:
                      EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                    )
                  ]),
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        hintText: 'Procurar'),
                    onChanged: (value) {
                      setState(() {
                        if (value != null && value.trim().length > 0) {
                          rececaoBloc.query = value;
                          rececaoBloc..add(RececaoSearched());
                        } else {
                          rececaoBloc.query = "";

                          rececaoBloc..add(RececaoFetched());
                        }
                      });
                    },
                    controller: rececaoPesquisarController,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: RececaoLista(
            title: 'rececao',
            isSelected: isSelected,
          )),
        ],
      ),
    ));
  }
}
