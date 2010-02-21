class CreatePages < Sequel::Migration
  def up
    create_table(:pages) do
      primary_key :id
      String :name
      Text :body
      Integer :page_id
      String :page_type

      timestamp :created_at
      timestamp :updated_at
       
    end
    
  end

  def down
    drop_table(:pages)
  end
end