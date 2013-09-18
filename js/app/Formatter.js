queralyzer.Formatter = (function() {

	/*
	 * It will format the give file content into understandable format.
	 */
	var str = "id	select_type	table	type	possible_keys	key	key_len	ref	rows	Extra    \n1	SIMPLE	ur	system	(null)	(null)	(null)	(null)	1	(null)    \n1	SIMPLE	b	const	PRIMARY	PRIMARY	4	const	1	(null)    \n1	SIMPLE	p	ref	i2	i2	4	const	1	(null)";
	var accessplanplaceholder = "- Join using bookmark lookup(index lookup)<br>&nbsp;&nbsp;- Join using bookmark lookup(index lookup) [1]<br>&nbsp;&nbsp;&nbsp;- Join [5]<br>&nbsp;&nbsp;&nbsp;&nbsp;Filter on p [6]<br>&nbsp;&nbsp;&nbsp;&nbsp;Filter on e [6]<br>&nbsp;&nbsp;&nbsp;- Join [5]<br>&nbsp;&nbsp;&nbsp;&nbsp;Filter on p [7]<br>&nbsp;&nbsp;&nbsp;&nbsp;Filter on e [7]<br>&nbsp;&nbsp;- Join using bookmark lookup(index lookup) [1]<br>&nbsp;&nbsp;&nbsp;- Join [2]<br>&nbsp;&nbsp;&nbsp;&nbsp;- Join<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Filter on b [3]<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Filter on p [3]<br>&nbsp;&nbsp;&nbsp;&nbsp;Filter on ur [3]<br>&nbsp;&nbsp;&nbsp;&nbsp;- Join [2]<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Join<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Filter on b [4]<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Filter on p [4]<br>&nbsp;&nbsp;&nbsp;&nbsp;Filter on ur [4]<br>";
	var queryplaceholder = "select count(distinct b.id_1) as value, p.name, p.id_1  from x_booking b, x_property p, x_upgrade_request ur where b.property_id = p.id_1 and b.id_1 = ur.booking_id  group by b.property_id;";
	
	function format(fileContent) {
		var data, str, i, j, headerLines;

		data = fileContent.split("\n");
		str = "";
		headerLines = 1;
		i = 0;
		for (i in data) {
			str += data[i];
			var headerCount = str.split("+");
			if ((headerCount.length - 2) == 10) {
				headerLines = parseInt(i) + 1;
				break;
			}
		}
		str = "";
		for (i = 0; i < data.length; i = i + headerLines) {
			for (j = i; j < i + headerLines; j++) {
				str += data[j];
			}
			str += "\n";
		}
		return str;
	}

	function prepareJsonEntry(entry) {
		var jsonContent;
		if (entry !== null && entry.length >= 10) {
			return jsonContent = {
				"id" : entry[0],
				"select_type" : entry[1],
				"table" : entry[2],
				"type" : entry[3],
				"possible_keys" : checkNullity(entry[4]),
				"key" : checkNullity(entry[5]),
				"key_len" : checkNullity(entry[6]),
				"ref" : checkNullity(entry[7]),
				"rows" : entry[8],
				"Extra" : checkNullity(entry[9])
			};
		}
		return null;
	}

	function checkNullity(value) {
		if (value === "(null)") {
			return "NULL";
		}
		return value;
	}

	function trimElements(entry) {
		var i;
		for (i in entry) {
			entry[i] = $.trim(entry[i]);
		}
		return entry;
	}

	function fileStartsWith(actualString, str) {
		if (actualString.slice(0, str.length) == str) {
			return true;
		}
		return false;
	}

	function checkHeaders(entry) {
		var headers, i;
		headers = [ "id", "select_type", "table", "type", "possible_keys",
				"key", "key_len", "ref", "rows", "Extra" ];
		i = 0;
		for (i in headers) {
			if (headers[i] !== entry[i]) {
				return false;
			}
		}
		return true;
	}

	/*
	 * This API will validate headers of the given access plan.
	 */
	function validateHeaders(headers) {
		if (headers.length < 10) {
			$('#info').html("Error : Expected no of column headers are 10. ");
			return false;
		}
		if (!checkHeaders(trimElements(headers))) {
			$('#info')
					.html(
							"Error : Expected order of column headers are \"id\" \"select_type\" \"table\" \"type\" \"possible_keys\" \"key\" \"key_len\" \"ref\" \"rows\" \"Extra\".");
			return false;
		}
		return true;
	}

	/*
	 * This API will handle access plan generated on Ms Sql client(eg
	 * +---+---+--+).
	 */
	function handleDashedContent(fileContent) {
		var formatedData, headers, records, i, j, entries;

		formatedData = format(fileContent);
		records = formatedData.split("\n");
		entries = new Array();

		if (records.length > 1) {
			headers = records[1].split("|");
			headers = headers.splice(1, headers.length);
			if (validateHeaders(headers)) {
				for (i = 3, j = 0; i < records.length - 2; i++, j++) {
					var entry = records[i].split("|");
					entry = entry.splice(1, entry.length);
					entry = trimElements(entry);
					entries[j] = prepareJsonEntry(entry);
				}
			}
			return entries;
		} else {
			$('#info').html("Error : Empty data could not be tranformed!!!");
			return null;
		}
	}

	/*
	 * This API will handle access plan of type CSV,Text..
	 */
	function handleCSVContent(records) {
		var headers, entries;

		entries = new Array();
		headers = records[0].split("\t");

		if (validateHeaders(headers)) {
			for ( var i = 1; i < records.length; i++) {
				var entry = records[i].split("\t");
				if (entry.length >= 10) {
					entries[i - 1] = prepareJsonEntry(entry);
				}
			}
		}
		return entries;
	}

	return {

		reset : function() {
	
            $(".accessplan")[0].value = str;
            $(".accessplan")[0].style.color="#808080";
			queralyzer.Formatter.formatToTree(str);
			for(var i=0; i<$(".leaves").length ; i++)
			{
			$(".leaves")[i].style.color = "#808080";
			}
			
            $(".table-condensed")[0].style.color = "#808080";
			$("#fileupload")[0].value = "";
			$("#userQuery").val(accessplanplaceholder);
			$("#userQuery")[0].placeholder = queryplaceholder;
			$('#info').empty();
			$('#fileupload').focus();
		},

		readfile : function() {
			var file, files, startIndex, stopIndex, reader, blob;

			files = document.getElementById('fileupload').files;
			if (!files.length) {
				alert('Please select a file!');
				return false;
			}

			file = files[0];
			startIndex = 0;
			stopIndex = file.size - 1;
			reader = new FileReader();
			blob = file.slice(startIndex, stopIndex + 1);

			reader.readAsBinaryString(blob);
			reader.onloadend = function(evt) {
				if (evt.target.readyState == FileReader.DONE) {
					$('[name="accessplan"]')[0].value = evt.target.result;
					$('[name="accessplan"]')[0].style.color="black";
				}
			};
		},

		formatToTree : function(fileContent) {
			var records, accessPlanEntries;
				fileContent = fileContent.replace(/^\s+|\s+$/g, '');
				records = fileContent.split("\n");
				accessPlanEntries = new Array();
				if (fileStartsWith(records[0], '+--')) {
					accessPlanEntries = handleDashedContent(fileContent);
				} else {
					accessPlanEntries = handleCSVContent(records)
				}
				queralyzer.App.renderTree(accessPlanEntries);
		}

	};
})();
