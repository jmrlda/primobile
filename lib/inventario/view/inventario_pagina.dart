import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:primobile/inventario/bloc/bloc.dart';
import 'package:primobile/inventario/util.dart';
import 'package:primobile/inventario/view/view.dart';
import 'package:primobile/inventario/widgets/widgets.dart';

class InventarioPage extends StatefulWidget {
  final bool isSelected;
  InventarioPage({this.isSelected = false});

  @override
  _InventarioPageState createState() => _InventarioPageState();
}

class _InventarioPageState extends State<InventarioPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: inventarioAppBar(context),
      body: inventarioBody(context, this.widget.isSelected),
      // BlocProvider(
      //   create: (BuildContext context) => _inventarioBloc,
      //   // ArtigoBloc(httpClient: http.Client())..add(ArtigoFetched()),
      //   child: ,
      // ),
    );
  }

  Widget inventarioBody(BuildContext context, bool isSelected) {
    return Container(
        child: BlocProvider(
      create: (BuildContext context) {
        inventarioPesquisarController.text = "";

        inventarioBloc = InventarioBloc(httpClient: http.Client())
          ..add(InventarioFetched());

        return inventarioBloc;
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
                          inventarioBloc.query = value;
                          inventarioBloc..add(InventarioSearched());
                        } else {
                          inventarioBloc.query = "";

                          inventarioBloc..add(InventarioFetched());
                        }
                      });
                    },
                    controller: inventarioPesquisarController,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: InventarioLista(
            title: 'inventario',
            isSelected: isSelected,
          )),
        ],
      ),
    ));
  }
}
