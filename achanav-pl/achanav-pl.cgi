#!/usr/bin/perl

# Achanav-pl (a Perl program to browse through pictures)
#
# I, Raphael Champeimont, the author of this program,
# hereby release it into the public domain.
# This applies worldwide.
# 
# In case this is not legally possible:
# I grant anyone the right to use this work for any purpose,
# without any conditions, unless such conditions are required by law.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

use strict;
use warnings;
use CGI;

print <<EOF;
Content-Type: text/html; charset=UTF-8

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html 
	PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<style type="text/css">
body {
  background: white;
  color: black;
  font-size: 80%;
  font-family: Arial, sans-serif;
}
a:link {
  color: #00f;
  background: transparent;
  text-decoration: underline;
}
a:visited {
  color: #060;
  background: transparent;
  text-decoration: underline;
}
a:link:hover {
  color: white;
  background: #006;
  text-decoration: underline;
}
a:visited:hover {
  color: white;
  background: #060;
  text-decoration: underline;
}
a:link:active {
  color: white;
  background: #00f;
  text-decoration: underline;
}
a:visited:active {
  color: white;
  background: #0d0;
  text-decoration: underline;
}
table {
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
EOF



# -----------------
# | CONFIGURATION |
# -----------------

# the title
my $title = "customizable-title";
my $welcome = "customizable-welcome";

# End of CONFIGURATION



my $thisfile = $ENV{"SCRIPT_NAME"};

# let's get GET vars
# file
my $F;
if (defined CGI::param('f')) {
  $F = CGI::param('f');
} else {
  $F = "";
}

# height: (0 = native)
my $H;
if (defined CGI::param('h')) {
  $H = CGI::param('h');
} else {
  $H = "";
}

# F not defined? set it to root
if ($F eq "") {
  $F = ".";
}

# set args, to keep them
my $args = "h=$H";

my $type;
if ($F !~ m!^\.! or $F =~ m!\.\.!) {
  $type = "forbidden";
} elsif (-d $F) {
  $type = "directory";
} elsif (-f $F) {
  $type = "file";
} else {
  $type = "notfilenordir";
}

# find parent directory
my $parent;
if ($F =~ m!^(.+)/([^/]*)$!) {
  $parent = $1;
} else {
  $parent = "";
}

my $heightstr = $H;

if ($H eq "0") {
  $heightstr = "native";
}

if ($H eq "") {
  $heightstr = "not&nbsp;defined";
}


print <<EOF;
<title>$title - $F</title>
</head>
<body>
<p>
EOF

# Part #1: print first line

print "<span class=\"pagetitle\">$title</span> &nbsp;&nbsp;&nbsp;\n";

print "<span class=\"$type\">";

if ($type eq "directory") {
  # directory
  print "Directory:&nbsp;$F";
} elsif ($type eq "file") {
  # file
  # find file name without full path (we cut until the last /)
  my $fn;
  if ($F =~ m!^(.+)/([^/]*)$!) {
    $fn = $2;
  } else {
    $fn = $F;
  }

  # if there is a parent directory, list its files
  # and find the current file in it
  if ($parent ne "") {
    # case: we have a parent directory
    my $found = 0;
    my $filebefore = "";
    my $fileafter = "";
    # search for fn in files
    if (opendir(DIR, $parent)) {
      my @files = readdir(DIR);
      foreach my $i (@files) {
      	next if $i =~ /^\./;
	if (-f "$parent/$i") {
	  if ($found) {
	    $fileafter = $i;
	    last;
	  # is this file fn?
	  } elsif ($i eq $fn) {
	    $found = 1;
	  } else {
	    # in case next file is fn,
	    # we will know that one is before
	    $filebefore = $i ;
	  }
	}
      }

      # did we find fn?
      if ($found) {
	print("(");

	# is there a file before fn?
	if ($filebefore ne "") {
	  print ("<a href=\"$thisfile?f=$parent/$filebefore&amp;$args\" title=\"Display previous file\">&lt;Previous</a>\n");
	} else {
	  print "<span class=\"not\">&lt;Previous</span>\n";
	}

	# is there a next after fn?
	if ($fileafter ne "") {
	  print "<a href=\"$thisfile?f=$parent/$fileafter&amp;$args\" title=\"Display next file\">Next&gt;</a>";
	} else {
	  print "<span class=\"not\">Next&gt;</span>";
	}

	print ")";
      }

      print "\n";

      # close directory
      closedir DIR;
    } else {
      print("\n<br />Error while opening directory.<br />\n");
      print "File:&nbsp;$fn";
    }

    # print file name
    print "File:&nbsp;$fn";

  } else {
    # case: we did not find parent directory
    print("File&nbsp;:&nbsp;");
  }
} elsif ($type eq "notfilenordir") {
  print "Error:&nbsp;No&nbsp;such&nbsp;file&nbsp;or&nbsp;directory:&nbsp;$F";
} elsif ($type eq "forbidden") {
  print "Error:&nbsp;Access&nbsp;is&nbsp;forbidden:&nbsp;$F";
} else {
  print "Ooops! There is a bug in the Achanav! (F=$F)";
}

print "</span>";

print "\n";

# link to parent directory
if ($parent ne "") {
  print "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href=\"$thisfile?f=$parent&amp;$args\">&lt;&nbsp;Back to parent directory ($parent)</a>";
}

print "\n";

# display picture height
print "\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\n";
print "\n<a href=\"$thisfile?f=$F\" title=\"Change height\">Height:</a> <span class=\"height\">$heightstr</span>\n";




# let's go to next line
print "\n<br />\n";



# Part #2: Display file or options


# Big case 1: display options
if ($H eq "") {
  print "\n<br />\n";
  print "\n</p>\n";
  print "\n<form action=\"$thisfile\" method=\"get\">\n";
  print "\n<table><tr><td>\n";
  print "\n$welcome\n";
  print "\n<br /><br />\n";

  print "\nHeight: \n";
  print "\n<input type=\"text\" name=\"h\" style=\"width: 40%;\" /> (0 = native)<br />\n";
  print "\n<input readonly=\"readonly\" type=\"hidden\" name=\"f\" value=\"$F\" />\n";
  print "\n<br />\n";
  print "\n<button type=\"submit\" name=\"v\"><div class=\"done\">Ok</div></button><br />\n";

  print "\n</td></tr></table>\n";
  print "\n</form>\n";

} else {
  # Second big case: Display the file or directory

  if ($type eq "directory") {
    # directory

    print("\n<br />\n");
    print("\nSubdirectories of <span class=\"directory\">$F</span> : <br />\n");

    # list subdirectories
    if (opendir(DIR, $F)) {
      my @files = readdir(DIR);
      foreach my $file (@files) {
      	next if $file =~ /^\./;
	if ($file ne "." and $file ne "..") {
	  if (-d "$F/$file") {
	    print ("&nbsp; &gt; <a href=\"$thisfile?f=$F/$file&amp;$args\">$file</a><br />\n");
	  }
	}
      }

      # close file
      closedir DIR;
    } else {
      print("\n<br />Error while opening directory.<br />\n");
    }

    print("\n<br /><br /><br />\n");

    print("\nFiles: <br /><br />\n");

    # list directory contents
    if (opendir(DIR, $F)) {
      my @files = readdir(DIR);
      foreach my $file (@files) {
      	next if $file =~ /^\./;
	if (-f "$F/$file") {
	  print ("\n&nbsp; &gt; <a href=\"$thisfile?f=$F/$file&amp;$args\" title=\"$file (click to displa)\">$file</a><br />");
	}
      }

      # close directory 
      closedir DIR;
    } else {
      print("\n<br />Error while opening directory.<br />\n");
    }

  } elsif ($type eq "file") {
    # file
    print("</p><p style=\"text-align: center;\">\n");
      print("<img src=\"$F\" alt=\"$F\"");
    if ($H ne "0") {
      # non-native height
      print(" style=\"height: ${H}px;\"");
    }
    print(" />");
  }

print "</p>";
}




print <<EOF;
<p>
<br /><br /><br /><br />
<small>
EOF

print "This file was generated by Achanav.\n" . '$Id: achanav-pl.cgi 342 2008-08-20 12:45:31Z almacha $' . "\n";

print <<EOF;
</small>
</p>
</body>
</html>
EOF
