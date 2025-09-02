import 'package:equatable/equatable.dart';
import 'package:sagr/features/commissions/data/models/commission_model.dart';

class Commission extends Equatable {
  final int? id;
  final Advertisment? advertisement;
  final String? amount;
  final String? commission;
  final String? amount_after_commission;
  final String? currency;
  final String? is_paid;



  Commission({
    required this.id,
    required this.advertisement,
    this.amount,
    this.commission,
    this.amount_after_commission,
    this.currency,
    this.is_paid
  });
  

  @override
  List<Object?> get props => [
        id,
        advertisement,
        amount,
        commission,
        amount_after_commission,
        currency,
        is_paid
      ];
}
