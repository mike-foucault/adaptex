defmodule Adaptex do
  defmodule Utils do
    def gateway_functions(gateway), do: gateway.__protocol__(:functions)

    def extract_struct(adapter), do: adapter.__struct__()

    def adapter_struct(adapter),
      do: adapter |> adapter_for() |> extract_struct()

    def adapter_for(adapter),
      do: [adapter, Adaptex] |> Module.concat()

    def adapter_scope(options),
      do: Keyword.get(options, :adapter_scope, nil)

    def config(options) do
      %{
        gateway: Keyword.get(options, :gateway, nil),
        default_adapter: Keyword.get(options, :default_adapter, nil)
      }
    end
  end

  defmodule Gateway do
    defmacro __using__(options) do
      %{gateway: gateway, default_adapter: default_adapter} = Utils.config(options)

      attribute_definition_quote =
        quote bind_quoted: [gateway: gateway, default_adapter: default_adapter] do
          Module.put_attribute(__MODULE__, :adaptex_gateway_api, gateway)

          Module.put_attribute(
            __MODULE__,
            :adaptex_default_adapter,
            Utils.adapter_for(default_adapter)
          )
        end

      gateway_function_delegation_quote =
        quote unquote: false do
          varify = fn pos ->
            Macro.var(String.to_atom("arg" <> Integer.to_string(pos)), __MODULE__)
          end

          funs =
            @adaptex_gateway_api
            |> Utils.gateway_functions()
            |> Macro.escape()
            |> List.wrap()

          for {name, arity} <- funs do
            args = :lists.map(varify, :lists.seq(2, arity))
            call_args = [quote(do: Utils.extract_struct(@adaptex_default_adapter)) | args]

            def unquote(name)(unquote_splicing(args)) do
              unquote(@adaptex_gateway_api).unquote(name)(unquote_splicing(call_args))
            end
          end
        end

      quote do
        unquote(attribute_definition_quote)
        unquote(gateway_function_delegation_quote)
      end
    end
  end

  defmodule SecondaryAdapter do
    defmacro __using__(options) do
      %{gateway: gateway} = Utils.config(options)

      adaptex_quote =
        quote bind_quoted: [gateway: gateway, adapter_scope: Utils.adapter_scope(options)] do
          defmodule Adaptex do
            defstruct gateway_api: gateway,
                      adapter_scope: adapter_scope,
                      adapter_type: "secondary"
          end

          Module.put_attribute(__MODULE__, :adaptex_gateway_api, gateway)
          Module.put_attribute(__MODULE__, :adaptex_current_adapter, Adaptex)
        end

      quote do
        unquote(adaptex_quote)
      end
    end
  end
end
