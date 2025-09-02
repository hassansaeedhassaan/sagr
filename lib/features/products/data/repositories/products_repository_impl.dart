import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sagr/core/error/exceptions.dart';
import 'package:sagr/features/products/data/models/product_model.dart';
import 'package:sagr/features/products/domain/entities/product.dart';

import 'package:sagr/core/error/failures.dart';

import 'package:dartz/dartz.dart';

import '../../domain/repositories/products_repository.dart';

import '../datasources/product_data_source.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  
  final ProductDataSource productDataSource;

  ProductsRepositoryImpl(this.productDataSource);

  @override
  Future<Either<Failure, List<Product>>> getProducts(filter) async {
    try {
      final productsData = await productDataSource.getProducts(filter);
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
  
  @override
  Future<Either<Failure, Product>> getProductInfo(productId) async{
   try {
      final productsData = await productDataSource.getProductInfo(productId);
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

   @override
  Future<Either<Failure, List<Product>>> getRelatedAds(productId) async {
    try {
      final productsData = await productDataSource.getRelatedAds(productId);
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

   Future<Either<Failure, ProductModel>> createAd(Map<String, dynamic> body, BuildContext context) async {
    try {
      final productsData = await productDataSource.createAd(body, context);
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, ProductModel>> updateAd(Map<String, dynamic> body) async{
   try {
      final productsData = await productDataSource.updateAd(body);
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
  
  @override
  Future<Either<Failure, Response>> deleteAd(int adId, int mediaId) async {
 try {
      final productsData = await productDataSource.deleteAd(adId, mediaId);
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
 