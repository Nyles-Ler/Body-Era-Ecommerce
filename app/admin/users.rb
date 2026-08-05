ActiveAdmin.register User do
  permit_params :first_name,
                :last_name,
                :email,
                :phone_number

  # Remove the password_digest filter to prevent it from being displayed in the admin interface
  remove_filter :password_digest

  index do
    selectable_column
    id_column

    column :first_name
    column :last_name
    column :email
    column :phone_number
    column :created_at

    actions
  end

  show do
    attributes_table do
      row :id
      row :first_name
      row :last_name
      row :email
      row :phone_number
      row :created_at
      row :updated_at
    end

    panel "Addresses" do
      table_for user.addresses do
        column :street_address
        column :city
        column :province
        column :postal_code
      end
    end

    panel "Orders" do
      table_for user.orders do
        column :id
        column :order_status
        column :subtotal
        column :tax_amount
        column :total_amount
        column :created_at
      end
    end
  end
end