require 'rails/generators/base'

class ServiceGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  argument :service_name, type: :string, desc: "Add your service class name"

  def   generate_layout
    unless File.directory?("#{Rails.root}/app/services")
        # directory "/app", 'service'
      directory "#{Rails.root}/app/", "#{Rails.root}/app/services", recursive: false
    end
    create_file "app/services/#{file_name}.rb", service_class_template

    # creates a test case directory
    unless File.directory?("#{Rails.root}/test")
      directory "#{Rails.root}/test/", 'services'
    end

    # creates a test file
    create_file "test/services/#{file_name}_test.rb", service_class_test_template
  end

  private

  def service_class_template
    <<-FILE
class #{file_name.classify}
  def call
  end
end
    FILE
  end

  def service_class_test_template
    <<-FILE
require 'test_helper'

class #{file_name.classify}ServiceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
    FILE
  end

  def file_name
    service_name.underscore
  end
end
