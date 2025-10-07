
import '../../domain/entities/ad.dart';

class AdModel extends Ad {
  final int? id;

  final String? name;

  final String? description;


  final String? logo;

  final String? datetime;

  final String? date;

  final String? time;



  const AdModel(
      {this.id,
      this.name,
      this.description,
      this.logo,
      this.datetime,
      this.date,
      this.time,
    })
      : super(
            id: id,
            name: name,
            description: description,
            logo: logo,
            datetime: datetime,
            date: date,
            time: time,
           );

  factory AdModel.fromJson(Map<String, dynamic> json) {


    return AdModel(
      id: json['id'],
      name: json['name'] ?? "",
      description: json['description'],
      logo: json['logo'],
      datetime: json['datetime'],
      date: json['date'],
      time: json['time'],
     
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'logo': logo,
      'datetime': datetime,
      'date': date,
      'time': time,
      'address': address,
      'ago': ago,
      'preparing': preparing,
      'periods': periods,
      'appliedStatus': appliedStatus,
      'nationalID': nationalID,
      
    };
  }

  @override
  String toString() {
    return name!;
  }
}

class ChannelInfo {
  final String channelName;
  final String agoraToken;
  String? displayName;

  ChannelInfo(
      {required this.channelName, required this.agoraToken, this.displayName});

  factory ChannelInfo.fromJson(Map<String, dynamic> json) {
    return ChannelInfo(
        channelName: json['channel_name'] ?? '',
        agoraToken: json['agora_token'] ?? '',
        displayName: json['channel_display_name']);
  }

  Map<String, dynamic> toJson() {
    return {
      'channel_name': channelName,
      'agora_token': agoraToken,
      'display_name': displayName,
    };
  }

  ChannelInfo copyWith({
    String? channelName,
    String? agoraToken,
    String? displayName,
  }) {
    return ChannelInfo(
        channelName: channelName ?? this.channelName,
        agoraToken: agoraToken ?? this.agoraToken,
        displayName: displayName ?? this.displayName);
  }

  @override
  String toString() {
    return 'ChannelInfo(channelName: $channelName, agoraToken: $agoraToken, DisplayName $displayName';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChannelInfo &&
        other.channelName == channelName &&
        other.agoraToken == agoraToken;
  }

  @override
  int get hashCode {
    return channelName.hashCode ^ agoraToken.hashCode;
  }
}
