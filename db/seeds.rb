# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb

puts "Destroying all records..."
Enrollment.destroy_all
Student.destroy_all
Course.destroy_all
User.destroy_all
Teacher.destroy_all

puts "Creating users..."
10.times do
  User.create!(
    name: Faker::Name.name, # <-- Add this line
    email: Faker::Internet.unique.email,
    password: 'password',
    password_confirmation: 'password'
  )
end
users = User.all

puts "Creating courses..."
50.times do
  start_date = Faker::Date.forward(days: 365)
  end_date = start_date + rand(30..90).days
  Course.create!(
    name: Faker::Educator.course_name,
    description: Faker::Lorem.paragraph,
    start_date: start_date,
    end_date: end_date,
    address: Faker::Address.full_address,
    weekly_schedule: [
      { day: "Monday", start_time: "18:00", end_time: "20:00" },
      { day: "Wednesday", start_time: "18:00", end_time: "20:00" }
    ]
  )
end
courses = Course.all

puts "Creating students..."
100.times do
  Student.create!(
    first_name: Faker::Name.name.split.first,
    last_name: Faker::Name.name,
    email: Faker::Internet.unique.email
  )
end
students = Student.all

puts "Creating enrollments..."
200.times do
  Enrollment.create!(
    course: courses.sample,
    student: students.sample,
  )
end

puts "Creating teachers..."
5.times do
  Teacher.create!(
    name: Faker::Name.name,
    phone_number: Faker::PhoneNumber.phone_number,
    email: Faker::Internet.unique.email
  )
end

puts "Seeding finished!"
puts "#{User.count} users created."
puts "#{Course.count} courses created."
puts "#{Student.count} students created."
puts "#{Enrollment.count} enrollments created."
puts "#{Teacher.count} teachers created."
