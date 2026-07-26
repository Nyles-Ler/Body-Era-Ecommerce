ActiveAdmin.register Page do
  permit_params :title, :slug, :content

  actions :index, :show, :edit, :update

  index do
    selectable_column
    id_column
    column :title
    column :slug
    column :updated_at
    actions
  end

  form do |f|
    f.semantic_errors

    f.inputs "Page Content" do
      f.input :title
      f.input :slug, input_html: { readonly: true }, hint: "The slug identifies whether this is the About or Contact page."
      f.input :content, as: :text, input_html: { rows: 15 }
    end

    f.actions
  end

end
