class AddPreorderIdToFreeInsurances < ActiveRecord::Migration
  def change
    add_column :free_insurances, :preorder_id, :integer
    
    add_index :free_insurances, :id
    add_index :free_insurances, :preorder_id
    add_index :free_insurances, :user
    add_index :free_insurances, :mobile
  end
end
