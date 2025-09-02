import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sagr/features/chat/data/models/conversation_model.dart';
import 'package:sagr/features/chat/data/models/message_model.dart';
import 'package:sagr/models/pagination_filter.dart';

import '../../../../core/error/failures.dart';
import '../repositories/conversations_repository.dart';

class ConversationUsecase {
  
  ConversationsRepository conversationsRepository;

  ConversationUsecase(this.conversationsRepository);

  /// Get list of conversions
  /// @params PaginationFilter
  /// return Array List of converstions (ConversationModel )
  Future<Either<Failure, List<ConversationModel>>> call(
      PaginationFilter filter) async {
    return await conversationsRepository.getConversations(filter);
  }


  /**
   * Get list of messages.
   * @params PaginationFilter AND conversationId
   * return Array List of messages (MessageModel )
   */

  Future<Either<Failure, List<MessageModel>>> getMessages(
      int conversationId, PaginationFilter filter) async {
    return await conversationsRepository.getMessages(conversationId, filter);
  }


  /**
   * Send Message Func.
   * @params Map of <dynamic, string> 
   * return MessageModel as response.
   */
  Future<Either<Failure, Response>> sendMessage(
      Map<String, dynamic> body, BuildContext context) async {
    return await conversationsRepository.sendMessage(body, context);
  }
  /**
   * Send Message Func.
   * @params Map of <dynamic, string> 
   * return MessageModel as response.
   */
  Future<Either<Failure, Response>> updateOfferStatus(
      Map<String, dynamic> body, BuildContext context) async {
    return await conversationsRepository.updateOfferStatus(body, context);
  }

  /**
   * Send Message Func.
   * @params Map of <dynamic, string> 
   * return MessageModel as response.
   */
  Future<Either<Failure, Response>> openChat(
      int adId, BuildContext context) async {
        
    return await conversationsRepository.openChat(adId, context);
  }


    /**
   * Send Message Func.
   * @params Map of <dynamic, string> 
   * return MessageModel as response.
   */
  Future<Either<Failure, Response>> sendOffer(
      int adId,String offerPrice, BuildContext context) async {
        
    return await conversationsRepository.sendOffer(adId,offerPrice, context);
  }
}
