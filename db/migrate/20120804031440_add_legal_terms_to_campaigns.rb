class AddLegalTermsToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :legal_terms, :string
  end
end
