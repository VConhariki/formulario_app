import 'package:flutter/material.dart';
import 'package:formulario_app/model/feedback_model.dart';
import 'package:formulario_app/repository/feedback_repository.dart';

class FeedbackListPage extends StatefulWidget {
  @override
  State<FeedbackListPage> createState() => _FeedbackListPageState();
}

class _FeedbackListPageState extends State<FeedbackListPage> {
  final FeedbackRepository _feedbackRepository = FeedbackRepository();
  List<FeedbackModel> _feedbacks = [];
  int _novoStatus = 0;
  FeedbackModel _feedbackSelecionado = FeedbackModel();
  final Map<int, String> _status = {
    1: 'Recebido',
    2: 'Em Análise',
    3: 'Em Desenvolvimento',
    4: 'Finalizado'
  };

  @override
  void initState() {
    super.initState();
    _loadFeedbacks();
  }

  Future<void> _loadFeedbacks() async {
    try {
      final feedbacks = await _feedbackRepository.obterTodos();
      setState(() {
        _feedbacks = feedbacks;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar feedbacks')),
      );
    }
  }

  Future<void> _buscarFeedbackPorId(int id) async {
    try {
      final feedback = await _feedbackRepository.obterPorId(id);
      setState(() {
        _feedbackSelecionado = feedback;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar feedback')),
      );
    }
  }

  void _showDetailsModal(BuildContext context, FeedbackModel feedback) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height *
              0.95, // Modal ocupa quase toda a tela
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Detalhes do Feedback',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const Divider(),
              Text('ID: ${_feedbackSelecionado.id}'),
              const SizedBox(height: 8.0),
              Text('Título: ${_feedbackSelecionado.titulo}'),
              const SizedBox(height: 8.0),
              Text('Descrição: ${_feedbackSelecionado.descricao}'),
              const SizedBox(height: 8.0),
              Text('Tipo: ${_feedbackSelecionado.tipo}'),
              const SizedBox(height: 8.0),
              Text('Status: ${_feedbackSelecionado.status}'),
              const SizedBox(height: 20),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Novo Status',
                  border: OutlineInputBorder(),
                ),
                value: _feedbackSelecionado.status,
                items: _status.entries
                    .map((entry) => DropdownMenuItem<int>(
                          value: entry.key,
                          child: Text(entry.value),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _novoStatus = value!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecione um tipo.';
                  }
                  return null;
                },
              ),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await _feedbackRepository.atualizarStatus(
                        id: _feedbackSelecionado.id!, novoStatus: _novoStatus);
                    await _loadFeedbacks();
                    Navigator.pop(context);
                  },
                  child: const Text('Atualizar Status'),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Fechar'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Feedbacks'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            showCheckboxColumn: false, // Remove os checkboxes
            columns: const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Título')),
              DataColumn(label: Text('Tipo')),
              DataColumn(label: Text('Status')),
            ],
            rows: _feedbacks.map((feedback) {
              return DataRow(
                cells: [
                  DataCell(Text(feedback.id.toString())),
                  DataCell(Text(feedback.titulo!)),
                  DataCell(Text(feedback.tipo.toString())),
                  DataCell(Text(_status.entries
                      .firstWhere((f) => f.key == feedback.status)
                      .value
                      .toString())),
                ],
                onSelectChanged: (isSelected) async {
                  if (isSelected == true) {
                    await _buscarFeedbackPorId(feedback.id!);
                    _showDetailsModal(context, feedback);
                  }
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FeedbackListPage(),
  ));
}
