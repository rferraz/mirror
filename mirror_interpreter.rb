require "rubygems"
require "treetop"
require "active_record"

require "lib/mirror"
require "lib/mirror_extensions"
require "lib/blank_object"
require "lib/proxy"
require "lib/slot_container"
require "lib/block_context"
require "lib/universe"
require "lib/world"
require "lib/ast"
require "lib/code_generator"
require "lib/vm"

code = <<-EOF

  World mirrorInto: "Account".

  Account set: "balance" to: 0.

  Account set: "deposit" to: [ 
    amount | 
    balance become: balance + amount.
  ].

  Account set: "withdraw" to: [
    amount |
    balance become: (balance - amount).
  ].

  Account mirrorInto: "account".

  account deposit: 100.
  account deposit: 200.

  account withdraw: 20.

  account balance inspect.
  
EOF

ast = MirrorParser.new.parse(code).build

instructions = CodeGenerator.new(ast).generate

puts VM.new(instructions).run.inspect