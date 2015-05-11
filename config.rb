###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (https://middlemanapp.com/advanced/dynamic_pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
# configure :development do
#   activate :livereload
# end

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

set :css_dir, 'assets/stylesheets'

set :js_dir, 'assets/scripts'

set :images_dir, 'assets/images'

sprockets.append_path File.join(root, 'bower_components')

def to_paths(object)
  case object
  when Hash
    object.flat_map do |base_directory, contents|
      to_paths(contents).map do |path|
        File.join(base_directory.to_s, path)
      end
    end
  when Array
    object.flat_map(&method(:to_paths))
  else
    [object.to_s]
  end
end

def glob_bower_file(file)
  Dir.glob(File.join(root, 'bower_components', file)).map do |globbed_file|
    globbed_file.gsub(/^#{Regexp.escape File.join(root, 'bower_components')}/, '')
  end
end

def to_globbed_paths(object)
  to_paths(object).flat_map(&method(:glob_bower_file))
end

# Accepts an array, hash, or string representing the bower component files to
# include in the built project.
def import_bower_files(*files)
  to_globbed_paths(files.flatten(1)).each do |asset|
    sprockets.import_asset asset do |base_path|
      File.join('vendor', asset)
    end
  end
end

import_bower_files '**/*.js', '**/*.css', '**/*.png', '**/*.jpg', '**/*.jpeg', '**/*.html'

page "assets/components/*", layout: false

data.work_experience.each do |job|
  proxy(
    "/work-experience/#{job.id}.html",
    "/work-experience/template.html",
    locals: job,
    ignore: true,
  )
end

data.education.each do |degree|
  proxy(
    "/education/#{degree.id}.html",
    "/education/template.html",
    locals: degree,
    ignore: true,
  )
end

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end
