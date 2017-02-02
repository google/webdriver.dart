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
"""Configure required repositories for webdriver.dart."""

load(":pub.bzl", "pub_repository")


def webdriver_dart_repositories(
    omit_org_dartlang_pub_analyzer=False,
    omit_org_dartlang_pub_archive=False,
    omit_org_dartlang_pub_args=False,
    omit_org_dartlang_pub_async=False,
    omit_org_dartlang_pub_barback=False,
    omit_org_dartlang_pub_boolean_selector=False,
    omit_org_dartlang_pub_charcode=False,
    omit_org_dartlang_pub_cli_util=False,
    omit_org_dartlang_pub_collection=False,
    omit_org_dartlang_pub_convert=False,
    omit_org_dartlang_pub_crypto=False,
    omit_org_dartlang_pub_csslib=False,
    omit_org_dartlang_pub_glob=False,
    omit_org_dartlang_pub_html=False,
    omit_org_dartlang_pub_http=False,
    omit_org_dartlang_pub_http_multi_server=False,
    omit_org_dartlang_pub_http_parser=False,
    omit_org_dartlang_pub_isolate=False,
    omit_org_dartlang_pub_logging=False,
    omit_org_dartlang_pub_matcher=False,
    omit_org_dartlang_pub_meta=False,
    omit_org_dartlang_pub_mime=False,
    omit_org_dartlang_pub_package_config=False,
    omit_org_dartlang_pub_package_resolver=False,
    omit_org_dartlang_pub_path=False,
    omit_org_dartlang_pub_plugin=False,
    omit_org_dartlang_pub_pool=False,
    omit_org_dartlang_pub_pub_semver=False,
    omit_org_dartlang_pub_shelf=False,
    omit_org_dartlang_pub_shelf_packages_handler=False,
    omit_org_dartlang_pub_shelf_static=False,
    omit_org_dartlang_pub_shelf_web_socket=False,
    omit_org_dartlang_pub_source_map_stack_trace=False,
    omit_org_dartlang_pub_source_maps=False,
    omit_org_dartlang_pub_source_span=False,
    omit_org_dartlang_pub_stack_trace=False,
    omit_org_dartlang_pub_stream_channel=False,
    omit_org_dartlang_pub_string_scanner=False,
    omit_org_dartlang_pub_test=False,
    omit_org_dartlang_pub_typed_data=False,
    omit_org_dartlang_pub_unittest=False,
    omit_org_dartlang_pub_utf=False,
    omit_org_dartlang_pub_watcher=False,
    omit_org_dartlang_pub_web_socket_channel=False,
    omit_org_dartlang_pub_when=False,
    omit_org_dartlang_pub_which=False,
    omit_org_dartlang_pub_yaml=False):
  """Configure required repositories for webdriver.dart."""

  if not omit_org_dartlang_pub_analyzer:
    org_dartlang_pub_analyzer()

  if not omit_org_dartlang_pub_archive:
    org_dartlang_pub_archive()

  if not omit_org_dartlang_pub_args:
    org_dartlang_pub_args()

  if not omit_org_dartlang_pub_async:
    org_dartlang_pub_async()

  if not omit_org_dartlang_pub_barback:
    org_dartlang_pub_barback()

  if not omit_org_dartlang_pub_boolean_selector:
    org_dartlang_pub_boolean_selector()

  if not omit_org_dartlang_pub_charcode:
    org_dartlang_pub_charcode()

  if not omit_org_dartlang_pub_cli_util:
    org_dartlang_pub_cli_util()

  if not omit_org_dartlang_pub_collection:
    org_dartlang_pub_collection()

  if not omit_org_dartlang_pub_convert:
    org_dartlang_pub_convert()

  if not omit_org_dartlang_pub_crypto:
    org_dartlang_pub_crypto()

  if not omit_org_dartlang_pub_csslib:
    org_dartlang_pub_csslib()

  if not omit_org_dartlang_pub_glob:
    org_dartlang_pub_glob()

  if not omit_org_dartlang_pub_html:
    org_dartlang_pub_html()

  if not omit_org_dartlang_pub_http:
    org_dartlang_pub_http()

  if not omit_org_dartlang_pub_http_multi_server:
    org_dartlang_pub_http_multi_server()

  if not omit_org_dartlang_pub_http_parser:
    org_dartlang_pub_http_parser()

  if not omit_org_dartlang_pub_isolate:
    org_dartlang_pub_isolate()

  if not omit_org_dartlang_pub_logging:
    org_dartlang_pub_logging()

  if not omit_org_dartlang_pub_matcher:
    org_dartlang_pub_matcher()

  if not omit_org_dartlang_pub_meta:
    org_dartlang_pub_meta()

  if not omit_org_dartlang_pub_mime:
    org_dartlang_pub_mime()

  if not omit_org_dartlang_pub_package_config:
    org_dartlang_pub_package_config()

  if not omit_org_dartlang_pub_package_resolver:
    org_dartlang_pub_package_resolver()

  if not omit_org_dartlang_pub_path:
    org_dartlang_pub_path()

  if not omit_org_dartlang_pub_plugin:
    org_dartlang_pub_plugin()

  if not omit_org_dartlang_pub_pool:
    org_dartlang_pub_pool()

  if not omit_org_dartlang_pub_pub_semver:
    org_dartlang_pub_pub_semver()

  if not omit_org_dartlang_pub_shelf:
    org_dartlang_pub_shelf()

  if not omit_org_dartlang_pub_shelf_packages_handler:
    org_dartlang_pub_shelf_packages_handler()

  if not omit_org_dartlang_pub_shelf_static:
    org_dartlang_pub_shelf_static()

  if not omit_org_dartlang_pub_shelf_web_socket:
    org_dartlang_pub_shelf_web_socket()

  if not omit_org_dartlang_pub_source_map_stack_trace:
    org_dartlang_pub_source_map_stack_trace()

  if not omit_org_dartlang_pub_source_maps:
    org_dartlang_pub_source_maps()

  if not omit_org_dartlang_pub_source_span:
    org_dartlang_pub_source_span()

  if not omit_org_dartlang_pub_stack_trace:
    org_dartlang_pub_stack_trace()

  if not omit_org_dartlang_pub_stream_channel:
    org_dartlang_pub_stream_channel()

  if not omit_org_dartlang_pub_string_scanner:
    org_dartlang_pub_string_scanner()

  if not omit_org_dartlang_pub_test:
    org_dartlang_pub_test()

  if not omit_org_dartlang_pub_typed_data:
    org_dartlang_pub_typed_data()

  if not omit_org_dartlang_pub_unittest:
    org_dartlang_pub_unittest()

  if not omit_org_dartlang_pub_utf:
    org_dartlang_pub_utf()

  if not omit_org_dartlang_pub_watcher:
    org_dartlang_pub_watcher()

  if not omit_org_dartlang_pub_when:
    org_dartlang_pub_when()

  if not omit_org_dartlang_pub_which:
    org_dartlang_pub_which()

  if not omit_org_dartlang_pub_web_socket_channel:
    org_dartlang_pub_web_socket_channel()

  if not omit_org_dartlang_pub_yaml:
    org_dartlang_pub_yaml()


