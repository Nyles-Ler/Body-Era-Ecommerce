class CategoriesController < ApplicationController
  def index
    @categories = Category
    .includes(products: [images_attachments: :blob])
    .order(:name)
  end

  def show
    @category = Category.find(params[:id])

    @products = @category.products
    .with_attached_images
    .where(active: true)
    .order(:name)
  end
end
