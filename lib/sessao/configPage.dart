import 'package:flutter/material.dart';
import 'package:primobile/sessao/empresaFilial_modelo.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';
import 'package:primobile/usuario/models/models.dart';
import 'package:primobile/util/util.dart';
import 'package:progress_indicator_button/progress_button.dart';

// import 'package:primobile/sessao/sessao_api_provider.dart';
// import 'package:primobile/util.dart';
//
//
TextEditingController txtNomeEmpresa = new TextEditingController();
TextEditingController txtIpGlobal = new TextEditingController();
TextEditingController txtIpLocal = new TextEditingController();

TextEditingController txtCompany = new TextEditingController();
TextEditingController txtGrantType = new TextEditingController();
TextEditingController txtLine = new TextEditingController();
TextEditingController txtInstance = new TextEditingController();

TextEditingController txtAdmin = new TextEditingController();
TextEditingController txtAdminSenha = new TextEditingController();
TextEditingController txtPorta = new TextEditingController();
BuildContext contexto;

class ConfigPage extends StatefulWidget {
  ConfigPage({Key key}) : super(key: key);

  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  var isLoading = false;

  BoxDecoration boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(50)),
      color: Colors.white,
      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]);
  Dialog dialog = new Dialog();

  @override
  void initState() {
    super.initState();

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
      var sessaoProvider = SessaoApiProvider.readSession();
      if (sessaoProvider != null) {
        sessaoProvider.then((value) {
          if (value != null) {
            txtNomeEmpresa.text = value['nome_empresa'];
            txtIpGlobal.text = value['ip_global'];
            txtIpLocal.text = value['ip_local'];

            txtCompany.text = value['company'];
            txtGrantType.text = value['grant_type'];
            txtLine.text = value['line'];
            txtInstance.text = value['instance'];
            txtPorta.text = value['porta'];

            txtAdmin.text = "";
            txtAdminSenha.text = "";
          }
        });
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    contexto = context;

    return Scaffold(
        appBar: configAppBar(),
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    // begin: ``
                    colors: [Colors.blue, Colors.blueAccent]),
                // borderRadius: BorderRadius.only(
                //     bottomLeft: Radius.circular(50),
                //     bottomRight: Radius.circular(50))
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.1,
              margin: EdgeInsets.only(top: 64),
              padding: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
              decoration: boxDecoration,
              child: TextField(
                controller: txtNomeEmpresa,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.verified,
                      color: Colors.grey,
                    ),
                    hintText: 'Nome empresa'),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.1,
              // height: 45,
              margin: EdgeInsets.only(top: 32),
              padding: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
              decoration: boxDecoration,
              child: TextField(
                controller: txtCompany,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.verified_user,
                      color: Colors.grey,
                    ),
                    hintText: 'Company'),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.1,
              // height: 45,
              margin: EdgeInsets.only(top: 32),
              padding: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
              decoration: boxDecoration,
              child: TextField(
                controller: txtLine,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.linear_scale_sharp,
                      color: Colors.grey,
                    ),
                    hintText: 'Line'),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.1,
              // height: 45,
              margin: EdgeInsets.only(top: 32),
              padding: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
              decoration: boxDecoration,
              child: TextField(
                controller: txtInstance,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.alt_route,
                      color: Colors.grey,
                    ),
                    hintText: 'instance'),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.1,
              // height: 45,
              margin: EdgeInsets.only(top: 32),
              padding: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
              decoration: boxDecoration,
              child: TextField(
                controller: txtIpGlobal,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.computer,
                      color: Colors.grey,
                    ),
                    hintText: 'IP global'),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.1,
              // height: 45,
              margin: EdgeInsets.only(top: 32),
              padding: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
              decoration: boxDecoration,
              child: TextField(
                controller: txtIpLocal,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.computer,
                      color: Colors.grey,
                    ),
                    hintText: 'IP Local'),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.1,
              // height: 45,
              margin: EdgeInsets.only(top: 32),
              padding: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
              decoration: boxDecoration,
              child: TextField(
                controller: txtPorta,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.vpn_lock,
                      color: Colors.grey,
                    ),
                    hintText: 'Porta'),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.1,
              // height: 45,
              margin: EdgeInsets.only(top: 32),
              padding: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
              decoration: boxDecoration,
              child: TextField(
                controller: txtGrantType,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.vpn_key,
                      color: Colors.grey,
                    ),
                    hintText: 'Grant Type'),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.1,
              // height: 45,
              margin: EdgeInsets.only(top: 32),
              padding: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
              decoration: boxDecoration,
              child: TextField(
                controller: txtAdmin,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.person,
                      color: Colors.grey,
                    ),
                    hintText: 'Admin'),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.1,
              // height: 45,
              margin: EdgeInsets.only(top: 32, bottom: 40),
              padding: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
              decoration: boxDecoration,
              child: TextField(
                obscureText: true,
                obscuringCharacter: '*',
                controller: txtAdminSenha,
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
                      "Conectar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    onPressed: (AnimationController controller) async {
                      try {
                        await httpConectar(controller);
                      } catch (e) {
                        alerta_info(context,
                            "Ocorreu um erro inesperado. Tente novamente!");
                      }
                    }),

                // MaterialButton(
                //     minWidth: double.infinity,
                //     shape: StadiumBorder(),
                //     color: Colors.blue,
                //     child: Text(
                //       "Conectar",
                //       style: TextStyle(color: Colors.white, fontSize: 20),
                //     ),
                //     onPressed: () async {
                //       // Navigator.pushNamed(context, '/menu');
                //       bool conexao = await temConexao();
                //       if (conexao == true) {
                //         String nome = txtAdmin.text.trim();
                //         String senha = txtAdminSenha.text.trim();
                //         String nomeEmpresa = txtNomeEmpresa.text.trim();
                //         String company = txtCompany.text.trim();
                //         String line = txtLine.text.trim();
                //         String instance = txtInstance.text.trim();
                //         String grantType = txtGrantType.text.trim();
                //         String ipGlobal = txtIpGlobal.text.trim();
                //         String ipLocal = txtIpLocal.text.trim();
                //         String porta = txtPorta.text.trim();

                //         // if (true) {
                //         //       // bool rv = await checkAcessoInternet();
                //         conectar(nome, senha, nomeEmpresa, company, line,
                //             instance, grantType, ipGlobal, ipLocal, porta);
                //         // }
                //       } else {
                //         alerta_info(context, "Verifique sua conexão.");
                //       }
                //       // else {
                //       //   conectar(nome, senha, false);

                //       // }

                //       // Usuario usuario = await DBProvider.db.login(nome, senha);
                //     }),
              ),
            ),
          ],
        )));
  }

  Future<int> conectar(
      String admin,
      String senha,
      String nomeEmpresa,
      String company,
      String line,
      String instance,
      String grantType,
      String ipGlobal,
      String ipLocal,
      String porta) async {
    Filial config = new Filial(
        company: company,
        grantType: grantType,
        instance: instance,
        ipGlobal: ipGlobal,
        ipLocal: ipLocal,
        line: line,
        nome: nomeEmpresa,
        porta: porta);

    Usuario usuario = new Usuario(nome: admin, senha: senha);

    Map<String, dynamic> resultado = new Map<String, dynamic>();
    resultado = await SessaoApiProvider.conectar(usuario, config);
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
            content: Text(
                "Erro de autenticação. Verificar se os campos estão preenchidos com dados corretos"),
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
    } else if (rv == 0) {
      Navigator.pushNamed(context, '/');
    }

    return rv;
  }

  Future<void> httpConectar(AnimationController controller) async {
    try {
      controller.forward();

      bool conexao = await temConexao();
      if (conexao == true) {
        String nome = txtAdmin.text.trim();
        String senha = txtAdminSenha.text.trim();
        String nomeEmpresa = txtNomeEmpresa.text.trim();
        String company = txtCompany.text.trim();
        String line = txtLine.text.trim();
        String instance = txtInstance.text.trim();
        String grantType = txtGrantType.text.trim();
        String ipGlobal = txtIpGlobal.text.trim();
        String ipLocal = txtIpLocal.text.trim();
        String porta = txtPorta.text.trim();

        // if (true) {
        //       // bool rv = await checkAcessoInternet();
        int rv = await conectar(nome, senha, nomeEmpresa, company, line,
            instance, grantType, ipGlobal, ipLocal, porta);

        if (rv != 0) {
          controller.reset();
        }
        // }
      } else {
        alerta_info(context, "Verifique sua conexão.");
        controller.reset();
      }
    } catch (e) {
      controller.reset();
    }
  }
}

AppBar configAppBar() {
  return new AppBar(
    title: new Center(
      child: Text('Configuração'),
    ),
    backgroundColor: PRIMARY_COLOR,
    actions: <Widget>[
      PopupMenuButton<String>(
        onSelected: opcaoAcao,
        itemBuilder: (BuildContext context) {
          return Opcoes.escolhaConfig.map((String escolha) {
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
  if (opcao == Opcoes.Login) {
    Navigator.pushReplacementNamed(contexto, '/');
  }
}