def org_dartlang_pub_analyzer():
  pub_repository(
      name="analyzer",
      license='licenses(["notice"])  # BSD (Google-authored with external contributions)',
      version="0.29.6",
      sha256="a447e36d3c63c38e178b26b7a561f61437fbd09666f8ab8e5b46f50e5505666c",
      deps=[
          "@org_dartlang_pub_args",
          "@org_dartlang_pub_charcode",
          "@org_dartlang_pub_cli_util",
          "@org_dartlang_pub_crypto",
          "@org_dartlang_pub_glob",
          "@org_dartlang_pub_html",
          "@org_dartlang_pub_isolate",
          "@org_dartlang_pub_meta",
          "@org_dartlang_pub_package_config",
          "@org_dartlang_pub_path",
          "@org_dartlang_pub_plugin",
          "@org_dartlang_pub_watcher",
          "@org_dartlang_pub_yaml",
      ])


def org_dartlang_pub_archive():
  pub_repository(
      name="archive",
      license='licenses(["notice"])  # Apache 2.0',
      version="1.0.27",
      sha256="c05654256072f7eb0a351fb97605bbfdb02ba191241de2ddec61041982fc3206",
      deps=["@org_dartlang_pub_crypto"])


def org_dartlang_pub_args():
  pub_repository(
      name="args",
      license='licenses(["notice"])  # BSD (Google-authored with external contributions)',
      version="0.13.7",
      sha256="3b592846eb4458e340e8bf03d950314c4dbadf964a8fe022cab1c9a1106b3754")


