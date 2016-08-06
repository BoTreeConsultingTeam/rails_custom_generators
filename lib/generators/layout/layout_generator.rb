class LayoutGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  argument :name, type: :string, default: "application"
  class_option :stylesheet, :type => :boolean, :default => true, :description => "Include stylesheet file"
  class_option :javascript, :type => :boolean, :default => true, :description => "Include javascript file"

  def generate_layout
    create_file "app/assets/stylesheets/#{file_name}.css" if options.stylesheet?
    create_file "app/assets/javascripts/#{file_name}.js" if options.javascript?
    template "layout.html.erb", "app/views/layouts/#{file_name}.html.erb"
  end

  private

  def file_name
    name.underscore
  end
end
