IN_EXTENSION = ".dart"
OUT_EXTENSION = ".io.dart"

def _change_extension(path):
  return "%s%s" % (path[:-1 * len(IN_EXTENSION)], OUT_EXTENSION)

def _compute_outs(srcs):
  outs = {}
  for label in srcs:
    if label.name.endswith(IN_EXTENSION):
      out_name = _change_extension(label.name)
      outs[out_name] = out_name
  return outs

def _generate_io_tests_impl(ctx):
  """Rewrites tests to replace dart_util imports with io_dart_util"""
  outs = []
  for src in ctx.files.srcs:
    path = src.basename
    if path.endswith(IN_EXTENSION):
      out_name = _change_extension(path)
      out_file = ctx.new_file(src, out_name)
      outs.append(out_file)
      ctx.template_action(
          output = out_file,
          template = src,
          substitutions = {
              "test_util.dart": "io_test_util.dart",
          }
      )
  return struct(files=set(outs))

generate_io_tests = rule(
    attrs = {
        "srcs": attr.label_list(allow_files=True),
    },
    outputs = _compute_outs,
    implementation = _generate_io_tests_impl,
)
