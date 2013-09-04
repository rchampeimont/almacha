<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
"http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<?php
/* Achanav (a PHP program to browse through pictures)
 *
 * I, Raphael Champeimont, the author of this program,
 * hereby release it into the public domain.
 * This applies worldwide.
 * 
 * In case this is not legally possible:
 * I grant anyone the right to use this work for any purpose,
 * without any conditions, unless such conditions are required by law.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 -------------------------------------------------------------------------- */

/* Note that this program is not developped any more.
   The new version is written in Perl and is Achanav-pl. */
?>

<!-- the CSS style sheet -->
<style type="text/css">
BODY {
  background: white;
  color: black;
  font-size: 80%;
  font-family: Arial, sans-serif;
}
A:link {
  color: #00f;
  background: transparent;
  text-decoration: underline;
}
A:visited {
  color: #060;
  background: transparent;
  text-decoration: underline;
}
A:link:hover {
  color: white;
  background: #006;
  text-decoration: underline;
}
A:visited:hover {
  color: white;
  background: #060;
  text-decoration: underline;
}
A:link:active {
  color: white;
  background: #00f;
  text-decoration: underline;
}
A:visited:active {
  color: white;
  background: #0d0;
  text-decoration: underline;
}
TABLE {
  border: solid 2px black;
  width: 100%;
}
.pagetitle {
  color:white;
  background: black;	
}
.directory {
  color:black;
  background: #0ff;
}
.file {
  color:black;
  background: #0f0;
}
.notfilenordir {
  color:white;
  background: #f00;
}
.forbidden {
  color:white;
  background: #f00;
}
.height {
  color:white;
  background: #f90;
}
.done {
  border: solid 1px black;
  color: black;
  font-size: 150%;
  background: #0f0;
}
.not {
  text-decoration: line-through;
}
</style>

<?php


/* -----------------
   | CONFIGURATION |
   ----------------- */

/* the title */
$title = "customizable-title";
$welcome = "customizable-welcome";


/* end of CONFIGURATION */

/* returns true if and only if the file named
 * fn could be displayed using <img src=...>
 * (the function only look at the extension)
 */
function okforimgsrc($fn) {
  if ($pos = strrpos($fn, ".")) {
    $ext = substr($fn, $pos+1) ;
    if (!$ext) {
      return 0;
    }
    return ($ext == "png" || $ext == "gif" || $ext == "jpg" || $ext == "jpeg");
  } else {
    return 0;
  }
}


$thisfile = $_SERVER['PHP_SELF'];
/* let's get GET vars */
/* file */
$F = isset($_GET['f']) ? $_GET['f'] : "";
/* height: (0 = native) */
$H = isset($_GET['h']) ? $_GET['h'] : "";
/* list style (t = text, p = previews) */
$L = isset($_GET['l']) ? $_GET['l'] : "";

/* check $L has a correct value */
if ($L != "p") {
    $L = "t";
}

/* F not defined? set it to root */
if ($F == "") {
  $F = ".";
}

/* set args, to keep them */
$args = "h=$H&amp;l=$L";

if (substr($F, 0, 1) != "." || strstr($F, "..")) {
  $type = "forbidden";
} else if (is_dir($F)) {
  $type = "directory";
} else if (is_file($F)) {
  $type = "file";
} else {
  $type = "notfilenordir";
}

/* find parent directory */
if ($position = strrpos($F, "/")) {
  $parent = substr($F, 0, $position) ;
} else {
  $parent = "";
}

$heightstr = $H;

if ($H == "0") {
$heightstr = "native";
}

if ($H == "") {
$heightstr = "not&nbsp;defined";
}
?>


<title><?php print("$title - $F"); ?></title>
</head>
<body>

<p>

<?php

/* Part #1: print first line */

print("<span class=\"pagetitle\">$title</span> &nbsp;&nbsp;&nbsp;\n");

print "<span class=\"$type\">";

if ($type == "directory") {
  /* directory */
  print("Directory:&nbsp;$F");
} else if ($type == "file") {
  /* file */
  /* find file name without full path (we cut until the last /) */
  if ($position = strrpos($F, "/")) {
    $fn = substr($F, $position + 1) ;
  } else {
    $fn = $F ;
  }

  /* if there is a parent directory, list its files
   * and find the current file in it
   */
  if ($parent != "") {
    /* case: we have a parent directory */
    $found = 0;
    $filebefore = "";
    $fileafter = "";
    /* search for fn in files */
    if ($handle = opendir("$parent")) {
      while (!$found  && (($i = readdir($handle)) !== false) ) {
	if (is_file("$parent/$i")) {
	  /* is this file fn? */
	  if ($i == $fn) {
	    $found = 1 ;
	  } else {
	    /* in case next file is fn,
	     * we will know that one is before
	     */
	    $filebefore = $i ;
	  }
	}
      }

      /* did we find fn? */
      if ($found) {
	print("(");

	/* is there a file before fn? */
	if ($filebefore != "") {
	  print ("<a href=\"$thisfile?f=$parent/$filebefore&amp;$args\" title=\"Display previous file\">&lt;Previous</a>\n");
	} else {
	  print "<span class=\"not\">&lt;Previous</span>\n";
	}

	/* is there a next after fn? */
	while ($fileafter == "" && (($i = readdir($handle)) !== false)) {
	  if (is_file("$parent/$i")) {
	    $fileafter = $i ;
	  }
	}
	if ($fileafter != "") {
	  print "<a href=\"$thisfile?f=$parent/$fileafter&amp;$args\" title=\"Display next file\">Next&gt;</a>";
	} else {
	  print "<span class=\"not\">Next&gt;</span>";
	}

	print ")";
      }

      print "\n";

      /* close directory */
      closedir($handle);
    } else {
      print("\n<br>Error while opening directory.<br>\n");
      print "File:&nbsp;$fn";
    }

    /* print file name */
    print "File:&nbsp;$fn";

  } else {
    /* case: we did not find parent directory */
    print("Fichier&nbsp;:&nbsp;");
  }
} else if ($type == "notfilenordir") {
  print "Error:&nbsp;No&nbsp;such&nbsp;file&nbsp;or&nbsp;directory:&nbsp;$F";
} else if ($type == "forbidden") {
  print "Error:&nbsp;Access&nbsp;is&nbsp;forbidden:&nbsp;$F";
} else {
  print "Ooops! There is a bug in the Achanav! (F=$F)";
}

