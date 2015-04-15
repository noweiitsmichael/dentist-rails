namespace :import do
  task :practice, [:practice_id] => :environment do |t, args|
    practice = Practice.find_by_id(args[:practice_id])

    if practice.blank?
      puts "No Practice record for practice_id #{args[:practice_id]}!"
      next
    end

    di = OpenDental::DataImporter.new(
           practice,
           { :verbose => true, :new_only => true }
         )
    di.import
  end
end