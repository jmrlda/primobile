import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primobile/artigo/bloc/artigo_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:primobile/fornecedor/bloc/bloc.dart';
import 'package:primobile/fornecedor/util.dart';
import 'package:primobile/fornecedor/view/view.dart';
import 'package:primobile/fornecedor/widgets/fornecedor_appbar.dart';
import 'package:primobile/fornecedor/widgets/fornecedor_body.dart';
import 'package:primobile/menu/util.dart';

class FornecedorPage extends StatefulWidget {
  final bool isSelected;
  FornecedorPage({this.isSelected = false});
  @override
  _FornecedorPageState createState() => _FornecedorPageState();
}

class _FornecedorPageState extends State<FornecedorPage> {
  @override
  Widget build(BuildContext context) {
    ArtigoBloc _artigoBloc = ArtigoBloc(httpClient: http.Client())
      ..add(ArtigoFetched());
    return Scaffold(
      appBar: fornecedorAppBar(context),
      body: fornecedorBody(context, this.widget.isSelected),

      //  BlocProvider(
      //   create: (BuildContext context) => _artigoBloc,
      //   // ArtigoBloc(httpClient: http.Client())..add(ArtigoFetched()),
      //   child: ,
      // ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.save),
      //   onPressed: () async {
      //     // Navigator.pop(context, listaArtigoSelecionado);
      //   },
      // )
    );
  }

  Widget fornecedorBody(BuildContext context, bool isSelected) {
    return Container(
        child: BlocProvider(
            create: (BuildContext context) {
              fornecedorPesquisaController.text = "";
              fornecedorBloc = FornecedorBloc(httpClient: http.Client())
                ..add(FornecedorFetched());

              return fornecedorBloc;
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
                                fornecedorBloc.query = value;

                                fornecedorBloc..add(FornecedorSearched());
                              } else {
                                fornecedorBloc.query = "";
                                fornecedorBloc..add(FornecedorFetched());
                              }
                            });
                          },
                          controller: fornecedorPesquisaController,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: FornecedorLista(
                  title: 'Fornecedor',
                  isSelected: isSelected,
                )),
              ],
            )));
  }
}
