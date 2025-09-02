import 'package:dio/src/response.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sagr/core/error/exceptions.dart';
import 'package:sagr/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:sagr/features/chat/data/datasource/conversations_data_source.dart';
import 'package:sagr/features/chat/data/models/conversation_model.dart';
import 'package:sagr/features/chat/data/models/message_model.dart';
import 'package:sagr/features/chat/domain/repositories/conversations_repository.dart';
import 'package:sagr/models/pagination_filter.dart';

class ConversationsRepositoryImpl implements ConversationsRepository {
  final ConversationDataSource conversationDataSource;

  ConversationsRepositoryImpl(this.conversationDataSource);

  @override
  Future<Either<Failure, List<ConversationModel>>> getConversations(filter) async {
    try {
      final conversationsData = await conversationDataSource.getConversations(filter);
      return Right(conversationsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<MessageModel>>> getMessages(int conversationId, PaginationFilter filter) async{
    try {
      final conversationsData = await conversationDataSource.getMessages(conversationId, filter);
      return Right(conversationsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }



     Future<Either<Failure, Response>> sendMessage(Map<String, dynamic> body, BuildContext context) async {
    try {
      final productsData = await conversationDataSource.sendMessage(body, context);
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
  
  @override
  Future<Either<Failure, Response>> openChat(int adId, BuildContext context) async{
      try {
      final productsData = await conversationDataSource.openChat(adId, context);
      print(productsData);
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
  
  @override
  Future<Either<Failure, Response>> sendOffer(int adId, String offerPrice, BuildContext context) async{
     try {
      final productsData = await conversationDataSource.sendOffer(adId, offerPrice, context);
      print(productsData);
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
  
  @override
  Future<Either<Failure, Response>> updateOfferStatus(Map<String, dynamic> body, BuildContext context) async {
   try {
      final productsData = await conversationDataSource.updateOfferStatus(body, context);
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
