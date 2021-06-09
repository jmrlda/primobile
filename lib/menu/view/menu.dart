import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:primobile/artigo/bloc/bloc.dart';
import 'package:primobile/artigo/util.dart';
import 'package:primobile/cliente/bloc/bloc.dart';
import 'package:primobile/expedicao/bloc/bloc.dart';
import 'package:primobile/fornecedor/bloc/bloc.dart';
import 'package:primobile/inventario/bloc/bloc.dart';
import 'package:primobile/menu/util.dart';
import 'package:primobile/menu/widgets/menu_appbar.dart';
import 'package:http/http.dart' as http;
import 'package:primobile/rececao/bloc/bloc.dart';

List<Widget> item = List<Widget>();
int _page = 2;

class MenuPrincipal extends StatefulWidget {
  MenuPrincipal({Key key}) : super(key: key);

  @override
  _MenuPrincipal createState() => _MenuPrincipal();
}

class _MenuPrincipal extends State<MenuPrincipal> {
  _MenuPrincipal();

  @override
  void initState() {
    super.initState();
  }

  GlobalKey _bottomNavigationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      debugShowCheckedModeBanner: false,
      title: 'Primobile',
      themeMode: ThemeMode.light,
      theme: NeumorphicThemeData(
        baseColor: Color(0xFFFFFFFF),
        lightSource: LightSource.topLeft,
        depth: 10,
      ),
      darkTheme: NeumorphicThemeData(
        baseColor: Color(0xFF3E3E3E),
        lightSource: LightSource.topLeft,
        depth: 6,
      ),
      home: Home(),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       bottomNavigationBar: CurvedNavigationBar(
  //         key: _bottomNavigationKey,
  //         index: 2,
  //         height: 50.0,
  //         items: <Widget>[
  //           Icon(
  //             Icons.add,
  //             size: 30,
  //             color: Colors.white,
  //           ),
  //           Icon(Icons.list, size: 30, color: Colors.white),
  //           Icon(Icons.compare_arrows, size: 30, color: Colors.white),
  //           Icon(Icons.call_split, size: 30, color: Colors.white),
  //           Icon(Icons.perm_identity, size: 30, color: Colors.white),
  //         ],
  //         color: Colors.blue,
  //         buttonBackgroundColor: Colors.blue,
  //         backgroundColor: Colors.white,
  //         animationCurve: Curves.easeInOut,
  //         animationDuration: Duration(milliseconds: 600),
  //         onTap: (index) {
  //           setState(() {
  //             _page = index;
  //           });
  //         },
  //         letIndexChange: (index) => true,
  //       ),
  //       body: GridView.count(
  //         crossAxisCount: 3,
  //         children: menuItemView(),
  //       )

  //       //  Container(
  //       //   color: Colors.white,
  //       //   child: Center(
  //       //     child: Column(
  //       //       children: <Widget>[
  //       //         Text(_page.toString(), textScaleFactor: 10.0),
  //       //         RaisedButton(
  //       //           child: Text('Pagina ' + _page.toString()),
  //       //           onPressed: () {
  //       //             final CurvedNavigationBarState navBarState =
  //       //                 _bottomNavigationKey.currentState;
  //       //             navBarState.setPage(1);
  //       //           },
  //       //         )
  //       //       ],
  //       //     ),
  //       //   ),
  //       // )

  //       );
  // }

  Widget Home() {
    // menuLabel = "Menu";

    return Scaffold(
      appBar: menuAppBar(),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 1,
        height: 50.0,
        items: <Widget>[
          Neumorphic(
            style: NeumorphicStyle(
                border: NeumorphicBorder(
              color: Color(0x33000000),
              width: 0.4,
            )),
            child: Icon(
              Icons.business_center_outlined,
              size: 30,
            ),
          ),
          Neumorphic(
            style: NeumorphicStyle(
                border: NeumorphicBorder(
              color: Color(0x33000000),
              width: 0.4,
            )),
            child: Icon(
              Icons.dashboard_outlined,
              size: 30,
            ),
          ),
          Neumorphic(
            style: NeumorphicStyle(
                border: NeumorphicBorder(
              color: Color(0x33000000),
              width: 0.4,
            )),
            child: Icon(
              Icons.build_outlined,
              size: 30,
            ),
          ),
        ],
        color: Colors.blueAccent,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          item.clear();
          setState(() {
            _page = index;

            if (index == 0) {
              item = getMenuItemInventario(context);
              setState(() {
                menuLabel = "Inventario";
              });
            } else if (index == 1) {
              item = getMenuItemGeral(context);
              setState(() {
                menuLabel = "Geral";
              });
            } else if (index == 2) {
              item = getMenuItemSistema(context);
              setState(() {
                menuLabel = "Sistema";
              });
            }
          });
        },
        letIndexChange: (index) => true,
      ),
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3.5,
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
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
              ),
            ),
            Stack(
              children: <Widget>[
                // container menu body
                Container(
                  width: MediaQuery.of(context).size.width - 16,
                  height: MediaQuery.of(context).size.height / 2,
                  margin: EdgeInsets.only(top: 50),
                  child: Container(
                    child: GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 1.0,
                      mainAxisSpacing: 1,
                      shrinkWrap: true,
                      children: menuItemView(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget menuItem(IconData icon, String label, String subtitulo, String rota,
      {Function callback}) {
    return Column(
      children: [
        NeumorphicButton(
          onPressed: () {
            if (callback != null) {
              callback();
            } else {
              Navigator.pushNamed(context, rota);
            }
          },
          style: NeumorphicStyle(
            shape: NeumorphicShape.concave,
          ),
          padding: const EdgeInsets.all(8.0),
          margin: EdgeInsets.only(bottom: 5),
          child: Icon(
            icon,
            color: Colors.blueAccent,
          ),
        ),
        Center(
          child: Text(
            label,
            style: TextStyle(fontSize: 12),
          ),
        ),
        Center(
          child: Text(
            subtitulo,
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  List<Widget> menuItemView() {
    return item;
  }

  List<Widget> getMenuItemInventario(BuildContext context) {
    return [
      menuItem(
          FontAwesomeIcons.cartPlus, "Editor", "Encomenda", '/encomenda_novo'),
      menuItem(FontAwesomeIcons.edit, "Editor", "Receção", '/rececao_editor'),
      menuItem(Icons.border_color, "Editor", "Expedição", '/expedicao_editor'),
      menuItem(FontAwesomeIcons.fileSignature, "Editor", "Inventário",
          '/inventario_editor'),
      menuItem(Icons.content_paste_outlined, "Lista", "Inventario",
          '/inventario_lista'),
      menuItem(
          Icons.open_in_new_outlined, "Lista", "Receção", '/rececao_lista'),
      menuItem(Icons.input_outlined, "Lista", "Expedição", '/expedicao_lista'),
    ];
  }

  List<Widget> getMenuItemGeral(BuildContext context) {
    return [
      menuItem(Icons.local_offer_outlined, "Artigo", "", '/artigo_lista'),
      // menuItem(
      //     Icons.shopping_cart_outlined, "Encomenda", "", '/encomenda_lista'),
      menuItem(FontAwesomeIcons.user, "Cliente", "", '/cliente_lista'),
      menuItem(Icons.airport_shuttle_outlined, "Fornecedor", "",
          '/fornecedor_lista'),
      menuItem(
          Icons.content_paste_outlined, "Inventario", "", '/inventario_lista'),
      menuItem(Icons.open_in_new_outlined, "Receção", "", '/rececao_lista'),
      menuItem(Icons.input_outlined, "Expedição", "", '/expedicao_lista'),
    ];
  }

  List<Widget> getMenuItemSistema(BuildContext context) {
    return [
      menuItem(Icons.settings_outlined, "Configurar", "", '/config_instancia'),
      menuItem(Icons.build_outlined, "Definições", "", '/config_instancia'),
      menuItem(Icons.sync_outlined, "Sincronizar", "", '', callback: () async {
        // setState(() async {
        //   // await ArtigoBloc(httpClient: http.Client()).syncArtigo();
        //   await ClienteBloc(httpClient: http.Client()).clienteSync();
        // });\
        try {
          BuildContext dialogContext;
          String syncMsg = "";

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              dialogContext = context;

              return WillPopScope(
                child: AlertDialog(
                  title: Column(
                    children: [
                      Center(child: Text('Sincronizando')),
                      Center(child: Text('Aguarde'))
                    ],
                  ),
                  content: Container(
                      width: 50,
                      height: 50,
                      child: Center(child: CircularProgressIndicator())),
                ),
                onWillPop: () async {
                  return false;
                },
              );
            },
          );
          // setState(() {
          //   syncMsg = "Artigo 1/6";
          // });
          await ArtigoBloc(httpClient: http.Client()).syncArtigo();
          // setState(() {
          //   syncMsg = "Cliente 2/6";
          // });

          await ClienteBloc(httpClient: http.Client()).clienteSync();
          // setState(() {
          //   syncMsg = "Fornecedor 3/6";
          // });

          await FornecedorBloc(httpClient: http.Client()).fornecedorSync();
          // setState(() {
          //   syncMsg = "Inventario 4/6";
          // });

          await InventarioBloc(httpClient: http.Client()).inventarioSync();
          // setState(() {
          //   syncMsg = "Cliente 5/6";
          // });

          await RececaoBloc(httpClient: http.Client()).rececaoSync();
          // setState(() {
          //   syncMsg = "Expedição 6/6";
          // });
          await ExpedicaoBloc(httpClient: http.Client()).expedicaoSync();
          Navigator.pop(dialogContext);
        } catch (e) {
          print("Ocorreu um erro ao sincronizar");
          print(e);
        }
      }),
      menuItem(Icons.undo_outlined, "Sair", "", '/'),
    ];
  }

  Color _iconsColor(BuildContext context) {
    final theme = NeumorphicTheme.of(context);
    if (theme.isUsingDark) {
      return theme.current.accentColor;
    } else {
      return null;
    }
  }

  Color _textColor(BuildContext context) {
    if (NeumorphicTheme.isUsingDark(context)) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }
}

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key}) : super(key: key);

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   GlobalKey _bottomNavigationKey = GlobalKey();

//   int _page = 0;

//   Widget build(BuildContext context) {
//     // menuLabel = "Menu";

//     return Scaffold(
//       appBar: menuAppBar(),
//       bottomNavigationBar: CurvedNavigationBar(
//         key: _bottomNavigationKey,
//         index: 1,
//         height: 50.0,
//         items: <Widget>[
//           Neumorphic(
//             style: NeumorphicStyle(
//                 border: NeumorphicBorder(
//               color: Color(0x33000000),
//               width: 0.4,
//             )),
//             child: Icon(
//               Icons.business_center_outlined,
//               size: 30,
//             ),
//           ),
//           Neumorphic(
//             style: NeumorphicStyle(
//                 border: NeumorphicBorder(
//               color: Color(0x33000000),
//               width: 0.4,
//             )),
//             child: Icon(
//               Icons.dashboard_outlined,
//               size: 30,
//             ),
//           ),
//           Neumorphic(
//             style: NeumorphicStyle(
//                 border: NeumorphicBorder(
//               color: Color(0x33000000),
//               width: 0.4,
//             )),
//             child: Icon(
//               Icons.build_outlined,
//               size: 30,
//             ),
//           ),
//         ],
//         color: Colors.blueAccent,
//         buttonBackgroundColor: Colors.white,
//         backgroundColor: Colors.white,
//         animationCurve: Curves.easeInOut,
//         animationDuration: Duration(milliseconds: 600),
//         onTap: (index) {
//           item.clear();
//           setState(() {
//             _page = index;

//             if (index == 0) {
//               item = getMenuItemInventario(context);
//               setState(() {
//                 menuLabel = "Inventario";
//               });
//             } else if (index == 1) {
//               item = getMenuItemGeral(context);
//               setState(() {
//                 menuLabel = "Geral";
//               });
//             } else if (index == 2) {
//               item = getMenuItemSistema(context);
//               setState(() {
//                 menuLabel = "Sistema";
//               });
//             }
//           });
//         },
//         letIndexChange: (index) => true,
//       ),
//       backgroundColor: NeumorphicTheme.baseColor(context),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             Container(
//               width: MediaQuery.of(context).size.width,
//               height: MediaQuery.of(context).size.height / 3.5,
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   CircleAvatar(
//                     backgroundColor: Colors.white38,
//                     radius: 55.0,
//                     child: NeumorphicIcon(
//                       Icons.extension,
//                       size: 50,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Stack(
//               children: <Widget>[
//                 // container menu body
//                 Container(
//                   width: MediaQuery.of(context).size.width - 16,
//                   height: MediaQuery.of(context).size.height / 2,
//                   margin: EdgeInsets.only(top: 50),
//                   child: Container(
//                     child: GridView.count(
//                       crossAxisCount: 3,
//                       crossAxisSpacing: 1.0,
//                       mainAxisSpacing: 1,
//                       shrinkWrap: true,
//                       children: menuItemView(),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

// }
