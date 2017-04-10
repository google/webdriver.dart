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
    sha256 = "845f9e9f364bd1ef8c6694a66674876482224cef12c865b5b89569ee8f67d3a0",
    strip_prefix = "rules_dart-89784166bceecfba04fa64c2aac30be4a5907067",
    urls = ["https://github.com/DrMarcII/rules_dart/archive/89784166bceecfba04fa64c2aac30be4a5907067.tar.gz"],
)

load("@io_bazel_rules_dart//dart/build_rules:repositories.bzl", "dart_repositories")

dart_repositories()

http_archive(
    name = "io_bazel_rules_go",
    sha256 = "8da41f16959023ce5c32ab98661eaf6a0c45724252c16693c4ec53abbe7d422c",
    strip_prefix = "rules_go-7828452850597b52b49ec603b23f8ad2bcb22aed",
    urls = ["https://github.com/bazelbuild/rules_go/archive/7828452850597b52b49ec603b23f8ad2bcb22aed.tar.gz"],
)

load("@io_bazel_rules_go//go:def.bzl", "go_repositories")

go_repositories()

http_archive(
    name = "io_bazel_rules_webtesting",
    sha256 = "f5627c1593cb54360b9935a4a006332dd130a0f0a7ce6656d5e5c59ec0b5ba0d",
    strip_prefix = "rules_webtesting-6b7c92c951fd05ecc02abe898269b94cc9a6e875",
    urls = ["https://github.com/bazelbuild/rules_webtesting/archive/6b7c92c951fd05ecc02abe898269b94cc9a6e875.tar.gz"],
)

load("@io_bazel_rules_webtesting//web:repositories.bzl", "web_test_repositories")

web_test_repositories()

load(":repositories.bzl", "webdriver_dart_repositories")

webdriver_dart_repositories()

http_file(
    name = "org_chromium_chromedriver",
    sha256 = "d011749e76305b5591b5500897939b33fac460d705d9815b8c03c53b0e1ecc7c",
    urls = ["http://chromedriver.storage.googleapis.com/2.25/chromedriver_linux64.zip"],
)

http_file(
    name = "org_chromium_chromium",
    sha256 = "e3c99954d6acce013174053534b72f47f67f18a0d75f79c794daaa8dd2ae8aaf",
    urls = ["https://commondatastorage.googleapis.com/chromium-browser-snapshots/Linux_x64/423768/chrome-linux.zip"],
)
