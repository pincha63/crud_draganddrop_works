# config.ru
require 'sass-embedded'
require 'fileutils'

# --- UPDATE THESE PATHS ---
scss_file = File.expand_path('views/sass/app.scss', __dir__) # Changed 'scss' to 'sass'
css_dir   = File.expand_path('public/css', __dir__)
css_file  = File.join(css_dir, 'app.css')

if File.exist?(scss_file)
  FileUtils.mkdir_p(css_dir)
  
  # Force a compile if the CSS is missing or the Sass is newer
  if !File.exist?(css_file) || File.mtime(scss_file) > File.mtime(css_file)
    puts ">>> Found SCSS in views/sass. Compiling..."
    begin
      result = Sass.compile(scss_file)
      File.write(css_file, result.css)
      puts ">>> SUCCESS: app.css created at #{css_file}"
    rescue => e
      puts ">>> SASS COMPILE ERROR: #{e.message}"
    end
  end
else
  puts ">>> ERROR: Still can't find your file at #{scss_file}"
end

require_relative 'app'
use Rack::MethodOverride
run LibraryApp.freeze.app
