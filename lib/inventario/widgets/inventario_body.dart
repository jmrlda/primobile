// import 'package:flutter/material.dart';
// import 'package:primobile/inventario/bloc/bloc.dart';
// import 'package:primobile/inventario/view/view.dart';

// Widget inventarioBody(
//     BuildContext context, InventarioBloc _inventarioBloc, bool isSelected) {
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
//                       _inventarioBloc.query = value;
//                       _inventarioBloc..add(InventarioSearched());
//                     } else {
//                       _inventarioBloc..add(InventarioSearched());
//                     }
//                   },
//                   controller: editingController,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Expanded(
//             child: InventarioLista(
//           title: 'inventario',
//           isSelected: isSelected,
//         )),
//       ],
//     ),
//   );
// }
