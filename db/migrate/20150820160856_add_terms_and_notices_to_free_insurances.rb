class AddTermsAndNoticesToFreeInsurances < ActiveRecord::Migration
  def change
    add_column :free_insurances, :accepted_terms, :boolean
    add_column :free_insurances, :accepted_notices, :boolean
  end
end
