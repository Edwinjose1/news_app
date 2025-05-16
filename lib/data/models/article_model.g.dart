// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArticleModelAdapter extends TypeAdapter<ArticleModel> {
  @override
  final int typeId = 0;

  @override
  ArticleModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ArticleModel(
      id: fields[0] as String?,
      source: fields[1] as String?,
      author: fields[2] as String?,
      title: fields[3] as String,
      description: fields[4] as String,
      url: fields[5] as String,
      urlToImage: fields[6] as String?,
      publishedDate: fields[7] as String,
      content: fields[8] as String?,
      isSynced: fields[9] as bool,
      lastUpdated: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ArticleModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.source)
      ..writeByte(2)
      ..write(obj.author)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.url)
      ..writeByte(6)
      ..write(obj.urlToImage)
      ..writeByte(7)
      ..write(obj.publishedDate)
      ..writeByte(8)
      ..write(obj.content)
      ..writeByte(9)
      ..write(obj.isSynced)
      ..writeByte(10)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArticleModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$ArticleModelToJson(ArticleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'source': instance.source,
      'author': instance.author,
      'title': instance.title,
      'description': instance.description,
      'url': instance.url,
      'urlToImage': instance.urlToImage,
      'publishedAt': instance.publishedDate,
      'content': instance.content,
      'isSynced': instance.isSynced,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
    };