def org_dartlang_pub_async():
  pub_repository(
      name="async",
      license='licenses(["notice"])  # BSD (Google-authored with external contributions)',
      version="1.12.0",
      sha256="78eda22375d22c73ebfa349d425e8795b375f28a021ee2b14a50827605120213",
      deps=["@org_dartlang_pub_collection"])


def org_dartlang_pub_barback():
  pub_repository(
      name="barback",
      license='licenses(["notice"])  # BSD',
      version="0.15.2+9",
      sha256="d7d2a527f07d7af61c0c9d91376df6df1dbc8e8a606817b8ec82459ecf91a4af",
      deps=[
          "@org_dartlang_pub_async",
          "@org_dartlang_pub_collection",
          "@org_dartlang_pub_path",
          "@org_dartlang_pub_pool",
          "@org_dartlang_pub_source_span",
          "@org_dartlang_pub_stack_trace",
      ])


def org_dartlang_pub_boolean_selector():
  pub_repository(
      name="boolean_selector",
      license='licenses(["notice"])  # BSD (Google-authored with external contributions)',
      version="1.0.2",
      sha256="fd70dd881d04c4e6d89f07e0045c371551ddc083aa6f0fcb1dbab85a85b9875d",
      deps=[
          "@org_dartlang_pub_collection",
          "@org_dartlang_pub_source_span",
          "@org_dartlang_pub_string_scanner",
      ])


def org_dartlang_pub_charcode():
  pub_repository(
      name="charcode",
      license='licenses(["notice"])  # BSD (Google-authored with external contributions)',
      version="1.1.1",
      sha256="c3a733a042234bbe813741c41a298232ce162feb6ffd2b368b54aa1d995256e0")


def org_dartlang_pub_cli_util():
  pub_repository(
      name="cli_util",
      license='licenses(["notice"])  # BSD (Google-authored with external contributions)',
      version="0.0.1+2",
      sha256="979967cb1a84282c822556cab638f73cfdd4dea9f95f763d502dcc5af1bafc73",
      deps=["@org_dartlang_pub_which"])


def org_dartlang_pub_collection():
  pub_repository(
      name="collection",
      license='licenses(["notice"])  # BSD (Google-authored with external contributions)',
      version="1.13.0",
      sha256="396abdd82b601422f21b3020392b45f8464b89c2c407082eaf8c038ef2b8306b")


def org_dartlang_pub_convert():
  pub_repository(
      name="convert",
      license='licenses(["notice"])  # BSD',
      version="2.0.1",
      sha256="45c7a83da5d927ec0780d475a755c7bec3b38ce33308413e3729c7afc958464f",
      deps=[
          "@org_dartlang_pub_charcode",
          "@org_dartlang_pub_typed_data",
      ])


def org_dartlang_pub_crypto():
  pub_repository(
      name="crypto",
      license='licenses(["notice"])  # BSD (Google-authored with external contributions)',
      version="2.0.1",
      sha256="252cbd678600b61ff0cd051e4d8fee35475cd7533ba0dc712eff4dbce0b2b609",
      deps=[
          "@org_dartlang_pub_collection",
          "@org_dartlang_pub_convert",
      ])


