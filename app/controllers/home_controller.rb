class HomeController < ApplicationController
  def index
    @categories = Category.order(:name)
    @featured_products = Product
    .includes(:category)
    .with_attached_images
    .where(active: true)
    .limit(8)
  end
end
