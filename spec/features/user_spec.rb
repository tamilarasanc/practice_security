require 'spec_helper'
require 'rails_helper'

require 'capybara/poltergeist'

require 'selenium-webdriver'

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

RSpec.configure do |config|
  # Not supported while using Capybara
  config.use_transactional_fixtures = false
  DatabaseCleaner.strategy = :truncation
end


RSpec.describe 'Regular User', type: :feature do
  before(:each) do
    DatabaseCleaner.start
    DatabaseCleaner.clean

    # @admin = create(:user)
      @user  = User.create(email: "deva@gmail.com", password: "deva",admin: false)
    @user1  = User.create(email: "tamil@gmail.com", password: "tamil",admin: true)
    @user2  = User.create(email: "lokesh@gmail.com", password: "lokesh",admin: true)
  end

  after(:each) do
    DatabaseCleaner.clean
  end

  it "should logout and go to login page if normal user try to load users index page", :js => true do

    visit root_path
    fill_in 'email', with: 'deva@gmail.com'
    fill_in 'password', with: 'deva'
    click_button 'login'

    visit admin_index_path

    # Check for error message
    ## expect(page).to have_css('p.flash')
    expect(page).to have_content('you are not admin')

    # Check for existence of login button (you can use CSS selectors as well)
    #expect(page).to have_xpath('//input[@value="login" and @type="submit"]')
  end

  it "should view the normal users details and update the details of the current user and change password and logout", :js => true do

    visit root_path
    fill_in 'email', with: 'deva@gmail.com'
    fill_in 'password', with: 'deva'
    click_button 'login'


    click_link 'Edit'

    fill_in 'user[name]', with: 'deva1'
    fill_in 'user[email]', with: 'deva@gmail.com'
    fill_in 'user[description]', with: 'test2'
    ##expect(page).to have_text('Succesfully updated')
    click_button 'Update User'

    click_link 'Change Password'

    fill_in 'exist_password', with: 'deva'
    fill_in 'new_password', with: 'deva1'
    fill_in 'confirm_password', with: 'deva1'
    click_button 'update_password'
    ##expect(page).to have_text('Password updated succesfully')

    click_link 'Log out'
    ##expect(page).to have_text('logged out successfully')

    fill_in 'email', with: 'deva@gmail.com'
    fill_in 'password', with: 'deva1'
    click_button 'login'
    expect(page).to have_link('Change Password')


    # Check for existence of login button (you can use CSS selectors as well)
    ##expect(page).to have_xpath('//input[@value="login" and @type="submit"]')
  end

  it "admin only can create new user", :js => true do

    visit root_path
    fill_in 'email', with: 'deva@gmail.com'
    fill_in 'password', with: 'deva'
    click_button 'login'

     visit new_admin_path
    expect(page).to have_content('you are not admin')

  end

  it "admin can create any user with admin access", :js => true do

    visit root_path
    fill_in 'email', with: 'tamil@gmail.com'
    fill_in 'password', with: 'tamil'
    click_button 'login'

    click_link 'New user'

    fill_in 'user[name]', with: 'jegan@gmail.com'
    fill_in 'user[password]', with: 'jegan'
    fill_in 'user[description]', with: 'test3'
    check 'user_admin'
    click_button 'Create User'
    expect(page).to have_content('Admin creates a user and given admin access')
  end

  it "admin can make other admin to normal user", :js => true do

    visit root_path
    fill_in 'email', with: 'tamil@gmail.com'
    fill_in 'password', with: 'tamil'
    click_button 'login'
    click_link('Edit', :href => edit_admin_path(@user2))
    uncheck 'user[admin]'
    click_button 'Update User'
    expect(page).to have_content('User is downgraded from Admin to Normal User')
  end

  it "admin can make normal user to admin", :js => true do

    visit root_path
    fill_in 'email', with: 'tamil@gmail.com'
    fill_in 'password', with: 'tamil'
    click_button 'login'
    click_link('Edit', :href => edit_admin_path(@user))
    check 'user[admin]'
    click_button 'Update User'
    expect(page).to have_content('User is upgraded from Normal user to admin')
  end

end
