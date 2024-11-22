class Usuario {
  String id;
  String nombre;
  String correo;
  String contrasenia;
  String? fechaNacimiento;
  double? estatura;
  double? peso;
  int? activo;

  Usuario({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.contrasenia,
    this.fechaNacimiento,
    this.estatura,
    this.peso,
    this.activo,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nombre: json['nombre'],
      correo: json['correo'],
      contrasenia: json['contrasenia'],
      fechaNacimiento: json['fechaNacimiento'],
      estatura: json['estatura'],
      peso: json['peso'],
      activo: json['activo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'correo': correo,
      'contrasenia': contrasenia,
      'fechaNacimiento': fechaNacimiento,
      'estatura': estatura,
      'peso': peso,
      'activo': activo,
    };
  }

  @override
  String toString() {
    return 'Usuario{id: $id, nombre: $nombre, correo: $correo, contrasenia: $contrasenia, fechaNacimiento: $fechaNacimiento, estatura: $estatura, peso: $peso, activo: $activo}';
  }
}