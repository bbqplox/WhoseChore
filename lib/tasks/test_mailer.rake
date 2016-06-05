desc 'test mailer'
task test_mailer: :environment do
  UserMailer.test_email().deliver_now
end
