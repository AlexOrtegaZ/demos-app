import 'package:demos_app/constans/api_path.dart';
import 'package:demos_app/core/models/data_event.model.dart';

import 'api.dart';

class CacheApi {
  static final CacheApi _cacheApi = CacheApi._internal();
  CacheApi._internal();

  factory CacheApi() {
    return _cacheApi;
  }

  Future<List<DataEvent>> getCache(String? lastUpdatedDate) async {
    String endpoint = ApiPath().getGetCachePath();

    Object params = {
      "lastUpdatedDate": lastUpdatedDate ?? ''
    };

    final List httpResponse  = await Api.post(endpoint, params);

    final events = httpResponse.map((event) => DataEvent.fromObject(event)).toList();

    return events;
  }
}