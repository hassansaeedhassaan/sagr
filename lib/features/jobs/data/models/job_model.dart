import '../../domain/entities/job.dart';

class JobModel extends Job {

  final int? id;

  final String? name;

  const JobModel({ this.id, this.name }) : super( id: id,name: name);
  
  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel( id: json['id'], name: json['name']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {'id': id,'name': name};
  }

  @override
  String toString() {
        return 'Job(id: $id, name: $name)';
  }
}