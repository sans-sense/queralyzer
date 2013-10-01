queralyzer.Formatter = (function() {

	var sampleAccessPlan = "id	select_type	table	type	possible_keys	key	key_len	ref	rows	Extra    \n1	SIMPLE	ur	system	(null)	(null)	(null)	(null)	1	(null)    \n1	SIMPLE	b	const	PRIMARY	PRIMARY	4	const	1	(null)    \n1	SIMPLE	p	ref	i2	i2	4	const	1	(null)";
	var withPrefix = "Below is the sample Access plan :\n" + sampleAccessPlan;
	const MIN_COLUMNS = 10;

	function format(fileContent) {
		var data, str, i, j, headerLines;

		data = fileContent.split("\n");
		str = "";
		headerLines = 1;
		i = 0;
		for (i in data) {
			str += data[i];
			var headerCount = str.split("+");
			if ((headerCount.length - 2) == MIN_COLUMNS) {
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
		if (entry !== null&& entry.length>=MIN_COLUMNS) {
			var jsonContent = {
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
			return jsonContent;
		}
		return null;
	}

	function checkNullity(value) {
		if (value === "(null)"|| value === "NULL" || value === "") {
			return null;
		}
		return value.replace(/"/g,"");
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
		if (headers.length < MIN_COLUMNS) {
			$('#info').html("Error : Expected no of column headers are "+MIN_COLUMNS+". ");
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
				if (entry.length >= MIN_COLUMNS) {
					entries[i - 1] = prepareJsonEntry(entry);	
				}
				else if(i===records.length-1&&entry.length===9) {
						entry[9] = "";
						entries[i - 1] = prepareJsonEntry(entry);
					}
			}
		}
		return entries;
	}

	/*
	 * API to read file content and registering events.
	 */
	function readFile(file, reader) {
		reader.readAsText(file, "UTF-8");
		reader.onload = loaded;
		reader.onerror = errorHandler;
	}

	function loaded(evt) {
		var fileString = evt.target.result;
		$(".accessplan")[0].value = fileString;
		$(".accessplan")[0].style.color = "black";
	}
	function errorHandler(evt) {
		if (evt.target.error.code == evt.target.error.NOT_READABLE_ERR) {
			$('#info').html("Error reading file...");
		}
	}

	return {

		reset : function() {

			$(".accessplan")[0].value = withPrefix;
			$(".accessplan")[0].style.color = "#808080";
			queralyzer.Formatter.formatToTree(sampleAccessPlan);
			for ( var i = 0; i < $(".leaves").length; i++) {
				$(".leaves")[i].style.color = "#808080";
			}

			$(".table-condensed")[0].style.color = "#808080";
			$('#info').empty();
			$('#browse').focus();
		},

		readfile : function(file) {
			var reader;
			try {
				reader = new FileReader();
			} catch (e) {
				$('#info')
						.html(
								"Error: It seems File API is not supported on your browser");
				return;
			}
			readFile(file, reader);
		},

		formatToTree : function(fileContent) {
			var records, accessPlanEntries;
			fileContent = fileContent.replace(/^\s+|\s+$/g, '');
			records = fileContent.split("\n");
			accessPlanEntries = new Array();
			if (fileStartsWith(records[0], '+--')) {
				accessPlanEntries = handleDashedContent(fileContent);
			} else {
				accessPlanEntries = handleCSVContent(records);
			}
			// File f = new File()
			queralyzer.App.renderTree(accessPlanEntries);
		},

		getCodeMirrorEditor : function(textEditor) {
			var editor = CodeMirror.fromTextArea($(textEditor)[0], {
				mode : "text/x-mysql",
				lineNumbers : false,
				lineWrapping : true,
				extraKeys : {
					"Enter" : function() {
						if (queralyzer.App.isValidQuery(editor.getValue())) {
							editor.save();
							queralyzer.App.submitQuery();
						} else {
							alert("Please check the query");
						}
					}
				}
			});
			return editor;
		},
		initializeEditor : function(editor) {
			editor.setSize("98%", $(".accessplan").height());
			editor.getWrapperElement().style["fontFamily"] = "\"Helvetica Neue\", Helvetica, Arial, sans-serif";
			if ($.browser.mozilla) {
				editor.getWrapperElement().style["lineHeight"] = "1.5";
			} else {
				editor.getWrapperElement().style["line-height"] = "1.5";
			}
		}

	};
})();
