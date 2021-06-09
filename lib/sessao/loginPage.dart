import 'dart:async';

import 'package:flutter/material.dart';
import 'package:primobile/artigo/util.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';
import 'package:primobile/util/util.dart';
// import 'package:primobile/sessao/sessao_api_provider.dart';
// import 'package:connectivity/connectivity.dart';
// import 'package:primobile/util.dart';
import 'package:progress_indicator_button/button_stagger_animation.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

BuildContext contexto;

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var isLoading = false;
  TextEditingController txtNomeEmail = new TextEditingController();
  TextEditingController txtSenha = new TextEditingController();
  BoxDecoration boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(50)),
      color: Colors.white,
      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]);
  Dialog dialog = new Dialog();
  // StreamSubscription<ConnectivityResult> _connectivitySubscription;
  // String _connectionStatus = 'Unknown';

  @override
  void initState() {
    super.initState();
    // initConnectivity(mounted, _updateConexao);

    // _connectivitySubscription =
    //     connectivity.onConnectivityChanged.listen(_updateConexao);
    //
    //
    //
    //\

    // updateConnectionStatus(contexto);
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
    try {
      var sessaoProvider = SessaoApiProvider.readSession();
      sessaoProvider.then((value) {
        if (value == null) {
          Navigator.pushReplacementNamed(contexto, '/config_instancia');
        }
      });
    } catch (e) {}
  }

  @override
  void dispose() {
    // _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ler o arquivo de configuracao
    // Se for nulo redirecionar para pagina de configuracao.
    contexto = context;

    return Scaffold(
        appBar: loginAppBar(),
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.9,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      // begin: ``
                      colors: [Colors.blue, Colors.blueAccent]),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white38,
                        radius: 55.0,
                        child: NeumorphicIcon(
                          Icons.extension,
                          size: 50,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            // campo email
            Container(
              width: MediaQuery.of(context).size.width / 1.1,
              margin: EdgeInsets.only(top: 64),
              padding: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
              decoration: boxDecoration,
              child: TextField(
                controller: txtNomeEmail,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.person,
                      color: Colors.grey,
                    ),
                    hintText: 'Utilizador'),
              ),
            ),

            // campo senha
            Container(
              width: MediaQuery.of(context).size.width / 1.1,
              // height: 45,
              margin: EdgeInsets.only(top: 32, bottom: 20),
              padding: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
              decoration: boxDecoration,
              child: TextField(
                obscureText: true,
                obscuringCharacter: '*',
                controller: txtSenha,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.vpn_key,
                      color: Colors.grey,
                    ),
                    hintText: 'Senha'),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 60),
                child: ProgressButton(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    strokeWidth: 2,
                    child: Text(
                      "Entrar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    onPressed: (AnimationController controller) async {
                      await httpLogin(controller);
                    }),
              ),
            ),
          ],
        )));
  }

  Future<int> autenticar(String nome, String senha, bool online) async {
    Map<String, dynamic> resultado = new Map<String, dynamic>();
    resultado = await SessaoApiProvider.login(nome, senha, online);
    int rv = resultado['status'];
    dynamic descricao = resultado['descricao'];
    if (rv == 1) {
      setState(() {
        boxDecoration = BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.red, blurRadius: 5)]);
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("atenção"),
            content: Text("Erro de autenticação. Verificar o Nome e a Senha"),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Fechar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else if (rv == 2) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("atenção"),
            content: Text(
                "Erro de Conexão. Sem acesso a internet ou servidor não responde!"),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Fechar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else if (rv == 3) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("atenção"),
            content: Text("Ocorreu um erro desconhecido. Tentar novamente!" +
                descricao.toString()),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Fechar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else if (rv == 4) {
      AlertDialog(
        title: Text("atenção"),
        content: Text(descricao),
        actions: <Widget>[
          new FlatButton(
            child: new Text("Configurar"),
            onPressed: () {
              Navigator.pushNamed(context, '/config_instancia');
            },
          ),
        ],
      );
    } else if (rv == 0) {
      txtNomeEmail.clear();
      txtSenha.clear();
      // Limpar todos dados em cache
      artigoListaDisplay.clear();
      // artigoListaArmazemDisplay.clear();
      Navigator.pushNamed(context, '/menu');
    }

    return rv;
  }

  AppBar loginAppBar() {
    return new AppBar(
      title: new Center(
        child: Text('Login '),
      ),
      backgroundColor: PRIMARY_COLOR,
      actions: <Widget>[
        PopupMenuButton<String>(
          onSelected: opcaoAcao,
          itemBuilder: (BuildContext context) {
            return Opcoes.escolhaLogin.map((String escolha) {
              return PopupMenuItem<String>(
                value: escolha,
                child: Text(escolha),
              );
            }).toList();
          },
        )
      ],
    );
  }

  void opcaoAcao(String opcao) async {
    if (opcao == Opcoes.Configurar) {
      Navigator.pushNamed(contexto, '/config_instancia');
    }
  }

  Future<void> httpLogin(AnimationController controller) async {
    // Navigator.pushNamed(context, '/menu');
    //
    controller.forward();
    try {
      bool conexao = await temConexao();
      if (conexao == true) {
        String nome = txtNomeEmail.text.trim();
        String senha = txtSenha.text.trim();

        int rv = await autenticar(nome, senha, true);
        if (rv != 0) {
          controller.reset();
        }
      } else {
        controller.reset();

        alerta_info(context, "Verifique sua conexão.");
      }
    } catch (e) {
      controller.reset();
      alerta_info(context, "Ocorreu um erro inesperado. Tente novamente!");
    }
  }
  // Future<void> _updateConexao(ConnectivityResult result) async {
  //   switch (result) {
  //     case ConnectivityResult.wifi:
  //     case ConnectivityResult.mobile:
  //     case ConnectivityResult.none:
  //       setState(() => _connectionStatus = result.toString());
  //       break;
  //     default:
  //       setState(() => _connectionStatus = 'Failed to get connectivity.');
  //       break;
  //   }
  // }
}
