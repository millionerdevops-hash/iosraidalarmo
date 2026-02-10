import 'package:flutter/material.dart';

/// RAID ALARM Screen Layout Component
/// Provides scanline and noise overlay effects for authentic Rust game aesthetic
/// Optimized with RepaintBoundary to prevent unnecessary rebuilds of effect layers
class RustScreenLayout extends StatelessWidget {
  final Widget child;
  final bool showScanlines;
  final bool showNoise;

  const RustScreenLayout({
    super.key,
    required this.child,
    this.showScanlines = true,
    this.showNoise = true,
  });

  // Performance: Extract constants to prevent recreation
  static const double _scanlineOpacity = 0.3;
  static const double _noiseOpacity = 0.3;
  static const String _scanlineAsset = 'assets/grid-noise.png';
  static const String _noiseAsset = 'assets/otis-redding.png';

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Main Content
        child,

        // 2. Scanline Effect Layer
        // Positioned must be parent of RepaintBoundary for correct widget hierarchy
        if (showScanlines)
          Positioned.fill(
            child: RepaintBoundary(
              child: IgnorePointer(
                child: Opacity(
                  opacity: _scanlineOpacity,
                  child: Image.asset(
                    _scanlineAsset,
                    repeat: ImageRepeat.repeat,
                    color: Colors.black,
                    // Performance: gaplessPlayback prevents flicker during rebuild
                    gaplessPlayback: true,
                  ),
                ),
              ),
            ),
          ),

        // 3. Noise/Grain Effect Layer
        // Positioned must be parent of RepaintBoundary for correct widget hierarchy
        if (showNoise)
          Positioned.fill(
            child: RepaintBoundary(
              child: IgnorePointer(
                child: Opacity(
                  opacity: _noiseOpacity,
                  child: Image.asset(
                    _noiseAsset,
                    repeat: ImageRepeat.repeat,
                    fit: BoxFit.none,
                    // Performance: gaplessPlayback prevents flicker during rebuild
                    gaplessPlayback: true,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
