// const priceCalculation = () => {
//   const priceInput = document.getElementById("item-price");
//   const addTaxPrice = document.getElementById("add-tax-price");
//   const profit = document.getElementById("profit");

//   if (!priceInput) return;

//   priceInput.addEventListener("input", () => {
//     const inputValue = priceInput.value;

//     if (inputValue >= 300 && inputValue <= 9999999) {
//       const taxRate = 0.1;
//       let taxValue = inputValue * taxRate;
      
//       taxValue = Math.floor(taxValue);

//       let profitValue = inputValue - taxValue;

//       addTaxPrice.innerHTML = taxValue.toLocaleString();
//       profit.innerHTML = profitValue.toLocaleString();
//     } else {
//       addTaxPrice.innerHTML = '0';
//       profit.innerHTML = '0';
//     }
//   });
// };

// window.addEventListener("turbo:load", priceCalculation);
// window.addEventListener("DOMContentLoaded", priceCalculation);