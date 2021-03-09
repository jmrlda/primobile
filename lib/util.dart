import 'package:flutter/material.dart';

class Opcoes {
  static const String Sincronizar = 'sincronizar';

  static const List<String> escolha = <String>[
    Sincronizar,
  ];
}

Widget networkIconImage(url) {
  // Widget rv;
  // try {
  //   rv = CachedNetworkImage(
  //     width: 45,
  //     height: 45,
  //     fit: BoxFit.cover,
  //     imageUrl: url,
  //     placeholder: (context, url) => CircularProgressIndicator(),
  //     errorWidget: (context, url, error) => Icon(Icons.error),

  //   );
  // } catch (err) {
  //   rv = Icon(Icons.error);
  // }

  return Icon(Icons.error);
}
