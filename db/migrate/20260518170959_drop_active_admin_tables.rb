class DropActiveAdminTables < ActiveRecord::Migration[8.0]
  def up
    drop_table :admin_users
    drop_table :active_admin_comments
  end

  def down
    create_table :admin_users do |t|
      t.string :email, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.timestamps null: false
    end
    add_index :admin_users, :email, unique: true
    add_index :admin_users, :reset_password_token, unique: true

    create_table :active_admin_comments do |t|
      t.string :namespace
      t.text :body
      t.references :resource, polymorphic: true
      t.references :author, polymorphic: true
      t.timestamps
    end
    add_index :active_admin_comments, :namespace
  end
end
