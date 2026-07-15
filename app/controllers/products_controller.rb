class ProductsController < ApplicationController
  def index
    @products = Product
    .includes(:category, :product_images)
    .where(active: true)

    if params[:search].present?
      search_term = "%#{params[:search]}%"

      @products = @products.where(
        "products.name LIKE :search OR products.description LIKE :search",
        search: search_term)
    end

    @products = @products
    .order(:name)
    .page(params[:page])
    .per(12)
  end

  def show
    @product = Product
    .includes(:category, :product_images, :product_variants)
    .find(params[:id])
  end
end
