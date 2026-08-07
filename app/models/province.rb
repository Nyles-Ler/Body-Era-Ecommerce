class Province < ApplicationRecord

  belongs_to :province_record,
             class_name: "Province",
             optional: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[
      code
      created_at
      gst_rate
      hst_rate
      id
      name
      pst_rate
      updated_at
    ]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[addresses]
  end
end
