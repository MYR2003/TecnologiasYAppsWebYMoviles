class Consulta {
  final int? idconsulta;
  final int idpersona;
  final int idmedico;
  final int? idfichamedica;
  final String fecha;
  final String? motivo;
  final int? duracionminutos;
  final String? observaciones;
  final String? nombrePaciente;
  final String? nombreMedico;

  Consulta({
    this.idconsulta,
    required this.idpersona,
    required this.idmedico,
    this.idfichamedica,
    required this.fecha,
    this.motivo,
    this.duracionminutos,
    this.observaciones,
    this.nombrePaciente,
    this.nombreMedico,
  });

  factory Consulta.fromJson(Map<String, dynamic> json) {
    int _toInt(dynamic value) {
      if (value is int) return value;
      return int.tryParse(value?.toString() ?? '') ?? 0;
    }

    return Consulta(
      idconsulta: json['idconsulta'],
      idpersona: _toInt(json['idpersona']),
      idmedico: _toInt(json['idmedico']),
      idfichamedica: json['idfichamedica'] != null
          ? _toInt(json['idfichamedica'])
          : null,
      fecha: (json['fecha'] ?? '').toString(),
      motivo: json['motivo']?.toString(),
      duracionminutos: json['duracionminutos'] is int
          ? json['duracionminutos'] as int
          : int.tryParse(json['duracionminutos']?.toString() ?? ''),
      observaciones: (json['observaciones'] ?? json['observacion'])?.toString(),
      nombrePaciente: (json['nombre_paciente'] ?? '').toString().isNotEmpty
          ? json['nombre_paciente'].toString()
          : null,
      nombreMedico: (json['medico'] ?? '').toString().isNotEmpty
          ? json['medico'].toString()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idconsulta != null) 'idconsulta': idconsulta,
      'idpersona': idpersona,
      'idmedico': idmedico,
      'idfichamedica': idfichamedica,
      'fecha': fecha,
      'motivo': motivo,
      'duracionminutos': duracionminutos,
      'observaciones': observaciones,
    };
  }
}
