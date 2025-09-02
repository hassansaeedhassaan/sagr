import 'package:equatable/equatable.dart';

class Wallet extends Equatable {

  final String? balance;
  final String? currency;



  Wallet({
    this.balance,
    this.currency
   
  });
  

  @override
  List<Object?> get props => [
        balance,
        currency
      ];
}
