import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/caminhada.dart';

class CaminhadaStorage {
  static const _chave = 'caminhadas';

  Future<List<Caminhada>> listar() async {
    final preferences = await SharedPreferences.getInstance();
    final texto = preferences.getString(_chave);
    if (texto == null || texto.isEmpty) return [];

    try {
      final lista = jsonDecode(texto) as List<dynamic>;
      return lista
          .map((item) => Caminhada.fromJson(item as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.criadaEm.compareTo(a.criadaEm));
    } catch (_) {
      return [];
    }
  }

  Future<void> salvar(Caminhada caminhada) async {
    final caminhadas = await listar();
    caminhadas.add(caminhada);
    await _gravar(caminhadas);
  }

  Future<void> atualizar(Caminhada caminhada) async {
    final caminhadas = await listar();
    final indice = caminhadas.indexWhere((item) => item.id == caminhada.id);
    if (indice >= 0) {
      caminhadas[indice] = caminhada;
      await _gravar(caminhadas);
    }
  }

  Future<void> excluir(String id) async {
    final caminhadas = await listar();
    caminhadas.removeWhere((item) => item.id == id);
    await _gravar(caminhadas);
  }

  Future<void> _gravar(List<Caminhada> caminhadas) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _chave,
      jsonEncode(caminhadas.map((item) => item.toJson()).toList()),
    );
  }
}
