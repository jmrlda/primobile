import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:primobile/artigo/models/models.dart';
import 'package:primobile/util/util.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';

class ArtigoLoteForm extends StatefulWidget {
  ArtigoLoteForm({Key key, this.artigoArmazem}) : super(key: key);
  final ArtigoLote artigoLote = new ArtigoLote();
  ArtigoArmazem artigoArmazem;
  @override
  _ArtigoLoteFormState createState() => _ArtigoLoteFormState();
}

class _ArtigoLoteFormState extends State<ArtigoLoteForm> {
  DateTime selectedDate;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      content: StatefulBuilder(
          // You need this, notice the parameters below:
          builder: (BuildContext context, StateSetter setState) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Center(child: Text("Novo Lote", style: TextStyle(fontSize: 12))),
              // campo email
              TextInput("Artigo"),
              TextInput("Lote"),
              TextInput("Descricao"),
              DateInput("Data Fabrico"),
              DateInput("Data Validade"),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop(null);
                    },
                    child: const Text(
                      'Fechar',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      removeKeyCacheData('lote');
                      print(widget.artigoLote.toString());
                      ArtigoLote.httpPost(widget.artigoLote)
                          .then((value) async {
                        if (value.statusCode == 200) {
                          print("gravado com sucesso");
                          alerta_sucesso(context, 'Lote criado com sucesso');

                          List<ArtigoLote> lstArtigoLote =
                              new List<ArtigoLote>();
                          ToList lista = new ToList();
                          dynamic data = json.decode(value.body);
                          data = json.decode(data)["DataSet"]["Table"];

                          data.map((lote) async {
                            ArtigoLote _artigoLote =
                                ArtigoLote.fromJson(json.decode(lote));
                            Map<String, dynamic> map = json.decode(lote);
                            if (!lista.items.contains(_artigoLote))
                              lista.items.add(_artigoLote);
                          });
                          await saveCacheData("lote", lista);

                          this.widget.artigoArmazem.lote =
                              this.widget.artigoLote.lote;

                          this.widget.artigoArmazem.quantidade = 0;
                          this.widget.artigoArmazem.quantidadeExpedir = 0;
                          this.widget.artigoArmazem.quantidadePendente = 0;
                          this.widget.artigoArmazem.quantidadeRecebido = 0;
                          this.widget.artigoArmazem.quantidadeRejeitada = 0;
                          this.widget.artigoArmazem.quantidadeStock = 0;

                          Navigator.of(context).pop(this.widget.artigoArmazem);
                        } else if (value.statusCode == 401 ||
                            value.statusCode == 500) {
                          //  #TODO informar ao usuario sobre a renovação da sessão
                          // mostrando mensagem e um widget de LOADING

                          await SessaoApiProvider.refreshToken();
                          alerta_info(context,
                              'Tente novamente. A sessão foi renovada');
                        } else if (value.statusCode == 404) {
                          alerta_info(
                              context,
                              'Ocorreu um erro: Artigo ' +
                                  this.widget.artigoLote.artigo +
                                  '  não existe');
                        } else if (value.statusCode == 406) {
                          alerta_info(
                              context,
                              'Ocorreu um erro: Artigo ' +
                                  this.widget.artigoLote.artigo +
                                  ' e Lote ' +
                                  this.widget.artigoLote.lote +
                                  ' ja registado!');
                        } else {
                          alerta_info(context,
                              'Servidor não respondeu com sucesso o envio do Lote! Por favor tente novamente');
                        }
                      }).catchError((err) {
                        print('[postLote] ERRO');
                        print(err);
                        if (this.mounted == true) {
                          alerta_info(context,
                              '[postLote]Ocorreu um erro: ' + err.toString());
                        }

                        alerta_info(context,
                            'Ocorreu um erro interno ao enviar Lote! Por favor tente novamente');
                      });
                    },
                    child: const Text('Guardar'),
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            ],
          ),
        );
      }),
      actions: null,
    );
  }

  Widget DateInput(String label) {
    final format = DateFormat("dd/MM/yyyy");
    Key inputKey = new Key(label);

    return Column(children: <Widget>[
      Text('$label (${format.pattern})'),
      DateTimeField(
        format: format,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
        },
      ),
    ]);

    // InputDatePickerFormField(
    //   fieldLabelText: label + "  ($format)",
    //   fieldHintText: format,
    //   key: inputKey,
    //   firstDate: DateTime(1900),
    //   lastDate: DateTime(2100),
    //   onDateSubmitted: (datetime) {
    //     print(datetime);
    //     print('submit');
    //   },
    //   onDateSaved: (datetime) {
    //     if (label == "Data Fabrico")
    //       setState(() {
    //         selectedDate = datetime;
    //       });
    //     else if (label == "Data Validade")
    //       setState(() {
    //         selectedDate = datetime;
    //       });
    //   },
    // );
  }

  Widget TextInput(String label) {
    TextEditingController inputController = new TextEditingController();
    Key inputKey = new Key(label);

    if (label == "Artigo")
      inputController.text = this.widget.artigoArmazem.artigo ?? "";
    this.widget.artigoLote.artigo = this.widget.artigoArmazem.artigo ?? "";

    return TextField(
      controller: inputController,
      decoration: InputDecoration(labelText: label, hintText: label),
      onChanged: (texto) {
        print(selectedDate);
        if (label == "Artigo")
          widget.artigoLote.artigo = texto;
        else if (label == "Lote")
          widget.artigoLote.lote = texto;
        else if (label == "Descricao") widget.artigoLote.descricao = texto;
      },
      onSubmitted: (texto) {
        print("submetido");
        if (label == "Artigo")
          widget.artigoLote.artigo = texto;
        else if (label == "Lote")
          widget.artigoLote.lote = texto;
        else if (label == "Descricao") widget.artigoLote.descricao = texto;
      },
    );
  }
}


// Widget artigoLoteForm(BuildContext context) {
//   BoxDecoration boxDecoration = BoxDecoration(
//       borderRadius: BorderRadius.all(Radius.circular(50)),
//       color: Colors.white,
//       boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]);
//   return AlertDialog(
//     scrollable: true,
//     content: StatefulBuilder(
//         // You need this, notice the parameters below:
//         builder: (BuildContext context, StateSetter setState) {
//       return SingleChildScrollView(
//         child: Column(
//           children: [
//             Center(child: Text("Novo Lote", style: TextStyle(fontSize: 12))),
//             // campo email
//             TextInput("Artigo"),
//             TextInput("Lote"),
//             TextInput("Descricao"),
//             DateInput("Data Fabrico"),
//             DateInput("Data Validade"),
//             Row(
//               children: [
//                 OutlinedButton(
//                   onPressed: () {
//                     print('Received click');
//                   },
//                   child: const Text(
//                     'Fechar',
//                     style: TextStyle(color: Colors.black),
//                   ),
//                 ),
//                 OutlinedButton(
//                   onPressed: () {
//                     print('Received click');
//                   },
//                   child: const Text('Guardar'),
//                 )
//               ],
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             ),
//           ],
//         ),
//       );
//     }),
//     actions: null,
//   );
// }
