import 'package:dio/dio.dart';
import 'package:flutter_test_assignment/data/models/beer_model.dart';

class PexelsApi {
  // Private keys should not be in the source code, but this is only a demo.
  final _apiKey = 'nIei1AgjiUXmBN83cz2mIwInlcfFqlVN7HVU3rsayWfw96JI2JPNhb79';

  final Dio dio;

  PexelsApi(this.dio);

  factory PexelsApi.withDefaultOptions() {
    return PexelsApi(
      Dio(
        BaseOptions(
          baseUrl: 'https://api.pexels.com/v1',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 5),
        ),
      ),
    );
  }

  Future<List<BeerModel>> fetchFeed(int page, int perPage) async {
    final response = await dio.get(
      '/curated',
      queryParameters: {"page": page, "per_page": perPage},
      options: Options(
        headers: {"Authorization": _apiKey},
      ),
    );
    return List<BeerModel>.from(
      response.data["photos"].map((value) {
        final String alt = value["alt"];
        return BeerModel(
          value["photographer"],
          alt.isEmpty ? "Empty" : alt,
          value["src"]["small"],
        );
      }),
    );
  }
}
