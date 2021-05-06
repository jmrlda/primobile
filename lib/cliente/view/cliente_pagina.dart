import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:primobile/cliente/cliente.dart';
import 'package:primobile/cliente/util.dart';
import 'package:primobile/cliente/view/cliente_lista.dart';
import 'package:primobile/cliente/widgets/cliente_appbar.dart';

class ClientePage extends StatefulWidget {
  final bool isSelected;
  ClientePage({this.isSelected = false});

  @override
  _ClientePageState createState() => _ClientePageState();
}

class _ClientePageState extends State<ClientePage> {
  @override
  Widget build(BuildContext context) {
    // clienteBloc..add(ClienteFetched());
    return Scaffold(
        appBar: clienteAppBar(context),
        body: clienteBody(context, this.widget.isSelected));
  }

  Widget clienteBody(BuildContext context, bool isSelected) {
    return Container(
        child: BlocProvider(
            create: (BuildContext context) {
              clientePesquisaController.text = "";
              clienteBloc = ClienteBloc(httpClient: http.Client())
                ..add(ClienteFetched());

              return clienteBloc;
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
                                clienteBloc.query = value;

                                clienteBloc..add(ClienteSearched());
                              } else {
                                clienteBloc.query = "";
                                clienteBloc..add(ClienteFetched());
                              }
                            });
                          },
                          controller: clientePesquisaController,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: ClienteLista(
                  title: 'cliente',
                  isSelected: isSelected,
                )),
              ],
            )));
  }
}
