class Filial {
  String nome;
  String ipGlobal;
  String ipLocal;
  String porta;
  String company;
  String grantType;
  String line;
  String instance;

  Filial(
      {this.nome,
      this.ipGlobal,
      this.ipLocal,
      this.company,
      this.grantType,
      this.line,
      this.instance,
      this.porta});

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'ip_global': ipGlobal,
        'ip_local': ipLocal,
        'company': company,
        'grant_type': grantType,
        'line': line,
        'instance': instance,
        'porta': porta,
      };

  factory Filial.fromJson(Map<String, dynamic> data) {
    return Filial(
      nome: data['nome'],
      ipGlobal: data['ip_global'],
      ipLocal: data['ip_local'],
      company: data['company'],
      grantType: data['grant_type'],
      line: data['line'],
      instance: data['instance'],
      porta: data['porta'],
    );
  }
}
