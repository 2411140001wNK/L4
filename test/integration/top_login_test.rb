require "test_helper"

class TopLoginTest < ActionDispatch::IntegrationTest
  test "root displays login form when logged out" do
    get root_path

    assert_response :success
    assert_select "form[action='/top/login']"
    assert_select "input[name='uid']"
    assert_select "input[name='pass'][type='password']"
  end

  test "valid credentials establish a session" do
    post "/top/login", params: { uid: "kindai", pass: "sanriko" }

    assert_redirected_to top_main_path
    follow_redirect!
    assert_response :success
    assert_select "h1", "ログイン成功"
  end

  test "a copied session cookie restores logged-in access" do
    logged_in_client = open_session
    logged_in_client.post "/top/login", params: { uid: "kindai", pass: "sanriko" }
    session_cookie = logged_in_client.cookies["_l4_session"]

    copied_client = open_session
    copied_client.cookies["_l4_session"] = session_cookie
    copied_client.get root_path

    copied_client.assert_select "h1", "ログイン成功"
  end

  test "invalid credentials show a generic error" do
    post "/top/login", params: { uid: "kindai", pass: "wrong" }

    assert_response :success
    assert_select "p", "IDまたはパスワードが違います"

    get top_main_path
    assert_select "h1", "ログイン"
  end
end
