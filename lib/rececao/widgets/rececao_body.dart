// import 'package:flutter/material.dart';
// import 'package:primobile/rececao/bloc/bloc.dart';
// import 'package:primobile/rececao/view/rececao_lista.dart';

// Widget rececaoBody(
//     BuildContext context, RececaoBloc _rececaoBloc, bool isSelected) {
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
//                         _rececaoBloc.query = value;
//                         _rececaoBloc..add(RececaoSearched());
//                       } else {
//                         _rececaoBloc.query = "";

//                         _rececaoBloc..add(RececaoSearched());
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
//             child: RececaoLista(
//           title: 'rececao',
//           isSelected: isSelected,
//         )),
//       ],
//     ),
//   );
// }
