# frozen_string_literal: true

dir = 'shared_contexts'
file_absollute_path = File.absolute_path(__FILE__)
file_dirname = File.dirname(file_absollute_path)
dir_path = File.join(file_dirname, dir)
dir_files_path = "#{File.expand_path(dir_path)}/**/*.rb"

Dir[dir_files_path].each do |file|
  require file
end
