ActiveAdmin.register Category do
  permit_params :name, :description

  index do
    selectable_column
    id_column

    column :name
    column :description

    column "Products" do |category|
      category.products.count
    end

    actions
  end

  filter :name
  filter :created_at

  form do |f|
    f.semantic_errors

    f.inputs "Category Details" do
      f.input :name
      f.input :description
    end

    f.actions
  end
end
