MRUBY_CONFIG = File.expand_path(ENV['MRUBY_CONFIG'] || 'build_config.rb')

rb_scripts = Dir.glob('./scripts/*.rb').sort
mrb_script = 'build/scripts_compiled.h'
mruby_lib = 'mruby/build/host/lib/libmruby.a'

task default: :game

file :mruby do
  sh 'git clone --depth 1 git://github.com/mruby/mruby.git'
end

desc 'test game scripts'
task :test do
  sh 'rspec'
end

desc 'cleanup'
task :clean do
  sh 'rm -rf mruby'
  sh 'rm -rf build'
end

file mruby_lib => :mruby do
  sh "cd mruby && MRUBY_CONFIG=#{MRUBY_CONFIG} rake all"
end

file mrb_script => rb_scripts + [mruby_lib] do |_task|
  sh 'mkdir -p build'
  mrbc = 'mruby/build/host/bin/mrbc'
  sh "#{mrbc} -g -o #{mrb_script} -Bmrb_scripts #{rb_scripts.join(' ')}"
end

file 'build/game' => [mrb_script, mruby_lib, 'src/main.cpp'] do
  sh 'mkdir -p build'
  compiler = (ENV['CXX'] || 'g++')
  libs = '-lsfml-graphics -lsfml-window -lsfml-system'
  includes = '-Imruby/include'
  sh "#{compiler} #{includes} src/main.cpp #{libs} #{mruby_lib} -o build/game"
end

desc 'build game'
task game: ['build/game'] do
end

desc 'run game'
task run: :game do
  sh './build/game'
end
