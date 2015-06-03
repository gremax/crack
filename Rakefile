namespace :db do
  desc "Reset database"
  task :reset do
    File.write('data/scores.db', Marshal.dump([])) if File.exists?('data/scores.db')
  end

  desc "Remove database file"
  task :remove do
    rm_rf 'data/scores.db'
  end
end

desc "Generate a secret key"
task :secret do
  require 'securerandom'
  puts SecureRandom.hex(64)
end
