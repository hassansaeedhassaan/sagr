import 'package:dartz/dartz.dart';
import 'package:sagr/features/notifications/data/models/notification_model.dart';
import 'package:sagr/models/pagination_filter.dart';

import '../../../../core/error/failures.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<NotificationModel>>> getNotificationsList(PaginationFilter filter);
}
