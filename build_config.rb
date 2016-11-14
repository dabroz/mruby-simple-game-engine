MRuby::Build.new do |conf|
  toolchain :gcc

  conf.gembox 'default'
  conf.gem github: 'dabroz/mruby-float4'
  conf.gem github: 'dabroz/mruby-perlin-noise'
  conf.gem github: 'iij/mruby-io'
end
