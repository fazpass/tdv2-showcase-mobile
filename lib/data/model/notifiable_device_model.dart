
import 'package:tdv2_showcase_mobile/domain/entity/notifiable_device.dart';

class NotifiableDeviceModel {
  final String id;
  final String name;
  final String os_version;
  final String series;
  final String cpu;

  NotifiableDeviceModel._(this.id, this.name, this.os_version, this.series, this.cpu);

  factory NotifiableDeviceModel.fromJson(dynamic json) => NotifiableDeviceModel._(
      json['id'], json['name'], json['os_version'], json['series'], json['cpu']);

  NotifiableDevice toEntity() => NotifiableDevice(id, name, os_version, series, cpu);
}