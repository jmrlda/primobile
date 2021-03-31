import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:primobile/encomenda/models/models.dart';
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

Slidable encomenda(
    BuildContext context, Encomenda enc, List<EncomendaItem> itens, pos) {
  return Slidable(
    actionPane: SlidableDrawerActionPane(),
    actionExtentRatio: 0.18,
    child: encomendaItem(context, enc, itens, pos),
  );
}

Widget listaTile({
  Key key,
  Widget leading,
  Widget title,
  Widget subtitle,
  Widget trailing,
  bool dense,
  EdgeInsetsGeometry contentPadding,
  bool enabled,
  GestureTapCallback onTap,
  GestureLongPressCallback onLongPress,
  bool selected,
  String data,
  bool isThreeLine = false,
}) {
  return _ListaTile(
    key: key,
    leading: leading,
    title: title,
    subtitle: subtitle,
    trailing: trailing,
    // isThreeLine: isThreeLine,
    dense: dense,
    contentPadding: contentPadding,
    enabled: enabled,
    onTap: onTap,
    onLongPress: onLongPress,
    selected: selected,
    data: data,
  );
}

ExpansionTile encomendaItem(
    BuildContext context, Encomenda enc, List<EncomendaItem> itens, pos) {
  int count = 0;
  double totalValor = 0.0;
  List<DataTable> encomendaItens = List<DataTable>();

  encomendaItens.add(DataTable(
    columns: [
      DataColumn(
          label: Text("Artigo",
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w900,
              ))),
      DataColumn(
          label: Text("Qtd.",
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w900,
              ))),
      DataColumn(
          label: Text("P.Unit",
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w900,
              ))),
      DataColumn(
          label: Text("Subtotal",
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w900,
              ))),
    ],
    rows: [],
  ));

  itens.forEach((element) {
    EncomendaItem e = element;
    if (e.encomendaPk.toString() == enc.id.toString()) {
      totalValor += e.valorTotal;
      count++;
      encomendaItens.elementAt(0).rows.add(DataRow(cells: [
            DataCell(Text(e?.artigoPk.toString())),
            DataCell(Text(e.quantidade.toString())),
            DataCell(Text(e.valorUnit.toString())),
            DataCell(Text((e.valorUnit * e.quantidade).toStringAsFixed(2))),
          ]));
    }
  });

  MaterialColor cor = enc.estado == "pendente" ? Colors.red : Colors.blue;
  url = baseUrl + (enc.encomenda_id.replaceAll("/", "_"));
  return ExpansionTile(
    title: Padding(
      padding: EdgeInsets.only(top: 15, left: 16, right: 16),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.,
        children: <Widget>[
          GestureDetector(
              child: ClipOval(
                  child: Icon(
                Icons.gesture,
                size: 45,
              )
                  //     child: CachedNetworkImage(
                  //   width: 45,
                  //   height: 45,
                  //   fit: BoxFit.cover,
                  //   imageUrl: baseUrl + (enc.encomenda_id.replaceAll("/", "_")),
                  //   placeholder: (context, url) => CircularProgressIndicator(),
                  //   errorWidget: (context, url, error) => Icon(Icons.error),
                  // )
                  ),
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Center(child: Text(enc.encomenda_id)),
                      // memory(artigos[index].imagemBuffer as Uint8List, width: 350, height: 250)
                      content: CachedNetworkImage(
                        imageUrl:
                            baseUrl + enc.encomenda_id.replaceAll("/", "_"),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),

                      actions: <Widget>[
                        IconButton(
                          icon: new Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        )
                      ],
                    );
                  },
                );
              }),
          Padding(
            padding: EdgeInsets.only(left: 55),
            child: Text(enc.encomenda_id,
                style: TextStyle(
                    color: cor, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
    ),
    subtitle: Column(
      children: [
        Divider(),
        Padding(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 20),
            child: Center(
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(count > 1 ? count.toString() + " Artigos" : "1 Artigo",
                      style: TextStyle(color: cor, fontSize: 14)),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 10,
                    ),
                    child: Text(
                        double.parse(enc.valorTotal.toStringAsFixed(2))
                                .toString() +
                            "MTN",
                        style: TextStyle(color: cor, fontSize: 13)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 10,
                    ),
                    child: Text(enc.cliente.cliente,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: cor, fontSize: 13)),
                  ),
                ],
              ),
            )),
      ],
    ),
    children: encomendaItens,
  );
}
