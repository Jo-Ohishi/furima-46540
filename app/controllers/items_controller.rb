class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
    @items = Item.order('created_at DESC')
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      # 保存成功: トップページなどにリダイレクト
      redirect_to root_path
    else
      # 保存失敗: newテンプレートを再表示 (エラーメッセージ付き)
      render :new, status: :unprocessable_content
    end
  end

  private

  def item_params
    # フォームから送られてきたデータ（ストロングパラメーター）
    params.require(:item).permit(
      :item_name, :description, :price,
      :category_id, :condition_id, :shipping_fee_payer_id,
      :prefecture_id, :shipping_day_id
    ).merge(user_id: current_user.id) # ログインユーザーIDを紐づける
  end
end
