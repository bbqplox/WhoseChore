desc 'chore reminder'
task chore_reminder: :environment do
  Chore.remind()
end
