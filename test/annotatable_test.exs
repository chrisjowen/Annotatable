defmodule AnnotatableTest do
  use ExUnit.Case
  doctest Annotatable


  defmodule Example do
    use Annotatable, [:bar, :foo]

    @bar true
    def bar_method do end

    @foo [:test]
    @bar true
    def foo_bar_method do end

    def no_annotation_method do end

    @baz "ads"
    def undefined_annotation_method do end
  end

  test "Example should contain single annotation if registered" do
    assert Example.annotations.bar_method == [%{annotation: :bar, value: true}]
  end

  test "Example should contain multipule annotations if registered" do
    assert Example.annotations.foo_bar_method == [%{annotation: :bar, value: true},%{annotation: :foo, value: [:test]}]
  end

  test "Example should not contain annoations if undefined annotation on method" do
    assert Example.annotations |> Map.has_key?(:undefined_annotation_method) == false
  end

  test "Example should not contain annoations in no annotations on method" do
    assert Example.annotations |> Map.has_key?(:no_annotation_method) == false
  end

  test "Example get methods annotated with bat" do
    assert Example.annotated_with(:bar) == [:bar_method, :foo_bar_method]
  end

end
