// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library test.runner.loader;

import 'dart:async';
import 'dart:io';

import 'package:analyzer/analyzer.dart';
import 'package:path/path.dart' as p;

import 'package:test/src/backend/invoker.dart';
import 'package:test/src/backend/metadata.dart';
import 'package:test/src/backend/suite.dart';
import 'package:test/src/backend/test_platform.dart';
import 'package:test/src/util/io.dart';
import 'package:test/src/util/isolate_wrapper.dart';
import 'package:test/src/utils.dart';
import 'server.dart';
import 'package:test/src/runner/load_exception.dart';
import 'package:test/src/runner/parse_metadata.dart';

/// A class for finding test files and loading them into a runnable form.
class Loader {
  /// All platforms for which tests should be loaded.
  final List<TestPlatform> _platforms;

  /// Whether to enable colors for Dart compilation.
  final bool _color;

  /// The root directory that will be served for browser tests.
  final String _root;

  /// The package root to use for loading tests.
  final String _packageRoot;

  /// The URL for the `pub serve` instance to use to load tests.
  ///
  /// This is `null` if tests should be loaded from the filesystem.
  final Uri _pubServeUrl;

  /// All isolates that have been spun up by the loader.
  final _isolates = new Set<IsolateWrapper>();

  final String _configDir;

  /// The server that serves browser test pages.
  ///
  /// This is lazily initialized the first time it's accessed.
  Future<BrowserServer> get _browserServer {
    if (_browserServerCompleter == null) {
      _browserServerCompleter = new Completer();
      BrowserServer
          .start(
              root: _root,
              packageRoot: _packageRoot,
              pubServeUrl: _pubServeUrl,
              color: _color,
              configDir: _configDir)
          .then(_browserServerCompleter.complete)
          .catchError(_browserServerCompleter.completeError);
    }
    return _browserServerCompleter.future;
  }
  Completer<BrowserServer> _browserServerCompleter;

  /// Creates a new loader.
  ///
  /// [root] is the root directory that will be served for browser tests. It
  /// defaults to the working directory.
  ///
  /// If [packageRoot] is passed, it's used as the package root for all loaded
  /// tests. Otherwise, it's inferred from [root].
  ///
  /// If [pubServeUrl] is passed, tests will be loaded from the `pub serve`
  /// instance at that URL rather than from the filesystem.
  ///
  /// If [color] is true, console colors will be used when compiling Dart.
  ///
  /// If the package root doesn't exist, throws an [ApplicationException].
  Loader(Iterable<TestPlatform> platforms, {String root, String packageRoot,
      Uri pubServeUrl, bool color: false, String configDir})
      : _platforms = platforms.toList(),
        _pubServeUrl = pubServeUrl,
        _root = root == null ? p.current : root,
        _packageRoot = packageRootFor(root, packageRoot),
        _color = color,
        _configDir = configDir;

  /// Loads all test suites in [dir].
  ///
  /// This will load tests from files that end in "_test.dart". Any tests that
  /// fail to load will be emitted as [LoadException]s.
  Stream<Suite> loadDir(String dir) {
    return mergeStreams(new Directory(dir)
        .listSync(recursive: true)
        .map((entry) {
      if (entry is! File) return new Stream.fromIterable([]);

      if (!entry.path.endsWith("_test.dart")) {
        return new Stream.fromIterable([]);
      }

      if (p.split(entry.path).contains('packages')) {
        return new Stream.fromIterable([]);
      }

      return loadFile(entry.path);
    }));
  }

  /// Loads a test suite from the file at [path].
  ///
  /// This will emit a [LoadException] if the file fails to load.
  Stream<Suite> loadFile(String path) {
    var suiteMetadata;
    try {
      suiteMetadata = parseMetadata(path);
    } on AnalyzerErrorGroup catch (_) {
      // Ignore the analyzer's error, since its formatting is much worse than
      // the VM's or dart2js's.
      suiteMetadata = new Metadata();
    } on FormatException catch (error, stackTrace) {
      return new Stream.fromFuture(
          new Future.error(new LoadException(path, error), stackTrace));
    }

    var controller = new StreamController();
    Future.forEach(_platforms, (platform) {
      if (!suiteMetadata.testOn.evaluate(platform, os: currentOS)) {
        return null;
      }

      var metadata = suiteMetadata.forPlatform(platform, os: currentOS);

      // Don't load a skipped suite.
      if (metadata.skip) {
        controller.add(new Suite([new LocalTest(path, metadata, () {})],
            path: path, platform: platform.name, metadata: metadata));
        return null;
      }

      return new Future.sync(() {
        if (_pubServeUrl != null && !p.isWithin('test', path)) {
          throw new LoadException(
              path, 'When using "pub serve", all test files must be in test/.');
        }
        assert(platform.isBrowser);
        return _loadBrowserFile(path, platform, metadata);
      }).then((suite) {
        if (suite != null) controller.add(suite);
      }).catchError(controller.addError);
    }).then((_) => controller.close());

    return controller.stream;
  }

  /// Load the test suite at [path] in [platform].
  ///
  /// [metadata] is the suite-level metadata for the test.
  Future<Suite> _loadBrowserFile(
      String path, TestPlatform platform, Metadata metadata) => _browserServer
      .then(
          (browserServer) => browserServer.loadSuite(path, platform, metadata));

  /// Closes the loader and releases all resources allocated by it.
  Future close() {
    for (var isolate in _isolates) {
      isolate.kill();
    }
    _isolates.clear();

    if (_browserServerCompleter == null) return new Future.value();
    return _browserServer.then((browserServer) => browserServer.close());
  }
}
