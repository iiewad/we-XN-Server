class CreateNews < ActiveRecord::Migration[5.1]
  def change
    create_table :news do |t|
      t.string :title
      t.string :isuser
      t.string :summary
      t.string :addtime
      t.integer :comment_count
      t.string :pic_path
      t.string :big_pic_path
      t.text :content

      t.timestamps
    end
  end
end
