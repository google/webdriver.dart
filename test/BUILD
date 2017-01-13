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
load("@io_bazel_rules_dart//dart/build_rules:code_gen.bzl", "dart_code_gen")
load("@io_bazel_rules_webtesting//web:dart.bzl", "dart_web_test_suite")

licenses(["notice"])  # Apache (Google-authored with external contributions)

# TODO(DrMarcII) Add support for html webdriver tests when rules_dart support dart_web_test

_TESTS_TO_RUN = glob(["*_test.dart"])

dart_code_gen(
    name = "generate_io_tests",
    srcs = _TESTS_TO_RUN,
    generator = "//:transform_tests",
    generator_args = ["--test_util_import=io_test_util.dart"],
    out_extensions = [".io.dart"],
)

[
    dart_web_test_suite(
        name = dart_file[:-5] + "_io",
        srcs = [
            dart_file[:-5] + ".io.dart",
            "io_test_util.dart",
            "test_util.dart",
        ],
        browsers = ["//browsers:chromium-native"],
        data = [
            "frame.html",
            "support/forwarder_test_page.html",
            "test_page.html",
        ],
        flaky = True,
        local = True,
        pub_pkg_name = "webdriver_test",
        script_file = dart_file[:-5] + ".io.dart",
        deps = [
            "//:webdriver",
            "@org_dartlang_pub_matcher//:matcher",
            "@org_dartlang_pub_path//:path",
            "@org_dartlang_pub_test//:test",
        ],
    )
    for dart_file in _TESTS_TO_RUN
]

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

dart_vm_test(
    name = "firefox_profile_test",
    srcs = [
        "io_test_util.dart",
        "support/firefox_profile_test.dart",
        "test_util.dart",
    ],
    data = glob(["support/firefox_profile/**"]),
    pub_pkg_name = "webdriver_test",
    script_file = "support/firefox_profile_test.dart",
    deps = [
        "//:webdriver",
        "@org_dartlang_pub_archive//:archive",
        "@org_dartlang_pub_matcher//:matcher",
        "@org_dartlang_pub_path//:path",
        "@org_dartlang_pub_test//:test",
    ],
)
