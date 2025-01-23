import 'dart:convert';
import 'package:http/http.dart' as http;



  Future<Map<String, dynamic>> obtenerArchivo() async {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Remover caracteres extraños del contenido Base64 antes de decodificar
      final contenidoBase64 =
          data['content'].replaceAll('\n', '').replaceAll('\r', '');
      final contenidoJson = utf8.decode(base64Decode(contenidoBase64));

      return {
        'sha': data['sha'],
        'contenido': jsonDecode(contenidoJson),
      };
    } else {
      throw Exception(
          'Error al obtener el archivo JSON: ${response.statusCode}');
    }
  }

  Future<void> actualizarArchivo(
      String contenidoJson, String mensaje, String sha) async {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'message': mensaje,
        'content': base64Encode(utf8.encode(contenidoJson)),
        'sha': sha,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Error al actualizar el archivo JSON: ${response.statusCode}');
    }
  }
}
