class ProductsController < ApplicationController
  def index
    @products = Product
    .includes(:category, :product_images)
    .where(active: true)
    .order(:name)
  end

  def show
    @product = Product
    .includes(:category, :product_images, :product_variants)
    .find(params[:id])
  end
end
