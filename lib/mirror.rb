libdir = File.join(File.dirname(__FILE__))
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require "rubygems"
require "treetop"

Treetop.load File.join(libdir, "mirror.treetop")

require "extensions"
require "mirror_extensions"
require "blank_object"
require "slot_container"
require "block_frame"
require "block_activation"
require "block_context"
require "scoping"
require "universe"
require "world"
require "error"
require "ast"
require "bytecode"
require "code_generator"
require "vm"
require "interpreter"