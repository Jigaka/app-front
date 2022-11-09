class Paciente {
  String nombre;
  String? apellido;
  int idPersona;

  Paciente(this.nombre, this.apellido, this.idPersona);

  Paciente.fromJson(Map<String, dynamic> json)
      : nombre = json['nombre'],
        apellido = json['apellido'],
        idPersona = json['idPersona'];

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'String': apellido,
        'idPersona': idPersona,
      };
}
