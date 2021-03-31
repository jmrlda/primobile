class Filial {
  String nome;
  String ip;
  String empresa;  

  Filial({this.nome, this.ip, this.empresa});

  Map<String, dynamic> toMap() => {
        'nome': nome,
        'ip': ip,
        'empresa': empresa,
      };


factory Filial.fromJson(Map<String, dynamic> data) {
  
   return Filial(
      nome: data['nome'],
      ip: data['ip'], 
      empresa : data['empresa'],

   );
}


}