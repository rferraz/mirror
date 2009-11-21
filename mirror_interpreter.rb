require "rubygems"
require "treetop"
require "active_support"

require "lib/extensions"
require "lib/mirror"
require "lib/mirror_extensions"
require "lib/blank_object"
require "lib/proxy"
require "lib/boolean_proxy"
require "lib/slot_container"
require "lib/block_context"
require "lib/universe"
require "lib/world"
require "lib/error"
require "lib/ast"
require "lib/bytecode"
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
    (balance < amount) ifTrue: [ Error signal: "Insufficient funds! Amount drawn should be less than " + balance asString. ].
    balance become: (balance - amount).
  ].

  Account mirrorInto: "account".

  account deposit: 100.
  account deposit: 200.

  account withdraw: 120.
  
  account balance printLn.
  
EOF

ast = MirrorParser.new.parse(code).build

instructions = CodeGenerator.new(ast).generate

VM.new(instructions).run.inspect