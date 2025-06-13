class Produto {
  final String id;
  final String nome;
  final String descricao;
  final double preco;
  final String imagem;

  Produto({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.imagem,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['_id'],
      nome: json['name'],
      descricao: json['description'],
      preco: (json['price'] as num).toDouble(),
      imagem: (json['images'] != null && json['images'].isNotEmpty)
          ? json['images'][0]
          : '', // fallback se não tiver imagem
    );
  }
}
