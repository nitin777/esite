require 'test_helper'

class TodoSharesControllerTest < ActionController::TestCase
  setup do
    @todo_share = todo_shares(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:todo_shares)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create todo_share" do
    assert_difference('TodoShare.count') do
      post :create, todo_share: { share_user_id: @todo_share.share_user_id, user_id: @todo_share.user_id }
    end

    assert_redirected_to todo_share_path(assigns(:todo_share))
  end

  test "should show todo_share" do
    get :show, id: @todo_share
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @todo_share
    assert_response :success
  end

  test "should update todo_share" do
    put :update, id: @todo_share, todo_share: { share_user_id: @todo_share.share_user_id, user_id: @todo_share.user_id }
    assert_redirected_to todo_share_path(assigns(:todo_share))
  end

  test "should destroy todo_share" do
    assert_difference('TodoShare.count', -1) do
      delete :destroy, id: @todo_share
    end

    assert_redirected_to todo_shares_path
  end
end
