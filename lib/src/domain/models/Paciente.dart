class Paciente {
  String nombre;
  String? apellido;
  int? idPersona;
  String? email;
  String? telefono;
  String? ruc;
  String? cedula;
  String? tipoPersona;
  String? fechaNacimiento;

  Paciente({
    required this.nombre,
    this.apellido,
    this.idPersona,
    this.email,
    this.cedula,
    this.fechaNacimiento,
    this.ruc,
    this.telefono,
    this.tipoPersona,
  });

  Paciente.fromJson(Map<String, dynamic> json)
      : nombre = json['nombre'],
        apellido = json['apellido'],
        idPersona = json['idPersona'],
        email = json['email'],
        telefono = json['telefono'],
        ruc = json['ruc'],
        cedula = json['cedula'],
        tipoPersona = json['tipoPersona'],
        fechaNacimiento = json['fechaNacimiento'];

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'apellido': apellido,
        'email': email,
        'telefono': telefono,
        'ruc': ruc,
        'cedula': cedula,
        'tipoPersona': tipoPersona,
        'fechaNacimiento': fechaNacimiento,
      };
}
