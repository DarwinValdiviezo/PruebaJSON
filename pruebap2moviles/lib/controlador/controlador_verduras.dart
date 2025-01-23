import '../modelo/verdura.dart';
import '../datos/github_service.dart';
import 'dart:convert';

class ControladorVerduras {
  final GitHubService servicioGitHub;

  ControladorVerduras(this.servicioGitHub);

  Future<Map<String, dynamic>> obtenerArchivo() async {
    return await servicioGitHub.obtenerArchivo();
  }

  Future<void> agregarVerdura(
      List<Verdura> verduras, Verdura nuevaVerdura, String sha) async {
    if (verduras.any((v) => v.codigo == nuevaVerdura.codigo)) {
      throw Exception(
          'El código ${nuevaVerdura.codigo} ya existe. Elija otro.');
    }

    verduras.add(nuevaVerdura);
    final contenidoJson = _generarContenidoJson(verduras);
    await servicioGitHub.actualizarArchivo(
        contenidoJson, 'Agregado nueva verdura', sha);
  }

  Future<void> actualizarVerdura(
      List<Verdura> verduras, Verdura verduraActualizada, String sha) async {
    final index =
        verduras.indexWhere((v) => v.codigo == verduraActualizada.codigo);
    if (index != -1) {
      verduras[index] = verduraActualizada;
      final contenidoJson = _generarContenidoJson(verduras);
      await servicioGitHub.actualizarArchivo(
          contenidoJson, 'Actualización de verdura', sha);
    } else {
      throw Exception(
          'La verdura con el código ${verduraActualizada.codigo} no existe.');
    }
  }

  Future<void> eliminarVerdura(
      List<Verdura> verduras, int codigo, String sha) async {
    verduras.removeWhere((v) => v.codigo == codigo);
    final contenidoJson = _generarContenidoJson(verduras);
    await servicioGitHub.actualizarArchivo(
        contenidoJson, 'Eliminación de verdura', sha);
  }

  String _generarContenidoJson(List<Verdura> verduras) {
    // Generar un JSON válido con las comillas necesarias
    return jsonEncode(verduras.map((v) => v.toJson()).toList());
  }
}
