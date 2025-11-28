const pay = () => {
  const publicKey = gon.public_key;

  if (!publicKey) {
    console.error("PAY.JP Public Key (gon.public_key) is not defined.");
    return;
  } 

  const payjp = Payjp(publicKey);
  const elements = payjp.elements();
  const numberElement = elements.create('cardNumber');
  const expiryElement = elements.create('cardExpiry');
  const cvcElement = elements.create('cardCvc');
  


  numberElement.mount('#number-form');
  expiryElement.mount('#expiry-form');
  cvcElement.mount('#cvc-form');

  const form = document.getElementById('charge-form');
  
  form.addEventListener("submit", (e) => {
    e.preventDefault();

    const submitButton = document.getElementById("button-text");
    if (submitButton) {
        submitButton.disabled = true;
    }

    payjp.createToken(numberElement).then(function (response) {
      numberElement.clear();
      expiryElement.clear();
      cvcElement.clear();
      
      if (response.error) {
        console.error("Token generation failed:", response.error);
        alert("カード情報に問題があり、決済トークンを生成できませんでした。再度お確かめください。");
      } else {
        const token = response.id;
        const renderDom = document.getElementById("charge-form");
        
        const tokenObj = `<input value="${token}" name='order_form[token]' type="hidden">`;
        
        renderDom.insertAdjacentHTML("beforeend", tokenObj);
        
        form.submit(); 
      }
    });
  });
};

window.addEventListener("turbo:load", pay);
window.addEventListener("turbo:render", pay);