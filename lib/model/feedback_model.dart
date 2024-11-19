class FeedbackModel {
  int? id;
  String? titulo;
  String? descricao;
  int? tipo;
  int? status;

  FeedbackModel({this.id, this.titulo, this.descricao, this.tipo, this.status});

  FeedbackModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titulo = json['titulo'];
    descricao = json['descricao'];
    tipo = json['tipo'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['titulo'] = titulo;
    data['descricao'] = descricao;
    data['tipo'] = tipo;
    data['status'] = status;
    return data;
  }
}
