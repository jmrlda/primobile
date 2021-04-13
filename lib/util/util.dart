// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:another_flushbar/flushbar.dart';
// import 'package:data_connection_checker/data_connection_checker.dart';
// import 'package:dio/dio.dart';
// import 'package:dio_retry/dio_retry.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

// import 'package:connectivity/connectivity.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:dio_retry/dio_retry.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' show get;
import 'package:http_parser/http_parser.dart';
import 'package:primobile/expedicao/models/expedicao.dart';
import 'package:primobile/inventario/models/models.dart';
import 'package:primobile/rececao/models/models.dart';

class Opcoes {
  static const String Sincronizar = 'sincronizar';

  static const List<String> escolha = <String>[
    Sincronizar,
  ];
}

Widget networkIconImage(url) {
  // Widget rv;
  // try {
  //   rv = CachedNetworkImage(
  //     width: 45,
  //     height: 45,
  //     fit: BoxFit.cover,
  //     imageUrl: url,
  //     placeholder: (context, url) => CircularProgressIndicator(),
  //     errorWidget: (context, url, error) => Icon(Icons.error),

  //   );
  // } catch (err) {
  //   rv = Icon(Icons.error);
  // }

  return Icon(Icons.error);
}

String baseUrl = "";
String url = "";

class Conexao {
  static String baseUrl = "";
  static String url = "";
}

// Future<dynamic> SincronizarModelo(context, modelo) async {

//   var rv;

//   try {
//     if (modelo == "cliente") {
//       rv = await clienteApi.getTodosClientes();
//     } else if (modelo == "artigo") {
//       rv = await artigoApi.getTodosArtigos();
//     } else if (modelo == "encomenda") {
//      encomendaApi.getTodasEncomendas().then((value) {
//           // reduntante mas util para informar o estado dos modelos
//             if (encomendaApi.erro == false ) {
//                 encomendaApi.sincronizado = true;
//             } else {
//                 encomendaApi.erro = true;
//             }
//           // });
//        });    }
//   } catch (e) {
//     print('Erro: $e.message');
//     rv = null;
//   }

//   BuildContext dialogContext;
//    showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       dialogContext = context;

//           return WillPopScope(
//                 child: AlertDialog(
//                   title: Center(child: Text('Sincronizando')),
//                   content: Container(
//                       width: 50,
//                       height: 50,
//                       child: Center(child: CircularProgressIndicator())),
//                 ),
//                 onWillPop: () async {
//                   return false;
//                 },
//               );
//     },
//   );
//   // showDialog(
//   //   context: context,
//   //   barrierDismissible: false,
//   //   builder: (BuildContext context) {
//   //     return StatefulBuilder(
//   //       builder: (context, setState) {

//   //         new Future.delayed(new Duration(seconds: 3), () {
//   //           setState(() {
//   //             if (modelo == "cliente") {
//   //               if (clienteApi.sincronizado == true) {
//   //                 Navigator.of(context).pop();
//   //               }
//   //             } else if (modelo == "artigo") {
//   //               if (artigoApi.sincronizado == true) {
//   //                 Navigator.of(context).pop();
//   //               }
//   //             } else if (modelo == "encomenda") {
//   //               if (encomendaApi.sincronizado == true) {
//   //                 Navigator.of(context).pop();
//   //               }
//   //             }
//   //           });
//   //         });

//   //         return WillPopScope(
//   //           child: AlertDialog(
//   //             title: Container(
//   //               child: Center(child: Text("Sincronizando Aguarde ...")),
//   //             ),
//   //             content: Container(
//   //                 width: 50,
//   //                 height: 50,
//   //                 child: Center(child: CircularProgressIndicator())),
//   //             actions: <Widget>[],
//   //           ),
//   //           onWillPop: () async => false,
//   //         );
//   //       },
//   //     );
//   //   },
//   // );
// // Timer.periodic(Duration(seconds: 3), (timer) {

// // }

// // Timer.periodic(Duration(seconds: 5), (timer) {

// //               if (modelo == "cliente") {
// //                 if (clienteApi.sincronizado == true) {
// //                   Navigator.of(context).pop();
// //                 }
// //               } else if (modelo == "artigo") {
// //                 if (artigoApi.sincronizado == true) {
// //                   Navigator.of(context).pop();
// //                 }
// //               } else if (modelo == "encomenda") {
// //                 if (encomendaApi.sincronizado == true) {
// //                   Navigator.of(context).pop();
// //                 }
// //               }

// // });

//   return rv;
// }

