(function(){var t,r,e;t=$("#paybyway-data").data("payUrl"),e=$("#paybyway-data").data("verifyUrl"),r=function(t){return $(".working").collapse("hide"),$("#message-failure").find(".alert").text($("#messages").data(t)),$("#message-failure").collapse("show"),$("button",".pay-now-button").attr("disabled",!1),$(".pay-now-button").collapse("show")},$("#paybyway-creditcard-form").on("submit",function(t){var a;return t.preventDefault(),$("button",".pay-now-button").attr("disabled",!0),$(".pay-now-button").collapse("hide"),$(".working").collapse("show"),$("#message-failure").collapse("hide"),a=$.get($(this).attr("action")),a.done(function(t){var n,o,u,c,i;try{if(i=t.token,n=t.amount,null==i)throw"token request failure";return c=$("#number").val().replace(/ /g,""),u=$("#expiry").payment("cardExpiryVal"),o=$("#cvc").val(),a=$.post(t.payment_url,{token:i,amount:n,currency:t.currency,card:c,exp_month:u.month<10?"0"+u.month:u.month,exp_year:u.year,security_code:o}),a.done(function(){var t;return t=$.post(e,{token:i}),t.done(function(){return $("#checkout-form").trigger("submit.rails")}),t.fail(function(){return r("chargeError")})}),a.error(function(){return r("chargeError")})}catch(t){return t,r("tokenRequestError")}})}),$(".payment-button").on("click",function(){var e;return e=$.get(t,{selected:$(this).data("selected")}),e.done(function(t){var e;try{return e=$("<form></form>").attr("action",t.payment_url).attr("method","GET"),$("body").append(e),e.submit()}catch(t){return t,r("tokenRequestError")}})})}).call(this);