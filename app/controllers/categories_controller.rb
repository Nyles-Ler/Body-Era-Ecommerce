class CategoriesController < ApplicationController
  def index
    @categories = Category
    .includes(:products)
    .order(:name)
  end

  def show
    @category = Category.find(params[:id])

    @products = @category.products
    .includes(:product_images)
    .where(active: true)
    .order(:name)
  end
end
