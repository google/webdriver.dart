// Copyright 2022 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:convert';

import 'package:archive/archive_io.dart' as archive;
import 'package:test/test.dart';
import 'package:webdriver/src/common/zip.dart';

void main() {
  group('zip', () {
    test('decode', () {
      final zipData = base64.decode(testZipBase64);
      final zipArchive = archive.ZipDecoder().decodeBytes(zipData);

      expect(zipArchive.files, hasLength(2));

      var file = zipArchive.files[0];
      expect(file.name, 'dart_test.yaml');
      expect(file.size, 166);
      expect(utf8.decode(file.content as List<int>),
          contains('See https://github.com/dart-lang/test/'));

      file = zipArchive.files[1];
      expect(file.name, 'lib/src/common/spec.dart');
      expect(file.size, 209);
      expect(utf8.decode(file.content as List<int>),
          contains('Defines the WebDriver spec to use'));
    });

    test('round-trip', () {
      final zipArchive = Archive();
      const aaaContents = 'aaa';
      const bbbContents = 'bbb';
      final cccContents = 'c' * 1024;

      zipArchive.addFile(ArchiveFile('aaa.txt', utf8.encode(aaaContents)));
      zipArchive.addFile(ArchiveFile('bbb.txt', utf8.encode(bbbContents)));
      zipArchive.addFile(ArchiveFile('ccc/ccc.txt', utf8.encode(cccContents)));

      final zipBytes = ZipEncoder.encode(zipArchive);

      expect(zipBytes, isNotEmpty);

      final decodedArchive = archive.ZipDecoder().decodeBytes(zipBytes);
      expect(decodedArchive.files, hasLength(3));

      var file = zipArchive.files[0];
      expect(file.name, 'aaa.txt');
      expect(file.length, 3);
      expect(utf8.decode(file.content), equals('aaa'));

      file = zipArchive.files[1];
      expect(file.name, 'bbb.txt');
      expect(file.length, 3);
      expect(utf8.decode(file.content), equals('bbb'));

      file = zipArchive.files[2];
      expect(file.name, 'ccc/ccc.txt');
      expect(file.length, 1024);
      expect(utf8.decode(file.content), contains('cccccccccccccc'));
    });
  });

  group('crc32', () {
    test('0 bytes', () {
      expect(crc32([]), 0x00000000);
    });

    test('1 byte', () {
      expect(crc32([0x00]), 0xD202EF8D);
    });

    test('1 byte redux', () {
      expect(crc32([0x01]), 0xA505DF1B);
    });

    test('2 bytes', () {
      expect(crc32([0x01, 0x02]), 0xB6CC4292);
    });

    test('test string', () {
      expect(crc32(utf8.encode('My very long test string.')), 0x88B8252E);
    });
  });
}

const testZipBase64 =
    'UEsDBAoAAAAAALw2alV+3V8lpgAAAKYAAAAOABwAZGFydF90ZXN0LnlhbWxVVAkAA4QQbWOEEG'
    '1jdXgLAAEE9QEAAAQUAAAAIyBTZWUgaHR0cHM6Ly9naXRodWIuY29tL2RhcnQtbGFuZy90ZXN0'
    'L2Jsb2IvbWFzdGVyL3BrZ3MvdGVzdC9kb2MvY29uZmlndXJhdGlvbi5tZAp0YWdzOgogIGZmOi'
    'AjIHRlc3RzIHRoYXQgcnVuIG9uIEZpcmVmb3guIE90aGVycyB0ZXN0cyBhcmUgYXNzdW1lZCB0'
    'byBydW4gb24gQ2hyb21lClBLAwQKAAAAAAC8NmpVezD5KdEAAADRAAAAGAAcAGxpYi9zcmMvY2'
    '9tbW9uL3NwZWMuZGFydFVUCQADhBBtY4QQbWN1eAsAAQT1AQAABBQAAAAvLyBpZ25vcmVfZm9y'
    'X2ZpbGU6IGNvbnN0YW50X2lkZW50aWZpZXJfbmFtZXMKCi8vLyBEZWZpbmVzIHRoZSBXZWJEcm'
    'l2ZXIgc3BlYyB0byB1c2UuIEF1dG8gPSB0cnkgdG8gaW5mZXIgdGhlIHNwZWMgYmFzZWQgb24K'
    'Ly8vIHRoZSByZXNwb25zZSBkdXJpbmcgc2Vzc2lvbiBjcmVhdGlvbi4KZW51bSBXZWJEcml2ZX'
    'JTcGVjIHsgQXV0bywgSnNvbldpcmUsIFczYyB9ClBLAQIeAwoAAAAAALw2alV+3V8lpgAAAKYA'
    'AAAOABgAAAAAAAAAAACkgQAAAABkYXJ0X3Rlc3QueWFtbFVUBQADhBBtY3V4CwABBPUBAAAEFA'
    'AAAFBLAQIeAwoAAAAAALw2alV7MPkp0QAAANEAAAAYABgAAAAAAAAAAACkge4AAABsaWIvc3Jj'
    'L2NvbW1vbi9zcGVjLmRhcnRVVAUAA4QQbWN1eAsAAQT1AQAABBQAAABQSwUGAAAAAAIAAgCyAA'
    'AAEQIAAAAA';
