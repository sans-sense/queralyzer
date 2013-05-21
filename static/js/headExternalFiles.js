// JavaScript Document
(function(){
	
	var externalCSS = ["bootstrap.css", "bootstrap.min.css", "bootstrap-responsive.css", "styles.css"];
	
	$.each(externalCSS, function(index, links){
		var allCSSFiles = [];
			allCSSFiles.push("<link rel='stylesheet' href='css/"+links+"'>");
			$('head').append(allCSSFiles.join(''));
	});

})();