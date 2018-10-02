class CreatePractices < ActiveRecord::Migration
  def change
    create_table :practices do |t|
      t.string :attribute1
      t.string :attribute2

      t.timestamps
    end
  end
end
