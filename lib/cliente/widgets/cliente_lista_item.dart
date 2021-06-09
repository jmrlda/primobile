import 'package:flutter/material.dart';
import 'package:primobile/cliente/bloc/bloc.dart';
import 'package:primobile/cliente/models/cliente.dart';
import 'package:primobile/cliente/util.dart';
import 'package:primobile/encomenda/models/encomenda.dart';
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

class ClienteListaItem extends StatelessWidget {
  final Cliente cliente;
  final ClienteBloc clienteBloc;
  final isSelected;
  const ClienteListaItem(
      {Key key,
      @required this.cliente,
      this.clienteBloc,
      this.isSelected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Conexao.url = Conexao.baseUrl + cliente.cliente;
    TextEditingController txtArtigoQtd = new TextEditingController();
    String msgQtd = '';

    return new Container(
        color: existeClienteSelecionado(cliente) == false
            ? Colors.white
            : Colors.red,
        child: _ListaTile(
          selected: false,
          onTap: () {
            if (isSelected) {
              Navigator.pop(context, cliente);
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
                      title: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                cliente.nome ?? "",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Telefone: " +
                                        cliente.telefone.replaceAll(" ", "") ??
                                    "",
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 11),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Limite Credito: " +
                                        cliente.limiteCredito
                                            .toString()
                                            .replaceAll(" ", "") ??
                                    "",
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 11),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "enc. Pendente: " +
                                        cliente.encomendaPendente
                                            .toString()
                                            .replaceAll(" ", "") ??
                                    "",
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 11),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Venda não Convertida: " +
                                        cliente.vendaNaoConvertida
                                            .toString()
                                            .replaceAll(" ", "") ??
                                    "",
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 11),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Total Débito: " +
                                        cliente.totalDeb
                                            .toString()
                                            .replaceAll(" ", "") ??
                                    "",
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 11),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Saldo Disponivel: " +
                                        Encomenda.calcularSaldoCliente(cliente)
                                            .toString() ??
                                    "",
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 11),
                              )
                            ],
                          )
                        ],
                      ),
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
            cliente.nome,
            style: TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          subtitle: Column(
            children: [
              Row(
                children: [
                  Text(
                    cliente.endereco.descricao ?? "",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Nº Contribuinte: " +
                            cliente.numContrib.replaceAll(" ", "") ??
                        "",
                    style: TextStyle(color: Colors.blue, fontSize: 13),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Telefone: " + cliente.telefone.replaceAll(" ", "") ?? "",
                    style: TextStyle(color: Colors.blue, fontSize: 13),
                  )
                ],
              )
            ],
          ),
          data: cliente.cliente,
        ));
  }
}
