$(function(){
	        $.post('/Muushop/api/cancel_order',data,function (ret) {
                //ret = JSON.parse(ret);
            if(ret.status==1){
                toast.success(ret.info, '温馨提示');
                setTimeout(function () {
                    window.location.href = ret.url;
                }, 1000);
            }else{
                toast.error(ret.info, '温馨提示');
            }
        })
})