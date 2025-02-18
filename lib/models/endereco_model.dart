class EnderecoModel {
  final String logradouro;
  final String bairro;
  final String localidade;
  final String uf;

  EnderecoModel({
    required this.logradouro,
    required this.bairro,
    required this.localidade,
    required this.uf,
  });

  // Factory para construir o objeto a partir de um JSON
  factory EnderecoModel.fromJson(Map<String, dynamic> json) {
    return EnderecoModel(
      logradouro: json['logradouro'],
      bairro: json['bairro'],
      localidade: json['localidade'],
      uf: json['uf'],
    );
  }
}
