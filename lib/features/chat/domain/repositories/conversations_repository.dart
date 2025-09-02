import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sagr/features/chat/data/models/conversation_model.dart';
import 'package:sagr/features/chat/data/models/message_model.dart';
import 'package:sagr/models/pagination_filter.dart';

import '../../../../core/error/failures.dart';

abstract class ConversationsRepository {
  
  Future<Either<Failure, List<ConversationModel>>> getConversations(PaginationFilter filter);
  
  Future<Either<Failure, List<MessageModel>>> getMessages(int conversationId, PaginationFilter filter);

  Future<Either<Failure, Response>> sendMessage(Map<String, dynamic> body, BuildContext context);

  Future<Either<Failure, Response>> openChat(int adId, BuildContext context);
  
  Future<Either<Failure, Response>> sendOffer(int adId, String offerPrice, BuildContext context);

    Future<Either<Failure, Response>> updateOfferStatus(Map<String, dynamic> body, BuildContext context);


}
