// ページロード時に実行される関数を定義
const priceCalculation = () => {
  // 💡 HTML要素の取得
  const priceInput = document.getElementById("item-price");
  const addTaxPrice = document.getElementById("add-tax-price");
  const profit = document.getElementById("profit");

  if (!priceInput) return; // priceInput が存在しない場合は処理を終了

  // 💡 入力イベントを監視
  priceInput.addEventListener("input", () => {
    const inputValue = priceInput.value;

    // 入力が有効な数値であるかチェック
    if (inputValue >= 300 && inputValue <= 9999999) {
      // 1. 手数料の計算 (10%)
      const taxRate = 0.1;
      let taxValue = inputValue * taxRate;
      
      // 🚨 小数点以下を切り捨て
      taxValue = Math.floor(taxValue);

      // 2. 利益の計算 (販売価格 - 手数料)
      let profitValue = inputValue - taxValue;
      
      // 3. 結果の表示
      // toLocaleString() で3桁カンマ区切りにフォーマットして表示
      addTaxPrice.innerHTML = taxValue.toLocaleString();
      profit.innerHTML = profitValue.toLocaleString();
    } else {
      // 無効な値が入力された場合や、空の場合の表示をクリア
      addTaxPrice.innerHTML = '0';
      profit.innerHTML = '0';
    }
  });
};

// ページ読み込み完了後に priceCalculation 関数を実行
window.addEventListener("turbo:load", priceCalculation);
window.addEventListener("DOMContentLoaded", priceCalculation);