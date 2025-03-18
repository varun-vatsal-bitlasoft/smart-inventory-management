require "test_helper"

class ProductTransactionsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get product_transactions_show_url
    assert_response :success
  end

  test "should get insert" do
    get product_transactions_insert_url
    assert_response :success
  end
end
