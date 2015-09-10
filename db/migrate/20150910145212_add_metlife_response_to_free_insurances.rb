class AddMetlifeResponseToFreeInsurances < ActiveRecord::Migration
  def change
    add_column :free_insurances, :metlife_msg, :string
    add_column :free_insurances, :free_insurance_no, :string
  end
end
