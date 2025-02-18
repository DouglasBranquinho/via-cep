import 'dart:developer';

import 'package:teste_create_flutter/models/endereco_model.dart';

import './cep_repository.dart';
import 'package:dio/dio.dart';

class CepRepositoryImpl implements CepRepository {
  @override
  Future<EnderecoModel> getCep(String cep) async {
    try {
      final result = await Dio().get('https://viacep.com.br/ws/$cep/json');
      log(result.data);
      return EnderecoModel.fromMap(result.data);
    } on DioException catch (e) {
      log('Erro ao buscar CEP $e');
      throw Exception('Erro ao buscar CEP');
    }
  }
}
