# db/seeds.rb

puts "Destroying all records..."
Attendance.destroy_all # Destroy attendances first due to dependencies
Enrollment.destroy_all
Student.destroy_all
Course.destroy_all
User.destroy_all
Teacher.destroy_all

puts "Creating users..."
# Fixed admin user for easy login
User.create!(
  name: "Admin User",
  email: "admin@example.com",
  password: "password",
  password_confirmation: "password",
  role: :administrator
)

9.times do
  User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.unique.email,
    password: 'password',
    password_confirmation: 'password'
  )
end
users = User.all

puts "Creating teachers..."
5.times do
  Teacher.create!(
    name: Faker::Name.name,
    phone_number: Faker::PhoneNumber.phone_number,
    email: Faker::Internet.unique.email
  )
end
teachers = Teacher.all

puts "Creating courses..."
# Create courses with a mix of past and future dates
courses = []
20.times do |i|
  # Half of the courses started in the past
  start_date = i < 10 ? Faker::Date.backward(days: 60) : Faker::Date.forward(days: 30)
  end_date = start_date + 90.days
  
  courses << Course.create!(
    name: Faker::Educator.course_name,
    description: Faker::Lorem.paragraph,
    start_date: start_date,
    end_date: end_date,
    address: Faker::Address.full_address,
    teacher: teachers.sample,
    weekly_schedule: [
      { "day" => "Monday", "start_time" => "18:00", "end_time" => "20:00", "enabled" => "1" },
      { "day" => "Wednesday", "start_time" => "18:00", "end_time" => "20:00", "enabled" => "1" },
      { "day" => "Friday", "start_time" => "18:00", "end_time" => "20:00", "enabled" => "1" }
    ]
  )
end

puts "Creating students..."
50.times do
  Student.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.unique.email,
    phone: Faker::PhoneNumber.phone_number, # Corrected from phone_number
    date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 65),
    tax_code: Faker::IdNumber.brazilian_citizen_number # Just a placeholder for tax code
  )
end
students = Student.all

puts "Creating enrollments..."
enrollments = []
courses.each do |course|
  # Enroll 10-15 students per course
  students.sample(rand(10..15)).each do |student|
    enrollments << Enrollment.create!(
      course: course,
      student: student
    )
  end
end

puts "Creating attendances (this might take a moment)..."
attendance_count = 0
enrollments.each do |enrollment|
  course = enrollment.course
  student = enrollment.student
  
  next if course.start_date > Date.today # Skip future courses
  
  # Calculate valid class dates in the past
  wdays = course.weekly_schedule.map { |s| s["day"].downcase }
  
  (course.start_date..[course.end_date, Date.today].min).each do |date|
    day_name = date.strftime("%A").downcase
    if wdays.include?(day_name)
      # 80% attendance rate
      if rand < 0.8
        Attendance.create!(
          student: student,
          course: course,
          attended_on: date.to_datetime.change(hour: 18), # Set time to match schedule
          created_at: date.to_datetime.change(hour: 18), # Set created_at to match for realism
          manual: rand < 0.3 # 30% are manual entries
        )
        attendance_count += 1
      end
    end
  end
end

puts "Seeding finished!"
puts "#{User.count} users created."
puts "#{Course.count} courses created."
puts "#{Student.count} students created."
puts "#{Enrollment.count} enrollments created."
puts "#{Teacher.count} teachers created."
puts "#{attendance_count} attendances created."
