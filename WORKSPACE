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
    sha256 = "c46db0431001b1a4aa7fdd2ec43642c07e443eba4161a3b2b0d60bd19ff7370e",
    strip_prefix = "rules_dart-b7ef091c339a55cd321b92399462f24aecf42fd6",
    url = "https://github.com/dart-lang/rules_dart/archive/b7ef091c339a55cd321b92399462f24aecf42fd6.tar.gz",
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
    strip_prefix = "rules_webtesting-f27ab1ce1bf42b3ef0fb4ca15b19507e27c28df9",
    url = "https://github.com/bazelbuild/rules_webtesting/archive/f27ab1ce1bf42b3ef0fb4ca15b19507e27c28df9.tar.gz",
)

load("@io_bazel_rules_webtesting//web:repositories.bzl", "web_test_repositories", "browser_repositories")

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
