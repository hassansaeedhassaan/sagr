import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sagr/features/products/data/models/product_model.dart';
import 'package:sagr/features/products/domain/entities/product.dart';
import 'package:sagr/models/pagination_filter.dart';


import '../../../../core/error/failures.dart';

abstract class ProductsRepository{
  Future<Either<Failure, List<Product>>> getProducts(PaginationFilter filter);
  Future<Either<Failure, Product>> getProductInfo(int productId);
  Future<Either<Failure, List<Product>>> getRelatedAds(int productId);
  Future<Either<Failure, ProductModel>> createAd(Map<String, dynamic> body, BuildContext context);
  Future<Either<Failure, ProductModel>> updateAd(Map<String, dynamic> body);
  Future<Either<Failure, Response>> deleteAd(int adId, int mediaId);
}


