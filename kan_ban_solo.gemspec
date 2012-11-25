# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kan_ban_solo/version'

Gem::Specification.new do |gem|
  gem.name          = "kan_ban_solo"
  gem.version       = KanBanSolo::VERSION
  gem.authors       = ["Edward Price"]
  gem.email         = ["ted.price@gmail.com"]
  gem.description   = %q{Curses based kanban board, because the terminal is terminal}
  gem.summary       = %q{Curses based kanban board, because the terminal is terminal}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
