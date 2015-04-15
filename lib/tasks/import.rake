namespace :import do
  task :practice, [:practice_id] => :environment do |t, args|
    practice = Practice.find(args[:practice_id])
    pp "No Practice record for practice_id #{args[:practice_id]}!" if practice.blank?

    di = OpenDental::DataImporter.new(practice, { :verbose => true })
    di.import
  end
end