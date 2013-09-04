/*
 * Copyright (c) 2012 Raphael CHAMPEIMONT
 * 
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */

var daysOfWeek, daysOfWeekInt, monthsArray, monthsArrayInd;
var patternString;
var report, divs;
var regex;

function init() {
	daysOfWeek = new Array("dimanche", "lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi");
	daysOfWeekInt = new Array(0, 1, 2, 3, 4, 5, 6);
	monthsArray = new Array("janvier", "février", "fevrier", "mars", "avril", "mai", "juin", "juillet", "août", "aout", "septembre", "octobre", "novembre", "décembre", "decembre");
	monthsArrayInt = new Array(0, 1, 1, 2, 3, 4, 5, 6, 7, 7, 8, 9, 10, 11, 11)
	
	patternString = "(";
	for (var i=0; i<daysOfWeek.length; i++) {
		if (i != daysOfWeek.length-1) {
			patternString += daysOfWeek[i] + "|";
		} else {
			patternString += daysOfWeek[i];
		}
	}
	patternString += ")\\s+(\\d+)(er)?\\s+(";
	for (var i=0; i<monthsArray.length; i++) {
		if (i != monthsArray.length-1) {
			patternString += monthsArray[i] + "|";
		} else {
			patternString += monthsArray[i];
		}
	}
	patternString += ")(\\s+(\\d\\d\\d\\d))?";
	regex = new RegExp(patternString, "ig");
	
	report = document.getElementById("report")
	divs = document.getElementById("divs")
	
	clearReport()
	verify()
}



function clearChildren(node) {
	while (node.childNodes.length > 0) {
		node.removeChild(node.childNodes[0])
	}
}

function clearReport() {
	clearChildren(report)
}

function addToReport(s) {
	report.appendChild(document.createTextNode(s));
}

function newLineReport() {
	report.appendChild(document.createElement("br"))
}

function verifyElement(node) {
	if (node instanceof HTMLTextAreaElement) {
		var matched;
		var text = node.value;
		while ((matched = regex.exec(text)) != null) {
			addToReport(matched[0])
			var dayW = daysOfWeekInt[daysOfWeek.indexOf(matched[1].toLowerCase())]
			var dayM = parseInt(matched[2])
			var month = monthsArrayInt[monthsArray.indexOf(matched[4].toLowerCase())]
			var yearString = matched[6];
			var year;
			if (yearString != undefined && yearString.length > 0) {
				year = parseInt(matched[6])
			} else {
				year = new Date().getFullYear()
				addToReport(" (supposé " + year + ")")
			}
			var date = new Date(year, month, dayM)
			//addToReport(" (" + date + ") ")
			var correctDay = date.getDay()
			var correct = (correctDay == dayW)
			addToReport(" ")
			if (correct) {
				var styleNode = document.createElement("span")
				styleNode.setAttribute("class", "correct")
				styleNode.appendChild(document.createTextNode("OK"))
			} else {
				var styleNode = document.createElement("span")
				styleNode.setAttribute("class", "incorrect")
				var logline = "INCORRECT - C'est un " + daysOfWeek[daysOfWeekInt.indexOf(correctDay)]
				styleNode.appendChild(document.createTextNode(logline))
			}
			
			// Add to report
			report.appendChild(styleNode)
			report.appendChild(document.createElement("br"))
			
		}
	}
}

function verify() {
	clearChildren(report)
	clearChildren(divs)
	var a = document.getElementById("mainarea")
	verifyElement(a)
}