class Establishment {
  final String id;
  final String name;
  final String address;

  Establishment({
    required this.id,
    required this.name,
    required this.address,
  });

  factory Establishment.fromJson(Map<String, dynamic> json) {
    return Establishment(
      id: json['_id'],
      name: json['name'],
      address: json['address'] is Map
          ? json['address']['address'] ?? 'Sem endereço'
          : 'Sem endereço',
    );
  }
}
