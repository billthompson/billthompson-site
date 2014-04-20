###
# Blog settings
###

Time.zone = "America/Chicago"

activate :blog do |blog|
  # This will add a prefix to all links, template references and source paths
  # blog.prefix = "blog"

  # blog.permalink = "{year}/{month}/{day}/{title}.html"
  # Matcher for blog source files
  blog.sources = "posts/{year}-{month}-{day}-{title}.html"
  # blog.taglink = "tags/{tag}.html"
  # blog.layout = "layout"
  # blog.summary_separator = /(READMORE)/
  # blog.summary_length = 250
  # blog.year_link = "{year}.html"
  # blog.month_link = "{year}/{month}.html"
  # blog.day_link = "{year}/{month}/{day}.html"
  blog.default_extension = ".md"

  blog.tag_template = "tag.html"
  blog.calendar_template = "calendar.html"

  # Enable pagination
  blog.paginate = true
  blog.per_page = 10
  # blog.page_link = "page/{num}"
end

page "/feed.xml", layout: false
page "/sitemap.xml", layout: false

activate :directory_indexes


###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

# Change Compass configuration
configure :development do
  set :debug_assets, true

  compass_config do |config|
    config.sass_options = {:debug_info => true}
  end
end

###
# Page options, layouts, aliases and proxies
###

# Slim settings
Slim::Engine.set_default_options :pretty => true
# shortcut
Slim::Engine.set_default_options :shortcut => {
  '#' => {:tag => 'div', :attr => 'id'},
  '.' => {:tag => 'div', :attr => 'class'},
  '&' => {:tag => 'input', :attr => 'type'}
}

# Markdown settings 
set :markdown, :tables => true, :autolink => true, :gh_blockcode => true, :fenced_code_blocks => true, :with_toc_data => true
set :markdown_engine, :redcarpet

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", layout: false
#
# With alternative layout
# page "/path/to/file.html", layout: :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
activate :livereload

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

###
# Site Settings
###
# Set site setting, used in helpers / sitemap.xml / feed.xml.
set :site_url, 'http://billthompson.me'
set :site_author, 'Bill Thompson'
set :site_title, 'Bill Thompson'
set :site_description, 'Bill Thompson - A full-stack software engineer in Austin, TX.'
# Select the theme from bootswatch.com.
# If false, you can get plain bootstrap style.
#set :theme_name, 'flatly'
set :theme_name, 'readable'

# set @analytics_account, like "XX-12345678-9"
@analytics_account = 'UA-19996001-1'

# Asset Settings
set :css_dir, 'css'
set :js_dir, 'js'
set :images_dir, 'images'

set :cache_favicon, true

activate :favicon_maker do |f|
  unless :cache_favicon || File.join(root, 'source', 'favicon.ico').exists?
    avatar_asset_path = File.join(root, 'source', 'images', 'avatar')

    Dir.foreach(avatar_asset_path) do |f|
      fn = File.join(avatar_asset_path, f)
      File.delete(fn) if f != '.' && f != '..'
    end

    agent = Mechanize.new
    author = YAML.load_file(File.join(root, 'data', 'author.yml'))
    agent.get(author['gravatar'].to_s + "?s=152").save "#{avatar_asset_path}/152x152.png"

    f.template_dir  = avatar_asset_path
    f.output_dir    = File.join(root, 'source')
    f.icons = {
        "152x152.png" => [
            { icon: "apple-touch-icon-152x152-precomposed.png" },
            { icon: "apple-touch-icon-114x114-precomposed.png" },
            { icon: "apple-touch-icon-72x72-precomposed.png" },
            { icon: "mstile-144x144", format: :png },
            { icon: "favicon.png", size: "16x16" },
            { icon: "favicon.ico", size: "64x64" },
        ]
    }
  end
end

after_configuration do
  @bower_config = JSON.parse(IO.read("#{root}/.bowerrc"))
  Dir.glob(File.join("#{root}", @bower_config["directory"], "*", "fonts")) do |f|
    sprockets.append_path f
  end
  sprockets.append_path File.join "#{root}", @bower_config["directory"]
end


###
# Target settings
###

# To build the target of "android" you would run:
# MIDDLEMAN_BUILD_TARGET=android middleman build

# require 'middleman-target'
# activate :target do |target|

#  target.build_targets = {
#    "phonegap" => {
#      :includes => %w[android ios]
#    }
#  }

# end

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end

###
# Deploy settings
###
activate :deploy do |deploy|
  deploy.method = :git
  deploy.branch = 'master'
end
# ftp deployment configuration. 
# activate :deploy do |deploy|
#   deploy.method = :ftp
#   deploy.host = "ftp-host"
#   deploy.user = "ftp-user"
#   deploy.password = "ftp-password"
#   deploy.path = "ftp-path"
# end
