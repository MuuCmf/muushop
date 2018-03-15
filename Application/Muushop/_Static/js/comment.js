$(function(){
  
  var assembleData = function(){
    var cData = [];

    $('[data-toggle="comment_info"]').each(function(){
      var _this = $(this);
      var obj = {};
      var product_id = _this.find('[name="product_id"]').val();
      obj.product_id = product_id;
      var order_id = _this.find('[name="order_id"]').val();
      obj.order_id = order_id;
      var brief = _this.find('[name="brief"]').val();
      obj.brief = brief;
      var sku_id = _this.find('[name="sku_id"]').val();
      obj.sku_id = sku_id;
      var score = _this.find('.fenshu').text();
      if(score==''){
        score = 5;
      }
      obj.score = score;


      cData.push(obj);
    });
    
    return cData;
  }

  $('#submit').click(function(){
      var cData = assembleData();
      var comment_json = JSON.stringify(cData);
      console.log(comment_json);
      
  })
})