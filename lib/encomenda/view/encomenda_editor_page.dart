import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:primobile/artigo/models/models.dart';
import 'package:primobile/artigo/util.dart';
import 'package:primobile/cliente/models/models.dart';
import 'package:primobile/encomenda/models/models.dart';
import 'package:primobile/encomenda/widgets/encomenda_confirmacao.dart';
import 'package:primobile/regras_negocio/models/regras_negocio.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';
import 'package:primobile/usuario/models/models.dart';
import 'package:primobile/util/util.dart';
import 'package:signature/signature.dart';

BuildContext contexto;
BuildContext dialogContext;

class EncomendaEditorPage extends StatefulWidget {
  EncomendaEditorPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _EncomendaEditorPageState createState() => new _EncomendaEditorPageState();
}

class _EncomendaEditorPageState extends State<EncomendaEditorPage> {
  TextEditingController txtClienteController = TextEditingController();
  TextEditingController txtQtdArtigoController = TextEditingController();
  TextEditingController txtPesquisa = TextEditingController();

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
  Cliente cliente = Cliente();
  double iva = 17.0;
  List<Artigo> artigos = new List<Artigo>();
  List artigoJson = List();
  bool erroEncomenda = false;
  bool evtPesquisar = false;
  final GlobalKey encomendaPesquisaKey = GlobalKey();

