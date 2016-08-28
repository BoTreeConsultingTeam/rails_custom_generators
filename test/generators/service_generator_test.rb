require 'test_helper'
require 'generators/service/service_generator'

class ServiceGeneratorTest < Rails::Generators::TestCase
  tests ServiceGenerator
  destination File.expand_path("../tmp", File.dirname(__FILE__))
  setup :prepare_destination

  # If no extra argument is given then generate foo_serive in service folder and
  # related test cases in test/services/ folder.
  # Default method for service is 'call' method
  test "should create appropriate files in service and test folders" do
    # This will simulate generator like command line arguments rails g service FooService
    run_generator %w(FooService)

    assert_file 'app/services/foo_service.rb'

    # checks for the file and content inside it. It matches the content with the
    # given regex as a second argument
    assert_file 'app/services/foo_service.rb', /def call/
    assert_file 'test/services/foo_service_test.rb'
  end

  test "should create methods if method is passed as argument" do
    # This will simulate generator like command line arguments rails g service BarService test
    # Will be considered as BarService#test
    run_generator %w(BarService test)

    assert_file 'app/services/bar_service.rb', /def test/
    assert_file 'test/services/bar_service_test.rb'

    assert_file "app/services/bar_service.rb" do |service|
      assert_instance_method :test, service do |test|
        assert_match(/write your code here/, test)
      end
    end
  end

  # This will check if user pass command from terminal without any argument
  # For exmaple,
  # rails g service
  # without any argument it will throw Thor::RequiredArgumentMissingError
  test "should throw error if no argument passed with service generator" do
    assert_raise Thor::RequiredArgumentMissingError do
      assert_raise run generator []
    end
    assert_no_directory 'app/services'
    assert_no_directory 'test/services'
  end

  # This check is for nested directory structure. If user passed namespaced
  # arguments seperated by '/' then it generator should create nested directory
  # structure with namespaced class name
  # For exmaple,
  # rails g service foo/BarService
  # Will generate,
  # directory like app/services/foo/ and class will look like, Foo::BarService
  test "should create nested directory structure for namespaced services" do
    run_generator %w(Foo/BarService test)

    assert_file 'app/services/foo/bar_service.rb', /class Foo::BarService/
    assert_file 'test/services/foo/bar_service_test.rb'

    assert_file "app/services/foo/bar_service.rb" do |service|
      assert_instance_method :test, service do |test|
        assert_match(/write your code here/, test)
      end
    end
  end

  # If user tries to generate service with already name with underscores then
  # create dont convert it to underscores and create appropriate service
  # For example,
  # rails g service foo_bar
  # Should create services/foo_bar.rb with FooBar class and same applies to tests
  test "shold create appropriate service with already underscored named service" do
    run_generator %w(bar_service)

    assert_file 'app/services/bar_service.rb', /class BarService/
    assert_file 'test/services/bar_service_test.rb'
    assert_file "app/services/bar_service.rb" do |service|
      assert_instance_method :call, service do |call|
        assert_match(/write your code here/, call)
      end
    end
  end
end
