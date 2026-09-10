import 'package:sagr/features/events/data/models/job_model.dart';
import 'package:sagr/features/events/data/models/period_model.dart';
import 'package:sagr/features/events/data/models/start_date_time_model.dart';

import '../../domain/entities/event.dart';
import 'application_info.dart';
import 'zone_coordinate_model.dart';

class EventModel extends Event {
  final int? id;

  final String? name;

  final String? description;

  final String? address;

  final String? logo;

  final String? datetime;

  final String? date;

  final String? time;

  final String? ago;

  final String? preparing;

  final List? periods;

  final String? appliedStatus;

  final String? nationalID;

  final String? location;

  final bool? assigned;
  final int? zone_id;
  final int? user_id;
  final bool? isCheckedIn;
  /// Organisation running the event, shown on the details hero.
  final String? companyName;

  final ChannelInfo? channel;
  final ChannelInfo? supervisorChannel;
  final List<ZoneCoordinates>? zoneCoordinates;
  final List<JobModel>? jobs;

  final String? userType;

  final String? attachment;


  final StartDateTimeModel? startDateTime;

  /// The caller's latest application (status tracker); null on servers
  /// that don't send the `application` block yet.
  final ApplicationInfo? application;

  const EventModel(
      {this.id,
      this.name,
      this.description,
      this.logo,
      this.datetime,
      this.date,
      this.time,
      this.address,
      this.ago,
      this.preparing,
      this.appliedStatus,
      this.nationalID,
      this.periods,
      this.startDateTime,
      this.assigned,
      this.companyName,
      this.channel,
      this.attachment,
      this.supervisorChannel,
      this.zoneCoordinates,
      this.jobs,
      this.location,
      this.zone_id,
      this.user_id,
      this.isCheckedIn,
      this.userType,
      this.application})
      : super(
            id: id,
            name: name,
            description: description,
            logo: logo,
            datetime: datetime,
            date: date,
            time: time,
            address: address,
            ago: ago,
            preparing: preparing,
            appliedStatus: appliedStatus,
            nationalID: nationalID,
            periods: periods);

  factory EventModel.fromJson(Map<String, dynamic> json) {
    List<PeriodModel> periodsResults = [];

    if (json['periods'] != null) {
      json['periods'].forEach((child) {
        periodsResults.add(PeriodModel.fromMap(child));
      });
    }

    return EventModel(
      id: json['id'],
      name: json['name'] ?? "",
      description: json['description'],
      logo: json['logo'],
      datetime: json['datetime'],
      date: json['date'],
      time: json['time'],
      address: json['address'],
      location: json['location'],
      ago: json['ago'],
      preparing: json['preparing'],
      appliedStatus: json['appliedStatus'] ?? 'undefined',
      nationalID: json['nationalID'] ?? '',
      periods: periodsResults,
      zone_id: json['zone_id'],
      user_id: json['user_id'],
      attachment: json['attachment']??"undefined",
      isCheckedIn: json['isCheckIn'] ?? false,
      startDateTime: StartDateTimeModel.fromJson(json['startDateTime']),
      assigned: json['assigned'] ?? false,
      userType: json['userType'] ?? "employee",
      application: json['application'] is Map
          ? ApplicationInfo.fromJson(
              Map<String, dynamic>.from(json['application'] as Map))
          : null,
      companyName: json['company'] is Map
          ? json['company']['name']?.toString()
          : null,
      channel: json['channel'] != null
          ? ChannelInfo.fromJson(json['channel'])
          : null,
      supervisorChannel: json.containsKey('supervisorChannel') &&
              json['supervisorChannel'] != null
          ? ChannelInfo.fromJson(json['supervisorChannel'])
          : null,
      zoneCoordinates:
          json.containsKey('coordinates') && json['coordinates'] != null
              ? (json['coordinates'] as List)
                  .map((item) => ZoneCoordinates.fromJson(item))
                  .toList()
              : null,


       jobs:
          json.containsKey('jobs') && json['jobs'] != null
              ? (json['jobs'] as List)
                  .map((item) => JobModel.fromJson(item))
                  .toList()
              : null,

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
      'location': location,
      'ago': ago,
      'preparing': preparing,
      'periods': periods,
      'appliedStatus': appliedStatus,
      'nationalID': nationalID,
      'startDateTime': startDateTime,
      'assigned': assigned,
      'companyName': companyName,
      'channel': channel?.toJson(),
      'supervisorChannel': supervisorChannel?.toJson(),
      'zoneCoordinates': zoneCoordinates,
      'zone_id': zone_id,
      'user_id': user_id,
      'attachment': attachment,
      'jobs': jobs,
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

// import 'package:sagr/features/events/data/models/period_model.dart';
// import '../../domain/entities/event.dart';

// class EventModel extends Event {
//   const EventModel({
//     super.id,
//     super.name,
//     super.description,
//     super.address,
//     super.logo,
//     super.datetime,
//     super.date,
//     super.time,
//     super.ago,
//     super.preparing,
//     super.appliedStatus = null,
//     List<PeriodModel> super.periods = const [],
//   });

//   factory EventModel.fromJson(Map<String, dynamic> json) {
//     return EventModel(
//       id: json['id'],
//       name: json['name'] ?? '',
//       description: json['description'],
//       logo: json['logo'],
//       datetime: json['datetime'],
//       date: json['date'],
//       time: json['time'],
//       address: json['address'],
//       ago: json['ago'],
//       preparing: json['preparing'],
//       appliedStatus: json['appliedStatus'] ?? 'undefined',
//       periods: (json['periods'] as List<dynamic>?)
//               ?.map((e) => PeriodModel.fromMap(e))
//               .toList() ??
//           [],
//     );
//   }

//   @override
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'description': description,
//       'logo': logo,
//       'datetime': datetime,
//       'date': date,
//       'time': time,
//       'address': address,
//       'ago': ago,
//       'preparing': preparing,
//       'appliedStatus': appliedStatus,
//       'periods': periods!.map((e) => e.toJson()).toList(),
//     };
//   }

//   @override
//   String toString() => name ?? '';
// }
