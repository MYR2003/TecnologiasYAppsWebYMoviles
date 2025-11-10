class Paciente {
  final int? idpersona;
  final String nombre;
  final String apellido;
  final String rut;
  final String? fechanacimiento;
  final String? sistemadesalud;
  final String? domicilio;
  final String? telefono;

  Paciente({
    this.idpersona,
    required this.nombre,
    required this.apellido,
    required this.rut,
    this.fechanacimiento,
    this.sistemadesalud,
    this.domicilio,
    this.telefono,
  });

  // Crear Paciente desde JSON
  factory Paciente.fromJson(Map<String, dynamic> json) {
    return Paciente(
      idpersona: json['idpersona'], // minúsculas como viene de la DB
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'] ?? '',
      rut: json['rut'] ?? '',
      fechanacimiento: json['fechanacimiento'], // minúsculas como viene de la DB
      sistemadesalud: json['sistemadesalud'], // minúsculas como viene de la DB
      domicilio: json['domicilio'],
      telefono: json['telefono'],
    );
  }

  // Convertir Paciente a JSON
  Map<String, dynamic> toJson() {
    return {
      if (idpersona != null) 'idPersona': idpersona, // camelCase para enviar al servidor
      'nombre': nombre,
      'apellido': apellido,
      'rut': rut,
      'fechaNacimiento': fechanacimiento, // camelCase para enviar al servidor
      'sistemaDeSalud': sistemadesalud, // camelCase para enviar al servidor
      'domicilio': domicilio,
      'telefono': telefono,
    };
  }

  // Crear una copia del paciente con algunos campos modificados
  Paciente copyWith({
    int? idpersona,
    String? nombre,
    String? apellido,
    String? rut,
    String? fechanacimiento,
    String? sistemadesalud,
    String? domicilio,
    String? telefono,
  }) {
    return Paciente(
      idpersona: idpersona ?? this.idpersona,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      rut: rut ?? this.rut,
      fechanacimiento: fechanacimiento ?? this.fechanacimiento,
      sistemadesalud: sistemadesalud ?? this.sistemadesalud,
      domicilio: domicilio ?? this.domicilio,
      telefono: telefono ?? this.telefono,
    );
  }

  String get nombreCompleto => '$nombre $apellido';
}

