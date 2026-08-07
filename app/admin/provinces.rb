ActiveAdmin.register Province do
  permit_params :gst_rate, :pst_rate, :hst_rate

  actions :index, :show, :edit, :update

  filter :name
  filter :code
  filter :gst_rate
  filter :pst_rate
  filter :hst_rate

  index do
    selectable_column
    id_column

    column :name
    column :code

    column "GST" do |province|
      number_to_percentage(province.gst_rate * 100, precision: 3)
    end

    column "PST" do |province|
      number_to_percentage(province.pst_rate * 100, precision: 3)
    end

    column "HST" do |province|
      number_to_percentage(province.hst_rate * 100, precision: 3)
    end

    column :updated_at

    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :code

      row("GST") do |province|
        number_to_percentage(province.gst_rate * 100, precision: 3)
      end

      row("PST") do |province|
        number_to_percentage(province.pst_rate * 100, precision: 3)
      end

      row("HST") do |province|
        number_to_percentage(province.hst_rate * 100, precision: 3)
      end

      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors

    f.inputs "Province Tax Rates" do
      f.input :name,
              input_html: { readonly: true }

      f.input :code,
              input_html: { readonly: true }

      f.input :gst_rate,
              label: "GST Rate",
              hint: "EG: 0.05 for 5%."

      f.input :pst_rate,
              label: "PST Rate"

      f.input :hst_rate,
              label: "HST Rate"
    end

    f.actions
  end
end