import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:primobile/artigo/models/models.dart';
import 'package:primobile/cliente/models/models.dart';
import 'package:primobile/encomenda/models/models.dart';
import 'package:primobile/regras_negocio/models/regras_negocio.dart';
import 'package:primobile/usuario/models/models.dart';

BuildContext contexto;

class VendaEditorPage extends StatefulWidget {
  VendaEditorPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _VendaEditorPageState createState() => new _VendaEditorPageState();
}

class _VendaEditorPageState extends State<VendaEditorPage> {
  TextEditingController txtClienteController = TextEditingController();
  TextEditingController txtQtdArtigoController = TextEditingController();
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

  @override
  void initState() {
    // encomendaItens.add(encomendaItemVazio());
    // items.addAll(encomendaItens);

    super.initState();
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
            content: Text('Deseja Cancelar Venda ?'),
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
    temConexao(
        'Dispositivo sem conexão WIFI ou Dados Moveis. Por Favor Active para processar as vendas!');
    temLocalizacao();

    return WillPopScope(
      child: new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.blue[900],
          centerTitle: true,
          title: new Text("Venda"),
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
                    Container(
                      margin: EdgeInsets.only(top: 2, bottom: 0),
                      // color: Colors.red,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            totalVenda.toStringAsFixed(2).toString() + "\n",
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
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
                          // espaco(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Mercadoria/Serviço",
                                style:
                                    TextStyle(fontSize: 18, color: Colors.blue),
                              ),
                              Text(
                                mercadServicValor
                                        .toStringAsFixed(2)
                                        .toString() +
                                    "\n",
                                style: TextStyle(
                                    fontSize: 18,
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
                                  fontSize: 18,
                                  color: Colors.blue,
                                ),
                              ),
                              Text(
                                ivaTotal.toStringAsFixed(2).toString() + "\n",
                                style: TextStyle(
                                    fontSize: 18,
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
                                    TextStyle(fontSize: 18, color: Colors.blue),
                              ),
                              Text(
                                subtotal.toStringAsFixed(2).toString(),
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Spacer(),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: (MediaQuery.of(context).size.width - 62),
                                height: 60,

                                // margin: EdgeInsets.only(top: 64),/s
                                padding: EdgeInsets.only(
                                    top: 4, left: 6, right: 16, bottom: 4),
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
                                    fontSize: 16,
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
                                    final result = Navigator.pushNamed(
                                        context, '/cliente_selecionar_lista');
                                    // print(result);
                                    result.then((obj) {
                                      this.cliente = obj;
                                      if ((this.cliente.anulado == false &&
                                              this.cliente.limiteCredito ==
                                                  0) ||
                                          this.cliente.anulado == false &&
                                              this.cliente.totalDeb <
                                                  this.cliente.limiteCredito) {
                                        txtClienteController.text =
                                            this.cliente.nome;
                                      } else {
                                        String msg = "";
                                        if (this.cliente.anulado == true) {
                                          msg =
                                              "Cliente anulado. Entre em contacto com o Administrador";
                                        } else if (this.cliente.totalDeb >
                                            this.cliente.limiteCredito) {
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
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    });
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
              icon: Icon(Icons.exit_to_app, color: Colors.blue),
              label: 'Sair',
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
      if (artigos != null && artigos.length > 0) {
        createAlertDialog(contexto).then((sair) {
          if (sair == true) {
            Navigator.of(contexto).pop();
          }
        });
      }
    }
    if (index == 1) {
      final result = await Navigator.pushNamed(
          contexto, '/artigo_selecionar_lista',
          arguments: artigos);
      if (result != null) {
        artigos = result;
      }

      refresh2();

      // Terminar
    }
    if (index == 2) {
      await Navigator.pushReplacementNamed(contexto, '/venda_sucesso');

      // createAlertDialogErroEncomenda
      createAlertDialogEncomendaProcesso(BuildContext context) {
        if (erroEncomenda == true) {
          Navigator.of(context).pop();
        }

        bool rv = false;
        return showDialog(
            context: contexto,
            builder: (contexto) {
              // 3 minutos ate fechar a janela devido a demora do processo de envio de encomenda
              Future.delayed(Duration(seconds: 180), () {
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

      bool conexao = await temConexao(
          'Sem conexão WIFI ou Dados Moveis. Por Favor Active para processar a uma venda');
      bool dado = false; //await temDados('Sem acesso a internet!', contexto);
      bool localizacao = false; //await temLocalizacao();

      if (conexao == true && dado == true && localizacao == true) {
        if (artigos != null &&
            artigos.length > 0 &&
            this.cliente != null &&
            this.cliente.cliente != null) {
          // EncomendaApiProvider encomendaApi = EncomendaApiProvider();
          // Map<String, dynamic> rv = await SessaoApiProvider.read();
          Map<String, dynamic> _usuario = null; //rv['resultado'];

          Usuario usuario = Usuario(
              usuario: _usuario['usuario'],
              nome: _usuario['nome'],
              perfil: _usuario['perfil'],
              documento: _usuario['documento']);
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
            // final SignatureController _controller = SignatureController(
            //   penStrokeWidth: 3.5,
            //   penColor: Colors.black,
            //   exportBackgroundColor: Colors.white,
            // );
            var assinatura = await Navigator.of(contexto).push(
              MaterialPageRoute(builder: (BuildContext context) {
                return MaterialApp(
                  home: Builder(
                    builder: (context) => Scaffold(
                      body: Column(
                        children: <Widget>[
                          Container(
                            height: 50,
                            margin: const EdgeInsets.only(top: 50.0),
                            child: Center(
                              child: Text('ASSINATURA CLIENTE'),
                            ),
                          ),
                          //SIGNATURE CANVAS
                          // Signature(
                          //   controller: _controller,
                          //   // height: 300,
                          //   backgroundColor: Colors.white,
                          // ),
                          // OK AND CLEAR BUTTONS
                          Container(
                            decoration:
                                const BoxDecoration(color: Colors.black),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.check),
                                  color: Colors.blue,
                                  onPressed: () async {
                                    // if (_controller.isNotEmpty) {

                                    Uint8List data = null;
                                    // await _controller.toPngBytes();

                                    if (data.length > 0) {
                                      Navigator.of(contexto).pop(data);
                                    }
                                  },
                                ),
                                //CLEAR CANVAS
                                IconButton(
                                  icon: const Icon(Icons.clear),
                                  color: Colors.blue,
                                  onPressed: () {
                                    // setState(() => _controller.clear());
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            );
            if (assinatura != null) {
              try {
                // encomenda.assinaturaImagemBuffer = assinatura;
                // final Geolocator geolocator = Geolocator()
                //   ..forceAndroidLocationManager;

                // if ((await Geolocator.isLocationServiceEnabled())) {
                //   createAlertDialogEncomendaProcesso(contexto);
                //   int idEncomenda = -1;
                //
                //   encomenda.setLocalizacao().then((coordenada) async {
                //
                //     // encomendaApi.insertEncomenda(encomenda).then((id) async {
                //     //   idEncomenda = id;
                //       // if (id >= 0) {
                //          String filename =
                //                 encomenda.encomenda_id.replaceAll('/', '_') +
                //                     '.png';
                //
                //                      writeByteFile(filename, assinatura).then((file) {
                //                                           encomenda.assinaturaImagemBuffer = "";
                //
                //         encomendaApi.postEncomenda(encomenda).then((value) {
                //           if (value.statusCode == 200) {
                //             encomenda.assinaturaImagemBuffer = "";
                //
                //             encomendaApi
                //                 .postEncomendaAssinatura(
                //                     encomenda, filename, assinatura, file)
                //                 .then((status) {
                //               if (status == 200) {
                //
                //                 Navigator.pushReplacementNamed(
                //                     contexto, '/encomenda_sucesso');
                //                 // limpar a lista de itens apos envio ou salvo na base de dados;
                //                 items.clear();
                //                 encomendaItens.clear();
                //                 artigos.clear();
                //                 txtClienteController.clear();
                //                 mercadServicValor = 0;
                //                 subtotal = 0;
                //                 totalVenda = 0;
                //                 ivaTotal = 0;
                //                 noIva = 0;
                //               } else {
                //                 showDialog(
                //                   context: context,
                //                   builder: (BuildContext context) {
                //                     return AlertDialog(
                //                       title: Text("atenção"),
                //                       content: Text(
                //                           "Ocorreu um erro no servidor. codigo: " +
                //                               value.toString() +
                //                               ". A assinatura Salvo e sera reenviada!"),
                //                       actions: <Widget>[
                //                         new FlatButton(
                //                           child: new Text("Fechar"),
                //                           onPressed: () {
                //                             Navigator.of(context).pop();
                //                           },
                //                         ),
                //                       ],
                //                     );
                //                   },
                //                 );
                //               }
                //             }).catchError((err) {
                //               print('[postEncomendaAssinatura] ERRO');
                //               print(err);
                //               alerta_info(contexto,
                //                   'Ocorreu um erro ao enviar assinatura! Por favor tente novamente');
                //
                //               if (this.mounted == true) {
                //                 setState(() {
                //                   erroEncomenda = true;
                //                 });
                //               }
                //             });
                //           } else {
                //             // remover encomenda em caso de erro no envio da encomenda.
                //             // TODO: armazenar temporariamente ate haver sucesso. Se estiver tudo bem com a encomenda.
                //             // notificar ao usuario se a encomenda  nao estiver completa
                //             encomendaApi
                //                 .removeEncomendaByid(idEncomenda)
                //                 .then((value) {
                //               if (this.mounted == true) {
                //                 setState(() {
                //                   erroEncomenda = true;
                //                 });
                //               }
                //             });
                //             alerta_info(contexto,
                //                 'Servidor não respondeu com sucesso o envio da encomenda! Por favor tente novamente');
                //           }
                //         }).catchError((err) {
                //           print('[postEncomenda] ERRO');
                //           print(err);
                //           if (this.mounted == true) {
                //             setState(() {
                //               erroEncomenda = true;
                //             });
                //           }
                //
                //           alerta_info(contexto,
                //               'Ocorreu um erro interno ao enviar encomenda! Por favor tente novamente');
                //         });
                //                         });
                //
                //       // } else {
                //       //   print('[_onItemTapped] Erro:  ao inserir encomenda');
                //       //   /* TODO: Remover a encomenda ou armazenar em um repositorio temporario
                //       //  * para posterior enviar pela rede ate terminar com sucesso.
                //       //  */
                //
                //       //   encomendaApi
                //       //       .removeEncomendaByid(idEncomenda)
                //       //       .then((value) {
                //       //     if (this.mounted == true) {
                //       //       setState(() {
                //       //         erroEncomenda = true;
                //       //       });
                //       //     }
                //       //   });
                //       //   // return null;
                //
                //       // }
                //     // }).catchError((err) {
                //     //   print('[insertEncomenda] ERRO');
                //     //   print(err);
                //     //   alerta_info(contexto,
                //     //       'Erro ao inserir encomenda! Por favor tente novamente');
                //
                //     //   encomendaApi
                //     //       .removeEncomendaByid(idEncomenda)
                //     //       .then((value) {
                //     //     if (this.mounted == true) {
                //     //       setState(() {
                //     //         erroEncomenda = true;
                //     //       });
                //     //     }
                //     //   });
                //     // });
                //   }).catchError((err) {
                //     print('[setLocalizacao] Erro: ');
                //     print(err);
                //      alerta_info(contexto,
                //                   'Activar Localização GPS Ou Permita o acesso!');
                //
                //
                //     if (this.mounted == true) {
                //       setState(() {
                //         erroEncomenda = true;
                //       });
                //     }
                //   });
                // } else {
                //     alerta_info(contexto,
                //                   'Activar Localização GPS!');
                //
                // }

                // AssinaturaDigital();
                //  Navigator.pushNamed(contexto, '/assinatura');
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
            } else {
              createAlertDialogAssinatura(contexto);
            }
          }
        } else {
          // alerta_info(contexto,
          //                       'Ocorreu um erro ao inserir encomenda na Base de dados. Por favor Tente novamente!');

        }
      }
    }
    _selectedIndex = index;
  }

  ArtigoCard encomendaItem(Artigo artigo) {
    var artigoQuantidade;

    createAlertDialog(BuildContext context) {
      TextEditingController txtArtigoQtd = new TextEditingController();
      txtArtigoQtd.text = artigo.quantidade.toStringAsFixed(2).toString();
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
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 15, left: 16, right: 16, bottom: 4),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(artigo.artigo,
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold)),
              Text(artigo.descricao,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold)),
              Text(artigo.unidade == null ? " " : artigo.unidade,
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold))
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 15, left: 16, right: 16, bottom: 4),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  artigoQuantidade = await createAlertDialog(contexto);
                  artigo.quantidade = double.parse(artigoQuantidade);

                  setState(() {
                    // calcular o custo da encomenda que pode ter preco
                    // ja incluido iva ou nao.
                    // Verificar o caso e calcular o custo total.
                    refresh2();
                  });
                },
                child: Text(
                  "Qtd.: " + artigo.quantidade.toString(),
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              Text("Prc.Unit: " + artigo.preco.toStringAsFixed(2).toString(),
                  style: TextStyle(color: Colors.blue)),
              Text(
                  "Subtotal: " +
                      (artigo.preco * artigo.quantidade)
                          .toStringAsFixed(2)
                          .toString(),
                  style: TextStyle(color: Colors.blue))
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 15, left: 16, right: 16, bottom: 4),
          ),
        ],
      ),
    );
  }

  void refresh2() {
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
          totalVenda = subtotal;
          ivaTotal = mercadServicValor * (iva / 100);
          // encomendaItens.add(artigoEncomenda(a));
        } else {
          mercadServicValor += (a.pvp1 / ((iva + 100) / 100)) * a.quantidade;

          subtotal += (a.pvp1 / ((iva + 100) / 100)) * a.quantidade;
          totalVenda += subtotal;
          ivaTotal += mercadServicValor * (iva / 100);
          // encomendaItens.add(artigoEncomenda(a));
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
            await Navigator.pushNamed(contexto, '/artigo_selecionar_lista');
          },
          child: const Text('Adicionar ',
              style: TextStyle(fontSize: 15, color: Colors.white)),
        ),
        const SizedBox(height: 50),
      ],
    ));
  }
  //
  // Slidable artigoEncomenda(Artigo artigo) {
  //   return Slidable(
  //     actionPane: SlidableDrawerActionPane(),
  //     actionExtentRatio: 0.25,
  //     child: encomendaItem(artigo),
  //     secondaryActions: <Widget>[
  //       IconSlideAction(
  //         caption: 'Remover',
  //         color: Colors.red,
  //         icon: Icons.delete,
  //         onTap: ()  {
  //           setState(()  {
  //                 removeEncomenda(artigo);
  //                 refresh2();
  //               });
  //         },
  //       ),
  //     ],
  //   );
  // }

  void removeEncomenda(Artigo a) {
    for (var i = 0; i < encomendaItens.length; i++) {
      if (encomendaItens[i].child.artigo.artigo == a.artigo) {
        encomendaItens.removeAt(i);
        artigos.removeAt(i);
      }
    }
  }
}

Future<bool> temConexao(String mensagem) async {
  // var conexaoResultado = await (Connectivity().checkConnectivity());
  bool rv;
  if (true) {
    rv = false;
    // Flushbar(
    //   title: "Atenção",
    //   messageText: Text(mensagem,
    //       style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    //   duration: Duration(seconds: 4),
    //   backgroundColor: Colors.red,
    // )..show(contexto);
  } else {
    rv = true;
  }

  return rv;
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
