/*!
 * froala_editor v1.2.8 (https://www.froala.com/wysiwyg-editor)
 * License https://www.froala.com/wysiwyg-editor/terms
 * Copyright 2014-2015 Froala Labs
 */
!function(e){e.Editable.prototype.refreshFontSize=function(){var t=e(this.getSelectionElement()),a=parseInt(t.css("font-size").replace(/px/g,""),10)||16;this.$editor.find('.fr-dropdown > button[data-name="fontSize"] + ul li').removeClass("active"),this.$editor.find('.fr-dropdown > button[data-name="fontSize"] + ul li[data-val="'+a+'px"]').addClass("active")},e.Editable.commands=e.extend(e.Editable.commands,{fontSize:{title:"Font Size",icon:"fa fa-text-height",refreshOnShow:e.Editable.prototype.refreshFontSize,seed:[{min:11,max:52}],undo:!0,callback:function(e,t){this.inlineStyle("font-size",e,t)},callbackWithoutSelection:function(e,t){this._startInFontExec("font-size",e,t)}}}),e.Editable.prototype.command_dispatcher=e.extend(e.Editable.prototype.command_dispatcher,{fontSize:function(e){var t=this.buildDropdownFontsize(e),a=this.buildDropdownButton(e,t);return a}}),e.Editable.prototype.buildDropdownFontsize=function(e){for(var t='<ul class="fr-dropdown-menu f-font-sizes">',a=0;a<e.seed.length;a++)for(var l=e.seed[a],i=l.min;i<=l.max;i++)t+='<li data-cmd="'+e.cmd+'" data-val="'+i+'px"><a href="#"><span>'+i+"px</span></a></li>";return t+="</ul>"}}(jQuery);