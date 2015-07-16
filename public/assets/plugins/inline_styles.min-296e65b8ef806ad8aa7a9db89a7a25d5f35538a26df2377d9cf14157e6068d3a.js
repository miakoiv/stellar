/*!
 * froala_editor v1.2.8 (https://www.froala.com/wysiwyg-editor)
 * License https://www.froala.com/wysiwyg-editor/terms
 * Copyright 2014-2015 Froala Labs
 */
!function(e){e.Editable.prototype.refreshInlineStyles=function(){var t=this.getSelectionElements()[0],a=t.tagName.toLowerCase();this.$bttn_wrapper.find(".fr-block-style").empty();var l=this.options.blockStyles[a];if(void 0===l&&(l=this.options.defaultBlockStyle),void 0!==l){this.$bttn_wrapper.find('.fr-dropdown > button[data-name="blockStyle"].fr-trigger').removeAttr("disabled");for(var i in l){var n=l[i],r="";e(t).hasClass(i)&&(r=' class="active"'),this.$bttn_wrapper.find(".fr-block-style").append(e("<li"+r+">").append(e('<a href="#" data-text="true">').text(n).addClass(i)).attr("data-cmd","blockStyle").attr("data-val",i))}}},e.Editable.commands=e.extend(e.Editable.commands,{inlineStyle:{title:"Inline Style",icon:"fa fa-paint-brush",refreshOnShow:e.Editable.prototype.refreshInlineStyles,callback:function(e,t){this.applyInlineStyles(t)},callbackWithoutSelection:function(e,t){this.applyInlineStyles(t)}}}),e.Editable.DEFAULTS=e.extend(e.Editable.DEFAULTS,{inlineStyles:{"Big Red":"font-size: 20px; color: red;","Small Blue":"font-size: 14px; color: blue;"}}),e.Editable.prototype.command_dispatcher=e.extend(e.Editable.prototype.command_dispatcher,{inlineStyle:function(e){var t=this.buildDropdownInlineStyle(),a=this.buildDropdownButton(e,t);return a}}),e.Editable.prototype.buildDropdownInlineStyle=function(){var e='<ul class="fr-dropdown-menu fr-inline-style">';for(var t in this.options.inlineStyles)e+='<li data-cmd="inlineStyle" data-val="'+t+'"><a href="#" style="'+this.options.inlineStyles[t]+'">'+t+"</a></li>";return e+="</ul>"},e.Editable.prototype.applyInlineStyles=function(t){this.insertHTML(""!==this.text()?this.start_marker+'<span data-fr-verified="true" style="'+this.options.inlineStyles[t]+'">'+this.text()+"</span>"+this.end_marker:'<span data-fr-verified="true" style="'+this.options.inlineStyles[t]+'">'+this.markers_html+e.Editable.INVISIBLE_SPACE+"</span>"),this.restoreSelectionByMarkers(),this.triggerEvent("inlineStyle")},e.Editable.prototype.startInInlineStyles=function(e){for(var t in this.options.inlineStyles[e])this._startInFontExec(t.replace(/([A-Z])/g,"-$1").toLowerCase(),null,this.options.inlineStyles[e][t]);this.triggerEvent("inlineStyle")}}(jQuery);