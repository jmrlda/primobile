// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:http/http.dart' as http;

// // local
// import 'package:primobile/artigo/bloc/artigo_bloc.dart';
// import 'package:primobile/artigo/artigos.dart';
// import 'package:primobile/artigo/util.dart';

// Widget artigoBody(BuildContext context, bool isSelected) {
//   // if (artigoPesquisarController.text != null &&
//   //     artigoPesquisarController.text.length > 0) {
//   //   search();
//   // } else {
//   //   fetch();
//   // }

//   return Container(
//       child: BlocProvider(
//     create: (BuildContext context) {
//       artigoPesquisarController.text = "";
//       return ArtigoBloc(httpClient: http.Client())..add(ArtigoFetched());
//     },
//     //
//     child: Column(
//       children: <Widget>[
//         Container(
//           width: MediaQuery.of(context).size.width,
//           height: 100,
//           decoration: BoxDecoration(color: Color.fromRGBO(241, 249, 255, 100)),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Container(
//                 width: MediaQuery.of(context).size.width / 1.2,
//                 height: 45,
//                 padding:
//                     EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
//                 decoration: BoxDecoration(color: Colors.white, boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                   )
//                 ]),
//                 child: TextField(
//                   decoration: InputDecoration(
//                       border: InputBorder.none,
//                       icon: Icon(
//                         Icons.search,
//                         color: Colors.grey,
//                       ),
//                       hintText: 'Procurar'),
//                   onChanged: (value) {
//                     // filtroResultadoBusca( value );
//                     // setState
//                     if (value != null && value.trim().length > 0) {
//                       artigoBloc.query = value;

//                       artigoBloc..add(ArtigoSearched());
//                     } else {
//                       artigoBloc.query = "";

//                       artigoBloc =
//                           ArtigoBloc(httpClient: http.Client(), query: "")
//                             ..add(ArtigoFetched());
//                     }
//                   },
//                   controller: artigoPesquisarController,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Expanded(
//             child: ArtigoLista(
//           title: 'Lista Artigo',
//           isSelected: isSelected,
//         )),
//       ],
//     ),
//   ));
// }
