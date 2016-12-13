defmodule Annotatable do
  defmacro __using__(args) do
    quote do
      def __on_annotation_(_) do
        quote do end
      end
      @annotations %{}
      @supported_annotations unquote(args)
      @on_definition { unquote(__MODULE__), :__on_definition__ }
      @before_compile { unquote(__MODULE__), :__before_compile__ }
      import Annotatable
      require Annotatable
    end
  end

  def __on_definition__(env, kind, name, args, guards, body) do
    Module.get_attribute(env.module, :supported_annotations) |> Enum.each &annotate_method(&1, env.module, name)
  end

  def annotate_method(annotation, module, method) do
    annotations = Module.get_attribute(module, :annotations)
    value = Module.get_attribute(module, annotation)
    Module.delete_attribute(module, annotation)
    update_annotations(annotation, annotations, module, method, value)
  end

  def update_annotations(_, _, _, _, nil), do: :no_op

  def update_annotations(annotation, annotations, module, method, value) do
    method_annotations = Map.get(annotations, method, []) ++ [%{ annotation: annotation, value: value}]
    Module.put_attribute(module, :annotations, annotations |> Map.put(method, method_annotations))
  end

  defmacro __before_compile__(env) do
    quote do
      def annotations do
         @annotations
      end
    end

  end
end
