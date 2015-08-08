class AddEmailToFreeInsurances < ActiveRecord::Migration
  def change
    add_column :free_insurances, :email, :string
  end
end
