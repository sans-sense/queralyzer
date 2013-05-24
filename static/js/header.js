// JavaScript Document
(function(){


	var subMenu = [
			 		{
			 			"linkName" : "Change Password",
			 			"href" : "#",
			 			"tabindex" : "-1",
			 		},	 		
			 		{
			 			"linkName" : "Edit Profile",
			 			"href" : "#",
			 			"tabindex" : "-1",
			 		},
			 		
			 		{
			 			"linkName" : "Full Result",
			 			"href" : "#",
			 			"tabindex" : "-1",
			 		},
			 		
			 		{
			 			"linkName" : "Signout",
			 			"href" : "#",
			 			"tabindex" : "-1",
			 		},
		 		]


	$('body').prepend("<header><div class='headerWrapper'><a class='logo' href='index.html'></a></div></header>");
	$('.headerWrapper').append('<div class="profile-section dropdown btn-group"><div class="link dropdown-toggle" data-toggle="dropdown"><span class="profileName">Ashfaq</span><span class="caret"></span></div></div>');
	$('.btn-group').append("<ul class='dropdown-menu pull-right'></ul>");
	
	$.each(subMenu, function(index, listMenu){
		var storeListItem = [];
		storeListItem.push("<li><a href='"+listMenu.href+"' tabindex='"+listMenu.tabindex+"'>"+listMenu.linkName+"</a></li>");
		$('.dropdown-menu').append(storeListItem.join(''));
	})
})();