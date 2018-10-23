#Added by => rails generate migration add_admin_to_users admin:boolean
#The migration simply adds the admin column to the users table (List- ing 9.39), yielding the data model in Figure 9.13. (pg. 492) 

class AddAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean, default: false #Note that we’ve added the argument default: false to add_column in Listing 9.39, which means that users will not be administrators by default.
  end
end
