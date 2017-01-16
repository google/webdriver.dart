// Copyright 2017 Google Inc. All Rights Reserved.
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

library webdriver.transform_tests;

import 'dart:io';

void main(List<String> args) {
  String inExtension;
  String outExtension;
  String outDirectory;
  String srcsFile;

  // Stupid simple arg parsing.
  for (var arg in args.takeWhile((arg) => arg != '--')) {
    if (arg.startsWith('--in-extension=')) {
      inExtension = arg.split('=')[1];
    } else if (arg.startsWith('--out-extension=')) {
      outExtension = arg.split('=')[1];
    } else if (arg.startsWith('--out=')) {
      outDirectory = arg.split('=')[1];
    } else if (arg.startsWith('--srcs-file=')) {
      srcsFile = arg.split('=')[1];
    }
  }

  print('Parsed  --in-extension $inExtension');
  print('Parsed --out-extension $outExtension');
  print('Parsed           --out $outDirectory');
  print('Parsed     --srcs-file $srcsFile');

  String testUtilImport;
  for (var arg in args.skipWhile((arg) => arg != '--')) {
    if (arg.startsWith('--test_util_import=')) {
      testUtilImport = arg.split('=')[1];
    }
  }

  print('Parsed        --test_util_import $testUtilImport');

  var srcsList = new File(srcsFile).readAsLinesSync();
  var year = new DateTime.now().year;
  for (var srcFile in srcsList) {
    if (!srcFile.endsWith(inExtension)) {
      continue;
    }
    var outFile = '$outDirectory/$srcFile'
        .replaceFirst(new RegExp('$inExtension\$'), outExtension);

    var srcContents = new File(srcFile).readAsStringSync();
    srcContents = srcContents.replaceFirst('test_util.dart', '$testUtilImport');
    new File(outFile).writeAsString(srcContents);
  }
}
