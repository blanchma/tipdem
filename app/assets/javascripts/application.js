// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require_tree .


$(document).ajaxSend(function(e, xhr, options) {
  var token = $("meta[name='csrf-token']").attr("content");
  xhr.setRequestHeader("X-CSRF-Token", token);
});


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
