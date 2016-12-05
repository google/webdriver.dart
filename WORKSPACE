workspace(name = "com_github_google_webdriver_dart")

# Include the Dart SDK and language extensions for Bazel.
# git_repository(
#     name = "io_bazel_rules_dart",
#     remote = "https://github.com/dart-lang/rules_dart",
#     tag = "v0.2.2",
# )

local_repository(
    name = "io_bazel_rules_dart",
    path = "/usr/local/google/home/fisherii/github/rules_dart",
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

browser_repositories(firefox = True)

load(":repositories.bzl", "webdriver_dart_repositories")

webdriver_dart_repositories()
