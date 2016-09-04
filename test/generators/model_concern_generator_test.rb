require 'test_helper'
require 'generators/model_concern/model_concern_generator'

class ModelConcernGeneratorTest < Rails::Generators::TestCase
  tests ModelConcernGenerator
  destination File.expand_path("../tmp", File.dirname(__FILE__))
  setup :prepare_destination

  # If no extra argument is given then generate foo_serive in service folder and
  # related test cases in test/services/ folder.
  # Default method for service is 'call' method
  test "should create appropriate files in model/concerns" do
    # This will simulate generator like command line arguments rails g model_concern MyConcern
    run_generator %w(MyConcern)

    assert_directory 'app/models/concerns'

    # checks for the file and content inside it. It matches the content with the
    # given regex as a second argument
    assert_file 'app/models/concerns/my_concern.rb', /extend ActiveSupport::Concern/
  end

  # This will check if user pass command from terminal without any argument
  # For exmaple,
  # rails g model_concern
  # without any argument it will throw Thor::RequiredArgumentMissingError
  test "should throw error if no argument passed with service generator" do
    assert_raise Thor::RequiredArgumentMissingError do
      assert_raise run generator []
    end
    assert_no_directory 'app/models/concerns'
  end

  # This check is for nested directory structure. If user passed namespaced
  # arguments seperated by '/' then it generator should create nested directory
  # structure with namespaced class name
  # For exmaple,
  # rails g service foo/BarService
  # Will generate,
  # directory like app/services/foo/ and class will look like, Foo::BarService
  test "should create nested directory structure for namespaced services" do
    run_generator %w(Foo/Bar)

    assert_file 'app/models/concerns/foo/bar.rb', /module Foo::Bar/
    assert_file "app/models/concerns/foo/bar.rb", /extend ActiveSupport::Concern/
  end

  # If user tries to generate service with already name with underscores then
  # create dont convert it to underscores and create appropriate service
  # For example,
  # rails g service foo_bar
  # Should create services/foo_bar.rb with FooBar class and same applies to tests
  test "shold create appropriate service with already underscored named service" do
    run_generator %w(foo_bar)

    assert_file 'app/models/concerns/foo_bar.rb', /module FooBar/
    assert_file "app/models/concerns/foo_bar.rb", /extend ActiveSupport::Concern/
  end
end
