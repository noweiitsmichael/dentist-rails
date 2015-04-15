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
      puts "Beginning import for Practice(id=#{@practice.id})..." if @verbose
      start_time = Time.now

      import_dentists
      import_patients
      import_procedure_types
      import_insurance_plans
      import_claims
      import_procedures
      import_payments
  
      elapsed = (Time.now - start_time).round(2)
      puts "Finished import for Practice(id=#{@practice.id}) in #{elapsed} seconds." if @verbose
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
      num_imported = 0
      od_uids = Set.new(@practice.claims.map(&:od_uid))

      @db.query(build_od_query(:claim)).each do |c|
        od_data = build_od_data_hash(:claim, c)
        next if @new_only && od_uids.include?(od_data['uid'].to_s)

        claim = @practice.claims.where(od_uid: od_data['uid']).first_or_create
        claim.update_attributes({
          patient:         @practice.patients.where(od_uid: od_data['patient_uid'].to_s).first,
          insurance_plan:  @practice.insurance_plans.where(od_uid: od_data['insurance_plan_uid'].to_s).first,
          service_date:    od_data['service_date'],
          sent_date:       od_data['sent_date'],
          received_date:   od_data['received_date'],
          status:          od_data['status'],
          requested_price: od_data['requested_price'].to_f,
          payment_price:   od_data['payment_price'].to_f,
          claim_type:      od_data['type'],
          open_dental_raw: od_data.to_json
        })
        claim.save! rescue next
        num_imported += 1
      end
      puts "Imported #{num_imported} claims." if @verbose
    end

    def import_procedures
      # procedurelog
      num_imported = 0
      od_uids = Set.new(@practice.procedures.map(&:od_uid))

      @db.query(build_od_query(:procedurelog)).each do |p|
        od_data = build_od_data_hash(:procedurelog, p)
        next if @new_only && od_uids.include?(od_data['uid'].to_s)

        procedure = @practice.procedures.where(od_uid: od_data['uid']).first_or_create
        procedure.update_attributes({
          patient:         @practice.patients.where(od_uid: od_data['patient_uid'].to_s).first,
          procedure_type:  @practice.procedure_types.where(od_uid: od_data['procedure_type_uid'].to_s).first,
          dentist:         @practice.dentists.where(od_uid: od_data['dentist_uid'].to_s).first,
          date:            od_data['date'],
          price:           od_data['price'].to_f,
          status:          od_data['status'],
          open_dental_raw: od_data.to_json
        })
        procedure.save! rescue next
        num_imported += 1
      end
      puts "Imported #{num_imported} procedures." if @verbose

      # claimproc
      num_updated = 0

      @db.query(build_od_query(:claimproc)).each do |p|
        od_data = build_od_data_hash(:claimproc, p)

        procedure = @practice.procedures.where(od_uid: od_data['uid']).first_or_create
        next if @new_only && procedure.claim_id.present?

        proc_od_data = JSON.parse(procedure.open_dental_raw) rescue {}
        procedure.update_attributes({
          claim:           @practice.claims.where(od_uid: od_data['claim_uid'].to_s).first,
          open_dental_raw: od_data.merge(proc_od_data).to_json
        })
        procedure.save! rescue next
        num_updated += 1
      end
      puts "Updated #{num_updated} claim-procedure relationships." if @verbose
    end

    def import_payments
      num_imported = 0
      od_uids = Set.new(@practice.patient_payments.map(&:od_uid))

      @db.query(build_od_query(:payment)).each do |p|
        od_data = build_od_data_hash(:payment, p)
        next if @new_only && od_uids.include?(od_data['uid'].to_s)

        payment = @practice.patient_payments.where(od_uid: od_data['uid']).first_or_create
        payment.update_attributes({
          patient:         @practice.patients.where(od_uid: od_data['patient_uid'].to_s).first,
          date:            od_data['date'],
          amount:          od_data['amount'].to_f,
          open_dental_raw: od_data.to_json
        })
        payment.save! rescue next
        num_imported += 1
      end
      puts "Imported #{num_imported} patient payments." if @verbose
    end
  end
end