class AddAuthorityToUsers < ActiveRecord::Migration[6.0]
 def up
    execute <<-SQL
      CREATE TYPE user_authority AS ENUM ('standard', 'admin');
    SQL
    add_column :users, :authority, :user_authority, default: 'standard'
    add_index :users, :authority
  end

  def down
    remove_column :users, :authority
    execute <<-SQL
      DROP TYPE user_authority;
    SQL
  end
end
