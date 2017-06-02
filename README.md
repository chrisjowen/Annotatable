# Annotatable

Add simple annotations to elixir methods which can be used later to do some funkiness see https://medium.com/@cowen/annotations-in-elixir-450015ecdd97

## Usage

```
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

```

And later:

```
  Example.annotations
```

Gives:
```
%{
  bar_method: [%{annotation: :bar, value: true}],
  foo_bar_method: [
    %{annotation: :bar, value: true},
    %{annotation: :foo, value: [:test]}
   ]
 }
```


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `annotatable` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:annotatable, "~> 0.1.0"}]
    end
    ```

  2. Ensure `annotatable` is started before your application:

    ```elixir
    def application do
      [applications: [:annotatable]]
    end
    ```