def org_dartlang_pub_csslib():
  pub_repository(
      name="csslib",
      license='licenses(["notice"])  # BSD (Google-authored with external contributions)',
      version="0.13.3+1",
      sha256="09cfd7b1f2aea6a5b329e43d51e701334cc29fe47e0f6ab9917d2f32f914db36",
      deps=[
          "@org_dartlang_pub_args",
          "@org_dartlang_pub_logging",
          "@org_dartlang_pub_path",
          "@org_dartlang_pub_source_span",
      ])


def org_dartlang_pub_glob():
  pub_repository(
      name="glob",
      license='licenses(["notice"])  # New BSD',
      version="1.1.3",
      sha256="46e1584b52aa4b4098f6be96c335650b67d1bf6ffd289d5ad6623ffa038de71d",
      deps=[
          "@org_dartlang_pub_async",
          "@org_dartlang_pub_collection",
          "@org_dartlang_pub_path",
          "@org_dartlang_pub_string_scanner",
      ])


def org_dartlang_pub_html():
  pub_repository(
      name="html",
      license='licenses(["notice"])  # MIT (Google-authored with external contributions)',
      version="0.13.1",
      sha256="3df38f194934273d7aa6214ac017df0a61ee4c8cc42eb1fe1a6260370ad26eb3",
      deps=[
          "@org_dartlang_pub_csslib",
          "@org_dartlang_pub_source_span",
          "@org_dartlang_pub_utf",
      ])


def org_dartlang_pub_http():
  pub_repository(
      name="http",
      license='licenses(["notice"])  # BSD (Google-authored with external contributions)',
      version="0.11.3+9",
      sha256="1d95188dfe3b1d03049410e6eeea4f785658635f440735266c855daae82e15c7",
      deps=[
          "@org_dartlang_pub_async",
          "@org_dartlang_pub_collection",
          "@org_dartlang_pub_http_parser",
          "@org_dartlang_pub_path",
          "@org_dartlang_pub_stack_trace",
      ])


def org_dartlang_pub_http_multi_server():
  pub_repository(
      name="http_multi_server",
      license='licenses(["notice"])  # BSD (Google-authored with external contributions)',
      version="2.0.3",
      sha256="3f68607027cce2bc531ae66b0bbdae89aea82361f4f2fcaa42fb5f9644ce0113",
      deps=["@org_dartlang_pub_async"])


def org_dartlang_pub_http_parser():
  pub_repository(
      name="http_parser",
      license='licenses(["notice"])  # New BSD',
      version="3.1.1",
      sha256="cdd2fbf11f37ada5d81ab55395a5f1a7be303beee4b2b73631192cc6fe46a34e",
      deps=[
          "@org_dartlang_pub_charcode",
          "@org_dartlang_pub_collection",
          "@org_dartlang_pub_source_span",
          "@org_dartlang_pub_string_scanner",
          "@org_dartlang_pub_typed_data",
      ])


def org_dartlang_pub_isolate():
  pub_repository(
      name="isolate",
      license='licenses(["notice"])  # BSD',
      version="0.2.3",
      sha256="c0bcb80331f99eaa21daccb8c3ab24d5e69b77ecfffdfa603b10466a0955a99c")


def org_dartlang_pub_logging():
  pub_repository(
      name="logging",
      license='licenses(["notice"])  # BSD (Google-authored with external contributions)',
      version="0.11.3+1",
      sha256="d9374a73a13f941ee04c9bd09dafdbbc54c2fd7cb6972f75dd2e900cda69fdea")


def org_dartlang_pub_matcher():
  pub_repository(
      name="matcher",
      license='licenses(["notice"])  # BSD',
      version="0.12.0+2",
      sha256="66fe71ebcbd7064b6a492973775f1ba91bbf0b8bf1e8d86d545062d8ff35c2d9")


def org_dartlang_pub_meta():
  pub_repository(
      name="meta",
      license='licenses(["notice"])  # BSD (Google-authored with external contributions)',
      version="1.0.4",
      sha256="fa80faf10b014b40d72f00dfbf60044cd8f7b0b7d317e29634b01fbdc6397287")


