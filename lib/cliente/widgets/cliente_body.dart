// import 'package:flutter/material.dart';

// // local
// import 'package:primobile/cliente/bloc/bloc.dart';
// import 'package:primobile/cliente/view/cliente_lista.dart';

// Widget clienteBody(
//     BuildContext context, ClienteBloc _clienteBloc, bool isSelected) {
//   TextEditingController editingController = TextEditingController();
//   return Container(
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
//                     setState(() {
//                       if (value != null && value.trim().length > 0) {
//                         _clienteBloc.query = value;

//                         _clienteBloc..add(ClienteSearched());
//                       } else {
//                         _clienteBloc.query = "";
//                         _clienteBloc..add(ClienteFetched());
//                       }
//                     });
//                   },
//                   controller: editingController,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Expanded(
//             child: ClienteLista(
//           title: 'cliente',
//           isSelected: isSelected,
//         )),
//       ],
//     ),
//   );
// }
