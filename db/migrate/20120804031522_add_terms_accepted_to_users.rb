class AddTermsAcceptedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :terms_approved, :boolean
  end
end