// class SucessoPage extends StatelessWidget {
//   const SucessoPage({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         color: Colors.blue[50],
//         child: Container(
//           child: Card(
//             margin: EdgeInsets.only(top: 120, bottom: 120, left: 50, right: 50),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 Icon(
//                   Icons.check_circle,
//                   color: Colors.blue,
//                   size: 200,
//                 ),
//                 Text(
//                   "Sucesso",
//                   style: TextStyle(
//                     color: Colors.blue,
//                     fontSize: 20,
//                   ),
//                 ),
//                 MaterialButton(
//                   height: 56,
//                   color: Colors.blue[50],
//                   shape: CircleBorder(),
//                   child: Text(
//                     'Ok',
//                     style: TextStyle(color: Colors.blue),
//                   ),
//                   onPressed: () {
//                     Navigator.pushNamed(context, '/');
//                   },
//                 )
//               ],
//             ),
//           ),
//         ));
//   }
// }

void fileRename(String caminho, String nome) {
  String dir = path.dirname(caminho);
  path.join(dir, caminho);
}

Future<Uint8List> openCamera(String nome) async {
  final picker = ImagePicker();
  PickedFile imagem;
  var rv;
  try {
    imagem =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);
    if (imagem != null && imagem.path != null) {
      rv = await imagem
          .readAsBytes(); //base64String(await imagem.readAsBytes());

    }
  } catch (err) {
    print('[openCamera]ocorreu um erro');
    print(err);
    rv = null;
  }

  return rv;
}

Future<Uint8List> abrirGaleria() async {
  var picker = ImagePicker();
  PickedFile imagem;
  Uint8List rv;

  try {
    imagem = await picker.getImage(source: ImageSource.gallery);
    if (imagem != null && imagem.path != null) {
      rv = await imagem.readAsBytes();
    }
  } catch (err) {
    print('[abrirGaleria] ocorreu um erro');
    print(err);
    rv = null;
  }

  return rv;
}

Future<Position> GetLocalizacaoActual() async {
  Position posicao;
  bool geoEnable = await Geolocator.isLocationServiceEnabled();
  LocationPermission permissao = await Geolocator.checkPermission();
  try {
    if ((geoEnable) &&
        (permissao == LocationPermission.whileInUse ||
            permissao == LocationPermission.always)) {
      posicao = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } else {
      posicao = null;
    }
  } catch (err) {
    print('[_getLocalizacaoActual] Ocorreu um erro');
    print(err);
    posicao = null;
  }

  return posicao;
}

Image imageFromBase64String(String base64String) {
  return Image.memory(
    base64Decode(base64String),
    fit: BoxFit.fill,
  );
}

Uint8List dataFromBase64String(String base64String) {
  return base64Decode(base64String);
}

String base64String(Uint8List data) {
  return base64Encode(data);
}

Future<String> localPath() async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> localFile(String filename) async {
  final path = await localPath();
  return File('$path/' + filename);
}

Future<File> writeByteFile(filename, dynamic content) async {
  File file = await localFile(filename);

  try {
    file.writeAsBytesSync(content);
  } catch (err) {
    print('[writeByteFile] erro: ' + err.message);
    file = null;
  }
  // Write the file.

  return file;
}

Future<File> writeByteFileSync(filename, dynamic content) async {
  File file = await localFile(filename);

  try {
    file.writeAsBytesSync(content);
  } catch (err) {
    print('[writeByteFile] erro: ' + err.message);
    file = null;
  }
  // Write the file.

  return file;
}

Future<void> writeStringFile(filename, dynamic content) async {
  final file = await localFile(filename);

  // Write the file.
  try {
    file.writeAsString(content);
  } catch (err) {
    print('[writeStringFile] erro ' + err.message);
  }
}

// Future<File> writeByteFilSync(filename, dynamic content) async {
//   final file = await localFile(filename);

//   // Write the file.
//   return file.writeAsBytesSync(content);
// }
// Future<File> writeStringFileSync(filename, dynamic content) async {
//   final file = await localFile(filename);

//   // Write the file.
//   return file.writeAsStringSync(content)
// }

Future<int> getUrlStatus(url) async {
  Dio dio;
  Response response;
  dio = new Dio()
    ..interceptors.add(RetryInterceptor(
        dio: dio,
        options: const RetryOptions(
          retries: 1, // numero de tentativas antes de falhar
        )));

  try {
    response = await dio.get(url);
  } catch (e) {
    return 500;
  }
  return response.statusCode;
}

String downloadimage(String url, String artigo) {
  File file;
  get(url).then((response) async {
    file = await writeByteFile(artigo + '.jpg', response.bodyBytes);
  });
  // var firstPath = localDir.path + "/imagens";
  // filePathAndName = localDir.path + "/imagens/" + artigo + ".jpg";
  // await Directory(firstPath).create(recursive: true);
  // File file2 = new File(filePathAndName);

  return file.path;
}

Future<Response> uploadImage(File image, String url) async {
  Dio dio;
  dio = new Dio()
    ..interceptors.add(RetryInterceptor(
        dio: dio,
        options: const RetryOptions(
          retries: 3, // numero de tentativas antes de falhar
          retryInterval: const Duration(seconds: 3),
        )));
  Response response;
  try {
    String filename = image.path.split('/').last;
    // String ext = filename.split('.').last;

    FormData formData = new FormData.fromMap({
      'image': await MultipartFile.fromFile(image.path,
          filename: filename, contentType: new MediaType('image', 'png')),
      'type': 'image/png'
    });

    response = await dio.post(url, data: formData);

    if (response.statusCode == 200) {}
  } catch (ex) {
    print("Erro ${ex}");
    return response;
  }

  return response;
}

