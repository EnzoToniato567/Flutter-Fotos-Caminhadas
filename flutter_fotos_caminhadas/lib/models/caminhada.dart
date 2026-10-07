class Caminhada {
  const Caminhada({
    required this.id,
    required this.titulo,
    required this.origemLatitude,
    required this.origemLongitude,
    required this.destinoLatitude,
    required this.destinoLongitude,
    required this.distanciaKm,
    required this.tempoMinutos,
    required this.calorias,
    required this.criadaEm,
    this.fotoPath,
  });

  final String id;
  final String titulo;
  final double origemLatitude;
  final double origemLongitude;
  final double destinoLatitude;
  final double destinoLongitude;
  final double distanciaKm;
  final int tempoMinutos;
  final int calorias;
  final DateTime criadaEm;
  final String? fotoPath;

  Caminhada copiarCom({String? titulo, String? fotoPath}) => Caminhada(
    id: id,
    titulo: titulo ?? this.titulo,
    origemLatitude: origemLatitude,
    origemLongitude: origemLongitude,
    destinoLatitude: destinoLatitude,
    destinoLongitude: destinoLongitude,
    distanciaKm: distanciaKm,
    tempoMinutos: tempoMinutos,
    calorias: calorias,
    criadaEm: criadaEm,
    fotoPath: fotoPath ?? this.fotoPath,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'titulo': titulo,
    'origemLatitude': origemLatitude,
    'origemLongitude': origemLongitude,
    'destinoLatitude': destinoLatitude,
    'destinoLongitude': destinoLongitude,
    'distanciaKm': distanciaKm,
    'tempoMinutos': tempoMinutos,
    'calorias': calorias,
    'criadaEm': criadaEm.toIso8601String(),
    'fotoPath': fotoPath,
  };

  factory Caminhada.fromJson(Map<String, dynamic> json) => Caminhada(
    id: json['id'] as String,
    titulo: json['titulo'] as String,
    origemLatitude: (json['origemLatitude'] as num).toDouble(),
    origemLongitude: (json['origemLongitude'] as num).toDouble(),
    destinoLatitude: (json['destinoLatitude'] as num).toDouble(),
    destinoLongitude: (json['destinoLongitude'] as num).toDouble(),
    distanciaKm: (json['distanciaKm'] as num).toDouble(),
    tempoMinutos: (json['tempoMinutos'] as num).toInt(),
    calorias: (json['calorias'] as num).toInt(),
    criadaEm: DateTime.parse(json['criadaEm'] as String),
    fotoPath: json['fotoPath'] as String?,
  );
}
