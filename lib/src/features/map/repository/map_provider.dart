import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:mbtiles/mbtiles.dart';

class MBTilesImageProvider extends TileProvider {
  final MbTiles mbtiles;

  MBTilesImageProvider(this.mbtiles);

  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) {
    final z = coordinates.z.round();
    final x = coordinates.x.round();
    final y = _flipY(z, coordinates.y.round());
    return MBTilesImage(mbtiles, x, y, z);
  }

  int _flipY(int z, int y) {
    return (1 << z) - 1 - y;
  }
}

class MBTilesImage extends ImageProvider<MBTilesImage> {
  final MbTiles mbtiles;
  final int x;
  final int y;
  final int z;

  MBTilesImage(this.mbtiles, this.x, this.y, this.z);

  @override
  Future<MBTilesImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<MBTilesImage>(this);
  }

  @override
  ImageStreamCompleter loadImage(
    MBTilesImage key,
    ImageDecoderCallback decode,
  ) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: 1.0,
      informationCollector: () sync* {
        yield DiagnosticsProperty<ImageProvider>('Image provider', this);
        yield DiagnosticsProperty<MBTilesImage>('Image key', key);
      },
    );
  }

  Future<ui.Codec> _loadAsync(
    MBTilesImage key,
    ImageDecoderCallback decode,
  ) async {
    assert(key == this);
    try {
      final tile = mbtiles.getTile(x: key.x, y: key.y, z: key.z);
      if (tile == null) {
        throw Exception('Tile not found at ${key.z}/${key.x}/${key.y}');
      }

      final bytes = Uint8List.fromList(tile);
      final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
      final descriptor = await ui.ImageDescriptor.encoded(buffer);
      return await descriptor.instantiateCodec();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading tile: $e');
      }
      rethrow;
    }
  }
}
