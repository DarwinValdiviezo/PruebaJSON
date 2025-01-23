class Verdura {
  final int codigo;
  final String descripcion;
  final double precio;

  Verdura({
    required this.codigo,
    required this.descripcion,
    required this.precio,
  });

  // Convertir JSON a objeto Verdura
  factory Verdura.fromJson(Map<String, dynamic> json) {
    return Verdura(
      codigo: json['codigo'],
      descripcion: json['descripcion'],
      precio: (json['precio'] as num).toDouble(),
    );
  }

  // Convertir objeto Verdura a JSON
  Map<String, dynamic> toJson() {
    return {
      'codigo': codigo,
      'descripcion': descripcion,
      'precio': precio,
    };
  }
}
