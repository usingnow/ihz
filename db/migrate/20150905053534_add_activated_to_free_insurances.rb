class AddActivatedToFreeInsurances < ActiveRecord::Migration
  def change
    add_column :free_insurances, :activated, :boolean
  end
end
