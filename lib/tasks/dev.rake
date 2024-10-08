namespace :dev do

  DEFAULT_PASSWORD = 123456
  DEFAULT_FILES_PATH = File.join(Rails.root, 'lib', 'tmp')

  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando BD...") { %x(rails db:drop) }
      show_spinner("Criando BD...") { %x(rails db:create) }
      show_spinner("Migrando BD...") { %x(rails db:migrate) }
      show_spinner("Cadastrando o administrador padrão...") { %x(rails dev:add_default_admin) }
      show_spinner("Cadastrando novos administradores ..") { %x(rails dev:add_extra_admins) }
      show_spinner("Cadastrando o usuário padrão...") { %x(rails dev:add_default_user) }
      show_spinner("Cadastrando os assuntos  padrão...") { %x(rails dev:add_subjects) }
      show_spinner("Cadastrando perguntas e respotas...") { %x(rails dev:add_answers_and_questions) }
    else
      puts "Você não está em ambiente de desenvolvimento!"
    end
  end

  desc "Adiciona o administrador padrão"
  task add_default_admin: :environment do
    Admin.create!(
      email: 'admin@admin.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc "Adiciona o usuário padrão"
  task add_default_user: :environment do
    User.create!(
      email: 'user@user.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc "Adiciona o administrador padrão"
  task add_extra_admins: :environment do
    10.times do |j|
        Admin.create!(
        email:Faker::Internet.email,
        password: DEFAULT_PASSWORD,
        password_confirmation: DEFAULT_PASSWORD
    )
    end
  end


  desc "Adiciona assuntos padrão"
  task add_subjects: :environment do
    file_name = 'subjects.txt'
    file_path = File.join(DEFAULT_FILES_PATH, file_name)

    File.open(file_path, 'r').each do |line|
      Subject.create!(description: line.strip)
    end
  end


  desc "Adiciona perguntas e respostas"
  task add_answers_and_questions: :environment do
    Subject.all.each do |subject|
      rand(5..10).times do |i|
    question_params = {description: "#{Faker::Lorem.paragraph} #{Faker::Lorem.question}", subject: subject, answers_attributes: []}


        rand(2..5).times do |j|
          question_params[:answers_attributes] << {description: Faker::Lorem.sentence, correct: false }
       end

       question_params[:answers_attributes].sample[:correct] = true;

        Question.create!(question_params)
    end
  end
end

desc "Reseta o contador dos assuntos"
task reset_subject_counter: :environment do
  show_spinner("Resetando contador dos assuntos...") do
    Subject.find_each do |subject|
      Subject.reset_counters(subject.id, :questions)
    end
  end
end

  private

  def show_spinner(msg_start, msg_end = "Concluído!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end
end
