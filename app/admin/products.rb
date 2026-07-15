# Feature 1.2 Product CRUD with admin dashboard
ActiveAdmin.register Product do
  permit_params :name,
                :description,
                :current_price,
                :active,
                :category_id

  includes :category

  index do
    selectable_column
    id_column

    column :name
    column :category
    column :current_price
    column :active
    column :created_at

    actions
  end

  filter :name
  filter :category
  filter :current_price
  filter :active
  filter :created_at

  form do |f|
    f.semantic_errors

    f.inputs "Product Details" do
      f.input :category
      f.input :name
      f.input :description
      f.input :current_price
      f.input :active
    end

    f.actions
  end
end