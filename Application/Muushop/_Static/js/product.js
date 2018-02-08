$(function(){

    var viewSwiper = new Swiper('.view .swiper-container', {
        // 如果需要前进后退按钮
        prevButton:'.swiper-button-prev',
        nextButton:'.swiper-button-next',
        onInit: function(swiper){
            $('.preview .swiper-slide:first').addClass('active-nav');
        },
        onSlideChangeStart: function(swiper){
            updateNavPosition();
        }
    })

    var previewSwiper = new Swiper('.preview .swiper-container', {
        visibilityFullFit: true,
        slidesPerView: 'auto',
        allowTouchMove: false,
        onTap: function() {
            viewSwiper.slideTo(previewSwiper.clickedIndex);
        }
    })

    function updateNavPosition() {
        $('.preview .swiper-slide').removeClass('active-nav');
        $('.preview .swiper-slide').each(function(){
            $(this).removeClass('active-nav');

            if($(this).data('id') == viewSwiper.activeIndex+1){
                $(this).addClass('active-nav');
            }
        });
    }
});


$(function(){
    var product_sku = $('input[data-toggle="product_sku"]').val();
        product_sku = $.parseJSON(product_sku);
    $('.sku-content').Muusku({
        sku_data:product_sku
    });
});

$(function(){
    /*
    直接购买订单
    */
    var product_sku = $('input[data-toggle="product_sku"]').val();
        product_sku = $.parseJSON(product_sku);
    $('.buyImmediately').click(function () {
        /*数量*/
        var product_id = $('[data-type="title"]').data('id');
        var quantity = $('.count-input').val();
        quantity = (isNaN(quantity))?1:quantity;
        /*规格*/
        if(product_sku){
            var sku_index = $('.sku-content').find('input').val();
            if(sku_index){
                //console.log('sku-ready',sku_index);
                window.location.href='index.php?s=/muushop/order/makeorder'+'&id='+product_id+'&quantity='+quantity+'&sku='+sku_index;
            }else{
                alert('请选择商品规格');
            }
        }else{
            window.location.href='index.php?s=/muushop/order/makeorder'+'&id='+product_id+'&quantity='+quantity;
        } 
    });
})

$(function(){
    /*
    加入购物车
     */
    var product_sku = $('input[data-toggle="product_sku"]').val();
        product_sku = $.parseJSON(product_sku);
    $('.addCartNow').click(function () {
        /*数量*/
        var quantity = $('.count-input').val();
        quantity = (isNaN(quantity))?1:quantity;
        var sku_uid = $('[data-type="title"]').data('id');
        /*规格*/
        if(product_sku){
            var sku_index = $('.sku-content').find('input').val();
            if(sku_index){
                sku_uid += ';'+sku_index;
            }else{
                alert('请选择商品规格');
                return;
            }
        }
        var data = {
            sku_id:sku_uid,
            quantity:quantity
        };
        var url = $('input[data-toggle="add_cart_url"]').val();
        $.post(url,data, function (ret) {
            if(ret.status==1){
                $.get_cart_count();
                toast.success(ret.info, '温馨提示');
            }
            else{
                toast.error(ret.info, '温馨提示');
            }
        })
    });
});



//商品购买数量
$(function(){
    var cutBtn = $('.count-content .cut-btn');
    var addBtn = $('.count-content .add-btn');
    var countInput = $('.count-content .count-input');
    cutBtn.click(function(){
        if(countInput.val()<=1)return;
        countInput.val(parseInt(countInput.val())-1);
    });
    addBtn.click(function(){
        var quantity =parseInt($('.quantity span').text());
        if(countInput.val()>=quantity)return;
        countInput.val(parseInt(countInput.val())+1);
    });
})