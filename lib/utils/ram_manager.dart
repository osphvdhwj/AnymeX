import 'package:flutter/services.dart';
import 'package:flutter/painting.dart';



class RamManager {
  static const MethodChannel _memoryChannel = MethodChannel('com.ryan.anymex/memory');

  static void initialize() {
    _limitImageCache();

    _memoryChannel.setMethodCallHandler((call) async {
      if (call.method == 'onTrimMemory') {
        int level = call.arguments as int;
        _handleTrimMemory(level);
      }
    });
  }

  static void _limitImageCache() {
    PaintingBinding.instance.imageCache.maximumSize = 100; // max objects
    PaintingBinding.instance.imageCache.maximumSizeBytes = 50 * 1024 * 1024; // 50 MB max
  }

  static void _handleTrimMemory(int level) {
    // level >= 10 (TRIM_MEMORY_RUNNING_LOW) or level == 15 (TRIM_MEMORY_RUNNING_CRITICAL)
    if (level >= 10) {
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();

      // Optionally drop idle Isar connections here or perform other cleanup
      // If we have access to Isar instances, we could close unused ones or trigger a GC if dart exposed it natively.
      // E.g. final isar = Isar.getInstance();
      // isar?.close();
    }
  }
}
