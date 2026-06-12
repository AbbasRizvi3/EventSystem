require 'bcrypt'
encrypted_password = BCrypt::Password.create("password123")
now = Time.current

admin_role_id = Role.find_or_create_by!(name: "admin").id
attendee_role_id = Role.find_or_create_by!(name: "attendee").id
organizer_role_id = Role.find_or_create_by!(name: "organizer").id

unless User.exists?(email: "admin@admin.com")
  user_id = User.insert(
    { name: "Admin", email: "admin@admin.com", encrypted_password: encrypted_password, confirmed_at: now, created_at: now, updated_at: now },
    returning: [ "id" ]
  ).first["id"]
  UserRole.insert({ user_id: user_id, role_id: admin_role_id, created_at: now, updated_at: now })
  puts "Admin created: admin@admin.com / password123"
end

unless User.exists?(email: "organizer@organizer.com")
  user_id = User.insert(
    { name: "Organizer", email: "organizer@organizer.com", encrypted_password: encrypted_password, confirmed_at: now, created_at: now, updated_at: now },
    returning: [ "id" ]
  ).first["id"]
  UserRole.insert({ user_id: user_id, role_id: organizer_role_id, created_at: now, updated_at: now })
  puts "Organizer created: organizer@organizer.com / password123"
end

unless User.exists?(email: "attendee@attendee.com")
  user_id = User.insert(
    { name: "Attendee", email: "attendee@attendee.com", encrypted_password: encrypted_password, confirmed_at: now, created_at: now, updated_at: now },
    returning: [ "id" ]
  ).first["id"]
  UserRole.insert({ user_id: user_id, role_id: attendee_role_id, created_at: now, updated_at: now })
  puts "Attendee created: attendee@attendee.com / password123"
end
