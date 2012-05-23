$(document).ajaxSend(function(e, xhr, options) {
  var token = $("meta[name='csrf-token']").attr("content");
  xhr.setRequestHeader("X-CSRF-Token", token);
});


/* $.limit
 * Example: $('#myTextarea').limit('140','#charsLeft');

 * http://code.google.com/p/jquery-limit/downloads/list *
 */
(function($){$.fn.extend({limit:function(limit,element){var interval,f;var self=$(this);$(this).focus(function(){interval=window.setInterval(substring,100)});$(this).blur(function(){clearInterval(interval);substring()});substringFunction="function substring(){ var val = $(self).val();var length = val.length;if(length > limit){$(self).val($(self).val().substring(0,limit));}";if(typeof element!='undefined')substringFunction+="if($(element).html() != limit-length){$(element).html((limit-length<=0)?'0':limit-length);}";substringFunction+="}";eval(substringFunction);substring()}})})(jQuery);


/* Another text area limit plugin modified */
function limitText(textarea, limitNum) {
	if (textarea.value.length > limitNum) {
		textarea.value = textarea.value.substring(0, limitNum);
	} else {
		//limitCount.value = limitNum - limitField.value.length;
	}
}

/*
 * Textfocus v1.0 - Default message for text HTML elements
 * Copyright (c) 2010 Boyan Mihaylov
 * http://vivaweb-bg.com
 * Dual licensed under the MIT and GPL licenses:
 * 	http://www.opensource.org/licenses/mit-license.php
 * 	http://www.gnu.org/licenses/gpl.html
 *
 *
 */

(function($) {
	  $.fn.textfocus = function(message) {
	  this.each(function() {
	  $(this).val(message);
		});
    this.focus(function() {
		var value = $(this).val();
	  if(value==message){
	  $(this).val('');}
		});
		this.blur(function() {
		var value = $(this).val();
	  if(value==''){
	  $(this).val(message);}
		});
		return this;
	};
})(jQuery);

function log(message) {
    if (console) {
        console.log(message);
    }
}