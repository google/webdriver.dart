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


def webdriver_dart_repositories(
    omit_org_dartlang_pub_analyzer=False,
    omit_org_dartlang_pub_archive=False,
    omit_org_dartlang_pub_args=False,
    omit_org_dartlang_pub_async=False,
    omit_org_dartlang_pub_barback=False,
    omit_org_dartlang_pub_boolean_selector=False,
    omit_org_dartlang_pub_charcode=False,
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
    omit_org_dartlang_pub_yaml=False):
  """Configure required repositories for webdriver.dart."""
  
  if not omit_org_dartlang_pub_analyzer:
    native.new_http_archive(
        name="org_dartlang_pub_analyzer",
        build_file=str(Label("//build_files:analyzer.BUILD")),
        sha256="7249fc31827063a154b8d9f4232cf778713cd3cc29074abf19e42d9f0a5572c7",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/analyzer-0.29.5.tar.gz"
    )
    
  if not omit_org_dartlang_pub_archive:
    native.new_http_archive(
        name="org_dartlang_pub_archive",
        build_file=str(Label("//build_files:archive.BUILD")),
        sha256="c05654256072f7eb0a351fb97605bbfdb02ba191241de2ddec61041982fc3206",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/archive-1.0.27.tar.gz"
    )
    
  if not omit_org_dartlang_pub_args:
    native.new_http_archive(
        name="org_dartlang_pub_args",
        build_file=str(Label("//build_files:args.BUILD")),
        sha256="3b592846eb4458e340e8bf03d950314c4dbadf964a8fe022cab1c9a1106b3754",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/args-0.13.7.tar.gz"
    )
    
  if not omit_org_dartlang_pub_async:
    native.new_http_archive(
        name="org_dartlang_pub_async",
        build_file=str(Label("//build_files:async.BUILD")),
        sha256="78eda22375d22c73ebfa349d425e8795b375f28a021ee2b14a50827605120213",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/async-1.12.0.tar.gz"
    )
    
  if not omit_org_dartlang_pub_barback:
    native.new_http_archive(
        name="org_dartlang_pub_barback",
        build_file=str(Label("//build_files:barback.BUILD")),
        sha256="d7d2a527f07d7af61c0c9d91376df6df1dbc8e8a606817b8ec82459ecf91a4af",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/barback-0.15.2+9.tar.gz"
    )
    
  if not omit_org_dartlang_pub_boolean_selector:
    native.new_http_archive(
        name="org_dartlang_pub_boolean_selector",
        build_file=str(Label("//build_files:boolean_selector.BUILD")),
        sha256="fd70dd881d04c4e6d89f07e0045c371551ddc083aa6f0fcb1dbab85a85b9875d",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/boolean_selector-1.0.2.tar.gz"
    )
    
  if not omit_org_dartlang_pub_charcode:
    native.new_http_archive(
        name="org_dartlang_pub_charcode",
        build_file=str(Label("//build_files:charcode.BUILD")),
        sha256="c3a733a042234bbe813741c41a298232ce162feb6ffd2b368b54aa1d995256e0",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/charcode-1.1.1.tar.gz"
    )
    
  if not omit_org_dartlang_pub_collection:
    native.new_http_archive(
        name="org_dartlang_pub_collection",
        build_file=str(Label("//build_files:collection.BUILD")),
        sha256="396abdd82b601422f21b3020392b45f8464b89c2c407082eaf8c038ef2b8306b",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/collection-1.13.0.tar.gz"
    )
    
  if not omit_org_dartlang_pub_convert:
    native.new_http_archive(
        name="org_dartlang_pub_convert",
        build_file=str(Label("//build_files:convert.BUILD")),
        sha256="45c7a83da5d927ec0780d475a755c7bec3b38ce33308413e3729c7afc958464f",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/convert-2.0.1.tar.gz"
    )
    
  if not omit_org_dartlang_pub_crypto:
    native.new_http_archive(
        name="org_dartlang_pub_crypto",
        build_file=str(Label("//build_files:crypto.BUILD")),
        sha256="252cbd678600b61ff0cd051e4d8fee35475cd7533ba0dc712eff4dbce0b2b609",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/crypto-2.0.1.tar.gz"
    )
    
  if not omit_org_dartlang_pub_csslib:
    native.new_http_archive(
        name="org_dartlang_pub_csslib",
        build_file=str(Label("//build_files:csslib.BUILD")),
        sha256="0264a0c25e3bf54e8a675419b7b92ad828e2cc55b57d8205e6752ca86ff3a40f",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/csslib-0.13.2+2.tar.gz"
    )
    
  if not omit_org_dartlang_pub_glob:
    native.new_http_archive(
        name="org_dartlang_pub_glob",
        build_file=str(Label("//build_files:glob.BUILD")),
        sha256="46e1584b52aa4b4098f6be96c335650b67d1bf6ffd289d5ad6623ffa038de71d",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/glob-1.1.3.tar.gz"
    )
    
  if not omit_org_dartlang_pub_html:
    native.new_http_archive(
        name="org_dartlang_pub_html",
        build_file=str(Label("//build_files:html.BUILD")),
        sha256="3df38f194934273d7aa6214ac017df0a61ee4c8cc42eb1fe1a6260370ad26eb3",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/html-0.13.1.tar.gz"
    )
    
  if not omit_org_dartlang_pub_http:
    native.new_http_archive(
        name="org_dartlang_pub_http",
        build_file=str(Label("//build_files:http.BUILD")),
        sha256="1d95188dfe3b1d03049410e6eeea4f785658635f440735266c855daae82e15c7",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/http-0.11.3+9.tar.gz"
    )
    
  if not omit_org_dartlang_pub_http_multi_server:
    native.new_http_archive(
        name="org_dartlang_pub_http_multi_server",
        build_file=str(Label("//build_files:http_multi_server.BUILD")),
        sha256="3f68607027cce2bc531ae66b0bbdae89aea82361f4f2fcaa42fb5f9644ce0113",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/http_multi_server-2.0.3.tar.gz"
    )
    
  if not omit_org_dartlang_pub_http_parser:
    native.new_http_archive(
        name="org_dartlang_pub_http_parser",
        build_file=str(Label("//build_files:http_parser.BUILD")),
        sha256="cdd2fbf11f37ada5d81ab55395a5f1a7be303beee4b2b73631192cc6fe46a34e",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/http_parser-3.1.1.tar.gz"
    )

  if not omit_org_dartlang_pub_isolate:
    native.new_http_archive(
        name="org_dartlang_pub_isolate",
        build_file=str(Label("//build_files:isolate.BUILD")),
        sha256="c0bcb80331f99eaa21daccb8c3ab24d5e69b77ecfffdfa603b10466a0955a99c",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/isolate-0.2.3.tar.gz"
    )

  if not omit_org_dartlang_pub_logging:
    native.new_http_archive(
        name="org_dartlang_pub_logging",
        build_file=str(Label("//build_files:logging.BUILD")),
        sha256="d9374a73a13f941ee04c9bd09dafdbbc54c2fd7cb6972f75dd2e900cda69fdea",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/logging-0.11.3+1.tar.gz"
    )

  if not omit_org_dartlang_pub_matcher:
    native.new_http_archive(
        name="org_dartlang_pub_matcher",
        build_file=str(Label("//build_files:matcher.BUILD")),
        sha256="66fe71ebcbd7064b6a492973775f1ba91bbf0b8bf1e8d86d545062d8ff35c2d9",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/matcher-0.12.0+2.tar.gz"
    )

  if not omit_org_dartlang_pub_meta:
    native.new_http_archive(
        name="org_dartlang_pub_meta",
        build_file=str(Label("//build_files:meta.BUILD")),
        sha256="fa80faf10b014b40d72f00dfbf60044cd8f7b0b7d317e29634b01fbdc6397287",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/meta-1.0.4.tar.gz"
    )

  if not omit_org_dartlang_pub_mime:
    native.new_http_archive(
        name="org_dartlang_pub_mime",
        build_file=str(Label("//build_files:mime.BUILD")),
        sha256="6f2da7f8ae179b624f8e14cb36761868452761d6af287f86dc9cc5632e947d49",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/mime-0.9.3.tar.gz"
    )

  if not omit_org_dartlang_pub_package_config:
    native.new_http_archive(
        name="org_dartlang_pub_package_config",
        build_file=str(Label("//build_files:package_config.BUILD")),
        sha256="1af9acd7fa5f8a17a9ae1d7144666e8679b0053a23c21ed7ac83010e6c05b1f3",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/package_config-1.0.0.tar.gz"
    )

  if not omit_org_dartlang_pub_package_resolver:
    native.new_http_archive(
        name="org_dartlang_pub_package_resolver",
        build_file=str(Label("//build_files:package_resolver.BUILD")),
        sha256="2f138d188b960ec061e59233c9688be185081a7b422ea039c070639b19675f5e",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/package_resolver-1.0.2.tar.gz"
    )

  if not omit_org_dartlang_pub_path:
    native.new_http_archive(
        name="org_dartlang_pub_path",
        build_file=str(Label("//build_files:path.BUILD")),
        sha256="39413112ccce676d862608b51516bd45aee750e6865596267fc1500f3a7e0595",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/path-1.4.1.tar.gz"
    )

  if not omit_org_dartlang_pub_plugin:
    native.new_http_archive(
        name="org_dartlang_pub_plugin",
        build_file=str(Label("//build_files:plugin.BUILD")),
        sha256="21dc363e742b04cbdace0835960ef32aca27511302738f3439abb90b289870d9",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/plugin-0.2.0.tar.gz"
    )

  if not omit_org_dartlang_pub_pool:
    native.new_http_archive(
        name="org_dartlang_pub_pool",
        build_file=str(Label("//build_files:pool.BUILD")),
        sha256="c48abab9c32a0e66293a608abaaacfa1149d304096c5a688fe81d6d7ab705c89",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/pool-1.2.4.tar.gz"
    )

  if not omit_org_dartlang_pub_pub_semver:
    native.new_http_archive(
        name="org_dartlang_pub_pub_semver",
        build_file=str(Label("//build_files:pub_semver.BUILD")),
        sha256="657f1c09701f068bc905d2b5a152e42c9fed240ff43873d820b82c06d898849b",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/pub_semver-1.3.2.tar.gz"
    )

  if not omit_org_dartlang_pub_shelf:
    native.new_http_archive(
        name="org_dartlang_pub_shelf",
        build_file=str(Label("//build_files:shelf.BUILD")),
        sha256="e5abb9e0731acc24480df302a9b4a0c2bc46b976dd24f24cf4347be1833b8f03",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/shelf-0.6.7+2.tar.gz"
    )

  if not omit_org_dartlang_pub_shelf_packages_handler:
    native.new_http_archive(
        name="org_dartlang_pub_shelf_packages_handler",
        build_file=str(Label("//build_files:shelf_packages_handler.BUILD")),
        sha256="d2856eac40844d5889aac8cf78d94461ebef3867fa892ebf1f9ccd55dc301732",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/shelf_packages_handler-1.0.0.tar.gz"
    )

  if not omit_org_dartlang_pub_shelf_static:
    native.new_http_archive(
        name="org_dartlang_pub_shelf_static",
        build_file=str(Label("//build_files:shelf_static.BUILD")),
        sha256="0b302c648bbd4a1775ace3b43c9a604a7f199619375554447835c875918343d0",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/shelf_static-0.2.4.tar.gz"
    )

  if not omit_org_dartlang_pub_shelf_web_socket:
    native.new_http_archive(
        name="org_dartlang_pub_shelf_web_socket",
        build_file=str(Label("//build_files:shelf_web_socket.BUILD")),
        sha256="48e26601ad549ed5bdcc52a90ec59597154e05722ede2e66e85d5221ac3fa357",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/shelf_web_socket-0.2.1.tar.gz"
    )

  if not omit_org_dartlang_pub_source_map_stack_trace:
    native.new_http_archive(
        name="org_dartlang_pub_source_map_stack_trace",
        build_file=str(Label("//build_files:source_map_stack_trace.BUILD")),
        sha256="a9dde62354b0544f4c7e6ee00e7584e327c77dd6b380f18d7ec91aa72e07ebf2",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/source_map_stack_trace-1.1.4.tar.gz"
    )

  if not omit_org_dartlang_pub_source_maps:
    native.new_http_archive(
        name="org_dartlang_pub_source_maps",
        build_file=str(Label("//build_files:source_maps.BUILD")),
        sha256="1b77163b33baf614454ad34c79233754e120fbd03ac491dee70a2612a15eae85",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/source_maps-0.10.2.tar.gz"
    )

  if not omit_org_dartlang_pub_source_span:
    native.new_http_archive(
        name="org_dartlang_pub_source_span",
        build_file=str(Label("//build_files:source_span.BUILD")),
        sha256="32c891d21baa24013f1a516d367061862daa47039f052e322d83767cbe862725",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/source_span-1.3.1.tar.gz"
    )

  if not omit_org_dartlang_pub_stack_trace:
    native.new_http_archive(
        name="org_dartlang_pub_stack_trace",
        build_file=str(Label("//build_files:stack_trace.BUILD")),
        sha256="b8ea106aa932e2ba97fc29562caa76bd71c60f9d688ba03ca1466559f632af9d",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/stack_trace-1.7.0.tar.gz"
    )

  if not omit_org_dartlang_pub_stream_channel:
    native.new_http_archive(
        name="org_dartlang_pub_stream_channel",
        build_file=str(Label("//build_files:stream_channel.BUILD")),
        sha256="e22242ac461247618190a50342c3cd93a2466746637e55201375ccb4654cd420",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/stream_channel-1.6.0.tar.gz"
    )

  if not omit_org_dartlang_pub_string_scanner:
    native.new_http_archive(
        name="org_dartlang_pub_string_scanner",
        build_file=str(Label("//build_files:string_scanner.BUILD")),
        sha256="204cdb66eb0a8b933cb88f7504640e6dccdc35e15a2ec05a7aebfbe53b7a2fe8",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/string_scanner-1.0.1.tar.gz"
    )

  if not omit_org_dartlang_pub_test:
    native.new_http_archive(
        name="org_dartlang_pub_test",
        build_file=str(Label("//build_files:test.BUILD")),
        sha256="064efe7993b3be3a1980f88c5d1e5573f3bae1808d45785238a445edb70638f4",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/test-0.12.18+1.tar.gz"
    )

  if not omit_org_dartlang_pub_typed_data:
    native.new_http_archive(
        name="org_dartlang_pub_typed_data",
        build_file=str(Label("//build_files:typed_data.BUILD")),
        sha256="8c7637fad3224be35d2ad9b620db3f642bc5905ac3662bca1ec4f54408bfec21",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/typed_data-1.1.3.tar.gz"
    )

  if not omit_org_dartlang_pub_unittest:
    native.new_http_archive(
        name="org_dartlang_pub_unittest",
        build_file=str(Label("//build_files:unittest.BUILD")),
        sha256="96cd840fc210e876f6e9734ce2f95644c30c1b162a833b6015a6aa752b31ecf3",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/unittest-0.11.7.tar.gz"
    )

  if not omit_org_dartlang_pub_utf:
    native.new_http_archive(
        name="org_dartlang_pub_utf",
        build_file=str(Label("//build_files:utf.BUILD")),
        sha256="52cd84b505ac03d565606a576cf3d1f75ba807e8a02c4d9d1b876d59c3bc41e5",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/utf-0.9.0+3.tar.gz"
    )

  if not omit_org_dartlang_pub_watcher:
    native.new_http_archive(
        name="org_dartlang_pub_watcher",
        build_file=str(Label("//build_files:watcher.BUILD")),
        sha256="ea390b8b71c97b1d7fc45364842565b74b703df4174d4ae544664074ea754cf5",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/watcher-0.9.7+3.tar.gz"
    )

  if not omit_org_dartlang_pub_web_socket_channel:
    native.new_http_archive(
        name="org_dartlang_pub_web_socket_channel",
        build_file=str(Label("//build_files:web_socket_channel.BUILD")),
        sha256="4b27d9c641cc0e0dd527443d5899d0588c57d83615dc8b56a86653b784667c0c",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/web_socket_channel-1.0.4.tar.gz"
    )

  if not omit_org_dartlang_pub_yaml:
    native.new_http_archive(
        name="org_dartlang_pub_yaml",
        build_file=str(Label("//build_files:yaml.BUILD")),
        sha256="cae64a1337c3a0350e01989721172afc4411be5520f267e8fb568e9e6a5928b4",
        url="https://storage.googleapis.com/pub.dartlang.org/packages/yaml-2.1.12.tar.gz"
    )