def org_dartlang_pub_mime():
  pub_repository(
      name="mime",
      license='licenses(["notice"])  # New BSD',
      version="0.9.3",
      sha256="6f2da7f8ae179b624f8e14cb36761868452761d6af287f86dc9cc5632e947d49")


def org_dartlang_pub_package_config():
  pub_repository(
      name="package_config",
      license='licenses(["notice"])  # BSD (Google-authored with external contributions)',
      version="1.0.0",
      sha256="1af9acd7fa5f8a17a9ae1d7144666e8679b0053a23c21ed7ac83010e6c05b1f3",
      deps=[
          "@org_dartlang_pub_charcode",
          "@org_dartlang_pub_path",
      ])


def org_dartlang_pub_package_resolver():
  pub_repository(
      name="package_resolver",
      license='licenses(["notice"])  # BSD',
      version="1.0.2",
      sha256="2f138d188b960ec061e59233c9688be185081a7b422ea039c070639b19675f5e",
      deps=[
          "@org_dartlang_pub_collection",
          "@org_dartlang_pub_http",
          "@org_dartlang_pub_package_config",
          "@org_dartlang_pub_path",
      ])


def org_dartlang_pub_path():
  pub_repository(
      name="path",
      license='licenses(["notice"])  # BSD (Google-authored with external contributions)',
      version="1.4.1",
      sha256="39413112ccce676d862608b51516bd45aee750e6865596267fc1500f3a7e0595")


def org_dartlang_pub_plugin():
  pub_repository(
      name="plugin",
      license='licenses(["notice"])  # BSD (Google-authored with external contributions)',
      version="0.2.0",
      sha256="21dc363e742b04cbdace0835960ef32aca27511302738f3439abb90b289870d9")


def org_dartlang_pub_pool():
  pub_repository(
      name="pool",
      license='licenses(["notice"])  # New BSD',
      version="1.2.4",
      sha256="c48abab9c32a0e66293a608abaaacfa1149d304096c5a688fe81d6d7ab705c89",
      deps=[
          "@org_dartlang_pub_async",
          "@org_dartlang_pub_stack_trace",
      ])


def org_dartlang_pub_pub_semver():
  pub_repository(
      name="pub_semver",
      license='licenses(["notice"])  # New BSD',
      version="1.3.2",
      sha256="657f1c09701f068bc905d2b5a152e42c9fed240ff43873d820b82c06d898849b",
      deps=["@org_dartlang_pub_collection"])


def org_dartlang_pub_shelf():
  pub_repository(
      name="shelf",
      license='licenses(["notice"])  # New BSD',
      version="0.6.7+2",
      sha256="e5abb9e0731acc24480df302a9b4a0c2bc46b976dd24f24cf4347be1833b8f03",
      deps=[
          "@org_dartlang_pub_async",
          "@org_dartlang_pub_collection",
          "@org_dartlang_pub_http_parser",
          "@org_dartlang_pub_path",
          "@org_dartlang_pub_stack_trace",
          "@org_dartlang_pub_stream_channel",
      ])


def org_dartlang_pub_shelf_packages_handler():
  pub_repository(
      name="shelf_packages_handler",
      license='licenses(["notice"])  # BSD',
      version="1.0.0",
      sha256="d2856eac40844d5889aac8cf78d94461ebef3867fa892ebf1f9ccd55dc301732",
      deps=[
          "@org_dartlang_pub_async",
          "@org_dartlang_pub_package_resolver",
          "@org_dartlang_pub_path",
          "@org_dartlang_pub_shelf",
          "@org_dartlang_pub_shelf_static",
      ])


def org_dartlang_pub_shelf_static():
  pub_repository(
      name="shelf_static",
      license='licenses(["notice"])  # New BSD',
      version="0.2.4",
      sha256="0b302c648bbd4a1775ace3b43c9a604a7f199619375554447835c875918343d0",
      deps=[
          "@org_dartlang_pub_convert",
          "@org_dartlang_pub_http_parser",
          "@org_dartlang_pub_mime",
          "@org_dartlang_pub_path",
          "@org_dartlang_pub_shelf",
      ])


