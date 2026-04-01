import 'dart:io';

void main() async {
  final csvFile = File('J:\\ziwei_core_v2\\ok_geo.csv');
  final lines = await csvFile.readAsLines();

  final areas = <Map<String, dynamic>>[];

  for (var i = 1; i < lines.length; i++) {
    final line = lines[i];
    final parts = _parseCsvLine(line);

    if (parts.length < 6) continue;

    final id = int.tryParse(parts[0]);
    final pid = int.tryParse(parts[1]);
    final deep = int.tryParse(parts[2]);
    if (id == null || pid == null || deep == null || deep > 2) continue;

    final name = parts[3].replaceAll('"', '');
    final geo = parts[5].replaceAll('"', '');
    final geoParts = geo.split(' ');
    if (geoParts.length != 2) continue;

    final lon = double.tryParse(geoParts[0]);
    final lat = double.tryParse(geoParts[1]);
    if (lon == null || lat == null) continue;

    final lonInt = ((lon - 73.0) * 1000).round();
    final latInt = ((lat - 16.0) * 1000).round();
    if (lonInt < 0 || lonInt > 65535 || latInt < 0 || latInt > 65535) continue;

    areas.add({
      'id': id,
      'pid': pid,
      'deep': deep,
      'name': name,
      'geo': (lonInt << 16) | latInt,
    });
  }

  final output = StringBuffer();
  output.writeln('// Generated file - do not edit manually');
  output.writeln('// Total areas: ${areas.length}');
  output.writeln();
  output.writeln('class AreaData {');
  output.writeln('  final int id;');
  output.writeln('  final int pid;');
  output.writeln('  final int deep;');
  output.writeln('  final String name;');
  output.writeln('  final int geoInt;');
  output.writeln();
  output.writeln('  const AreaData(this.id, this.pid, this.deep, this.name, this.geoInt);');
  output.writeln();
  output.writeln('  double get longitude => ((geoInt >> 16) & 0xFFFF) / 1000.0 + 73.0;');
  output.writeln('  double get latitude => (geoInt & 0xFFFF) / 1000.0 + 16.0;');
  output.writeln('}');
  output.writeln();
  output.writeln('const areas = <AreaData>[');

  for (final area in areas) {
    output.writeln(
      '  AreaData(${area['id']}, ${area['pid']}, ${area['deep']}, "${area['name']}", ${area['geo']}),',
    );
  }

  output.writeln('];');

  final outFile = File('J:\\ziwei_core_v2\\opendestiny-flutter\\lib\\data\\cities.dart');
  await outFile.parent.create(recursive: true);
  await outFile.writeAsString(output.toString());
}

List<String> _parseCsvLine(String line) {
  final result = <String>[];
  var current = StringBuffer();
  var inQuotes = false;

  for (var i = 0; i < line.length; i++) {
    final char = line[i];
    if (char == '"') {
      inQuotes = !inQuotes;
      current.write(char);
    } else if (char == ',' && !inQuotes) {
      result.add(current.toString());
      current = StringBuffer();
    } else {
      current.write(char);
    }
  }

  result.add(current.toString());
  return result;
}
