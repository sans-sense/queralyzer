// JavaScript Document
(function(){
	
	var externalJS = ["bootstrap.js", "bootstrap.min.js", "bootstrap-dropdown.js", "header.js"];
	
	$.each(externalJS, function(index, links){
		var allJSFiles = [];
			allJSFiles.push("<script src='js/"+links+"'></script>");
			$('body').append(allJSFiles.join(''));
	});

})();