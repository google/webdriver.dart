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
    sha256 = "83220a6d89b2299887506911a4a12439190baa1633f6da2fd32a67c4442d6f33",
    strip_prefix = "rules_dart-84052073c0c6fdb60013b65358d887bb808c6478",
    url = "https://github.com/dart-lang/rules_dart/archive/84052073c0c6fdb60013b65358d887bb808c6478.tar.gz",
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
    strip_prefix = "rules_webtesting-ed37b9f200cfb7eb86d51f8a91102a939aad35be",
    url = "https://github.com/bazelbuild/rules_webtesting/archive/ed37b9f200cfb7eb86d51f8a91102a939aad35be.tar.gz",
)

load("@io_bazel_rules_webtesting//web:repositories.bzl", "web_test_repositories", "browser_repositories")

web_test_repositories()

load(":repositories.bzl", "webdriver_dart_repositories")

webdriver_dart_repositories()

http_file(
    name="org_chromium_chromedriver",
    sha256="59e6b1b1656a20334d5731b3c5a7400f92a9c6f5043bb4ab67f1ccf1979ee486",
    url=" http://chromedriver.storage.googleapis.com/2.26/chromedriver_linux64.zip",
)

http_file(
    name = "org_chromium_chromium",
    sha256="6966d205421dcafd5d873bd1d1a858fb5a025853bd87f9d5b4480dc3faff43c9",
    url="https://commondatastorage.googleapis.com/chromium-browser-snapshots/Linux_x64/437067/chrome-linux.zip",
)
