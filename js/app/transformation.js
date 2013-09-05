queralyzer.transformation  = (function () {
	
	/*
	Checking String starts with "".
	 */
	function startsWith(actualString, str) {
		if (actualString.slice(0, str.length) == str) {
			return true;
		}
		return false;
	}

	/*
	It will format the give file content into understandable format.
	 */
	function format(fileContent) {
		var data = fileContent.split("\n");
		var str = "";
		var headerLines = 1;
		for (var i = 0; i < data.length; i++) {
			str += data[i];
			var headerCount = str.split("+");
			if ((headerCount.length - 2) == 10) {
				headerLines = i + 1;
				break;
			}
		}
		str = "";
		for (var i = 0; i < data.length; i = i + headerLines) {
			for (var j = i; j < i + headerLines; j++) {
				str += data[j];
			}
			str += "\n";
		}
		return str;
	}

	/*
	This API will prepare JSON object for the given plan.
	 */
	function prepareJSONObj(entry) {
		var jsonObj = new Object();
		jsonObj.id = $.trim(entry[0]);
		jsonObj.select_type = $.trim(entry[1]);
		jsonObj.table = $.trim(entry[2]);
		jsonObj.type = $.trim(entry[3]);
		jsonObj.possible_keys = $.trim(checkNullity(entry[4]));
		jsonObj.key = $.trim(checkNullity(entry[5]));
		jsonObj.key_len = $.trim(checkNullity(entry[6]));
		jsonObj.ref = $.trim(checkNullity(entry[7]));
		jsonObj.rows = $.trim(entry[8]);
		jsonObj.Extra = $.trim(checkNullity(entry[9]));
		return jsonObj;
	}

	/*
	If value is null then formating null to NULL.
	 */
	function checkNullity(value) {
		if (value == "(null)") {
			return "NULL";
		}
		return value;
	}

	/*
	This API will validate headers of the given access plan.
	 */
	function validate(headers) {
		if (headers.length < 10) {
			$('#info').html("Error : Expected no of headers are 10 ");
			return false;
		}
		if ($.trim(headers[0]) != "id" || $.trim(headers[1]) != "select_type"
				|| $.trim(headers[2]) != "table"
				|| $.trim(headers[3]) != "type"
				|| $.trim(headers[4]) != "possible_keys"
				|| $.trim(headers[5]) != "key"
				|| $.trim(headers[6]) != "key_len"
				|| $.trim(headers[7]) != "ref" || $.trim(headers[8]) != "rows"
				|| $.trim(headers[9]) != "Extra") {
			$('#info')
					.html(
							"Error : Expected order of headers are \"id\" \"select_type\" \"table\" \"type\" \"possible_keys\" \"key\" \"key_len\" \"ref\" \"rows\" \"Extra\"");
			return false;
		}
		return true;
	}

	
	return {
	reset: function ()
	{
		document.getElementsByName('fileupload')[0].value = "";
		document.getElementsByName('fileContent')[0].value = "";
		document.getElementsByName('jsonContent')[0].value = "";
		document.getElementsByName('jsontreeview')[0]= "";
		document.getElementsByName('transform')[0].disabled = true;
	},
	readfile: function (file,container)
	{
		var files = document.getElementById('browse').files;
		if (!files.length) {
			alert('Please select a file!');
			return false;
			;
		}
		var file = files[0];
		var start = 0;
		var stop = file.size - 1;
		var reader = new FileReader();
		var blob = file.slice(start, stop + 1);
		reader.readAsBinaryString(blob);
		reader.onloadend = function(evt) {
			if (evt.target.readyState == FileReader.DONE) {
				document.getElementsByName('fileContent')[0].value = evt.target.result;
			}
		};
	},
	transfrom: function ()
	{
		var fileContent = document.getElementsByName('fileContent')[0].value;
		var records = fileContent.split("\n");
		var JSONObjects = new Array();
		var headers;

		if (startsWith(records[0], '+--')) {
			var formatedData = format(fileContent);
			var dataLines = formatedData.split("\n");
			if (dataLines.length > 1) {
				headers = dataLines[1].split("|");
				headers = headers.splice(1, headers.length);
				if (validate(headers)) {
					for (i = 3, j = 0; i < dataLines.length - 2; i++, j++) {
						var entry = dataLines[i].split("|");
						entry = entry.splice(1, entry.length);
						JSONObjects[j] = prepareJSONObj(entry);
					}
				}
			} else {
				$('#info')
						.html("Error : Empty data could not be tranformed!!!");
			}

		} else {
			headers = records[0].split("\t");
			if (validate(headers)) {
				for (var i=1; i < records.length; i++) {
					var entry = records[i].split("\t");
					if (entry.length >= 10) {
						JSONObjects[i - 1] = prepareJSONObj(entry);
					}
				}
			}
		}
		document.getElementsByName('jsonContent')[0].value = JSON.stringify(
				JSONObjects, null, 4);
		queralyzer.App.renderTree(JSONObjects); 
	}
	};
})();