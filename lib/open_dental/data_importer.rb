module OpenDental
  class DataImporter
    def initialize(practice, options)
      @practice = practice.instance_of?(Practice) ? practice : Practice.find(practice)
      
      @verbose = options[:verbose] || false
      @new_only = options[:new_only] || false # only imports new records not already in db

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
      num_imported = 0
      od_uids = Set.new(@practice.dentists.map(&:od_uid))

      @db.query(build_od_query(:provider)).each do |d|
        od_data = build_od_data_hash(:provider, d)
        next if @new_only && od_uids.include?(od_data['uid'].to_s)

        dentist = @practice.dentists.where(od_uid: od_data['uid']).first_or_create
        dentist.update_attributes({
          first_name:      od_data['first_name'],
          last_name:       od_data['last_name'],
          suffix:          od_data['suffix'],
          open_dental_raw: od_data.to_json
        })
        dentist.save! rescue next
        num_imported += 1
      end
      puts "Imported #{num_imported} dentists." if @verbose
    end

    def import_patients
      num_imported = 0
      od_uids = Set.new(@practice.patients.map(&:od_uid))

      @db.query(build_od_query(:patient)).each do |p|
        od_data = build_od_data_hash(:patient, p)
        next if @new_only && od_uids.include?(od_data['uid'].to_s)

        patient = @practice.patients.where(od_uid: od_data['uid']).first_or_create
        patient.update_attributes({
          zipcode:          od_data['zipcode'],
          gender:           od_data['gender'],
          first_visit_date: od_data['first_visit_date'],
          open_dental_raw:  od_data.to_json
        })
        patient.save! rescue next
        num_imported += 1
      end
      puts "Imported #{num_imported} patients." if @verbose
    end

    def import_procedure_types
      num_imported = 0
      od_uids = Set.new(@practice.procedure_types.map(&:od_uid))

      @db.query(build_od_query(:procedurecode)).each do |p|
        od_data = build_od_data_hash(:procedurecode, p)
        next if @new_only && od_uids.include?(od_data['uid'].to_s)

        proc_type = @practice.procedure_types.where(od_uid: od_data['uid']).first_or_create
        proc_type.update_attributes({
          code:            od_data['code'],
          description:     od_data['description'],
          open_dental_raw: od_data.to_json
        })
        proc_type.save! rescue next
        num_imported += 1
      end
      puts "Imported #{num_imported} procedure types." if @verbose
    end

    def import_insurance_plans
      num_imported = 0
      od_uids = Set.new(@practice.insurance_plans.map(&:od_uid))

      @db.query(build_od_query(:insplan)).each do |i|
        od_data = build_od_data_hash(:insplan, i)
        next if @new_only && od_uids.include?(od_data['uid'].to_s)

        ins_plan = @practice.insurance_plans.where(od_uid: od_data['uid']).first_or_create
        ins_plan.update_attributes({
          group_name:      od_data['group_name'],
          group_id:        od_data['group_uid'],
          description:     od_data['description'],
          carrier_id:      od_data['carrier_uid'],
          open_dental_raw: od_data.to_json
        })
        ins_plan.save! rescue next
        num_imported += 1
      end
      puts "Imported #{num_imported} insurance plans." if @verbose
    end

    def import_claims
    end

    def import_procedures
    end
  end
end