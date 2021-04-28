import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:primobile/artigo/models/models.dart';
import 'package:primobile/expedicao/models/expedicao.dart';
import 'package:primobile/expedicao/models/models.dart';
import 'package:primobile/inventario/inventario.dart';
import 'package:primobile/inventario/models/artigo_inventario.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';
import 'package:http/http.dart' as http;
import 'package:primobile/util/util.dart';

BuildContext contexto;
http.Client httpClient = http.Client();
List<ArtigoExpedicao> linhaExpedicao = List<ArtigoExpedicao>();
List<ArtigoExpedicao> lista_artigo_expedicao = List<ArtigoExpedicao>();
ScrollController _scrollController = new ScrollController();
List<bool> posicao;
int idx = 0;

class ExpedicaoEditorPage extends StatefulWidget {
  ExpedicaoEditorPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ExpedicaoEditorPageState createState() => new _ExpedicaoEditorPageState();
}

class _ExpedicaoEditorPageState extends State<ExpedicaoEditorPage> {
  TextEditingController txtArtigoQtd = new TextEditingController();

  BuildContext context;
  var items = List<dynamic>();
  final List<dynamic> encomendaItens = <dynamic>[
    // encomendaItemVazio(),
  ];

  double mercadServicValor = 0.0;
  double noIva = 0.0;
  double ivaTotal = 0.0;
  double subtotal = 0.0;
  double totalVenda = 0.0;
  Expedicao expedicao = Expedicao();
  double iva = 17.0;
  List<Artigo> artigos = new List<Artigo>();
  List artigoJson = List();
  bool erroEncomenda = false;
  String expedicaoNumDoc = "Selecionar";
  @override
  void initState() {
    // encomendaItens.add(encomendaItemVazio());
    // items.addAll(encomendaItens);

    super.initState();

    try {
      updateConnection(() {
        if (this.mounted)
          setState(() {
            PRIMARY_COLOR = CONEXAO_ON_COLOR;
          });
      }, () {
        if (this.mounted)
          setState(() {
            PRIMARY_COLOR = CONEXAO_OFF_COLOR;
          });
      });
    } catch (e) {}
  }

  void update(cb) {
    setState(() {
      cb();
    });
  }

