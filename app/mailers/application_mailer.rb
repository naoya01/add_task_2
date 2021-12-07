# app/mailers/application_mailer.rb
class ApplicationMailer < ActionMailer::Base
  default from: "管理人 <from@example.com>"
  layout 'mailer'
end


# app/mailers/user_mailer.rb
class UserMailer < ApplicationMailer
end