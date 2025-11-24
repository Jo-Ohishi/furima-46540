class ItemsController < ApplicationController
<<<<<<< Updated upstream
  def index
=======
  before_action :authenticate_user!, only: [:new, :create]
  before_action :find_item, only: [:show]

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

  private

  def item_params
    # フォームから送られてきたデータ（ストロングパラメーター）
    params.require(:item).permit(
      :image, :name, :description, :price,
      :category_id, :condition_id, :shipping_fee_payer_id,
      :prefecture_id, :shipping_day_id
    ).merge(user_id: current_user.id) # ログインユーザーIDを紐づける
>>>>>>> Stashed changes
  end

  def find_item
    # 💡 URLから渡された params[:id] を使って Item を検索
    @item = Item.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    # 該当のレコードが見つからなかった場合の処理（例：トップページへリダイレクト）
    redirect_to root_path
  end
end