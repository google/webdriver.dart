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

licenses(["notice"])  # BSD (Google-authored with external contributions)

exports_files(["LICENSE"])

dart_library(
    name = "test",
    srcs = glob(["lib/**"]),
    license_files = ["LICENSE"],
    pub_pkg_name = "test",
    visibility = ["//visibility:public"],
    deps = [
        "@org_dartlang_pub_analyzer//:analyzer",
        "@org_dartlang_pub_args//:args",
        "@org_dartlang_pub_async//:async",
        "@org_dartlang_pub_barback//:barback",
        "@org_dartlang_pub_boolean_selector//:boolean_selector",
        "@org_dartlang_pub_collection//:collection",
        "@org_dartlang_pub_glob//:glob",
        "@org_dartlang_pub_http_multi_server//:http_multi_server",
        "@org_dartlang_pub_matcher//:matcher",
        "@org_dartlang_pub_package_resolver//:package_resolver",
        "@org_dartlang_pub_path//:path",
        "@org_dartlang_pub_pool//:pool",
        "@org_dartlang_pub_pub_semver//:pub_semver",
        "@org_dartlang_pub_shelf//:shelf",
        "@org_dartlang_pub_shelf_packages_handler//:shelf_packages_handler",
        "@org_dartlang_pub_shelf_static//:shelf_static",
        "@org_dartlang_pub_shelf_web_socket//:shelf_web_socket",
        "@org_dartlang_pub_source_map_stack_trace//:source_map_stack_trace",
        "@org_dartlang_pub_source_maps//:source_maps",
        "@org_dartlang_pub_source_span//:source_span",
        "@org_dartlang_pub_stack_trace//:stack_trace",
        "@org_dartlang_pub_stream_channel//:stream_channel",
        "@org_dartlang_pub_string_scanner//:string_scanner",
        "@org_dartlang_pub_web_socket_channel//:web_socket_channel",
        "@org_dartlang_pub_yaml//:yaml",
    ],
)
