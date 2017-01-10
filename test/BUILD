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

load("@io_bazel_rules_dart//dart/build_rules:vm.bzl", "dart_vm_test")
load("@io_bazel_rules_webtesting//web:dart.bzl", "dart_web_test_suite")

licenses(["notice"])  # Apache (Google-authored with external contributions)

dart_web_test_suite(
    name = "io_test",
    srcs = glob(
        ["**/*.dart"],
        exclude = [
            "**/html_*.dart",
            "support/async_test.dart",
        ],
    ),
    browsers = ["//browsers:chromium-native"],
    data = glob(
        ["**"],
        exclude = ["**/*.dart"],
    ),
    local = True,
    pub_pkg_name = "webdriver_test",
    script_file = "io_test.dart",
    deps = [
        "//:webdriver",
        "@org_dartlang_pub_matcher//:matcher",
        "@org_dartlang_pub_path//:path",
        "@org_dartlang_pub_test//:test",
    ],
)

dart_vm_test(
    name = "async_test",
    srcs = ["support/async_test.dart"],
    pub_pkg_name = "webdriver_test",
    script_file = "support/async_test.dart",
    deps = [
        "//:webdriver",
        "@org_dartlang_pub_async//:async",
        "@org_dartlang_pub_test//:test",
        "@org_dartlang_pub_unittest//:unittest",
    ],
)
