OD_TABLES_MAPPING = {
	:procedurelog => {
			:model_name => 'Procedure',
      :field_mapping => {
        "ProcNum" => "uid",
        "PatNum" => "patient_uid",
        "ProcDate" => "date",
        "CodeNum" => "procedure_type_uid",
        "ProcFee" => "price",
        "ProcStatus" => "status",
        "ProvNum" => "dentist_uid"
      }
		},
	:procedurecode => {
      :model_name => 'ProcedureType',
      :field_mapping => {
        "CodeNum" => "uid",
        "ProcCode" => "code",
        "Descript" => "description",
        "AbbrDesc" => "description_abbr",
        "ProcCat" => "category_uid",
        "TreatArea" => "treatment_area_uid"
      }
    },
  :claim => {
      :model_name => 'Claim',
      :field_mapping => {
        "ClaimNum" => "uid",
        "PatNum" => "patient_uid",
        "DateService" => "service_date",
        "DateSent" => "sent_date",
        "DateReceived" => "received_date",
        "ClaimStatus" => "status",
        "PlanNum" => "insurance_plan_uid",
        "ClaimFee" => "specified_price",
        "InsPayEst" => "requested_price",
        "InsPayAmt" => "payment_price",
        "ClaimType" => "type"
      }
    },
  :claimproc => {
      :model_name => 'Procedure',
      :field_mapping => {
        "ProcNum" => "uid",
        "ClaimNum" => "claim_uid",
        "BaseEst" => "base_estimated_price",
        "InsEstTotal" => "insurance_estimated_price"
      }
    },
  :insplan => {
      :model_name => 'InsurancePlan',
      :field_mapping => {
        "PlanNum" => "uid",
        "GroupName" => "group_name",
        "GroupNum" => "group_uid",
        "PlanNote" => "description",
        "CarrierNum" => "carrier_uid"
      }
    },
  :provider => {
      :model_name => 'Dentist',
      :field_mapping => {
        "ProvNum" => "uid",
        "Abbr" => "name_abbr",
        "LName" => "last_name",
        "FName" => "first_name",
        "MI" => "middle_name",
        "Suffix" => "suffix"
      }
    },
  :patient => {
      :model_name => 'Patient',
      :field_mapping => {
        "PatNum" => "uid",
        "Zip" => "zipcode",
        "Gender" => "gender",
        "DateFirstVisit" => "first_visit_date"
      }
    },
  :payment => {
      :model_name => 'PatientPayments',
      :field_mapping => {
        "PayNum" => "uid",
        "PayDate" => "date",
        "PayAmt" => "amount",
        "PatNum" => "patient_uid"
      }
    }
}