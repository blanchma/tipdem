# -*- encoding : utf-8 -*-
module HelperMethods
  def login_with(user)
    user.confirm!
    visit "/users/sign_in"
    fill_in "user_login",     :with => user.email
    fill_in "user_password", :with => "lapassword"
    click_on "user_submit"
  end

  def should_be_on(path)
    page.current_url.should match(Regexp.new(path))
  end

  def should_not_be_on(path)
    page.current_url.should_not match(Regexp.new(path))
  end

  def should_have_errors(*messages)
    within(:css, "#errorExplanation") do
      messages.each { |msg| page.should have_content(msg) }
    end
  end
  alias_method :should_have_error, :should_have_errors

  def fill_the_following(fields={})
    fields.each do |field, value|
      fill_in field,  :with => value
    end
  end

  def should_have_the_following(*contents)
    contents.each do |content|
      page.should have_content(content)
    end
  end

  def should_have_table(table_name, *rows)
    within(table_name) do
      rows.each do |columns|
        columns.each { |content| page.should have_content(content) }
      end
    end
  end

 


end

Spec::Runner.configuration.include(HelperMethods)
