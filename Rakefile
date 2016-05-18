task :app do
  sh 'ruby -I . src/app.rb'
end

task :seed do
  sh 'ruby -I . src/db/seed.rb'
end

task :doc do
  sh 'rdoc --main src/README.txt --exclude "public/|views/|.csv" src'
end
