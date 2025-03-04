// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookHiveModelAdapter extends TypeAdapter<BookHiveModel> {
  @override
  final int typeId = 2;

  @override
  BookHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookHiveModel(
      id: fields[0] as String,
      title: fields[1] as String,
      genre: fields[2] as String,
      description: fields[3] as String,
      price: fields[4] as double,
      condition: fields[5] as String,
      delivery: fields[6] as bool,
      sellerId: fields[7] as String,
      sellerName: fields[8] as String,
      images: (fields[9] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, BookHiveModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.genre)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.condition)
      ..writeByte(6)
      ..write(obj.delivery)
      ..writeByte(7)
      ..write(obj.sellerId)
      ..writeByte(8)
      ..write(obj.sellerName)
      ..writeByte(9)
      ..write(obj.images);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
