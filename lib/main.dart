import 'package:flutter/material.dart';
import 'package:primobile/artigo/util.dart';
import 'package:primobile/artigo/view/view.dart';
import 'package:primobile/encomenda/view/encomenda_editor_page.dart';
import 'package:primobile/inventario/inventario.dart';
import 'package:primobile/menu/view/menu.dart';
import 'package:primobile/sessao/configPage.dart';
import 'package:primobile/sessao/loginPage.dart';
import 'package:primobile/util/view/view.dart';
import 'package:primobile/venda/venda.dart';

import 'cliente/view/view.dart';
import 'encomenda/encomenda.dart';
import 'expedicao/expedicao.dart';
import 'expedicao/view/view.dart';
import 'fornecedor/view/view.dart';
import 'inventario/view/view.dart';
// import 'menu/view/menu_page.dart';
import 'rececao/rececao.dart';
import 'rececao/view/rececao_pagina.dart';

void main() {
  runApp(MaterialApp(
    // autenticacaoRepositorio: AutenticacaoRepositorio(),
    //   usuarioRepositorio: UsuarioRepositorio(),

    theme:
        ThemeData(primaryColor: Colors.red, accentColor: Colors.yellowAccent),
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => LoginPage(),
      '/menu': (context) => MenuPrincipal(),
      '/artigo_lista': (context) => ArtigoPage(isSelected: false),
      '/artigo_selecionar_lista': (context) => ArtigoPage(isSelected: true),
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
      '/rececao_lista': (context) => RececaoPage(isSelected: false),
      '/rececao_selecionar_lista': (context) => RececaoPage(
            isSelected: true,
          ),
      '/expedicao_editor': (context) => ExpedicaoEditorPage(),
      '/expedicao_lista': (context) => ExpedicaoPage(
            isSelected: false,
          ),
      '/expedicao_selecionar_lista': (context) => ExpedicaoPage(
            isSelected: true,
          ),
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
      '/inventario_lista': (context) => InventarioPage(
            isSelected: false,
          ),
      '/inventario_selecionar_lista': (context) => InventarioPage(
            isSelected: true,
          ),
      '/inventario_editor': (context) => InventarioEditorPage(),
      '/inventario_sucesso': (context) => SucessoPage(
            modulo: "Inventario",
            mensagemSucesso: "Actualizado com Sucesso",
          ),
      '/fornecedor_lista': (context) => FornecedorPage(
            isSelected: false,
          ),
      '/fornecedor_selecionar_lista': (context) => FornecedorPage(
            isSelected: true,
          ),
    },

    // home: LoginPage(),
  ));
}
