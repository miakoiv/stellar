class AssignRoleResources < ActiveRecord::Migration

  # Assigns existing roles a store resource from the user's associated store.
  # Note: the superuser role will remain global.
  def up
    User.transaction do
      User.non_guest.each do |user|
        store, roles = user.store, user.roles.pluck(:name)
        roles.each do |role|
          next if role == 'superuser'
          user.remove_role role
          user.add_role role, store
        end
      end
    end
  end

  def down
    User.transaction do
      User.non_guest.each do |user|
        store, roles = user.store, user.roles.pluck(:name)
        roles.each do |role|
          next if role == 'superuser'
          user.remove_role role, store
          user.add_role role
        end
      end
    end
  end
end
