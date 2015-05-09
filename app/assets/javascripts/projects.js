// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
function removeLink(link){
	$(link).hide();
	$(link).prev().val(1);
	$(link).parent().parent(".link").hide();
}

function addLink(link,content){
	var re = new RegExp("new_link","g");
	$(link).before(
		content.replace(re,$.now())
	);
}