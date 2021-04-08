import 'package:flutter/material.dart';
import 'package:primobile/artigo/view/view.dart';
import 'package:primobile/encomenda/view/encomenda_editor_page.dart';
import 'package:primobile/sessao/configPage.dart';
import 'package:primobile/sessao/loginPage.dart';
import 'package:primobile/util/view/view.dart';
import 'package:primobile/venda/venda.dart';

import 'cliente/view/view.dart';
import 'encomenda/encomenda.dart';
import 'expedicao/expedicao.dart';
import 'expedicao/view/view.dart';
import 'menu/view/menu_page.dart';
import 'rececao/rececao.dart';
import 'rececao/view/rececao_pagina.dart';
import 'sessao/sessao_api_provider.dart';

void main() {
  runApp(MaterialApp(
    // autenticacaoRepositorio: AutenticacaoRepositorio(),
    //   usuarioRepositorio: UsuarioRepositorio(),

    theme:
        ThemeData(primaryColor: Colors.red, accentColor: Colors.yellowAccent),
    debugShowCheckedModeBanner: false,
    initialRoute: '/config_instancia',
    routes: {
      '/': (context) => LoginPage(),
      '/menu': (context) => MenuPage(),
      '/artigo_lista': (context) => ArtigoPage(),
      '/artigo_selecionar_lista': (context) => ArtigoPage(),
      '/cliente_lista': (context) => ClientePage(
            isSelected: false,
          ),
      '/cliente_selecionar_lista': (context) => ClientePage(
            isSelected: true,
          ),
      '/encomenda_novo': (context) => EncomendaEditorPage(),
      '/encomenda_lista': (context) => EncomendaListaPage(),
      '/encomenda_sucesso': (context) => EncomendaSucessoPage(),
      '/encomenda_lista_confirmacao': (context) =>
          EncomendaListaConfirmacaoPage(),
      '/rececao_editor': (context) => RececaoEditorPage(),
      '/rececao_lista': (context) => RececaoPage(),
      '/expedicao_editor': (context) => ExpedicaoEditorPage(),
      '/expedicao_lista': (context) => ExpedicaoPage(),
      '/venda_editor': (context) => VendaEditorPage(),
      '/expedicao_sucesso': (context) => SucessoPage(
            modulo: "Expedição",
            mensagemSucesso: "Actualizado com Sucesso",
          ),
      '/rececao_sucesso': (context) => SucessoPage(
            modulo: "Receção",
            mensagemSucesso: "Actualizado com Sucesso",
          ),
      '/config_instancia': (context) {
        return ConfigPage();
      },
    },

    // home: LoginPage(),
  ));
}
