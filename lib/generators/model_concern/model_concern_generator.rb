require 'rails/generators/base'

class ModelConcernGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  argument :concern_name, type: :string, desc: "Add your concern class name"

  def generate_layout
      unless File.directory?("#{Rails.root}/app/models/concerns/")
        empty_directory "#{Rails.root}/app/models/concerns/"
      end
      create_file "app/models/concerns/#{file_name}.rb", concern_class_template
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
