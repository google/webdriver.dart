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

load("@io_bazel_rules_dart//dart/build_rules:core.bzl", "dart_library")
load("@io_bazel_rules_dart//dart/build_rules:vm.bzl", "dart_vm_test")
load("@io_bazel_rules_webtesting//web:web.bzl", "web_test_suite")

licenses(["notice"])  # Apache 2.0

exports_files(["LICENSE"])

dart_library(
    name = "webdriver",
    srcs = glob(["lib/**"]),
    pub_pkg_name = "webdriver",
    visibility = ["//visibility:public"],
    deps = [
        "@org_dartlang_pub_archive//:archive",
        "@org_dartlang_pub_matcher//:matcher",
        "@org_dartlang_pub_path//:path",
        "@org_dartlang_pub_stack_trace//:stack_trace",
        "@org_dartlang_pub_unittest//:unittest",
    ],
)

dart_vm_test(
    name = "io_test_wrapped",
    srcs = glob(
        ["test/**/*.dart"],
        exclude = [
            "**/html_*.dart",
            "test/support/async_test.dart",
        ],
    ),
    data = glob(
        ["test/**"],
        exclude = ["**/*.dart"],
    ),
    script_file = "test/io_test.dart",
    tags = [
        "manual",
        "noci",
    ],
    deps = [
        ":webdriver",
        "@org_dartlang_pub_matcher//:matcher",
        "@org_dartlang_pub_path//:path",
        "@org_dartlang_pub_test//:test",
    ],
)

web_test_suite(
    name = "io_test",
    browsers = [
        "//browsers:chrome-native",
    ],
    local = True,
    test = ":io_test_wrapped",
)

dart_vm_test(
    name = "async_test",
    srcs = ["test/support/async_test.dart"],
    script_file = "test/support/async_test.dart",
    deps = [
        ":webdriver",
        "@org_dartlang_pub_async//:async",
        "@org_dartlang_pub_test//:test",
        "@org_dartlang_pub_unittest//:unittest",
    ],
)
