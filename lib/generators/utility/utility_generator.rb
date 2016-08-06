require 'rails/generators/base'

class UtilityGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  argument :utility_name, type: :string, desc: "Add your utility class name"

  def generate_layout
    unless File.directory?("#{Rails.root}/lib/utilities")
        # directory "/app", 'service'
      directory "#{Rails.root}/lib/", "#{Rails.root}/lib/utilities", recursive: false
    end
    create_file "lib/utilities/#{file_name}.rb", utility_class_template
  end

  private

  def utility_class_template
    <<-FILE
class #{file_name.classify}

end
    FILE
  end

  def file_name
    utility_name.underscore
  end
end
