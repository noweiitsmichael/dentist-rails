module OpenDental
  class DataImporter
    def initialize(practice_id)
      # use hardcoded db location for now
      # pull out all the db info from practice record
      hostname = "104.131.57.60"
      username = "root"
      port     = 3306
      password = "ARRJDS1pur"
      database = "dentaldb" # will be computed and generated
      @db      = Mysql2::Client.new(
                   :host => hostname,
                   :port => port,
                   :username => username,
                   :password => password,
                   :database => database,
                 )
    end

    def import
      dentists = @db.query("SELECT * FROM provider")
      dentists.each do |d|
        pp d
      end
    end
  end
end