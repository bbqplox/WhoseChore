desc "This task is called by the Heroku scheduler add-on"
task chore_reminder: :environment do
  puts "Starting Chore Reminder Process"
  Chore.remind()
  puts "Ending Chore Reminder Process"
end
