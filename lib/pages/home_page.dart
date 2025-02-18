import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teste_create_flutter/models/endereco_model.dart';
import 'package:teste_create_flutter/repositories/cep_repository_impl_temp.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CepRepositoryImpl cepRepository = CepRepositoryImpl();
  EnderecoModel? enderecoModel;
  bool isLoading = false;

  final formKey = GlobalKey<FormState>();
  final cepEC = TextEditingController();

  @override
  void dispose() {
    cepEC.dispose();
    super.dispose();
  }

  Future<void> buscarCep() async {
    if (formKey.currentState?.validate() ?? false) {
      setState(() => isLoading = true);
      try {
        final endereco = await cepRepository.getCep(cepEC.text);
        setState(() => enderecoModel = endereco);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao buscar CEP')),
        );
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Buscar CEP',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: cepEC,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(8),
                ],
                decoration: InputDecoration(
                  labelText: 'Digite o CEP',
                  prefixIcon:
                      const Icon(Icons.location_on, color: Colors.deepPurple),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  } else if (value.length != 8) {
                    return 'CEP deve ter 8 dígitos';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : buscarCep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Buscar',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
              ),
              const SizedBox(height: 20),
              if (enderecoModel != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '📍 Logradouro: ${enderecoModel!.logradouro}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('🏡 Bairro: ${enderecoModel!.bairro}'),
                      Text('🏙️ Cidade: ${enderecoModel!.localidade}'),
                      Text('🗺️ Estado: ${enderecoModel!.uf}'),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
