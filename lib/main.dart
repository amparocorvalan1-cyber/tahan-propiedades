import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Tahan Propiedades - DUO Apps Development
// NOTA: la app NO usa geolocalización (sin GPS, mapas ni permisos de ubicación).

const String kWhatsApp = 'https://wa.link/lc56dd';
const String kMail = 'mailto:veronicatahaninmobiliaria@gmail.com';
const String kInstagram = 'https://www.instagram.com/veronicatahaninmobiliaria/';

// Las coordenadas están en píxeles sobre las pantallas de 880 x 1913.
const double kW = 880;
const double kH = 1913;

void main() => runApp(const TahanApp());

class TahanApp extends StatelessWidget {
  const TahanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tahan Propiedades',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF897260),
        scaffoldBackgroundColor: const Color(0xFF8B7B6C),
      ),
      // Pantalla 22 = bienvenida (logo). Al tocar pasa al Inicio (pantalla 1).
      home: const ScreenPage(22),
      // En pantallas anchas (compu) se muestra dentro de un marco de celular.
      builder: (context, child) {
        final size = MediaQuery.of(context).size;
        if (size.width < 600) return child!;
        final h = size.height * 0.94;
        final w = h * 880 / 1913;
        return Container(
          color: const Color(0xFF2B2B2B),
          alignment: Alignment.center,
          child: Container(
            width: w + 20,
            height: h + 20,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(44),
              boxShadow: const [
                BoxShadow(color: Colors.black54, blurRadius: 30, spreadRadius: 2),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(34),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

/// Una zona táctil sobre la imagen.
class Hot {
  final double x, y, w, h, pad;
  final int? to; // número de pantalla destino
  final String? url; // o enlace externo
  final bool back; // botón visual de volver
  final bool fullScreen;
  final String label;
  const Hot(this.x, this.y, this.w, this.h,
      {this.pad = 8,
      this.to,
      this.url,
      this.back = false,
      this.fullScreen = false,
      required this.label});
}

List<Hot> hotspotsFor(int n) {
  if (n == 22) {
    return const [Hot(0, 0, kW, kH, pad: 0, to: 1, fullScreen: true, label: 'Entrar a la app')];
  }
  if (n == 1) {
    return const [
      Hot(257, 1177, 371, 73, to: 2, label: 'Ver propiedades en venta'),
      Hot(262, 1271, 372, 74, to: 11, label: 'Ver propiedades en alquiler'),
      Hot(254, 1606, 372, 73, to: 20, label: 'Ir a Contáctanos'),
      Hot(254, 1700, 372, 73, to: 21, label: 'Ir a Nosotros'),
      Hot(707, 1722, 86, 86, pad: 10, url: kWhatsApp, label: 'Abrir WhatsApp'),
    ];
  }
  if (n >= 2 && n <= 19) {
    final venta = n <= 10;
    final first = venta ? 2 : 11;
    final last = venta ? 10 : 19;
    return [
      const Hot(88, 88, 190, 190, to: 1, label: 'Volver al inicio'),
      const Hot(698, 1782, 86, 86, pad: 10, url: kWhatsApp, label: 'Consultar por WhatsApp'),
      if (n < last)
        Hot(710, 700, 150, 240, pad: 0, to: n + 1, label: 'Siguiente propiedad'),
      if (n > first)
        Hot(20, 700, 150, 240, pad: 0, to: n - 1, label: 'Propiedad anterior')
      else if (n == 11)
        const Hot(20, 700, 150, 240, pad: 0, to: 19, label: 'Última propiedad en alquiler'),
    ];
  }
  if (n == 20) {
    return const [
      Hot(88, 88, 92, 92, pad: 6, to: 1, back: true, label: 'Volver al inicio'),
      Hot(88, 1265, 704, 87, url: kWhatsApp, label: 'Escribir por WhatsApp'),
      Hot(88, 1413, 704, 87, url: kMail, label: 'Enviar un correo'),
      Hot(88, 1562, 694, 87, url: kInstagram, label: 'Abrir Instagram'),
    ];
  }
  if (n == 21) {
    return const [Hot(88, 88, 92, 92, pad: 6, to: 1, back: true, label: 'Volver al inicio')];
  }
  return const [];
}

String assetFor(int n) => 'assets/screens/s-${n.toString().padLeft(2, '0')}.jpg';

Future<void> openUrl(String url) async {
  final uri = Uri.parse(url);
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

void goTo(BuildContext context, int target) {
  final nav = Navigator.of(context);
  if (target == 1) {
    // Volver al Inicio: limpiamos la pila y mostramos el Inicio.
    nav.pushAndRemoveUntil(_fade(const ScreenPage(1)), (r) => false);
  } else if (target >= 2 && target <= 19) {
    // Entre fichas se reemplaza (así "atrás" siempre vuelve al Inicio).
    final comingFromHome = ModalRoute.of(context)?.settings.name == 'p1';
    if (comingFromHome) {
      nav.push(_fade(ScreenPage(target)));
    } else {
      nav.pushReplacement(_fade(ScreenPage(target)));
    }
  } else {
    nav.push(_fade(ScreenPage(target)));
  }
}

Route<void> _fade(ScreenPage page) {
  return PageRouteBuilder<void>(
    settings: RouteSettings(name: 'p${page.n}'),
    transitionDuration: const Duration(milliseconds: 220),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, anim, __, child) =>
        FadeTransition(opacity: anim, child: child),
  );
}

class ScreenPage extends StatelessWidget {
  final int n;
  const ScreenPage(this.n, {super.key});

  @override
  Widget build(BuildContext context) {
    final hots = hotspotsFor(n);
    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: kW / kH,
          child: LayoutBuilder(builder: (context, c) {
            final s = c.maxWidth / kW;
            return Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(assetFor(n), fit: BoxFit.fill, gaplessPlayback: true),
                for (final h in hots) _hotspot(context, h, s),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _hotspot(BuildContext context, Hot h, double s) {
    final left = ((h.x - h.pad) * s).clamp(0.0, kW * s);
    final top = ((h.y - h.pad) * s).clamp(0.0, kH * s);
    final width = ((h.w + 2 * h.pad) * s).clamp(0.0, kW * s - left);
    final height = ((h.h + 2 * h.pad) * s).clamp(0.0, kH * s - top);

    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: Semantics(
        button: true,
        label: h.label,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (h.to != null) {
              if (n == 22) {
                Navigator.of(context).pushAndRemoveUntil(
                    _fade(const ScreenPage(1)), (r) => false);
              } else {
                goTo(context, h.to!);
              }
            } else if (h.url != null) {
              openUrl(h.url!);
            }
          },
          child: h.back ? _backButton() : const SizedBox.expand(),
        ),
      ),
    );
  }

  // Botón de volver (único elemento visual agregado al diseño).
  Widget _backButton() {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.86,
        heightFactor: 0.86,
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFBE9E7),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(Icons.arrow_back, color: Color(0xFF8B7B6C), size: 22),
          ),
        ),
      ),
    );
  }
}