  Future<bool> createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Atenção')),
            content: Text('Deseja Cancelar Expedição ?'),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text('Sim'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              MaterialButton(
                elevation: 5.0,
                child: Text('Não'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    idx = 0;
    contexto = context;
    return WillPopScope(
      child: new Scaffold(
        appBar: new AppBar(
          backgroundColor: PRIMARY_COLOR,
          centerTitle: true,
          title: new Text("Expedição"),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              if (artigos != null && artigos.length > 0) {
                createAlertDialog(context).then((sair) {
                  if (sair == true) {
                    Navigator.of(context).pop();
                  }
                });
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        body: Container(
          color: Colors.blue[400],
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 285,
                decoration: BoxDecoration(
                  color: Colors.blue[900], // fromRGBO(7, 89, 250, 100)
                  // gradient: LinearGradient(
                  //     // begin: ``
                  //     colors: [Colors.blueAccent, Colors.blueAccent]),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    espaco(),
                    Container(
                      width: MediaQuery.of(context).size.width - 30,
                      height: 200,
                      padding: EdgeInsets.only(
                          top: 5, left: 16, right: 16, bottom: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              // blurRadius: 5
                            )
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // espaco(),.
                          Spacer(),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Expedição",
                                style:
                                    TextStyle(fontSize: 18, color: Colors.blue),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  bool conexao = await temConexao();

                                  if (conexao == true) {
                                    final result = Navigator.pushNamed(
                                        context, '/expedicao_lista');

                                    result.then((value) async {
                                      expedicao = value;
                                      lista_artigo_expedicao.clear();
                                      lista_artigo_expedicao =
                                          await _fetchLinhaExpedicao(
                                              expedicao.expedicao, 0, 0);

                                      if (lista_artigo_expedicao == null) {
                                        SessaoApiProvider.refreshToken();
                                        lista_artigo_expedicao =
                                            await _fetchLinhaExpedicao(
                                                int.parse(expedicao.expedicao
                                                    .toString()),
                                                0,
                                                0);
                                      }
                                      posicao = List.filled(
                                          lista_artigo_expedicao.length, false);

                                      actualizarEstado();
                                    });
                                  } else {
                                    alerta_info(
                                        contexto, "Verifique sua conexão.");
                                  }
                                },
                                child: Text(
                                  expedicaoNumDoc,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                          Spacer(),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Armazem",
                                style:
                                    TextStyle(fontSize: 18, color: Colors.blue),
                              ),
                              Text(
                                "A1",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return items[index];
                    // ListTile(
                    //   title: Text('${items[index]}'),
                    // );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.exit_to_app, color: Colors.blue),
              label: 'Sair',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera, color: Colors.blue),
              label: 'Camera',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline, color: Colors.blue),
              label: 'terminar',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue[800],
          onTap: _onItemTapped,
        ),
      ),
      onWillPop: () async {
        if (artigos != null && artigos.length > 0) {
          bool rv = await createAlertDialog(context);
          print('alert ' + rv.toString());
          return rv;
        } else {
          return true;
        }
      },
    );
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) async {
    // Sair
    if (index == 0) {
      if (artigos != null && artigos.length > 0) {
        createAlertDialog(contexto).then((sair) {
          if (sair == true) {
            Navigator.of(contexto).pop();
          }
        });
      }
    }
    if (index == 1) {
      // Ler codigo de barra de um artigo e identificar se esta
      // na lista de ArtigoExpedição, se localizado, alterar as quantidades
      // a expedir e alterar o estado da linha como processado ou actualizado

      // FlutterBarcodeScanner.getBarcodeStreamReceiver(
      //         "#ff6666", "Cancelar", true, ScanMode.DEFAULT)
      //     .listen((codigoBarra) {
      //   if (codigoBarra != null && codigoBarra != "-1") {
      //     print(codigoBarra);
      //     lista_artigo_expedicao.forEach((artigo) {
      //       if (artigo.codigoBarra == codigoBarra) {
      //         print("Encontrado");
      //       }
      //     });
      //   }
      // });
      scanBarCode();

      actualizarEstado();

      // Terminar
    }
    if (index == 2) {
      createAlertDialogEncomendaProcesso(BuildContext context) {
        bool rv = false;
        return showDialog(
            context: contexto,
            builder: (contexto) {
              // 1 minuto ate fechar a janela devido a demora do processo de envio de encomenda
              Future.delayed(Duration(seconds: 60), () {
                // alerta_info(contexto, "Parado processo devido o tempo de espera!");
                if (this.mounted) {
                  setState(() {
                    rv = true;
                  });
                }
                // Navigator.of(context).pop(true);
              });
              return WillPopScope(
                child: AlertDialog(
                  title: Center(child: Text('Aguarde')),
                  content: Container(
                      width: 50,
                      height: 50,
                      child: Center(child: CircularProgressIndicator())),
                ),
                onWillPop: () async {
                  return rv;
                },
              );
            });
      }

      bool conexao = await temConexao();

      if (conexao == true) {
        ArtigoExpedicao.postExpedicao(expedicao, lista_artigo_expedicao)
            .then((value) async {
          if (value.statusCode == 200) {
            await Navigator.pushReplacementNamed(
                contexto, '/expedicao_sucesso');
          } else if (value.statusCode == 401 || value.statusCode == 500) {
            //  #TODO informar ao usuario sobre a renovação da sessão
            // mostrando mensagem e um widget de LOADING
            alerta_info(contexto, 'Aguarde a sua sessão esta a ser renovada');
            await SessaoApiProvider.refreshToken();
          } else {
            alerta_info(contexto,
                'Servidor não respondeu com sucesso o envio da expedição! Por favor tente novamente');
          }
        }).catchError((err) {
          print('[postExpedicao] ERRO');
          print(err);
          if (this.mounted == true) {
            setState(() {
              erroEncomenda = true;
            });
          }

          alerta_info(contexto,
              'Ocorreu um erro interno ao enviar expedição! Por favor tente novamente');
        });
      } else {
        alerta_info(contexto, "Verifique sua conexão.");
      }
    }
    _selectedIndex = index;
  }

  void actualizarEstado() {
    /**
           * Se tiver artigos selecionados.
          *   limpar a lista artigos previamente selecionados
          **/

    // items.clear();

    setState(() {
      items.clear();
      encomendaItens.clear();
      expedicaoNumDoc = expedicao.expedicao.toString();

      items = getListaArtigo(lista_artigo_expedicao);
    });
  }

  Card encomendaItemVazio() {
    return Card(
        child: Column(
      children: <Widget>[
        const SizedBox(height: 50),
        RaisedButton(
          color: Colors.blue,
          onPressed: () async {
            await Navigator.pushNamed(contexto, '/artigo_selecionar_lista');
          },
          child: const Text('Adicionar ',
              style: TextStyle(fontSize: 15, color: Colors.white)),
        ),
        const SizedBox(height: 50),
      ],
    ));
  }

  void removeEncomenda(Artigo a) {
    for (var i = 0; i < encomendaItens.length; i++) {
      if (encomendaItens[i].child.artigo.artigo == a.artigo) {
        encomendaItens.removeAt(i);
        artigos.removeAt(i);
      }
    }
  }

  Future<bool> temLocalizacao() async {
    bool rv = false;

    //

    return rv;
  }

  createAlertDialogAssinatura(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Atenção')),
            content: Container(
                height: 40,
                alignment: Alignment.center,
                child: Center(
                    child: Text(
                        'Encomenda não certificada.\n Por favor Assine antes de gravar'))),
            actions: [
              new IconButton(
                color: Colors.blue,
                icon: new Icon(Icons.check),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              )
            ],
          );
        });
  }

  Padding espaco() {
    return Padding(
      padding: EdgeInsets.only(top: 15, left: 16, right: 16, bottom: 4),
    );
  }

  // Retornar lista de artigos por expedir convertidos em widgets
  List<Widget> getListaArtigo(List<ArtigoExpedicao> artigos) {
    List<Widget> lista_widget = List<Widget>();

    if (artigos != null || artigos.length > 0) {
      int i = 0;
      artigos.forEach((artigo) {
        lista_widget.add(expedicaoItem(artigo));
      });
    } else {
      lista_widget.add(Text(
        "Sem Artigo",
        style: TextStyle(color: Colors.blue, fontSize: 14),
      ));
    }

    return lista_widget;
  }

  Widget buildArtigoExpedicao(List<ArtigoExpedicao> artigos, int index) {
    List<Widget> lista_widget = List<Widget>();
    if (artigos != null || artigos.length > 0) {
      return (expedicaoItem(artigos[index]));
    }

    return Text("Sem Artigo",
        style: TextStyle(color: Colors.blue, fontSize: 14));
  }

  // Widget representado cada Artigo de uma expedição
  // Widget artigoExpedicao(ArtigoExpedicao artigo) {
  //   // return Slidable(
  //   //   actionPane: SlidableDrawerActionPane(),
  //   //   actionExtentRatio: 0.25,
  //   //   child:,
  //   //   // secondaryActions: <Widget>[
  //   //   //   IconSlideAction(
  //   //   //     caption: 'Remover',
  //   //   //     color: Colors.red,
  //   //   //     icon: Icons.delete,
  //   //   //     onTap: () {
  //   //   //       // setState(() {
  //   //   //       //   removeEncomenda(artigo);
  //   //   //       //   // actualizarEstado();
  //   //   //       // });
  //   //   //     },
  //   //   //   ),
  //   //   // ],
  //   // );
  //   //
  // return expedicaoItem(artigo);
  // }

  // buscar as linhas de uma determinada Expedição identificado pelo 'Numero de documento'
  Future<List<ArtigoExpedicao>> _fetchLinhaExpedicao(
      int numDoc, int startIndex, int limit) async {
    try {
      var sessao = await SessaoApiProvider.readSession();
      var response;
      if (sessao == null || sessao.length == 0) {
        print('Ficheiro sessao nao existe');
        return <ArtigoExpedicao>[];
      } else {
        String token = sessao['access_token'];
        String ip = sessao['ip_local'];
        String porta = sessao['porta'];
        String baseUrl = await SessaoApiProvider.getHostUrl();
        String protocolo = await SessaoApiProvider.getProtocolo();

        final response = await httpClient.get(
            protocolo +
                baseUrl +
                '/WebApi/ExpedicaoController/Expedicao/lista/' +
                numDoc.toString(),
            headers: {
              "Authorization": "Bearer $token",
              "Accept": "application/json"
            });

        if (response.statusCode == 200) {
          dynamic data = json.decode(response.body);

          await data.map((expedicao) {
            lista_artigo_expedicao
                .add(ArtigoExpedicao.fromJson(json.decode(expedicao)));
          }).toList();

          return lista_artigo_expedicao;
        }
        final msg = json.decode(response.body);
        print("Ocorreu um erro" + msg["Message"]);
      }
    } catch (e) {
      throw e;
    }
    return null;
  }

  ArtigoExpedicaoCard expedicaoItem(ArtigoExpedicao artigo) {
    txtArtigoQtd.text = artigo.quantidadeExpedir.toString();
    ArtigoExpedicaoCard artigoInventario;
    final GlobalKey expansionTileKey = GlobalKey();

    if (posicao[idx] == true) {
      txtArtigoQtd.selection = TextSelection(
          baseOffset: 0, extentOffset: txtArtigoQtd.value.text.length);
      artigoInventario = buildExpedicaoItem(artigo, true, expansionTileKey);
    } else {
      artigoInventario = buildExpedicaoItem(artigo, false, expansionTileKey);
    }
    idx++;

    return artigoInventario;
  }

  ArtigoExpedicaoCard buildExpedicaoItem(
      ArtigoExpedicao artigo, bool state, GlobalKey key) {
    return ArtigoExpedicaoCard(
      artigo: artigo,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 15, left: 20, right: 16, bottom: 4),
          ),

          ExpansionTile(
            key: key,
            maintainState: state,
            initiallyExpanded: state,
            title: Text(artigo.descricao,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            subtitle: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("Artigo:    " + artigo.artigo,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ],
                ),
              ],
            ),
            children: [
              Row(
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.only(top: 5, left: 15, right: 5, bottom: 5),
                    child: Text(
                      "Qtd. Pendente: ",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 5, left: 0, right: 20, bottom: 5),
                    child: Text(
                      artigo.quantidadePendente.toString(),
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.only(top: 5, left: 15, right: 5, bottom: 0),
                    child: Text(
                      "Qtd. Expedir: ",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 5, left: 15, right: 20, bottom: 15),
                    child: Container(
                      child: TextField(
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        controller: txtArtigoQtd,
                        onChanged: (value) {
                          try {
                            if (double.parse(txtArtigoQtd.text) > 0) {
                              artigo.quantidadeExpedir =
                                  double.parse(txtArtigoQtd.text);
                            }
                          } catch (e) {}
                        },
                        onTap: () {
                          txtArtigoQtd.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: txtArtigoQtd.value.text.length);
                        },
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      width: 100,
                    ),
                  ),
                ],
              )
            ],
          ),

          // Padding(
          //   padding: EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 4),
          // ),
        ],
      ),
    );
  }

