import '../../domain/entities/wallet.dart';

class WalletModel extends Wallet {
  WalletModel(
      {
      String? balance,
      String? currency,
      })
      : super(
            balance: balance,
            currency: currency,
            );

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
        balance: json['balance'],
        currency: json['currency'],
      );
  }

  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
      'currency': currency
    };
  }
}
