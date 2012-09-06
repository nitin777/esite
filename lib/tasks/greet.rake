task :greet do
   puts "Hello world"
end

task :ask => :greet do
   puts "How are you?"
end
