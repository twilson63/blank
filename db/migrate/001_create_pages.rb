class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :name
      t.text :body
      t.integer :page_id
      t.string :page_type

      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end