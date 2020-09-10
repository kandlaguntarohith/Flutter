import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
import 'package:wallpaperapp/Response/PixelImageReponse.dart';

class PixelRespiratory {
  final _dio = Dio();
  final baseUrl = 'https://api.pexels.com/v1';
  final api = '563492ad6f917000010000012a00a13eb20d4e5bbfd70984630a990a';
  final curatedUrl = 'https://api.pexels.com/v1/curated';
  final searchUrl = 'https://api.pexels.com/v1/search';
  Future<PixelImageResponse> getCuratedImages([
    page = 1,
    // ignore: non_constant_identifier_names
    per_page = 20,
  ]) async {
    _dio.options.headers["Authorization"] = api;
    // print(page);
    var param = {
      'page': page,
      'per_page': per_page,
    };
    try {
      Response _response = await _dio.get(
        curatedUrl,
        queryParameters: param,
      );
      return PixelImageResponse.fromJson(_response.data);
    } catch (error, stackTrace) {
      print('Error Occured : $error stacktrace : $stackTrace');
      return PixelImageResponse.withError(error.toString());
    }
  }

  Future<PixelImageResponse> getSearchImages([
    page = 1,
    // ignore: invalid_required_optional_positional_param
    // ignore: non_constant_identifier_names
    per_page = 20,
    query = 'trending',
  ]) async {
    _dio.options.headers["Authorization"] = api;
    var param = {'page': page, 'per_page': per_page, 'query': query};
    try {
      Response _response = await _dio.get(
        searchUrl,
        queryParameters: param,
      );
      return PixelImageResponse.fromJson(_response.data);
    } catch (error, stackTrace) {
      print('Error Occured : $error stacktrace : $stackTrace');
      return PixelImageResponse.withError(error.toString());
    }
  }
}
