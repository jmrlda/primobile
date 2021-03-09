import 'package:flutter/material.dart';
import 'package:primobile/artigo/models/models.dart';
import 'package:primobile/artigo/util.dart';
import 'package:primobile/util.dart';

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

class ArtigoListaItem extends StatelessWidget {
  final Artigo artigo;

  const ArtigoListaItem({Key key, @required this.artigo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String url = baseUrl + artigo.artigo;

    return _ListaTile(
      leading: GestureDetector(
          child: ClipOval(child: networkIconImage(url)),
          onTap: () async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Center(child: Text(artigo.descricao)),
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
      title: Text(
        artigo.descricao,
        style: TextStyle(
            color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(
        "Cod: " +
            artigo.artigo +
            ' ' +
            "Un: " +
            artigo.unidade +
            ', ' +
            "PVP: " +
            artigo.preco.toString() +
            ' MT',
        style: TextStyle(color: Colors.blue, fontSize: 14),
      ),
      data: artigo.descricao,
    );
  }
}
