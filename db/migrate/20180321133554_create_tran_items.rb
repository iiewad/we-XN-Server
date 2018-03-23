class CreateTranItems < ActiveRecord::Migration[5.1]
  def change
    create_table :tran_items do |t|
      t.string :trancode
      t.string :tranname

      t.timestamps
    end
  end
end