//   void scanBarCode() {
//     // dynamic codigoBarra = FlutterBarcodeScanner.getBarcodeStreamReceiver(
//     //     "#ff6666", "Cancelar", true, ScanMode.DEFAULT);

//     String codigoBarra = '6935364092313';

//     try {
//       if (codigoBarra != null) {
//         print(codigoBarra);
//         int i = 0;
//         lista_artigo_expedicao.forEach((artigo) async {
//           if (artigo.codigoBarra == codigoBarra) {
//             // print("Encontrado");

//             print("ARtigo " + artigo.artigo);
//             // print("descricao " + artigo.descricao);

//             _scrollController
//                 .animateTo(
//               (94.0 * i),
//               curve: Curves.easeInToLinear,
//               duration: const Duration(milliseconds: 300),
//             )
//                 .then((value) {
//               print('scroll');
//             });
//           }
//           i++;
//         });

//         posicao[i] = true;
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
// }
//
//
//
  void scanBarCode() {
    // dynamic codigoBarra = FlutterBarcodeScanner.getBarcodeStreamReceiver(
    //     "#ff6666", "Cancelar", true, ScanMode.DEFAULT);

    String codigoBarra = '6935364092313';

    try {
      if (codigoBarra != null) {
        print(codigoBarra);
        int i = 0;
        lista_artigo_expedicao.forEach((artigo) async {
          if (artigo.codigoBarra == codigoBarra) {
            print("ARtigo " + artigo.artigo);
            posicao[i] = true;
            _scrollController
                .animateTo(
              (94.0 * i),
              curve: Curves.easeInToLinear,
              duration: const Duration(milliseconds: 100),
            )
                .then((value) {
              print('scroll');
            });
          }
          i++;
        });
      }
    } catch (e) {
      print(e);
    }
  }
}

class ArtigoExpedicaoCard extends Card {
  ArtigoExpedicaoCard(
      {Key key,
      this.color,
      this.elevation,
      this.shape,
      this.borderOnForeground = true,
      this.margin,
      this.clipBehavior,
      this.child,
      this.semanticContainer = true,
      this.artigo})
      : super(
          key: key,
          color: color,
          elevation: elevation,
          shape: shape,
          borderOnForeground: borderOnForeground,
          margin: margin,
          clipBehavior: clipBehavior,
        );
  final Color color;
  final double elevation;
  final ShapeBorder shape;
  final Clip clipBehavior;
  final bool borderOnForeground;
  final EdgeInsetsGeometry margin;
  final Widget child;
  final bool semanticContainer;
  final ArtigoExpedicao artigo;
}
