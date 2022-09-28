puts "============ SEEDS - START ============"
puts "Clear databases"
Answer.delete_all
Survey.delete_all
Template.delete_all
Course.delete_all
User.delete_all
Role.delete_all

puts "Generate an Admin"
user_admin = User.find_or_create_by(email: 'admin@sead.com')
user_admin.password = '12345!'
user_admin.password_confirmation = '12345!'
user_admin.fullname = 'Admin'
user_admin.code = 20100501
user_admin.save!
user_admin.add_role :admin

puts "Generate a Teacher"
user_teacher = User.find_or_create_by(email: 'teacher@sead.com')
user_teacher.password = '12345!'
user_teacher.password_confirmation = '12345!'
user_teacher.fullname = 'Teacher'
user_teacher.code = 20001010
user_teacher.save!
user_teacher.add_role :teacher

puts "Generate a Student"
user_student = User.find_or_create_by(email: 'student@sead.com')
user_student.password = '12345!'
user_student.password_confirmation = '12345!'
user_student.fullname = 'Student'
user_student.code = 20100505
user_student.save!
user_student.add_role :student

puts "Populate Courses"
7.times do |n|
  Course.create(
    code: "NTZ00#{n+1}",
    name: "Mate #{n+1}"
  )
  print "."
end

puts "\nPopulate Students"
%w[
  alvertou 
  boby 
  chosita 
  dentista 
  elegante 
  famoso 
  grande 
  hipo 
  inocencio 
  julio 
  kamilo 
  lourdes 
  mateo 
  nolvert 
  omero 
  paulcito 
  qevin
].each_with_index do |val, index|
  user_student = User.find_or_create_by(email: "#{val}@sead.com")
  user_student.password = '12345!'
  user_student.password_confirmation = '12345!'
  user_student.fullname = val.upcase
  user_student.code = (30100505 + index)
  user_student.course_ids = [1, 2, 3]
  user_student.save!
  user_student.add_role :student

  print "."
end

puts "\nPopulate Teachers"
%w[
  juan
  luis
  tania
  tatiana
  maria
  helen
].each_with_index do |val, index|
  user_teacher = User.find_or_create_by(email: "#{val}@sead.com")
  user_teacher.password = '12345!'
  user_teacher.password_confirmation = '12345!'
  user_teacher.fullname = val.upcase
  user_teacher.code = (30100600 + index)
  user_teacher.save!
  user_teacher.add_role :teacher

  print "."
end

puts "\nPopulate Students With Courses"
User.all_students.each do |student| 
  Course.all.each do |course|
    student.courses << course

    print "."
  end
end

puts "\nPopulate Teachers With Courses"
all_courses = Course.all
User.all_teachers.each_with_index do |teacher, index| 
  teacher.courses << all_courses[index]

  print "."
end

puts "\nGenerate Survey Templates"
archived_template = Template.find_or_create_by(code: "12356", name: "Encuesta 2021-II", state: "archived")
published_template = Template.find_or_create_by(code: "11223", name: "Encuesta 2022-I", state: "published")
draft_template = Template.find_or_create_by(code: "43312", name: "Encuesta 2022-II", state: "draft")

# DOMINIO DE PROFESOR SOBRE EL CURSO
# LOS MÉTODOS DE ENSEÑANZA
# RELACIÓN DEL PROFESOR CON LOS ESTUDIANTES
# PUNTUALIDAD Y CUMPLIMIENTO
# CONTENIDO DEL CURSO PARA LA FORMACIÓN PROFESIONAL
# ESFUERZO Y DEDICACIÓN
# MANTENIMIENTO DE LA DISCIPLINA EN CLASE, COMO RECURSO DE APRENDIZAJE
# ACOMPAÑAMIENTO Y ATENCIÓN AL ESTUDIANTE
puts "Populate Questions"
[
  "El dominio del curso, por parte del docente es:", # 0
  "La relación entre lo contenidos teóricos y prácticos del curso es:", # 0
  "Las respuestas el docente frente a las preguntas del estudiante son:", # 0
  "Como considera usted, la cátedra del docente en la modalidad virtual", # 1
  "El grado de comunicación del profesor con los alumnos es:", # 1
  "El interés del docente por el aprendizaje de los alumnos es:", # 1
  "El trato del docente hacia los estudiantes es:", # 2
  "La empatía del docente en la modalidad virtual es:", # 2
  "El docente promueve un escenario de respesto y confianza durante las clases", # 2
  "La puntualidad del docente es:", # 3
  "A la fecha, los contenidos del curso se han cumplido de manera:", # 3
  "El docente cumple con lo establecido en el silabo referente a valores y actitudes.", # 3
  "La presentación y organización del los contenidos del silabo es:", # 4
  "La interrelación entre los contenidos del curso es:", # 4
  "La presentación y organización de la clase práctica es:", # 4
  "El docente utiliza, en su cátedra, su producción científica:", # 5
  "Las referencias bibliográficas que entrega el docente son pertinentes y actualizadas.", # 5
  "Los materiales de estudio que proporciona el docente son:", # 5
  "El grado de participación de los estudiantes en clase es:", # 6
  "El escenario generado por el docente en la clase virtual es:", # 6
  "Como valora usted el trabajo global relizado por el docente (considerando todos los aspectos)" # 6
].each do |val|
  Question.create(
    content: val
  )
  print "."
end

puts "\nPopulate Question in the Archived Template"
Question.all.each_with_index do |question, index|
  TemplateQuestion.create(
    template: archived_template,
    question: question,
    category: (index/3) + 1,
    order: index
  )
  
  print "."
end

puts "\nPopulate Question in the Published Template"
Question.all.each_with_index do |question, index|
  TemplateQuestion.create(
    template: published_template,
    question: question,
    category: (index/3) + 1,
    order: index
  )
  
  print "."
end

puts "\nPopulate Question in the Draft Template"
Question.all.each_with_index do |question, index|
  TemplateQuestion.create(
    template: draft_template,
    question: question,
    category: (index/3) + 1,
    order: index
  )
  
  print "."
end

puts "\nPopulate Surveys"
all_courses.each do |course|
  all_teacher_courses = course.users.all_teachers

  course.users.all_students.each do |student|
    all_teacher_courses.each do |teacher|
      Survey.find_or_create_by(
        template: published_template,
        student: student,
        teacher: teacher,
        course: course
      )

      print "."
    end
  end
end

puts "\nPopulate the answers to the first 10 survey"
surveys = Survey.take(10)

surveys.each do |survey|
  survey.template.questions.each_with_index do |question, index|
    Answer.find_or_create_by(
      survey: survey,
      question: question,
      point: rand(1..5)
    )
    print "."
  end
end

puts "\n============ SEEDS - END ============"