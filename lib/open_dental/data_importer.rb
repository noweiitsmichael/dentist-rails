module OpenDental
  class DataImporter
    def initialize(practice)
      if practice.instance_of? Practice
        @practice = practice
      else
        @practice = Practice.find(practice)
      end

      database = "dentaldb" # TODO: will be computed and generated
      @db      = Mysql2::Client.new(
                   :host => @practice.db_host,
                   :port => @practice.db_port,
                   :username => @practice.db_username,
                   :password => @practice.db_password,
                   :database => database
                 )
    end

    def import
      # sequence is important here in order to create the correct relationships
      import_dentists
      import_patients
      import_procedure_types
      import_insurance_plans
      import_claims
      import_procedures
    end

    private

    def build_od_query(od_table)
      columns = OD_TABLES_MAPPING[od_table][:field_mapping].keys
      "SELECT #{columns.join(',')} from #{od_table.to_s};"
    end

    def build_od_data_hash(od_table, row)
      od_row_data = {}
      OD_TABLES_MAPPING[od_table][:field_mapping].each do |od_column, data_key|
        od_row_data[data_key] = row[od_column]
      end
      od_row_data
    end

    def import_dentists
      @db.query(build_od_query(:provider)).each do |d|
        od_data = build_od_data_hash(:provider, d)
        dentist = @practice.dentists.where(od_uid: od_data['uid']).first_or_create
        dentist.update_attributes({
          first_name: od_data['first_name'],
          last_name: od_data['last_name'],
          suffix: od_data['suffix'],
          open_dental_raw: od_data.to_json
        })
        dentist.save! rescue next
      end
    end

    def import_patients
    end

    def import_procedure_types
    end

    def import_insurance_plans
    end

    def import_claims
    end

    def import_procedures
    end
  end
end