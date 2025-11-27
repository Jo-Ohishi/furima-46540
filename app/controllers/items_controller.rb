class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :find_item, only: [:show]
  before_action :set_item, only: [:show, :edit, :update]
  before_action :ensure_seller_and_unsold, only: [:edit, :update]

  def index
    @items = Item.order('created_at DESC')
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def edit
  end

  def update
    if @item.update(item_params)
      redirect_to item_path(@item)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # def destroy
  #   @item.destroy
  #   redirect_to root_path
  # end

  private

  def item_params
    params.require(:item).permit(
      :image, :name, :description, :price,
      :category_id, :condition_id, :shipping_fee_payer_id,
      :prefecture_id, :shipping_day_id
    ).merge(user_id: current_user.id)
  end

  def find_item
    @item = Item.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def ensure_seller_and_unsold
    return if current_user == @item.user

    redirect_to root_path
    # return

    # return unless @item.order.present?

    # redirect_to root_path
  end
end
