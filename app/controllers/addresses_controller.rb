class AddressesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_address, only: [:edit, :update]

  def new
    @address = current_user.addresses.build
    @provinces = Province.order(:name)
  end

  def create
    @address = current_user.addresses.build(address_params)
    @provinces = Province.order(:name)

    if @address.save
      current_user.update!(
        province: @address.province_record
      )

      redirect_to account_path,
                  notice: "Your shipping address was saved."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @provinces = Province.order(:name)
  end

  def update
    @provinces = Province.order(:name)

    if @address.update(address_params)
      current_user.update!(
        province: @address.province_record
      )

      redirect_to account_path,
                  notice: "Your shipping address was updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_address
    @address = current_user.addresses.find(params[:id])
  end

  def address_params
    params.require(:address).permit(
      :street_address,
      :city,
      :province_record_id,
      :postal_code,
      :country
    )
  end
end