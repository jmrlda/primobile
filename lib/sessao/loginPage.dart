import 'package:flutter/material.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';
// import 'package:primobile/sessao/sessao_api_provider.dart';
// import 'package:connectivity/connectivity.dart';
// import 'package:primobile/util.dart';

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

  @override
  Widget build(BuildContext context) {
    // Ler o arquivo de configuracao
    // Se for nulo redirecionar para pagina de configuracao.
    var sessaoProvider = SessaoApiProvider.read();
    sessaoProvider.then((value) {
      if (value == null) {
        Navigator.pushNamed(context, '/config_instancia');
      }
    });

    return Scaffold(
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
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 50.0,
                child: Image.asset('assets/images/logo.png'),
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
            child: MaterialButton(
                minWidth: double.infinity,
                shape: StadiumBorder(),
                color: Colors.blue,
                child: Text(
                  "Entrar",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () async {
                  // Navigator.pushNamed(context, '/menu');

                  String nome = txtNomeEmail.text.trim();
                  String senha = txtSenha.text.trim();

                  // if (true) {
                  //       // bool rv = await checkAcessoInternet();
                  autenticar(nome, senha, true);
                  // }

                  // else {
                  //   autenticar(nome, senha, false);

                  // }

                  // Usuario usuario = await DBProvider.db.login(nome, senha);
                }),
          ),
        ),
      ],
    )));
  }

  void autenticar(String nome, String senha, bool online) async {
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
      Navigator.pushNamed(context, '/menu');
    }
  }
}
