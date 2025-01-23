import 'package:flutter/material.dart';
import '../controlador/controlador_verduras.dart';
import '../datos/github_service.dart';
import '../vista/pantalla_principal.dart';

void main() {
  final servicioGitHub = GitHubService();
  final controlador = ControladorVerduras(servicioGitHub);

  runApp(MaterialApp(
    home: PantallaPrincipal(controlador: controlador),
  ));
}
