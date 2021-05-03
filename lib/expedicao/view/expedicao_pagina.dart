import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:primobile/expedicao/bloc/bloc.dart';
import 'package:primobile/expedicao/util.dart';
import 'package:primobile/expedicao/view/view.dart';
import 'package:primobile/expedicao/widgets/expedicao_appbar.dart';

class ExpedicaoPage extends StatefulWidget {
  final bool isSelected;
  ExpedicaoPage({this.isSelected = false});

  @override
  _ExpedicaoPageState createState() => _ExpedicaoPageState();
}

class _ExpedicaoPageState extends State<ExpedicaoPage> {
  @override
  void initState() {
    super.initState();
    setState(() {
      expedicaoBloc = ExpedicaoBloc(httpClient: http.Client())
        ..add(ExpedicaoFetched());
    });
  }

  @override
  Widget build(BuildContext context) {
    // ExpedicaoBloc _expedicaoBloc = ExpedicaoBloc(httpClient: http.Client())
    //   ..add(ExpedicaoFetched());
    Widget rv = Scaffold(
        appBar: expedicaoAppBar(context),
        body: expedicaoBody(context, this.widget.isSelected));

    //   BlocProvider(
    //     create: (BuildContext context) => _expedicaoBloc,
    //     // ArtigoBloc(httpClient: http.Client())..add(ArtigoFetched()),
    //     child: expedicaoBody(context, _expedicaoBloc, this.widget.isSelected),
    //   ),
    // );

    return rv;
  }

  Widget expedicaoBody(BuildContext context, bool isSelected) {
    return Container(
      child: BlocProvider(
          create: (BuildContext context) {
            expedicaoPesquisarController.text = "";
            expedicaoBloc = ExpedicaoBloc(httpClient: http.Client())
              ..add(ExpedicaoFetched());

            return expedicaoBloc;
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
                      padding: EdgeInsets.only(
                          top: 4, left: 16, right: 16, bottom: 4),
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
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
                              expedicaoBloc.query = value;
                              expedicaoBloc..add(ExpedicaoSearched());
                            } else {
                              expedicaoBloc.query = "";

                              expedicaoBloc = ExpedicaoBloc(
                                  httpClient: http.Client(), query: "")
                                ..add(ExpedicaoFetched());
                            }
                          });
                        },
                        controller: expedicaoPesquisarController,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: ExpedicaoLista(
                title: 'expedicao',
                isSelected: isSelected,
              )),
            ],
          )),
    );
  }
}
