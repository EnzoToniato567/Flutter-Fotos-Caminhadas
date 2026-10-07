import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/caminhada.dart';
import '../services/caminhada_storage.dart';
import '../services/localizacao_service.dart';

class NovaCaminhada extends StatefulWidget {
  const NovaCaminhada({super.key});

  @override
  State<NovaCaminhada> createState() => _NovaCaminhadaState();
}

class _NovaCaminhadaState extends State<NovaCaminhada> {
  final _storage = CaminhadaStorage();
  LatLng _origem = const LatLng(-23.5505, -46.6333);
  LatLng? _destino;
  GoogleMapController? _mapa;
  bool _localizacaoAtiva = false;

  double get _distanciaKm {
    final destino = _destino ?? _origem;
    return Geolocator.distanceBetween(
          _origem.latitude,
          _origem.longitude,
          destino.latitude,
          destino.longitude,
        ) /
        1000;
  }

  int get _tempoMinutos => (_distanciaKm * 12).ceil();
  int get _calorias => (_distanciaKm * 55).round();

  @override
  void initState() {
    super.initState();
    _buscarLocalizacao();
  }

  Future<void> _buscarLocalizacao() async {
    try {
      final posicao = await LocalizacaoService.posicaoAtual();
      if (!mounted) return;
      setState(() {
        _origem = LatLng(posicao.latitude, posicao.longitude);
        _localizacaoAtiva = true;
      });
      await _mapa?.animateCamera(CameraUpdate.newLatLng(_origem));
    } catch (erro) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(erro.toString().replaceFirst('Exception: ', '')),
        ),
      );
    }
  }

  Future<void> _abrirModal() async {
    final controller = TextEditingController();
    final titulo = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Salvar caminhada'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Título'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(dialogContext, controller.text.trim()),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (titulo == null || titulo.isEmpty || !mounted) return;
    await _salvar(titulo);
  }

  Future<void> _salvar(String titulo) async {
    final destino = _destino;
    if (destino == null) return;
    final agora = DateTime.now();

    await _storage.salvar(
      Caminhada(
        id: agora.microsecondsSinceEpoch.toString(),
        titulo: titulo,
        origemLatitude: _origem.latitude,
        origemLongitude: _origem.longitude,
        destinoLatitude: destino.latitude,
        destinoLongitude: destino.longitude,
        distanciaKm: _distanciaKm,
        tempoMinutos: _tempoMinutos,
        calorias: _calorias,
        criadaEm: agora,
      ),
    );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final destino = _destino;
    return Scaffold(
      appBar: AppBar(title: const Text('Nova caminhada')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              destino == null
                  ? 'Toque no mapa para escolher o destino'
                  : '${_distanciaKm.toStringAsFixed(2)} km  •  '
                        '$_tempoMinutos min  •  $_calorias kcal',
              style: const TextStyle(fontSize: 17),
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: _origem, zoom: 15),
              onMapCreated: (controller) => _mapa = controller,
              myLocationEnabled: _localizacaoAtiva,
              myLocationButtonEnabled: _localizacaoAtiva,
              zoomControlsEnabled: false,
              onTap: (ponto) => setState(() => _destino = ponto),
              markers: {
                Marker(
                  markerId: const MarkerId('origem'),
                  position: _origem,
                  infoWindow: const InfoWindow(title: 'Início'),
                ),
                if (destino != null)
                  Marker(
                    markerId: const MarkerId('destino'),
                    position: destino,
                    infoWindow: const InfoWindow(title: 'Destino'),
                  ),
              },
              polylines: {
                if (destino != null)
                  Polyline(
                    polylineId: const PolylineId('trajeto'),
                    points: [_origem, destino],
                    width: 6,
                    color: Theme.of(context).colorScheme.primary,
                  ),
              },
            ),
          ),
        ],
      ),
      floatingActionButton: destino == null
          ? null
          : FloatingActionButton.extended(
              onPressed: _abrirModal,
              icon: const Icon(Icons.save),
              label: const Text('Salvar'),
            ),
    );
  }
}
