(function(){this.stick_main_nav=function(){return $("#main-nav").stick_in_parent({offset_top:-30})},this.resize_masthead=function(){return $("#masthead").css("height",$(window).height())},jQuery(function(){return resize_masthead(),stick_main_nav(),$(window).on("resize",resize_masthead),$(document).on("page:done",stick_main_nav)})}).call(this);