import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheService {
  final customCache = CacheManager(
    Config(
      'customPicCache',
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 1000,
      repo: JsonCacheInfoRepository(databaseName: 'customPicCache'),
      fileService: HttpFileService(),
    ),
  );
}
