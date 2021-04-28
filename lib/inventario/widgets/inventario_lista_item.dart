import 'package:flutter/material.dart';
import 'package:primobile/inventario/bloc/bloc.dart';
import 'package:primobile/inventario/models/models.dart';
import 'package:primobile/inventario/util.dart';
import 'package:primobile/util/util.dart';

class _ListaTile extends ListTile {
  _ListaTile(
      {Key key,
      this.leading,
      this.title,
      this.subtitle,
      this.trailing,
      this.isThreeLine = false,
      this.dense,
      this.contentPadding,
      this.enabled = true,
      this.onTap,
      this.onLongPress,
      this.selected = false,
      this.data = ""})
      : super(
            key: key,
            leading: leading,
            title: title,
            subtitle: subtitle,
            trailing: trailing,
            isThreeLine: isThreeLine,
            dense: dense,
            contentPadding: contentPadding,
            enabled: enabled,
            onTap: onTap,
            onLongPress: onLongPress,
            selected: selected);
  final Widget leading;
  final Widget title;
  final Widget subtitle;
  final Widget trailing;
  final bool isThreeLine;
  final bool dense;
  final EdgeInsetsGeometry contentPadding;
  final bool enabled;
  final GestureTapCallback onTap;
  final GestureLongPressCallback onLongPress;
  final bool selected;
  final String data;

  String getTitle() {
    return this.data;
  }

  bool contem(value) {
    return this.data.toLowerCase().contains(value.toString().toLowerCase());
  }
}

class InventarioListaItem extends StatelessWidget {
  final Inventario inventario;
  final InventarioBloc inventarioBloc;
  final isSelected;
  const InventarioListaItem(
      {Key key,
      @required this.inventario,
      this.inventarioBloc,
      this.isSelected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Conexao.url = Conexao.baseUrl + inventario.documentoNumero.toString();
    TextEditingController txtArtigoQtd = new TextEditingController();
    String msgQtd = '';
    if (this.isSelected == false) {
      listaInventarioSelecionado.clear();
    }
    return new Container(
        color: existeInventarioSelecionado(
                        inventario, listaInventarioSelecionado) ==
                    false ||
                this.isSelected == false
            ? Colors.white
            : Colors.red,
        child: _ListaTile(
          selected: false,
          onTap: () {
            if (isSelected) {
              Navigator.pop(context, inventario);
            }
          },
          leading: GestureDetector(
              child: ClipOval(child: networkIconImage(Conexao.url)),
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    BuildContext contexto = context;
                    return AlertDialog(
                      title: Center(child: Text(inventario.documentoNumero)),
                      actions: <Widget>[
                        IconButton(
                          icon: new Icon(Icons.close),
                          onPressed: () => Navigator.of(contexto).pop(),
                        )
                      ],
                    );
                  },
                );
              }),
          title: Text(
            inventario.descricao,
            style: TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Text(
            "Responsavel: " + inventario.responsavel,
            style: TextStyle(
                color: Colors.blue, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          data: inventario.documentoNumero.toString(),
        ));
  }
}
