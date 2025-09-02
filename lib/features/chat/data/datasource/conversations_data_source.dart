import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sagr/features/chat/data/models/conversation_model.dart';
import 'package:sagr/features/chat/data/models/message_model.dart';
import 'package:sagr/helper/base_url.dart';
import 'package:sagr/models/pagination_filter.dart';
import 'package:dio/src/form_data.dart' as formData;
import 'package:dio/dio.dart' as dioHttp;
import '../../../../core/error/exceptions.dart';

abstract class ConversationDataSource {
  Future<List<ConversationModel>> getConversations(PaginationFilter filter);
  Future<List<MessageModel>> getMessages(
      int conversationId, PaginationFilter filter);
  Future<Response> payAllCommissions(String paymentMethod);

  Future<Response> sendMessage(Map<String, dynamic> body, BuildContext context);
  Future<Response> updateOfferStatus(Map<String, dynamic> body, BuildContext context);
  Future<Response> openChat(int adId, BuildContext context);
  Future<Response> sendOffer(int adId,String offerPrice, BuildContext context);
}

class ConversationDataSourceImpl extends ConversationDataSource {
  final Dio dio;

  ConversationDataSourceImpl({required this.dio});

  @override
  Future<List<ConversationModel>> getConversations(filter) async {
    var response = await dio.get(BASEURL + '/users/chat', queryParameters: {
      'page': filter.page,
      'limit': filter.limit,
      'search': filter.name
    });

    if (response.statusCode == 200) {
      final List<ConversationModel> conversations = response.data['data']
          .map<ConversationModel>(
              (jsonConvModel) => ConversationModel.fromJson(jsonConvModel))
          .toList();
      return conversations;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Response> payAllCommissions(String paymentMethod) async {
    try {
      var response = await dio
          .get(BASEURL + "/users/commissions/all/pay-${paymentMethod}");

      return response;
    } on DioException catch (e) {
      throw NotFoundException(e.response?.data);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<MessageModel>> getMessages(conversationId, filter) async {
    var response = await dio.get(
        BASEURL + '/users/chat/$conversationId/messages',
        queryParameters: {
          'page': filter.page,
          'limit': filter.limit,
          'search': filter.name
        });

    if (response.statusCode == 200) {
      final List<MessageModel> conversations = response.data['data']
          .map<MessageModel>(
              (jsonPostModel) => MessageModel.fromJson(jsonPostModel))
          .toList();
      return conversations;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Response> sendMessage(
      Map<String, dynamic> body, BuildContext context) async {
    try {
      // prepare to upload form
      dio.options.contentType = "multipart/form-data";

      formData.FormData preparedFormData = formData.FormData.fromMap(
          {'message': body['message'], 'chat_id': body['chat_id']});

      var response =
          await dio.post(BASEURL + '/users/chat/send', data: preparedFormData);

      return response;
    } on dioHttp.DioException catch (e) {
      print(e.response?.statusCode);
      // print(e.response?.data);

      throw ValidationException(e.response?.data);
    }
  }

  @override
  Future<Response> openChat(int adId, BuildContext context) async {
    try {
      // prepare to upload form

      var response = await dio.get(BASEURL + '/users/chat/start-chat/${adId}');

      return response;
    } on dioHttp.DioException catch (e) {
      print(e.response?.statusCode);
      print(e.response?.data);

      throw ServerException();
      // throw ValidationException(e.response?.data);
    }
  }

   @override
  Future<Response> sendOffer(int adId, String offerPrice, BuildContext context) async {
    try {
      // prepare to upload form

      Map<String, dynamic> body = {
        'offer': offerPrice
      };

      var response = await dio.post(BASEURL + '/users/advertisement/${adId}/offers', data: body);

      return response;
    } on dioHttp.DioException catch (e) {
      print(e.response?.statusCode);
      print(e.response?.data);

      throw ServerException();
      // throw ValidationException(e.response?.data);
    }
  }


   @override
  Future<Response> updateOfferStatus(
      Map<String, dynamic> body, BuildContext context) async {
    try {
    
    dio.options.headers['content-Type'] = 'application/x-www-form-urlencoded';
    
      var response =
          await dio.put(BASEURL + '/users/advertisement/${body['adId']}/offers/${body['offerId']}', data: {'status': body['status']});

      return response;

    } on dioHttp.DioException catch (e) {
   
    
      throw ValidationException(e.response?.data);
    }
  }
}
