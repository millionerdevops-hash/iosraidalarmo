import 'dart:typed_data';
import 'dart:convert';

class ProtoWriter {
  final BytesBuilder _builder = BytesBuilder();

  void writeVarint(int value) {
    while (value > 127) {
      _builder.addByte((value & 0x7F) | 0x80);
      value >>= 7;
    }
    _builder.addByte(value);
  }

  void writeTag(int fieldNumber, int wireType) {
    writeVarint((fieldNumber << 3) | wireType);
  }

  void writeInt32(int fieldNumber, int value) {
    writeTag(fieldNumber, 0); // WireType.varint
    writeVarint(value);
  }

  void writeInt64(int fieldNumber, int value) {
    writeTag(fieldNumber, 0); // WireType.varint
    writeVarint(value); // Dart ints are 64-bit
  }

  void writeBool(int fieldNumber, bool value) {
    writeTag(fieldNumber, 0);
    writeVarint(value ? 1 : 0);
  }

  void writeString(int fieldNumber, String value) {
    final bytes = utf8.encode(value);
    writeTag(fieldNumber, 2); // WireType.lengthDelimited
    writeVarint(bytes.length);
    _builder.add(bytes);
  }

  void writeBytes(int fieldNumber, List<int> value) {
    writeTag(fieldNumber, 2);
    writeVarint(value.length);
    _builder.add(value);
  }

  // Nested message support
  void writeMessage(int fieldNumber, List<int> messageBytes) {
    writeTag(fieldNumber, 2); // WireType.lengthDelimited
    writeVarint(messageBytes.length);
    _builder.add(messageBytes);
  }

  List<int> toBytes() => _builder.toBytes();
}

class ProtoReader {
  final Uint8List _buffer;
  int _offset = 0;

  ProtoReader(List<int> buffer) : _buffer = Uint8List.fromList(buffer);

  bool get isAtEnd => _offset >= _buffer.length;

  int readTag() {
    if (isAtEnd) return 0;
    return readVarint();
  }

  int getFieldNumber(int tag) => tag >> 3;
  int getWireType(int tag) => tag & 0x07;

  int readVarint() {
    int value = 0;
    int shift = 0;
    while (_offset < _buffer.length) {
      final byte = _buffer[_offset++];
      value |= (byte & 0x7F) << shift;
      if ((byte & 0x80) == 0) return value;
      shift += 7;
    }
    throw Exception("Truncated varint");
  }

  int readInt64() {
    // Dart ints handles 64-bit naturally, but let's treat same as varint for now
    // Since basic varint reading supports up to 64 bits logic
    return readVarint();
  }
  
  // Fixed64 is 8 bytes little endian
  int readFixed64() {
    if (_offset + 8 > _buffer.length) throw Exception("Truncated fixed64");
    final value = ByteData.sublistView(_buffer, _offset, _offset + 8).getUint64(0, Endian.little);
    _offset += 8;
    return value;
  }

  String readString() {
    final length = readVarint();
    if (_offset + length > _buffer.length) throw Exception("Truncated string");
    final str = utf8.decode(_buffer.sublist(_offset, _offset + length));
    _offset += length;
    return str;
  }

  Uint8List readBytes() {
    final length = readVarint();
    if (_offset + length > _buffer.length) throw Exception("Truncated bytes");
    final bytes = _buffer.sublist(_offset, _offset + length);
    _offset += length;
    return bytes;
  }

  void skipField(int tag) {
    final wireType = getWireType(tag);
    switch (wireType) {
      case 0: // Varint
        readVarint();
        break;
      case 1: // 64-bit
        _offset += 8;
        break;
      case 2: // Length-delimited
        final length = readVarint();
        _offset += length;
        break;
      case 5: // 32-bit
        _offset += 4;
        break;
      default:
        throw Exception("Unsupported wire type: $wireType");
    }
  }
}
