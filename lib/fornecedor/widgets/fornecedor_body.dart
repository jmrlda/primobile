import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

// local
import 'package:primobile/artigo/bloc/artigo_bloc.dart';
import 'package:primobile/artigo/artigos.dart';
import 'package:primobile/artigo/util.dart';

Widget artigoBody(BuildContext context, ArtigoBloc _artigoBloc) {
  TextEditingController editingController = TextEditingController();

  return Container(
    child: Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: 100,
          decoration: BoxDecoration(color: Color.fromRGBO(241, 249, 255, 100)),
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
                    // _artigoBloc.add(ArtigoSearched());
                    if (value != null && value.trim().length > 0) {
                      _artigoBloc.query = value;
                      _artigoBloc..add(ArtigoSearched());
                    } else {
                      _artigoBloc..add(ArtigoFetched());
                    }
                  },
                  controller: editingController,
                ),
              ),
            ],
          ),
        ),
        Expanded(
            child: ArtigoLista(
          title: 'teste artigo',
        )),
      ],
    ),
  );
}
