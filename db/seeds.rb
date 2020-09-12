# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

[{
  name: "Dr. Anand Manoharan",
  specialization: "Pediatrician"
}, {
  name: "Dr. Brindha Kandhavel",
  specialization: "General Physician"
}, {
  name: "Dr. Charles Xavier",
  specialization: "Psychiatrist"
}, {
  name: "Dr. David Jonas",
  specialization: "Ortho"
}, {
  name: "Dr. Elakkiya Narayanan",
  specialization: "Gynaecologist"
}].each do |doctor_data|
  Doctor.create(doctor_data)
end

[{
  name: "Ferdinand",
  email: "ferdy@mymail.com",
  password: "Password12",
  password_confirmation: "Password12"
}, {
  name: "Ganesh",
  email: "gany@mymail.com",
  password: "Password34",
  password_confirmation: "Password34"
}].each do |user_data|
  User.create(user_data)
end
