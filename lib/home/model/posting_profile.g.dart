// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posting_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Posting_profile _$Posting_profileFromJson(Map<String, dynamic> json) {
  return Posting_profile(
    status: json['status'] as int,
    error: json['error'] as bool,
    keterangan: json['keterangan'] as String,
    data: (json['data'] as List)
        ?.map(
            (e) => e == null ? null : Data.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$Posting_profileToJson(Posting_profile instance) =>
    <String, dynamic>{
      'status': instance.status,
      'error': instance.error,
      'keterangan': instance.keterangan,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
    id_post_profile: json['id_post_profile'] as String,
    id_profile: json['id_profile'] as String,
    description: json['description'] as String,
    foto: json['foto'] as String,
    privasi_post: json['privasi_post'] as String,
    created: json['created'] as String,
    updated: json['updated'] as String,
  );
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'id_post_profile': instance.id_post_profile,
      'id_profile': instance.id_profile,
      'description': instance.description,
      'foto': instance.foto,
      'privasi_post': instance.privasi_post,
      'created': instance.created,
      'updated': instance.updated,
    };