def org_dartlang_pub_shelf_web_socket():
  pub_repository(
      name="shelf_web_socket",
      license='licenses(["notice"])  # New BSD',
      version="0.2.1",
      sha256="48e26601ad549ed5bdcc52a90ec59597154e05722ede2e66e85d5221ac3fa357",
      deps=[
          "@org_dartlang_pub_shelf",
          "@org_dartlang_pub_stream_channel",
          "@org_dartlang_pub_web_socket_channel",
      ])


def org_dartlang_pub_source_map_stack_trace():
  pub_repository(
      name="source_map_stack_trace",
      license='licenses(["notice"])  # BSD',
      version="1.1.4",
      sha256="a9dde62354b0544f4c7e6ee00e7584e327c77dd6b380f18d7ec91aa72e07ebf2",
      deps=[
          "@org_dartlang_pub_package_resolver",
          "@org_dartlang_pub_path",
          "@org_dartlang_pub_source_maps",
          "@org_dartlang_pub_stack_trace",
      ])


def org_dartlang_pub_source_maps():
  pub_repository(
      name="source_maps",
      license='licenses(["notice"])  # BSD (Google-authored with external contributions)',
      version="0.10.2",
      sha256="1b77163b33baf614454ad34c79233754e120fbd03ac491dee70a2612a15eae85",
      deps=[
          "@org_dartlang_pub_path",
          "@org_dartlang_pub_source_span",
      ])


def org_dartlang_pub_source_span():
  pub_repository(
      name="source_span",
      license='licenses(["notice"])  # BSD (Google-authored with external contributions)',
      version="1.3.1",
      sha256="32c891d21baa24013f1a516d367061862daa47039f052e322d83767cbe862725",
      deps=[
          "@org_dartlang_pub_charcode",
          "@org_dartlang_pub_path",
      ])


def org_dartlang_pub_stack_trace():
  pub_repository(
      name="stack_trace",
      license='licenses(["notice"])  # BSD (Google-authored with external contributions)',
      version="1.7.0",
      sha256="b8ea106aa932e2ba97fc29562caa76bd71c60f9d688ba03ca1466559f632af9d",
      deps=["@org_dartlang_pub_path"])


def org_dartlang_pub_stream_channel():
  pub_repository(
      name="stream_channel",
      license='licenses(["notice"])  # BSD (Google-authored with external contributions)',
      version="1.6.1",
      sha256="0074d17086ea5a5594cb0a1d00bc050358d4ebdbfe4018cceb5f9ea1e1ae1dec",
      deps=[
          "@org_dartlang_pub_async",
          "@org_dartlang_pub_stack_trace",
      ])


def org_dartlang_pub_string_scanner():
  pub_repository(
      name="string_scanner",
      license='licenses(["notice"])  # New BSD',
      version="1.0.1",
      sha256="204cdb66eb0a8b933cb88f7504640e6dccdc35e15a2ec05a7aebfbe53b7a2fe8",
      deps=[
          "@org_dartlang_pub_charcode",
          "@org_dartlang_pub_source_span",
      ])


