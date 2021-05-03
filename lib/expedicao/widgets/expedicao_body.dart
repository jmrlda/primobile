// import 'package:flutter/material.dart';
// import 'package:primobile/expedicao/bloc/bloc.dart';
// import 'package:primobile/expedicao/view/view.dart';

// Widget expedicaoBody(
//     BuildContext context, ExpedicaoBloc _expedicaoBloc, bool isSelected) {
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
//                     if (value != null && value.trim().length > 0) {
//                       _expedicaoBloc.query = value;
//                       _expedicaoBloc..add(ExpedicaoSearched());
//                     } else {
//                       _expedicaoBloc..add(ExpedicaoSearched());
//                     }
//                   },
//                   controller: editingController,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Expanded(
//             child: ExpedicaoLista(
//           title: 'expedicao',
//           isSelected: isSelected,
//         )),
//       ],
//     ),
//   );
// }
