import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primobile/artigo/artigos.dart';
import 'package:primobile/artigo/bloc/artigo_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:primobile/artigo/util.dart';
import 'package:primobile/artigo/widgets/artigo_appbar.dart';
import 'package:primobile/artigo/widgets/artigo_body.dart';

class ArtigoPage extends StatefulWidget {
  bool isSelected;
  ArtigoPage({this.isSelected = false});

  @override
  _ArtigoPageState createState() => _ArtigoPageState();
}

class _ArtigoPageState extends State<ArtigoPage> {
  @override
  void initState() {
    super.initState();
    setState(() {
      artigoBloc = ArtigoBloc(httpClient: http.Client())..add(ArtigoFetched());
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget rv = Scaffold(
      appBar: artigoAppBar(context),
      body: artigoBody(context, this.widget.isSelected),
      // , () {
      //   setState(() {
      //     artigoBloc = ArtigoBloc(
      //         httpClient: http.Client(), query: artigoPesquisarController.text)
      //       ..add(ArtigoSearched());
      //   });
      // }, () {
      //   setState(() {
      //     artigoBloc = ArtigoBloc(httpClient: http.Client())
      //       ..add(ArtigoFetched());
      //   });
      // }),

      // BlocProvider(
      //   create: (BuildContext context) => _artigoBloc,
      //   // ArtigoBloc(httpClient: http.Client())..add(ArtigoFetched()),
      //   //
      //   child: artigoBody(context,  this.isSelected),
      // )

      floatingActionButton: this.widget.isSelected
          ? FloatingActionButton(
              child: Icon(Icons.save),
              onPressed: () async {
                Navigator.pop(context, listaArtigoSelecionado);
              },
            )
          : null,
    );

    return rv;
  }

  Widget artigoBody(BuildContext context, bool isSelected) {
    // if (artigoPesquisarController.text != null &&
    //     artigoPesquisarController.text.length > 0) {
    //   search();
    // } else {
    //   fetch();
    // }

    return Container(
        child: BlocProvider(
      create: (BuildContext context) {
        artigoPesquisarController.text = "";

        artigoBloc = ArtigoBloc(httpClient: http.Client())
          ..add(ArtigoFetched());

        return artigoBloc;
      },
      //
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
                      // filtroResultadoBusca( value );
                      setState(() {
                        if (value != null && value.trim().length > 0) {
                          artigoBloc.query = value;

                          artigoBloc..add(ArtigoSearched());
                        } else {
                          artigoBloc.query = "";
                          artigoBloc..add(ArtigoFetched());

                          // artigoBloc =
                          //     ArtigoBloc(httpClient: http.Client(), query: "")
                          //       ..add(ArtigoFetched());
                        }
                      });
                    },
                    controller: artigoPesquisarController,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: ArtigoLista(
            title: 'Lista Artigo',
            isSelected: isSelected,
          )),
        ],
      ),
    ));
  }
}
