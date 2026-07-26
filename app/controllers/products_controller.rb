class ProductsController < ApplicationController
  def index
    @products = Product
    .includes(:category).with_attached_images
    .where(active: true)

    if params[:search].present?
      search_term = "%#{params[:search]}%"

      @products = @products.where(
        "products.name LIKE :search OR products.description LIKE :search",
        search: search_term)
    end

    # Feature 2.6 Category dropdown
    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
    end

    case params[:filter]
    when "new"
      @products = @products.where("products.created_at >= ?", 3.days.ago)

    when "recently_updated"
      @products = @products
      .where("products.updated_at >= ?", 3.days.ago)
      .where("products.created_at < ?", 3.days.ago)
    end



    @products = @products
    .order(:name)
    .page(params[:page])
    .per(12)
  end

  def show
    @product = Product
    .includes(:category, :product_variants)
    .with_attached_images
    .find(params[:id])
  end
end
