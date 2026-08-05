class Province < ApplicationRecord

  belongs_to :province_record,
             class_name: "Province",
             optional: true
end
