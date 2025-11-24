class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_item, only: [:show]
  before_action :ensure_seller_and_unsold, only: [:edit, :update, :destroy]
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  def index
    @items = Item.order('created_at DESC')
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    @items = Item.order('created_at DESC')
    if @item.save
      # 保存成功: トップページなどにリダイレクト
      redirect_to root_path
    else
      # 保存失敗: newテンプレートを再表示 (エラーメッセージ付き)
      render :new, status: :unprocessable_content
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

  def destroy
    @item.destroy
    redirect_to root_path
  end

  private

  def item_params
    # フォームから送られてきたデータ（ストロングパラメーター）
    params.require(:item).permit(
      :image, :name, :description, :price,
      :category_id, :condition_id, :shipping_fee_payer_id,
      :prefecture_id, :shipping_day_id
    ).merge(user_id: current_user.id) # ログインユーザーIDを紐づける
  end

  def find_item
    # 💡 URLから渡された params[:id] を使って Item を検索
    @item = Item.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    # 該当のレコードが見つからなかった場合の処理（例：トップページへリダイレクト）
    redirect_to root_path
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def ensure_seller_and_unsold
    # 1. ログインユーザーと出品者が同一人物かチェック
    unless current_user == @item.user
      redirect_to root_path
      return # 処理を中断
    end
    # 2. 商品がすでに購入されていないかチェック (販売中であること)
    return unless @item.order.present?

    redirect_to root_path
  end
end