print "</span>";

print "\n";

/* link to parent directory */
if ($parent != "") {
  print "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href=\"$thisfile?f=$parent&amp;$args\">&lt;&nbsp;Back to parent directory ($parent)</a>";
}

print "\n";

/* display picture height */
print "\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\n";
print "\n<a href=\"$thisfile?f=$F&amp;l=$L\" title=\"Change height\">Height:</a> <span class=\"height\">$heightstr</span>\n";




/* let's go to next line */
print "\n<br>\n";



/* Part #2: Display file or options */


/* Big case 1: display options */
if ($H == "") {
  print "\n<br>\n";
  print "\n</p>\n";
  print "\n<form action=\"$thisfile\" method=\"get\">\n";
  print "\n<table><tr><td>\n";
  print "\n$welcome\n";
  print "\n<br><br>\n";

  print "\nHeight: \n";
  print "\n<input type=\"text\" name=\"h\" style=\"width: 40%;\"> (0 = native)<br>\n";

  print "\n<br>\n";

  // NOTE: I disabled the previews feature because it is done a stupid
  // way (using the original images) which consumes too much RAM.
  // If you really want that feature, you can uncomment the following
  // section.
  /*
  print "\nDisplay files using:<br>\n";

  print "\n<input type=\"radio\" name=\"l\" value=\"p\"";
  if ($L == "p") {
    print " checked=\"checked\"";
  }
  print ">";
  print "previews (warning: this may consume a lot of your machine's memory)<br>\n";

  print "\n<input type=\"radio\" name=\"l\" value=\"t\"";
  if ($L == "t") {
    print " checked=\"checked\"";
  }
  print ">";
  print "names (faster)<br>\n";

  print "\n<br>\n";
  */


  print "\nFile: (just for information)<br>\n";
  print "\n<input readonly=\"readonly\" type=\"text\" name=\"f\" value=\"$F\"> <br>\n";
  print "\n<br>\n";
  print "\n<button type=\"submit\" name=\"v\"><div class=\"done\">Ok</div></button><br>\n";

  print "\n</td></tr></table>\n";
  print "\n</form>\n";

} else {
  /* Second big case: Display the file or directory */

  if ($type == "directory") {
    /* directory */

    print("\n<br>\n");
    print("\nSubdirectories of <span class=\"directory\">$F</span> : <br>\n");

    /* list subdirectories */
    if ($handle = opendir($F)) {
      while (($file = readdir($handle)) !== false) {
	if ($file != "." && $file != "..") {
	  if (is_dir("$F/$file")) {
	    print ("&nbsp; &gt; <a href=\"$thisfile?f=$F/$file&amp;$args\">$file</a><br>\n");
	  }
	}
      }

      /* close file */
      closedir($handle);
    } else {
      print("\n<br>Error while opening directory.<br>\n");
    }

    print("\n<br><br><br>\n");

    print("\nFiles: <br><br>\n");

    /* list directory contents */
    if ($handle = opendir($F)) {
      while (($file = readdir($handle)) !== false) {
	if (is_file("$F/$file")) {
	  if ($L == "p") {
	    if (okforimgsrc($file)) {
	      print ("<a href=\"$thisfile?f=$F/$file&amp;$args\"><img style=\"border: 0; height: 100px;\" src=\"$F/$file\" alt=\"$file\" title=\"$file (click to enlarge)\"></a>\n");
	    } else {
	      print ("<a href=\"$thisfile?f=$F/$file&amp;$args\"><span title=\"$file (click to display)\">$file</span></a>\n");
	    }
	  } else {
	    print ("\n&nbsp; &gt; <a href=\"$thisfile?f=$F/$file&amp;$args\" title=\"$file (click to displa)\">$file</a><br>");
	  }
	}
      }

      /* close directory */
      closedir($handle);
    } else {
      print("\n<br>Error while opening directory.<br>\n");
    }

  } else if ($type == "file") {
    /* file */
    print("</p><p style=\"text-align: center;\">\n");
      print("<img src=\"$F\" alt=\"$F\"");
    if ($H != "0") {
      /* non-native height */
      print(" style=\"height: ${H}px;\"");
    }
    print(">");
  }

print "</p>";
}


?>


<p>
<br><br><br><br>
<small>
<?php
print "This file was generated by Achanav.\n". '$Id: achanav.php 338 2008-08-20 12:12:24Z almacha $' . "\n";
?>
</small>

</p>
</body>
</html>
