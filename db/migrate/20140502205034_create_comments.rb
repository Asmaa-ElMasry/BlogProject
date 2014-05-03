class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :comment
      t.integer :report
      t.references :post, index: true

      t.timestamps
    end
  end
end
