import 'dart:convert';
import 'package:formulario_app/model/feedback_model.dart';
import 'package:formulario_app/repository/user_repository.dart';
import 'package:http/http.dart' as http;

class FeedbackRepository {
  final String _baseUrl = 'https://localhost:44384';
  final UserRepository _userRepository = UserRepository();

  Future<String> cadastrar(
      {required String titulo,
      required String descricao,
      required int tipo}) async {
    final Uri url = Uri.parse('$_baseUrl/feedback/cadastrar');

    final Map<String, dynamic> data = {
      "titulo": titulo,
      "descricao": descricao,
      "tipo": tipo,
      "status": 1
    };

    try {
      var token = await _userRepository.login(
          username: 'Admin', password: '123456', role: 1);
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );
      return response.body;
    } catch (e) {
      return 'Erro ao cadastrar usuário';
    }
  }

  Future<List<FeedbackModel>> obterTodos() async {
    final Uri url = Uri.parse('$_baseUrl/feedbacks');

    try {
      var token = await _userRepository.login(
          username: 'Admin', password: '123456', role: 1);
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      Iterable l = json.decode(response.body);
      List<FeedbackModel> feedbacks = List<FeedbackModel>.from(
          l.map((model) => FeedbackModel.fromJson(model)));
      return feedbacks;
    } catch (e) {
      return [];
    }
  }

  Future<FeedbackModel> obterPorId(int id) async {
    final Uri url = Uri.parse('$_baseUrl/feedbacks/$id');

    try {
      var token = await _userRepository.login(
          username: 'Admin', password: '123456', role: 1);
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      var resp = json.decode(response.body);
      return FeedbackModel.fromJson(resp);
    } catch (e) {
      return FeedbackModel();
    }
  }

  Future<String> atualizarStatus(
      {required int id, required int novoStatus}) async {
    final Uri url = Uri.parse('$_baseUrl/feedback/atualizar');

    final Map<String, dynamic> data = {"id": id, "status": novoStatus};

    try {
      var token = await _userRepository.login(
          username: 'Admin', password: '123456', role: 1);
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );
      return response.body;
    } catch (e) {
      return 'Erro ao cadastrar usuário';
    }
  }
}
