 function fetchnext(id,eid,type) {

    jQuery.ajax({
		  type:'POST',
		  dataType:'html',
		  data:{id: id},
		  success:function(data, extStatus){jQuery("#inline_demo2").html(data);},
		  url:'/m/other/first'
	  });

	}
