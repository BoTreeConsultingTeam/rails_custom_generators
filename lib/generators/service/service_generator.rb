require 'rails/generators/base'

class ServiceGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  argument :service_name, type: :string, desc: "Add your service class name"
  argument :fields, :type => :array, default: ['call'], :desc => "Service methods list"

  def   generate_layout
    unless File.directory?("#{Rails.root}/app/services")
      empty_directory "#{Rails.root}/app/services"
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
#{service_methods.chomp}
  #add more methods here
end
FILE
  end

  def service_methods
    if fields.present?
      methods_available = fields.map(&:underscore)
      method_calls = ""
      methods_available.each do |method_name|
      method_calls.concat(
<<-METHOD
  def #{method_name}
    # write your code here
  end\n
METHOD
)
      end
      method_calls
    else
<<-METHOD
  def call
    # write your code here
  end
METHOD
    end
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
