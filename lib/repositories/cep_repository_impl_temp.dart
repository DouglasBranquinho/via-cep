import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:teste_create_flutter/models/endereco_model.dart';
import 'cep_repository.dart';

class CepRepositoryImpl implements CepRepository {
  @override
  Future<EnderecoModel> getCep(String cep) async {
    // Validação do CEP antes de fazer a requisição
    if (cep.length != 8 || int.tryParse(cep) == null) {
      throw Exception('CEP inválido. Digite um CEP com 8 números.');
    }

    final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data.containsKey('erro')) {
          throw Exception('CEP não encontrado.');
        }

        return EnderecoModel.fromJson(data);
      } else {
        throw Exception(
            'Erro ao buscar CEP: Servidor retornou ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: ${e.toString()}');
    }
  }
}
