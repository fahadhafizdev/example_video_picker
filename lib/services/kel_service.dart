import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vidio_upload/services/kel_log.dart';

class KelService {
  Future<dynamic> request({
    required String title,
    required String url,
    required Method method,
    bool withToken = true,
    Map<String, dynamic> params = const {},
    Map<String, dynamic> queryParameters = const {},
    bool isMultipart = false,
    Map<String, dynamic>? headers,
    bool isCustomHeader = false,
  }) async {
    late Response response;
    Dio dio = Dio();
    late String token;

    try {
      //NOTE : CHECK WITH TOKEN

      if (withToken) {
        token = '';

        dio = Dio(
          BaseOptions(
            contentType: isMultipart ? null : Headers.jsonContentType,
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );
      } else if (isCustomHeader) {
        dio = Dio(
          BaseOptions(
            contentType: isMultipart ? null : Headers.jsonContentType,
            headers: headers,
          ),
        );
      } else {
        token = '';
        dio = Dio(
          BaseOptions(
            contentType: Headers.jsonContentType,
          ),
        );
      }

      //NOTE : CHECK MULTIPART FOR IMAGE
      dynamic value =
          isMultipart ? await formData(params: params) : jsonEncode(params);

      //NOTE : CHECK METHOD API
      if (method == Method.GET) {
        response = await dio.get(
          url,
          queryParameters: queryParameters,
        );
      } else if (method == Method.POST) {
        response = await dio.post(
          url,
          data: value,
          queryParameters: queryParameters,
        );
      } else if (method == Method.DELETE) {
        response = await dio.delete(
          url,
          queryParameters: queryParameters,
        );
      } else if (method == Method.PUT) {
        response = await dio.put(
          url,
          data: value,
          queryParameters: queryParameters,
        );
      }

      //NOTE : CHECK RESPONSE STATUS
      KelLog().logPrint(title: title, data: response.data);

      if (response.statusCode == 200) {
        return response.data;
      } else if (response.statusCode == 204) {
        return response.data;
      }
    } on DioError catch (e) {
      debugPrint('dio error ${e.type}');

      String message =
          e.response == null ? '' : e.response!.data['message'] ?? '';

      //print error
      KelLog().logPrint(title: title, data: message);

      throw Exception(e.response!.data);
    }
  }

  Future<FormData> formData({required Map<String, dynamic> params}) async {
    return FormData.fromMap(params);
  }
}

enum Method { POST, GET, DELETE, PUT }
