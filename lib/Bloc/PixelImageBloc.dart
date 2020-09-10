import 'package:rxdart/rxdart.dart';
import 'package:wallpaperapp/Respiratory/PixelRespiratory.dart';
import 'package:wallpaperapp/Response/PixelImageReponse.dart';

class PixelImageBloc {
  PixelImageResponse _response;
  final BehaviorSubject<PixelImageResponse> _subject =
      BehaviorSubject<PixelImageResponse>();
  final PixelRespiratory _respiratory = PixelRespiratory();
  // ignore: non_constant_identifier_names
  getCuratedImages([int page = 1, per_page = 20]) async {
    PixelImageResponse _responseData =
        await _respiratory.getCuratedImages(page, per_page);
    if (page != 1)
      _response.images.addAll(_responseData.images); //
    else
      _response = _responseData;
    _subject.sink.add(_response);
  }

  dispose() async {
    _subject.value = null;
    await _subject.close();
  }

  drain() async {
    _subject.value = null;
    await _subject.drain();
  }

  getSearchImages(
      [int page = 1,
      // ignore: non_constant_identifier_names
      int per_page = 20,
      String query = 'trending']) async {
    PixelImageResponse _responseData =
        await _respiratory.getSearchImages(page, per_page, query);
    page == 1
        ? _response = _responseData
        : _response.images.addAll(_responseData.images); //

    _subject.sink.add(_response);
  }

  BehaviorSubject<PixelImageResponse> get subject => _subject;
}
