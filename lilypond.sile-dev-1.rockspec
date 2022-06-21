-- DO NOT EDIT! Modify template lilypond.sile.rockspec.in and rebuild with `make lilypond.sile-dev-1.rockspec`
rockspec_format = "3.0"
package = "lilypond.sile"
version = "dev-1"

source = {
   url = "git+https://github.com/sile-typesetter/lilypond.sile.git",
   tag = "master"
}

description = {
   summary = "Lilypond package for SILE",
   detailed = [[Add support for Lilypond notation and includes to SILE documents.]],
   license = "MIT",
   homepage = "https://github.com/sile-typesetter/fluent-lua",
   issues_url = "https://github.com/sile-typesetter/fluent-lua/issues",
   maintainer = "Caleb Maclennan <caleb@alerque.com>",
   labels = { "typesetting", "music" }
}

dependencies = {
   "lua >= 5.1"
}

build = {
   type = "builtin",
   modules = {
      ["sile.packages.lilypond"] = "packages/lilypond/init.lua"
   }
}
