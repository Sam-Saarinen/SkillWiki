require "application_system_test_case"

class UserFeaturesTest < ApplicationSystemTestCase
  setup do
    @user_feature = user_features(:one)
  end

  test "visiting the index" do
    visit user_features_url
    assert_selector "h1", text: "User Features"
  end

  test "creating a User feature" do
    visit user_features_url
    click_on "New User Feature"

    click_on "Create User feature"

    assert_text "User feature was successfully created"
    click_on "Back"
  end

  test "updating a User feature" do
    visit user_features_url
    click_on "Edit", match: :first

    click_on "Update User feature"

    assert_text "User feature was successfully updated"
    click_on "Back"
  end

  test "destroying a User feature" do
    visit user_features_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "User feature was successfully destroyed"
  end
end
