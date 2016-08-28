require 'test_helper'
require 'generators/utility/utility_generator'
class UtilityGeneratorTest < Rails::Generators::TestCase
  tests UtilityGenerator
  destination File.expand_path("../tmp", File.dirname(__FILE__))
  setup :prepare_destination

  # User passes command like, rails g utility Foo
  # should create foo.rb file with Foo class inside lib/utilities
  test "should create utility file named based on arguments passed" do
    run_generator %w(Foo)
    assert_file "lib/utilities/foo.rb", /class Foo/
  end

  test "should create nested directory with namespaced class" do
    # should create nested directory structure for namespaced class
    run_generator %w(foo/bar)
    assert_file "lib/utilities/foo/bar.rb", /class Foo::Bar/

    # Create new utility in same namespace with another utility class
    # should be added in same direcotory with new class file
    run_generator %w(foo/baz)
    assert_file "lib/utilities/foo/baz.rb", /class Foo::Baz/
  end
end
