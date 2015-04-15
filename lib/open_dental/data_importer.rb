module OpenDental
  class DataImporter
    def initialize(practice)
      if !practice.instance_of? Practice
        practice = Practice.find(practice)
      end

      database = "dentaldb" # TODO: will be computed and generated
      @db      = Mysql2::Client.new(
                   :host => practice.db_host,
                   :port => practice.db_port,
                   :username => practice.db_username,
                   :password => practice.db_password,
                   :database => database
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