require 'rails/generators/base'

class ControllerConcernGenerator < Rails::Generators::Base

  source_root File.expand_path('../templates', __FILE__)

  argument :concern_name, type: :string, desc: "Add your concern class name"

  def generate_layout
      unless File.directory?("#{Rails.root}/app/controllers/concerns/")
        empty_directory "#{Rails.root}/app/controllers/concerns/"
      end
      create_file "app/controllers/concerns/#{file_name}.rb", concern_class_template
  end

  private

  def file_name
    concern_name.underscore
  end

  def concern_class_template
<<-FILE
module #{file_name.classify}
  extend ActiveSupport::Concern
end
FILE
  end

end