  @override
  void initState() {
    // encomendaItens.add(encomendaItemVazio());
    // items.addAll(encomendaItens);

    super.initState();
    listaArtigoSelecionado.clear();

    try {
      updateConnection(() {
        setState(() {
          PRIMARY_COLOR = CONEXAO_ON_COLOR;
        });
      }, () {
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
            content: Text('Deseja Cancelar Encomenda ?'),
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
    contexto = context;
    // temConexao(
    //     'Dispositivo sem conexão WIFI ou Dados Moveis. Por Favor Active para criação das Encomendas!');
    // temLocalizacao();

    return WillPopScope(
      child: new Scaffold(
        appBar: new AppBar(
          backgroundColor: PRIMARY_COLOR,
          centerTitle: true,
          title: togglePesquisa(),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              // if (artigos != null && artigos.length > 0) {
              //   createAlertDialog(context).then((sair) {
              //     if (sair == true) {
              //       Navigator.of(context).pop();
              //     }
              //   });
              // } else {
              // }
              Navigator.of(contexto).pop();
            },
          ),
        ),
        body: Container(
          color: Colors.blue[400],
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 205,
                decoration: BoxDecoration(
                  color: Colors.blue[900], // fromRGBO(7, 89, 250, 100)
                  // gradient: LinearGradient(
                  //     // begin: ``
                  //     colors: [Colors.blueAccent, Colors.blueAccent]),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 1, bottom: 0),
                      // color: Colors.red,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            totalVenda.toStringAsFixed(2).toString() + "\n",
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 30,
                      height: 140,
                      padding: EdgeInsets.only(
                          top: 2, left: 16, right: 16, bottom: 2),
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
                          // espaco(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Mercadoria/Serviço",
                                style:
                                    TextStyle(fontSize: 14, color: Colors.blue),
                              ),
                              Text(
                                mercadServicValor
                                        .toStringAsFixed(2)
                                        .toString() +
                                    "\n",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          // espaco(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "IVA",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                ),
                              ),
                              Text(
                                ivaTotal.toStringAsFixed(2).toString() + "\n",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Total",
                                style:
                                    TextStyle(fontSize: 14, color: Colors.blue),
                              ),
                              Text(
                                subtotal.toStringAsFixed(2).toString(),
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: (MediaQuery.of(context).size.width - 62),
                                height: 40,

                                // margin: EdgeInsets.only(top: 64),/s
                                decoration: BoxDecoration(
                                    // borderRadius: BorderRadius.all(
                                    //   // Radius.circular(50)
                                    // ),
                                    color: Colors.white,
                                    border: Border.all(color: Colors.blue),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue,
                                        // blurRadius: 5
                                      )
                                    ]),
                                child: TextField(
                                  // enabled: false,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(
                                        Icons.person_outline,
                                        color: Colors.blue,
                                      ),
                                      hintText: 'Selecionar Cliente'),
                                  onChanged: (value) {
                                    // filtroResultadoBusca( value );
                                  },
                                  onTap: () async {
                                    bool conexao = await temConexao();

                                    if (conexao == true) {
                                      final result = Navigator.pushNamed(
                                          context, '/cliente_selecionar_lista');
                                      // print(result);
                                      result.then((obj) {
                                        // if (obj) {

                                        this.cliente = obj;
                                        if (obj != null) {
                                          if ((this.cliente.anulado == false &&
                                                  this.cliente.limiteCredito ==
                                                      0) ||
                                              this.cliente.anulado == false &&
                                                  Encomenda
                                                          .estaDentroLimiteCredito(
                                                              cliente,
                                                              totalVenda) ==
                                                      true) {
                                            txtClienteController.text =
                                                this.cliente.nome;
                                          } else {
                                            String msg = "";
                                            if (this.cliente.anulado == true) {
                                              msg =
                                                  "Cliente anulado. Entre em contacto com o Administrador";
                                            } else if (Encomenda
                                                    .estaDentroLimiteCredito(
                                                        cliente, totalVenda) ==
                                                true) {
                                              msg = "Cliente excedeu o limite de Credito de " +
                                                  this
                                                      .cliente
                                                      .limiteCredito
                                                      .toString() +
                                                  " MTN. Entre em contacto com o Administrador";
                                            }

                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text("atenção"),
                                                  content: Text(msg),
                                                  actions: <Widget>[
                                                    new FlatButton(
                                                      child: new Text("ok"),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        }
                                      });
                                    } else {
                                      alerta_info(
                                          contexto, "Verifique sua conexão.");
                                    }
                                  },

                                  controller: txtClienteController,
                                  readOnly: true,
                                ),
                              ),
                              //  Spacer(),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
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
              icon: Icon(Icons.search, color: Colors.blue),
              label: 'Pesquisar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline, color: Colors.blue),
              label: 'Adicionar',
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
      // if (artigos != null && artigos.length > 0) {
      //   createAlertDialog(contexto).then((sair) {
      //     if (sair == true) {
      //       Navigator.of(contexto).pop();
      //     }
      //   });
      // }
      setState(() {
        evtPesquisar = true;
      });
    } else if (index == 1) {
      bool conexao = await temConexao();

      if (conexao == true) {
        final result = await Navigator.pushNamed(
            contexto, '/artigo_selecionar_lista',
            arguments: artigos);
        if (result != null) {
          artigos = result;
        }

        actualizarEstado();
      } else {
        alerta_info(contexto, "Verifique sua conexão.");
      }

      // Terminar
    } else if (index == 2) {
      // await Navigator.pushReplacementNamed(contexto, '/encomenda_sucesso');

      // createAlertDialogErroEncomenda
      // createAlertDialogEncomendaProcesso(BuildContext context) {
      //   if (erroEncomenda == true) {
      //     Navigator.of(context).pop();
      //   }

      //   bool rv = false;
      //   return showDialog(
      //       context: contexto,
      //       builder: (contexto) {
      //         // 3 minutos ate fechar a janela devido a demora do processo de envio de encomenda
      //         Future.delayed(Duration(seconds: 180), () {
      //           // alerta_info(contexto, "Parado processo devido o tempo de espera!");
      //           if (this.mounted) {
      //             setState(() {
      //               rv = true;
      //             });
      //           }
      //           // Navigator.of(context).pop(true);
      //         });
      //         return WillPopScope(
      //           child: AlertDialog(
      //             title: Center(child: Text('Aguarde')),
      //             content: Container(
      //                 width: 50,
      //                 height: 50,
      //                 child: Center(child: CircularProgressIndicator())),
      //           ),
      //           onWillPop: () async {
      //             return rv;
      //           },
      //         );
      //       });
      // }

      //await temConexao(
      // 'Sem conexão WIFI ou Dados Moveis. Por Favor Active para criar encomenda');

      bool dado = true; //await temDados('Sem acesso a internet!', contexto);
      bool localizacao = true; //await temLocalizacao();
      bool conexao = await temConexao();

      if (conexao == true && dado == true && localizacao == true) {
        if (artigos != null &&
            artigos.length > 0 &&
            this.cliente != null &&
            this.cliente.cliente != null) {
          // EncomendaApiProvider encomendaApi = EncomendaApiProvider();
          // Map<String, dynamic> rv = await SessaoApiProvider.readSession();

          if (Encomenda.estaDentroLimiteCredito(this.cliente, totalVenda) ==
              false) {
            var msg = "Total da encomenda  " +
                totalVenda.toString() +
                " do Cliente excedeu o saldo disponivel de " +
                Encomenda.calcularSaldoCliente(this.cliente).toString() +
                " MTN. Entre em contacto com o Administrador";

            showDialog(
              context: contexto,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("atenção"),
                  content: Text(msg),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("ok"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            Map<String, dynamic> _usuario =
                await SessaoApiProvider.readSession();

            Usuario usuario = Usuario(
                usuario: _usuario['usuario'],
                nome: _usuario['usuario'],
                perfil: "usuario",
                documento: "ECL");
            Encomenda encomenda = new Encomenda(
                cliente: this.cliente,
                vendedor: usuario,
                artigos: artigos,
                dataHora: DateTime.now(),
                estado: "pendente",
                valorTotal: 0.0,
                encomenda_id: usuario.usuario +
                    DateTime.now().day.toString() +
                    DateTime.now().month.toString() +
                    "/" +
                    DateTime.now().hour.toString() +
                    "/" +
                    DateTime.now().minute.toString() +
                    "/" +
                    DateTime.now().second.toString(),
                regrasPreco: new List<RegraPrecoDesconto>());

            dynamic confirmado = await Navigator.pushNamed(
                contexto, '/encomenda_lista_confirmacao',
                arguments: encomenda);

            if (confirmado != null && confirmado['estado'] == false) {
              setState(() {
                artigos = confirmado["resultado"].artigos;
              });
            } else if (confirmado != null &&
                confirmado['estado'] == true &&
                confirmado['resultado'] != null) {
              try {
                encomenda = confirmado['resultado'] as Encomenda;
              } catch (err) {
                print(err);
              }
              final SignatureController _controller = SignatureController(
                penStrokeWidth: 3.5,
                penColor: Colors.black,
                exportBackgroundColor: Colors.white,
              );
              // var assinatura = await Navigator.of(contexto).push(
              //   MaterialPageRoute(builder: (BuildContext context) {
              //     return MaterialApp(
              //       home: Builder(
              //         builder: (context) => Scaffold(
              //           body: Column(
              //             children: <Widget>[
              //               Container(
              //                 height: 50,
              //                 margin: const EdgeInsets.only(top: 50.0),
              //                 child: Center(
              //                   child: Text('ASSINATURA CLIENTE'),
              //                 ),
              //               ),
              //               //SIGNATURE CANVAS
              //               Signature(
              //                 controller: _controller,
              //                 // height: 300,
              //                 backgroundColor: Colors.white,
              //               ),
              //               // OK AND CLEAR BUTTONS
              //               Container(
              //                 decoration:
              //                     const BoxDecoration(color: Colors.black),
              //                 child: Row(
              //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                   mainAxisSize: MainAxisSize.max,
              //                   children: <Widget>[
              //                     IconButton(
              //                       icon: const Icon(Icons.check),
              //                       color: Colors.blue,
              //                       onPressed: () async {
              //                         // if (_controller.isNotEmpty) {

              //                         Uint8List data =
              //                             await _controller.toPngBytes();

              //                         if (data.length > 0) {
              //                           Navigator.of(contexto).pop(data);
              //                         }
              //                       },
              //                     ),
              //                     //CLEAR CANVAS
              //                     IconButton(
              //                       icon: const Icon(Icons.clear),
              //                       color: Colors.blue,
              //                       onPressed: () {
              //                         setState(() => _controller.clear());
              //                       },
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     );
              //   }),
              // );
              // if (assinatura != null) {
              try {
                // encomenda.assinaturaImagemBuffer = assinatura;
                // final Geolocator geolocator = Geolocator()
                //   ..forceAndroidLocationManager;

                // if ((await Geolocator.isLocationServiceEnabled())) {
                // await createAlertDialogEncomendaProcesso(contexto);
                int idEncomenda = -1;
                //
                // encomenda.setLocalizacao().then((coordenada) async {
                // encomendaApi.insertEncomenda(encomenda).then((id) async {
                //   idEncomenda = id;
                // if (id >= 0) {
                String filename =
                    encomenda.encomenda_id.replaceAll('/', '_') + '.png';

                // writeByteFile(filename, assinatura).then((file) {
                // encomenda.assinaturaImagemBuffer = "";

                Encomenda.postEncomenda(encomenda).then((value) async {
                  // createAlertDialogEncomendaProcesso(contexto);
                  if (value.statusCode == 200) {
                    await Navigator.pushReplacementNamed(
                        contexto, '/encomenda_sucesso');
                  } else if (value.statusCode == 401 ||
                      value.statusCode == 500) {
                    //  #TODO informar ao usuario sobre a renovação da sessão
                    // mostrando mensagem e um widget de LOADING
                    if (this.mounted == true) {
                      setState(() {
                        erroEncomenda = true;
                      });
                    }
                    alerta_info(contexto,
                        'Sessão esta a ser renovada. Tente novamente!');
                    await SessaoApiProvider.refreshToken();
                  } else {
                    // remover encomenda em caso de erro no envio da encomenda.
                    // TODO: armazenar temporariamente ate haver sucesso. Se estiver tudo bem com a encomenda.
                    // notificar ao usuario se a encomenda  nao estiver completa
                    // Encomenda.removeEncomendaByid(idEncomenda)
                    //     .then((value) {
                    //   if (this.mounted == true) {
                    //     setState(() {
                    //       erroEncomenda = true;
                    //     });
                    //   }
                    // });

                    if (this.mounted == true) {
                      setState(() {
                        erroEncomenda = true;
                      });
                    }
                    alerta_info(
                        contexto,
                        'Servidor não respondeu com sucesso:\n ' +
                            value.body.toString() +
                            "\n Se persistir Contacte o Administrador.");
                  }
                }).catchError((err) {
                  print('[postEncomenda] ERRO');
                  print(err);
                  if (this.mounted == true) {
                    setState(() {
                      erroEncomenda = true;
                    });
                  }

                  alerta_info(contexto,
                      'Ocorreu um erro interno ao enviar encomenda! Por favor tente novamente');
                });
                // });

                // } else {
                //   print('[_onItemTapped] Erro:  ao inserir encomenda');
                //   /* TODO: Remover a encomenda ou armazenar em um repositorio temporario
                //  * para posterior enviar pela rede ate terminar com sucesso.
                //  */

                //   encomendaApi
                //       .removeEncomendaByid(idEncomenda)
                //       .then((value) {
                //     if (this.mounted == true) {
                //       setState(() {
                //         erroEncomenda = true;
                //       });
                //     }
                //   });
                //   // return null;

                // }
                // }).catchError((err) {
                //   print('[insertEncomenda] ERRO');
                //   print(err);
                //   alerta_info(contexto,
                //       'Erro ao inserir encomenda! Por favor tente novamente');

                //   encomendaApi
                //       .removeEncomendaByid(idEncomenda)
                //       .then((value) {
                //     if (this.mounted == true) {
                //       setState(() {
                //         erroEncomenda = true;
                //       });
                //     }
                //   });
                // });
                // }).catchError((err) {
                //   print('[setLocalizacao] Erro: ');
                //   print(err);
                //   alerta_info(
                //       contexto, 'Activar Localização GPS Ou Permita o acesso!');

                //   if (this.mounted == true) {
                //     setState(() {
                //       erroEncomenda = true;
                //     });
                //   }
                // });
                // } else {
                //   alerta_info(contexto, 'Activar Localização GPS!');
                // }

                // AssinaturaDigital();
                // Navigator.pushNamed(contexto, '/assinatura');
              } catch (e) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("atenção"),
                      content: Text("Ocorreu um erro. " + e.toString()),
                      actions: <Widget>[
                        new FlatButton(
                          child: new Text("Fechar"),
                          onPressed: () {
                            // Navigator.of(context).pop();
                            Navigator.pushNamed(contexto, '/encomenda_lista');
                          },
                        ),
                      ],
                    );
                  },
                );
              }
              // } else {
              //   createAlertDialogAssinatura(contexto);
              // }
            }
          }
        } else {
          alerta_info(contexto,
              'Preencha campo em falta ou adicione no minimo uma linha');
        }
      } else {
        alerta_info(contexto, "Verifique sua conexão.");
      }
    }
    _selectedIndex = index;
  }

  ArtigoCard encomendaItem(Artigo artigo) {
    var artigoQuantidade;
    TextEditingController txtArtigoQtd = new TextEditingController();
    txtArtigoQtd.text = artigo.quantidade.toStringAsFixed(2).toString();

    createAlertDialog(BuildContext context) {
      var msg_qtd = '';

      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Column(
                children: [
                  Center(
                      child: Text(artigo.descricao,
                          style: TextStyle(fontSize: 12))),
                  Center(
                      child: Text(
                          'Total Disponivel ' +
                              artigo.quantidadeStock.toString() +
                              ' ' +
                              artigo.unidade,
                          style: TextStyle(fontSize: 12))),
                  Center(child: Text('Quantidade em ' + artigo.unidade))
                ],
              ),
              content: TextField(
                keyboardType: TextInputType.number,
                controller: txtArtigoQtd,
              ),
              actions: <Widget>[
                Text(msg_qtd,
                    style: TextStyle(fontSize: 11, color: Colors.red)),
                MaterialButton(
                  elevation: 5.0,
                  child: Text('alterar'),
                  onPressed: () {
                    if (double.parse(txtArtigoQtd.text) <=
                            artigo.quantidadeStock &&
                        double.parse(txtArtigoQtd.text) > 0) {
                      Navigator.of(context).pop(txtArtigoQtd.text.toString());
                    }
                  },
                )
              ],
            );
          });
    }

    return ArtigoCard(
      artigo: artigo,
      child: Padding(
          padding: EdgeInsets.only(top: 15, left: 5, right: 5, bottom: 5),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(artigo.artigo,
                      style: TextStyle(color: Colors.blue, fontSize: 12)),
                  Text(artigo.descricao,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.blue, fontSize: 12)),
                  Text(artigo.unidade == null ? " " : artigo.unidade,
                      style: TextStyle(color: Colors.blue, fontSize: 12)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Quantidade: ",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                    ),
                  ),
                  Container(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: txtArtigoQtd,
                      onChanged: (value) {
                        try {
                          if (value.length > 0) {
                            if (double.parse(value) > 0) {
                              artigo.quantidade = double.parse(value);
                            } else {
                              alerta_info(contexto,
                                  "Permitido apenas valores positivos!");
                            }

                            actualizarEstado();
                          }
                        } catch (e) {}
                      },
                      onSubmitted: (value) {
                        print("valor");
                        print(value);
                      },
                      onTap: () {
                        txtArtigoQtd.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: txtArtigoQtd.value.text.length);
                      },
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                      ),
                    ),
                    width: 100,
                  )
                ],
              ),
              espaco(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // GestureDetector(
                  //   onTap: () async {
                  //     artigoQuantidade = await createAlertDialog(contexto);
                  //     artigo.quantidade = double.parse(artigoQuantidade);

                  //     setState(() {
                  //       // calcular o custo da encomenda que pode ter preco
                  //       // ja incluido iva ou nao.
                  //       // Verificar o caso e calcular o custo total.
                  //     });
                  //   },
                  //   child: Text(
                  //     "Qtd.: " + artigo.quantidade.toString(),
                  //     style: TextStyle(color: Colors.blue),
                  //   ),
                  // ),
                  Text(
                      "Prc.Unit: " + artigo.preco.toStringAsFixed(2).toString(),
                      style: TextStyle(color: Colors.blue, fontSize: 12)),
                  Text(
                      "Subtotal: " +
                          (artigo.preco * artigo.quantidade)
                              .toStringAsFixed(2)
                              .toString(),
                      style: TextStyle(color: Colors.blue, fontSize: 12))
                ],
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: 15, left: 16, right: 16, bottom: 4),
              ),
            ],
          )),
    );
  }

  void actualizarEstado() {
    /**
           * Se tiver artigos selecionados.
          *   limpar a lista artigos previamente selecionados
          **/

    encomendaItens.clear();
    items.clear();

    if (artigos != null) {
      // encomendaItens.clear();
      ivaTotal = totalVenda = subtotal = mercadServicValor = 0.0;
      encomendaItens.clear();

      artigos.forEach((a) {
        if (a.pvp1Iva == true) {
          noIva = (a.pvp1 / ((iva + 100) / 100)) * a.quantidade;
          mercadServicValor += (a.pvp1 / ((iva + 100) / 100)) * a.quantidade;

          subtotal += a.pvp1 * a.quantidade;
          totalVenda += subtotal;
          ivaTotal = mercadServicValor * (iva / 100);
          encomendaItens.add(artigoEncomenda(a));
        } else {
          mercadServicValor += (a.pvp1 / ((iva + 100) / 100)) * a.quantidade;

          subtotal += (a.pvp1 / ((iva + 100) / 100)) * a.quantidade;
          totalVenda += subtotal;
          ivaTotal += mercadServicValor * (iva / 100);
          encomendaItens.add(artigoEncomenda(a));
        }
        // encomendaItens.elementAt(0)
      });
    }
    setState(() {
      items.addAll(encomendaItens);
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
            // Navigator.pushNamed(contexto, '/artigo_selecionar_lista');
            bool conexao = await temConexao();

            if (conexao == true) {
              await Navigator.pushNamed(contexto, '/artigo_selecionar_lista');
            } else {
              alerta_info(contexto, "Verifique sua conexão.");
            }
          },
          child: const Text('Adicionar ',
              style: TextStyle(fontSize: 15, color: Colors.white)),
        ),
        const SizedBox(height: 50),
      ],
    ));
  }

  Slidable artigoEncomenda(Artigo artigo) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: encomendaItem(artigo),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Remover',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            setState(() {
              removeEncomenda(artigo);
              actualizarEstado();
            });
          },
        ),
      ],
    );
  }

  void removeEncomenda(Artigo a) {
    for (var i = 0; i < encomendaItens.length; i++) {
      if (encomendaItens[i].child.artigo.artigo == a.artigo) {
        encomendaItens.removeAt(i);
        artigos.removeAt(i);
      }
    }
  }

  Widget togglePesquisa() {
    return evtPesquisar
        ? new TextField(
            key: encomendaPesquisaKey,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Pesquise aqui...',
            ),
            onChanged: (value) {
              // items.clear();

              setState(() {
                if (value.length >= 0) {
                  items = PesquisaListaArtigo(artigos, value);
                } else {
                  items = getListaArtigo(artigos);
                }
              });
            },
            onEditingComplete: () {
              if (txtPesquisa.text.length == 0) {
                setState(() {
                  evtPesquisar = false;
                });
              }
            },
            onSubmitted: (value) {
              if (value.length == 0) {
                setState(() {
                  evtPesquisar = false;
                });
              }
            },
            controller: txtPesquisa,
          )
        : new Text('Encomenda');
  }

  List<Widget> PesquisaListaArtigo(List<Artigo> artigos, String keyword) {
    List<Widget> lista_widget = List<Widget>();
    if (keyword == null || keyword.length == 0) {
      return getListaArtigo(artigos);
    }
    keyword = keyword.toLowerCase();
    if (artigos != null || artigos.length > 0) {
      int i = 0;
      artigos.forEach((artigo) {
        if (artigo.artigo.toLowerCase().contains(keyword) ||
            artigo.descricao.toLowerCase().contains(keyword)) {
          lista_widget.add(artigoEncomenda(artigo));
        }
      });
    }

    if (lista_widget.length == 0) {
      lista_widget.add(Container(
          height: 60,
          padding: EdgeInsets.all(10),
          color: Colors.white,
          child: Center(
            child: Text(
              "Artigo não encontrado.",
              style: TextStyle(color: Colors.blue, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          )));
    }

    return lista_widget;
  }

  // Retornar lista de artigos por expedir convertidos em widgets
  List<Widget> getListaArtigo(List<Artigo> artigos) {
    List<Widget> lista_widget = List<Widget>();

    if (artigos != null || artigos.length > 0) {
      int i = 0;
      artigos.forEach((artigo) {
        setState(() {
          lista_widget.add(artigoEncomenda(artigo));
        });
      });
    } else {
      lista_widget.add(Text(
        "Sem Artigo",
        style: TextStyle(color: Colors.blue, fontSize: 14),
      ));
    }

    return lista_widget;
  }
}

Future<bool> temLocalizacao() async {
  bool rv = false;

  //
  //             if ((await Geolocator.isLocationServiceEnabled())) {
  //             rv = true;
  //
  //             } else {
  //               rv = false;
  //
  //               Flushbar(
  //   title: "Atenção",
  //   messageText: Text('Activar Localização GPS Ou Permita o acesso!',
  //       style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
  //   duration: Duration(seconds: 4),
  //   backgroundColor: Colors.red,
  // )..show(contexto);
  //             }

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

class ArtigoCard extends Card {
  ArtigoCard(
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
  final Artigo artigo;
}
