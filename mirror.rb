libdir = File.join(File.dirname(__FILE__))
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require "lib/mirror"

if $0 == __FILE__
  Interpreter.run(ARGF.read)
end