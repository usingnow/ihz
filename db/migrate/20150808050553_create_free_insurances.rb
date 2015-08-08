class CreateFreeInsurances < ActiveRecord::Migration
  def change
    create_table :free_insurances do |t|
      t.string :user
      t.string :mobile
      t.date :birthday
      t.boolean :processed
      t.boolean :accepted

      t.timestamps null: false
    end
  end
end
