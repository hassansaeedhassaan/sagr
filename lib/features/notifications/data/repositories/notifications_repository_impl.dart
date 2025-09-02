import 'package:sagr/core/error/exceptions.dart';
import 'package:sagr/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:sagr/features/notifications/data/models/notification_model.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasource/notifications_data_source.dart';

class NotificationsRepositoryImpl implements NotificationRepository {
  final NotificationsDataSource notificationsDataSource;

  NotificationsRepositoryImpl(this.notificationsDataSource);

  @override
  Future<Either<Failure, List<NotificationModel>>> getNotificationsList(filter) async {
    try {
      final productsData = await notificationsDataSource.getNotificationsList(filter);
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }



  // @override
  // Future<Either<Failure, Response>> payAllCommissions(
  //     String paymentMethod) async {
  //   try {
  //     final productsData =
  //         await commissionsDataSource.payAllCommissions(paymentMethod);
  //     return Right(productsData);
  //   } on ServerException {
  //     return Left(ServerFailure());
  //   } on NotFoundException catch (e) {
      
  //     return Left(NotFoundFailure(data: e.data));
  //   }
  // }
}
