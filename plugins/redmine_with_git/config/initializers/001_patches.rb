patches_root = ::File.dirname(::File.dirname(__dir__))
Dir["#{patches_root}/lib/**/*.rb"].each do |f|
  load(f)
end
