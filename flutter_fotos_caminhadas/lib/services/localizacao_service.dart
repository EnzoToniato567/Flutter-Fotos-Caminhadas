import 'package:geolocator/geolocator.dart';

class LocalizacaoService {
  static Future<Position> posicaoAtual() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('Ative a localização do celular para continuar.');
    }

    var permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
    }
    if (permissao == LocationPermission.denied) {
      throw Exception('Permissão de localização negada.');
    }
    if (permissao == LocationPermission.deniedForever) {
      throw Exception(
        'Permissão de localização bloqueada. Libere-a nas configurações.',
      );
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }
}