Future<bool> checkAcessoInternet() async {
  bool rv = false;
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      rv = true;
    }
  } on SocketException catch (_) {
    rv = false;
  }

  return rv;
}

Future<bool> checkConexao() async {
  // var conexaoResultado = await (Connectivity().checkConnectivity());
  // bool rv;
  // if (conexaoResultado != ConnectivityResult.mobile &&
  //     conexaoResultado != ConnectivityResult.wifi) {
  //   rv = false;
  // } else {
  //   rv = true;
  // }

  return true;
}

Future<bool> checkDadosConexao() async {
  bool conexao = await checkConexao();
  bool result = false;
  if (conexao == true) {
    Response response;
    Dio dio = new Dio();

    try {
      response = await dio.get("https://google.com");

      if (response.statusCode == 200) {
        result = true;
      } else {
        result = false;
      }
    } catch (err) {
      result = false;
    }
  } else {
    result = false;
  }

  return result;
}

Future<bool> temDados(String mensagem, BuildContext contexto) async {
  bool conexao = await checkConexao();
  bool result = false;
  if (conexao == true) {
    DataConnectionStatus status;
    Response response;
    Dio dio = new Dio();

    try {
      response = await dio.get("https://google.com");

      if (response.statusCode == 200) {
        result = true;
      } else {
        result = false;
        Flushbar(
          title: "Atenção",
          messageText: Text(mensagem,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          duration: Duration(seconds: 4),
          backgroundColor: Colors.red,
        )..show(contexto);
      }
    } catch (err) {
      result = false;

      Flushbar(
        title: "Atenção",
        messageText: Text(mensagem,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        duration: Duration(seconds: 4),
        backgroundColor: Colors.red,
      )..show(contexto);
    }
  }

  return result;
}

// Mensagens de alerta
void alerta_info(BuildContext contexto, String texto) {
  Flushbar(
    title: "Atenção",
    // message:  "Dispositivo sem conexão WIFI ou Dados Moveis. Por Favor Active para criar encomenda!",
    messageText: Text(texto,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    duration: Duration(seconds: 4),
    backgroundColor: Colors.red,
  )..show(contexto);
}

List<Expedicao> expedicaoPesquisar(
    String query, List<Expedicao> listaExpedicao) {
  List<Expedicao> resultado = new List<Expedicao>();

  if (query.trim().isNotEmpty) {
    listaExpedicao.forEach((item) {
      if (item.expedicao.toString().contains(query.toString().toLowerCase()) ||
          item.usuario.toLowerCase().contains(query.toString().toLowerCase())) {
        resultado.add(item);
      }
    });
  }
  return resultado;
}

bool existeExpedicaoSelecionado(
    Expedicao e, List<Expedicao> listaExpedicaoSelecionado) {
  bool existe = false;

  for (var i = 0; i < listaExpedicaoSelecionado.length; i++) {
    if (listaExpedicaoSelecionado[i].expedicao == e.expedicao) {
      existe = true;
    }
  }
  return existe;
}

List<Rececao> rececaoPesquisar(String query, List<Rececao> listaRececao) {
  List<Rececao> resultado = new List<Rececao>();

  if (query.trim().isNotEmpty) {
    listaRececao.forEach((item) {
      if (item.rececao.toString().contains(query.toString().toLowerCase()) ||
          item.usuario.toLowerCase().contains(query.toString().toLowerCase())) {
        resultado.add(item);
      }
    });
  }
  return resultado;
}

bool existeRececaoSelecionado(Rececao e, List<Rececao> listaRececaoelecionado) {
  bool existe = false;

  for (var i = 0; i < listaRececaoelecionado.length; i++) {
    if (listaRececaoelecionado[i].rececao == e.rececao) {
      existe = true;
    }
  }
  return existe;
}

List<Inventario> inventarioPesquisar(
    String query, List<Inventario> listaInventario) {
  List<Inventario> resultado = new List<Inventario>();

  if (query.trim().isNotEmpty) {
    listaInventario.forEach((item) {
      if (item.documentoNumero
              .toString()
              .contains(query.toString().toLowerCase()) ||
          item.responsavel
              .toLowerCase()
              .contains(query.toString().toLowerCase())) {
        resultado.add(item);
      }
    });
  }
  return resultado;
}

bool existeInventarioSelecionado(
    Inventario e, List<Inventario> listaInventarioSelecionado) {
  bool existe = false;

  for (var i = 0; i < listaInventarioSelecionado.length; i++) {
    if (listaInventarioSelecionado[i].documentoNumero == e.documentoNumero) {
      existe = true;
    }
  }
  return existe;
}
