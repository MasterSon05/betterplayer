import 'package:better_player/src/core/better_player_utils.dart';
import 'package:better_player/src/dash/better_player_dash_utils.dart';
import 'package:better_player/src/hls/better_player_hls_utils.dart';
import 'package:dio/dio.dart';

import 'better_player_asms_data_holder.dart';

///Base helper class for ASMS parsing.
class BetterPlayerAsmsUtils {
  static const String _hlsExtension = "m3u8";
  static const String _dashExtension = "mpd";

  ///Check if given url is HLS / DASH-type data source.
  static bool isDataSourceAsms(String url) =>
      isDataSourceHls(url) || isDataSourceDash(url);

  ///Check if given url is HLS-type data source.
  static bool isDataSourceHls(String url) => url.contains(_hlsExtension);

  ///Check if given url is DASH-type data source.
  static bool isDataSourceDash(String url) => url.contains(_dashExtension);

  ///Parse playlist based on type of stream.
  static Future<BetterPlayerAsmsDataHolder> parse(
      String data, String masterPlaylistUrl) async {
    return isDataSourceDash(masterPlaylistUrl)
        ? BetterPlayerDashUtils.parse(data, masterPlaylistUrl)
        : BetterPlayerHlsUtils.parse(data, masterPlaylistUrl);
  }

  ///Request data from given uri along with headers. May return null if resource
  ///is not available or on error.
  static Future<String?> getDataFromUrl(
    String url, [
    Map<String, String?>? headers,
  ]) async {
    try {
      var response = await Dio()
          .get(url, options: Options(headers: headers, receiveTimeout: 5000));
      return response.data;
    } catch (exception) {
      BetterPlayerUtils.log("GetDataFromUrl failed: $exception");
      return null;
    }
  }
}
