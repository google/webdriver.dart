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
"""Defines a pub_repository rule that loads a library from pub."""


def pub_repository(name,
                   version,
                   sha256,
                   license,
                   enable_ddc=None,
                   license_file="LICENSE",
                   deps=[],
                   testonly=None):
  repo_name = "org_dartlang_pub_" + name

  if deps:
    deps_str = '"' + '",\n    "'.join(deps) + '"'
  else:
    deps_str = ""

  build_file = """
load("@io_bazel_rules_dart//dart/build_rules:core.bzl", "dart_library")

{license}

exports_files(["{license_file}"])

dart_library(
    name = "{rule_name}",
    srcs = glob(["lib/**"]),
    enable_ddc = {enable_ddc},
    license_files = ["{license_file}"],
    pub_pkg_name = "{pkg_name}",
    testonly = {testonly},
    visibility = ["//visibility:public"],
    deps = [
        {deps}
    ],
)
""".format(
      rule_name=repo_name,
      license=license,
      license_file=license_file,
      pkg_name=name,
      testonly=testonly,
      deps=deps_str,
      enable_ddc=enable_ddc)

  native.new_http_archive(
      name=repo_name,
      build_file_content=build_file,
      sha256=sha256,
      urls=[
          "https://storage.googleapis.com/pub.dartlang.org/packages/%s-%s.tar.gz"
          % (name, version)
      ])
