import 'package:flutter/material.dart';
import 'package:formulario_app/repository/feedback_repository.dart';

class FormularioView extends StatefulWidget {
  const FormularioView({super.key});

  @override
  FormularioViewState createState() => FormularioViewState();
}

class FormularioViewState extends State<FormularioView> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final FeedbackRepository _feedbackRepository = FeedbackRepository();
  int? _tipoSelecionado = 1;
  final Map<int, String> _tipos = {
    1: 'Bug',
    2: 'Sugestão',
    3: 'Reclamação',
    4: 'Feedback'
  };

  void _cadastrarFeedback() {
    if (_formKey.currentState!.validate()) {
      final titulo = _tituloController.text;
      final descricao = _descricaoController.text;
      final tipo = _tipoSelecionado;

      _feedbackRepository.cadastrar(
          titulo: titulo, descricao: descricao, tipo: tipo!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Feedback cadastrado com sucesso!')),
      );
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o título.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a descrição.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Tipo',
                  border: OutlineInputBorder(),
                ),
                value: _tipoSelecionado,
                items: _tipos.entries
                    .map((entry) => DropdownMenuItem<int>(
                          value: entry.key,
                          child: Text(entry.value),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _tipoSelecionado = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecione um tipo.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.0),
              Center(
                child: ElevatedButton(
                  onPressed: _cadastrarFeedback,
                  child: Text('Cadastrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
