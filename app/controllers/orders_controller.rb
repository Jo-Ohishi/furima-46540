class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, only: [:index, :create]
  before_action :ensure_item_purchase_eligibility, only: [:index, :create]

  def index
    gon.public_key = ENV['PAYJP_PUBLIC_KEY']
    @order_form = OrderForm.new
  end

  def create
    @order_form = OrderForm.new(order_params)
    if @order_form.valid?
      pay_item
      @order_form.save
      redirect_to root_path
    else
      gon.public_key = ENV['PAYJP_PUBLIC_KEY']
      render 'index', status: :unprocessable_entity
    end
  end

  private

  def set_item
    @item = Item.find(params[:item_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  def ensure_item_purchase_eligibility
    if current_user.id == @item.user_id
      redirect_to root_path
      return
    end
    return unless @item.order.present?

    redirect_to root_path
  end

  def order_params
    params.require(:order_form).permit(:token, :postal_code, :prefecture_id, :city, :street_addresses, :building_name,
                                       :phone_number)
          .merge(item_id: @item.id, user_id: current_user.id)
  end

  def pay_item
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    Payjp::Charge.create(
      amount: @item.price,
      card: order_params[:token],
      currency: 'jpy'
    )
  end
end
