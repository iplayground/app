import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class MyCacheManager extends CacheManager {
  static const key = "customCache";

  static MyCacheManager _instance;

  // singleton implementation
  // for the custom cache manager
  factory MyCacheManager() {
    if (_instance == null) {
      _instance = new MyCacheManager._();
    }
    return _instance;
  }

  // pass the default setting values to the base class
  // link the custom handler to handle HTTP calls
  // via the custom cache manager
  MyCacheManager._()
      : super(Config(key,
            stalePeriod: Duration(days: 1),
            maxNrOfCacheObjects: 60,
            fileService: HttpFileService()));

//  @override
//  Future<String> getFilePath() async {
//    var directory = await getTemporaryDirectory();
//    return path.join(directory.path, key);
//  }
}
