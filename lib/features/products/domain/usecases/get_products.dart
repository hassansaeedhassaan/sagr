import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sagr/features/products/data/models/product_model.dart';
import 'package:sagr/features/products/domain/entities/product.dart';
import 'package:sagr/features/products/domain/repositories/products_repository.dart';
import 'package:sagr/models/pagination_filter.dart';

import '../../../../core/error/failures.dart';

class ProductUsecase {
  ProductsRepository repository;
  ProductUsecase(this.repository);

  Future<Either<Failure, List<Product>>> call(PaginationFilter filter) async {
    return await repository.getProducts(filter);
  }

  Future<Either<Failure, Product>> productInfo(int productId) async {
    return await repository.getProductInfo(productId);
  }

  Future<Either<Failure, List<Product>>> getRelatedAds(int productId) async {
    return await repository.getRelatedAds(productId);
  }

  Future<Either<Failure, ProductModel>> createAd(
      Map<String, dynamic> body, BuildContext context) async {
    return await repository.createAd(body,context);
  }

  Future<Either<Failure, ProductModel>> updateAd(
      Map<String, dynamic> body) async {
    return await repository.updateAd(body);
  }

    Future<Either<Failure, Response>> deleteAd(
      int adId, int mediaId) async {
    return await repository.deleteAd(adId, mediaId);
  }


}
