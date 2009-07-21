require 'test_helper'

class ClicksControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:clicks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create clicks" do
    assert_difference('Clicks.count') do
      post :create, :clicks => { }
    end

    assert_redirected_to clicks_path(assigns(:clicks))
  end

  test "should show clicks" do
    get :show, :id => clicks(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => clicks(:one).to_param
    assert_response :success
  end

  test "should update clicks" do
    put :update, :id => clicks(:one).to_param, :clicks => { }
    assert_redirected_to clicks_path(assigns(:clicks))
  end

  test "should destroy clicks" do
    assert_difference('Clicks.count', -1) do
      delete :destroy, :id => clicks(:one).to_param
    end

    assert_redirected_to clicks_path
  end
end
