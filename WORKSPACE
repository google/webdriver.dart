# Copyright 2016 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

workspace(name = "com_github_google_webdriver_dart")

http_archive(
    name = "io_bazel_rules_dart",
    sha256 = "db80bb1dd03485c959424dba8ea1aa4014fa0dbd22d57b069d14e5647f98b04e",
    strip_prefix = "rules_dart-66d7cd37696b6ee2397e8075da3c6d90812b65ba",
    url = "https://github.com/dart-lang/rules_dart/archive/66d7cd37696b6ee2397e8075da3c6d90812b65ba.tar.gz",
)

load("@io_bazel_rules_dart//dart/build_rules:repositories.bzl", "dart_repositories")

dart_repositories()

http_archive(
    name = "io_bazel_rules_go",
    sha256 = "0c0ec7b9c7935883cbfb2df48fbf524e857859a5c05ae1b24d5442956e6bb5e8",
    strip_prefix = "rules_go-0.2.0",
    url = "https://github.com/bazelbuild/rules_go/archive/0.2.0.tar.gz",
)

load("@io_bazel_rules_go//go:def.bzl", "go_repositories")

go_repositories()

http_archive(
    name = "io_bazel_rules_webtesting",
    sha256 = "602bd1fd4e2b756baa636c3815ef6686c111b3e30eab534c0fc84e6c8c9a14c3",    
    strip_prefix = "rules_webtesting-b875457028e38511d76e067378dacc1ffcb6c75b",
    url = "https://github.com/bazelbuild/rules_webtesting/archive/b875457028e38511d76e067378dacc1ffcb6c75b.tar.gz",
)

load("@io_bazel_rules_webtesting//web:repositories.bzl", "web_test_repositories")

web_test_repositories()

load(":repositories.bzl", "webdriver_dart_repositories")

webdriver_dart_repositories()

http_file(
    name = "org_chromium_chromedriver",
    sha256 = "d011749e76305b5591b5500897939b33fac460d705d9815b8c03c53b0e1ecc7c",
    url = " http://chromedriver.storage.googleapis.com/2.25/chromedriver_linux64.zip",
)

http_file(
    name = "org_chromium_chromium",
    sha256 = "e3c99954d6acce013174053534b72f47f67f18a0d75f79c794daaa8dd2ae8aaf",
    url = "https://commondatastorage.googleapis.com/chromium-browser-snapshots/Linux_x64/423768/chrome-linux.zip",
)
