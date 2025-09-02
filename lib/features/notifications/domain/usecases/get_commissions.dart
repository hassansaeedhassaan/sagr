import 'package:dartz/dartz.dart';
import 'package:sagr/features/notifications/data/models/notification_model.dart';
import 'package:sagr/models/pagination_filter.dart';

import '../../../../core/error/failures.dart';
import '../repositories/notifications_repository.dart';

class NotificationsUsecase {
  
  NotificationRepository notificationRepository;
  
  NotificationsUsecase(this.notificationRepository);

  Future<Either<Failure, List<NotificationModel>>> call(
      PaginationFilter filter) async {
    return await notificationRepository.getNotificationsList(filter);
  }

  // Future<Either<Failure, Response>> payAllCommissions(
  //     String paymentMethod) async {
  //   return await commissionsRepository.payAllCommissions(paymentMethod);
  // }

}
