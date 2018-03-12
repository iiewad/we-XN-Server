class CreateStuGrades < ActiveRecord::Migration[5.1]
  def change
    create_table :stu_grades do |t|
      t.string :xn
      t.string :xq
      t.string :xh
      t.string :xm
      t.string :kcmc
      t.string :xf
      t.string :cj
      t.string :kcxz

      t.timestamps
    end
  end
end
