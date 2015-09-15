class CreatePreorders < ActiveRecord::Migration
  def change
    create_table :preorders do |t|
      t.string :user
      t.string :id_num
      t.boolean :gender
      t.string :mobile
      t.text :remarks
      t.boolean :used

      t.timestamps null: false
    end
    add_index :preorders, :id
  end
end
