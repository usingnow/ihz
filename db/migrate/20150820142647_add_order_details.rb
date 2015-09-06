class AddOrderDetails < ActiveRecord::Migration
  def change
    add_column :free_insurances, :gender, :boolean
    add_column :free_insurances, :id_num, :string
    add_column :free_insurances, :id_type, :string
    add_column :free_insurances, :province, :string
    add_column :free_insurances, :city, :string
    add_column :free_insurances, :address, :string
  end
end