def org_dartlang_pub_test():
  pub_repository(
      name="test",
      license='licenses(["notice"])  # BSD (Google-authored with external contributions)',
      version="0.12.18+1",
      sha256="064efe7993b3be3a1980f88c5d1e5573f3bae1808d45785238a445edb70638f4",
      deps=[
          "@org_dartlang_pub_analyzer",
          "@org_dartlang_pub_args",
          "@org_dartlang_pub_async",
          "@org_dartlang_pub_barback",
          "@org_dartlang_pub_boolean_selector",
          "@org_dartlang_pub_collection",
          "@org_dartlang_pub_glob",
          "@org_dartlang_pub_http_multi_server",
          "@org_dartlang_pub_matcher",
          "@org_dartlang_pub_package_resolver",
          "@org_dartlang_pub_path",
          "@org_dartlang_pub_pool",
          "@org_dartlang_pub_pub_semver",
          "@org_dartlang_pub_shelf",
          "@org_dartlang_pub_shelf_packages_handler",
          "@org_dartlang_pub_shelf_static",
          "@org_dartlang_pub_shelf_web_socket",
          "@org_dartlang_pub_source_map_stack_trace",
          "@org_dartlang_pub_source_maps",
          "@org_dartlang_pub_source_span",
          "@org_dartlang_pub_stack_trace",
          "@org_dartlang_pub_stream_channel",
          "@org_dartlang_pub_string_scanner",
          "@org_dartlang_pub_web_socket_channel",
          "@org_dartlang_pub_yaml",
      ])


def org_dartlang_pub_typed_data():
  pub_repository(
      name="typed_data",
      license='licenses(["notice"])  # BSD',
      version="1.1.3",
      sha256="8c7637fad3224be35d2ad9b620db3f642bc5905ac3662bca1ec4f54408bfec21")


def org_dartlang_pub_unittest():
  pub_repository(
      name="unittest",
      license='licenses(["notice"])  # BSD (Google-authored with external contributions)',
      version="0.11.7",
      sha256="96cd840fc210e876f6e9734ce2f95644c30c1b162a833b6015a6aa752b31ecf3",
      deps=["@org_dartlang_pub_stack_trace"])


def org_dartlang_pub_utf():
  pub_repository(
      name="utf",
      license='licenses(["notice"])  # New BSD (Google-authored with external contributions)',
      version="0.9.0+3",
      sha256="52cd84b505ac03d565606a576cf3d1f75ba807e8a02c4d9d1b876d59c3bc41e5")


def org_dartlang_pub_watcher():
  pub_repository(
      name="watcher",
      license='licenses(["notice"])  # BSD (Google-authored with external contributions)',
      version="0.9.7+3",
      sha256="ea390b8b71c97b1d7fc45364842565b74b703df4174d4ae544664074ea754cf5",
      deps=[
          "@org_dartlang_pub_async",
          "@org_dartlang_pub_collection",
          "@org_dartlang_pub_path",
      ])


def org_dartlang_pub_web_socket_channel():
  pub_repository(
      name="web_socket_channel",
      license='licenses(["notice"])  # BSD (Google-authored with external contributions)',
      version="1.0.4",
      sha256="4b27d9c641cc0e0dd527443d5899d0588c57d83615dc8b56a86653b784667c0c",
      deps=[
          "@org_dartlang_pub_async",
          "@org_dartlang_pub_crypto",
          "@org_dartlang_pub_stream_channel",
      ])


def org_dartlang_pub_when():
  pub_repository(
      name="when",
      license='licenses(["notice"])  # BSD (Google-authored with external contributions)',
      version="0.2.0",
      sha256="751927fb195d482fa4e261bda420446bd96011ffb6eef17f4a4af08e534062cd")


def org_dartlang_pub_which():
  pub_repository(
      name="which",
      license='licenses(["notice"])  # BSD (Google-authored with external contributions)',
      version="0.1.3",
      sha256="f39f0bf0a00254f8d9e031bad6aabb4ff02c7fb6e14e38cb1538320aa7f1bd34",
      deps=[
          "@org_dartlang_pub_path",
          "@org_dartlang_pub_when",
      ])


def org_dartlang_pub_yaml():
  pub_repository(
      name="yaml",
      license='licenses(["notice"])  # BSD (Google-authored with external contributions)',
      version="2.1.12",
      sha256="cae64a1337c3a0350e01989721172afc4411be5520f267e8fb568e9e6a5928b4",
      deps=[
          "@org_dartlang_pub_charcode",
          "@org_dartlang_pub_collection",
          "@org_dartlang_pub_source_span",
          "@org_dartlang_pub_string_scanner",
      ])
