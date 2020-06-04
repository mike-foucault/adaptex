defmodule AdaptexTest do
  use ExUnit.Case, async: false
  doctest Adaptex

  defprotocol MyInterface do
    def foo_bar0(adapter)
    def foo_bar1(adapter, p1, p2)
    def foo_bar2(adapter)
  end

  defmodule MyFakeSecondaryAdapter do
    use Adaptex.SecondaryAdapter,
      adapter_scope: :kraken,
      gateway: MyInterface

    defstruct hello: "byebye"

    defimpl @adaptex_gateway_api, for: @adaptex_current_adapter do
      def foo_bar0(_adapter), do: :hello_from_adapter_foo_bar0
      def foo_bar1(_adapter, _p1, _p2), do: :hello_from_adapter_foo_bar1
      def foo_bar2(_adapter), do: :hello_from_adapter_foo_bar2
    end
  end

  defmodule MyFakeGateway do
    use Adaptex.Gateway,
      adapter_scope: :kraken,
      gateway: MyInterface,
      default_adapter: MyFakeSecondaryAdapter
  end

  describe "MyFakeGateway" do
    test "MyFakeGateway" do
      assert MyFakeGateway.foo_bar0() == :hello_from_adapter_foo_bar0
      assert MyFakeGateway.foo_bar1(%{coucou: :hello}, 123) == :hello_from_adapter_foo_bar1
      assert MyFakeGateway.foo_bar2() == :hello_from_adapter_foo_bar2

      Protocol.assert_protocol!(MyInterface)
      Protocol.assert_impl!(MyInterface, MyFakeSecondaryAdapter.Adaptex)
    end
  end

  describe "MyFakeSecondaryAdapter" do
    test "MyFakeSecondaryAdapter" do
      assert MyFakeSecondaryAdapter.__struct__() == %MyFakeSecondaryAdapter{hello: "byebye"}

      assert Adaptex.Utils.adapter_for(MyFakeSecondaryAdapter) ==
               MyFakeSecondaryAdapter.Adaptex

      assert Adaptex.Utils.adapter_struct(MyFakeSecondaryAdapter) ==
               %MyFakeSecondaryAdapter.Adaptex{
                 gateway_api: AdaptexTest.MyInterface,
                 adapter_scope: :kraken,
                 adapter_type: "secondary"
               }

      assert MyFakeSecondaryAdapter.Adaptex.__struct__() == %MyFakeSecondaryAdapter.Adaptex{
               gateway_api: AdaptexTest.MyInterface,
               adapter_scope: :kraken,
               adapter_type: "secondary"
             }
    end
  end
end
