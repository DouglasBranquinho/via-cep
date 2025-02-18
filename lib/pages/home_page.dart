import 'package:flutter/material.dart';
import 'package:teste_create_flutter/models/endereco_model.dart';
import 'package:teste_create_flutter/repositories/cep_repository.dart';
import 'package:teste_create_flutter/repositories/cep_repository_impl_temp.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CepRepository cepRepository = CepRepositoryImpl();
  EnderecoModel? enderecoModel = null;

  final formkey = GlobalKey<FormState>();
  final cepEC = TextEditingController();

  @override
  void dispose() {
    cepEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar CEP'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(
            children: [
              TextFormField(
                controller: cepEC,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  final valid = formkey.currentState?.validate() ?? false;
                  if (valid) {
                    final endereco = await cepRepository.getCep(cepEC.text);
                    setState(() {
                      enderecoModel = endereco;
                    });
                  }
                },
                child: const Text('Buscar'),
              ),
              Text('Logradoouro Complemento Cep'),
            ],
          ),
        ),
      ),
    );
  }
}
