class Item {
  final String id;
  final String nome;
  final String descricao;
  final String imagem;

  Item({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.imagem,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['_id'],
      nome: json['name'],
      descricao: json['description'],
      imagem: (json['images'] != null && json['images'].isNotEmpty)
          ? json['images'][0]
          : '', // fallback se não tiver imagem
    );
  }
}
