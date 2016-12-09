defmodule Annotatable do
  defmacro __using__(args) do
    quote do
      @annotations %{}
      @supported_annotations unquote(args)
      @on_definition { unquote(__MODULE__), :__on_definition__ }
      @before_compile { unquote(__MODULE__), :__before_compile__ }
      import Annotatable
    end
  end

  def __on_definition__(env, kind, name, args, guards, body) do
    supported_annotations =  Module.get_attribute(env.module, :supported_annotations)
    supported_annotations |> Enum.each fn supported_annotation ->
      annotations = Module.get_attribute(env.module, :annotations)
      value = Module.get_attribute(env.module, supported_annotation)
      if(value) do
        Module.delete_attribute(env.module, supported_annotation)
        method_annotations = Map.get(annotations, name, []) ++ [%{ annotation: supported_annotation, value: value}]
        Module.put_attribute(env.module, :annotations, annotations |> Map.put(name, method_annotations))
      end
    end
  end

  defmacro __before_compile__(env) do
    quote do
      def annotations do
         @annotations
      end
    end
  end
end
