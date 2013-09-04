(* Program:     Allambdator          *
 * Author:      Raphael Champeimont  *
 * License:     Public Domain        *
 * Depends on:  OcamlNet             *)

(* Modules *)
(* TODO: Add "open ExtLib" as first "open" if we manage to make extlib work *)
open Big_int;;
open List;;


(* TYPES AND GLOBALS *)

let appname = "Allambdator";;

(* in N *)
type color = big_int;;

(* integer in [0,6x256[ *)
type spectrum_color = int;;
let spectrum_size = 6 * 256;;

(* 3 integers in [0,255[, for RGB *)
type sapiens_color = int * int * int;;

(* Hungry Alligators, Old Alligators, and Eggs *)
type altree = HA of (color * (altree list)) | OA of (altree list) | Egg of color;;

(* Aliases for big int *)
let two_big_int = big_int_of_int 2;;
let equal_big_int a b = (compare_big_int a b) = 0;;






(* COLORIZING *)
(*
   This "spectrum" consists of a continuous range of different colors,
   in our case it is:
    R --- R+G --- G --- G+B --- B ---- B+R --- R
   The idea is to associate each natural integer (>= 0 ints)
   to a color, and we suppose that colors are used in order
   (starting from 0 to infinity). If we have only a few colors,
   we want them to be really different, and when we increase the number
   of colors, we want other colors. But we want the "spectrum color"
   associated to a "color" to be always the same.
   So:
   - We cannot take each "human color" of the spetrum, because colors from,
     (e.g.) 0 to 20 will look the same.
   - We cannot either divide the spectrum by the number of colors
     and then give each range a color, because when you increase the number
     of colors, the translation changes.
   So here is our solution:
     We devide the spectrum like that
   0________________________________________________________________________
   0__________________________________1_____________________________________
   0_______________2__________________1___________________3_________________
   0______4________2________5_________1_________6_________3_________7_______
   0__8___4___9____2___10___5____11___1____12___6____13___3____14___7___15__
   etc.
 *)
let spectrum_color_of_color (c : color) =
  (* find the maximum n so that k >= 2^n
     k must be >= 1 *)
  let find_n k =
    let rec try_n last_n = 
      let new_n = succ_big_int last_n in
      if (ge_big_int k (power_int_positive_big_int 2 new_n))
      then try_n new_n
      else last_n
    in
    if le_big_int k zero_big_int
    then failwith "find_n: given k was < 1"
    else try_n zero_big_int
  in

  if (lt_big_int c zero_big_int)
  then failwith "spectrum_color_of_color: invalid color because < 0";

  let bigpos =
    if (equal_big_int c zero_big_int)
    then zero_big_int
    else (
      let n = find_n c in
      let m = power_int_positive_big_int 2 n in
      let s = big_int_of_int spectrum_size in
      (* the next line is:
         s(2(c-m)+1)
         ------------
               2m
      *)
      div_big_int
        (mult_big_int
          s
          (add_big_int
            (mult_big_int two_big_int (sub_big_int c m))
            unit_big_int
          )
        )
        (mult_big_int two_big_int m)
      )
  in

  (* return value *)
  let ret = 
    try int_of_big_int bigpos with
    | _ -> failwith "spectrum_color_of_color: bigpos does not fit in int"
  in
  (ret : spectrum_color)
;;

let sapiens_color_of_spectrum_color (k : spectrum_color) =
  let ret = match k with
  | c when c < 0 -> failwith "sapiens_color_of_spectrum_color: k is < 0"
  | c when c < 1*256 -> (255, c, 0)
  | c when c < 2*256 -> (255 - (c mod 256), 255, 0)
  | c when c < 3*256 -> (0, 255, c mod 256)
  | c when c < 4*256 -> (0, 255 - (c mod 256), 255)
  | c when c < 5*256 -> (c mod 256, 0, 255)
  | c when c < 6*256 -> (255, 0, 255 - (c mod 256))
  | c -> failwith "sapiens_color_of_spectrum_color: k is >= 6*256"
  in
  (ret : sapiens_color)
;;

let sapiens_color_of_color (c : color) =
  let ret = sapiens_color_of_spectrum_color (spectrum_color_of_color c) in
  (ret : sapiens_color)
;;





(* HTML TREE TYPES AND FUNCTIONS *)
type html_elementname = string;;
type html_value = HtmlTrue | HtmlVal of string;;
type html_attribute = (string * html_value);;
type html_node =
  | HtmlElement of
  (html_elementname * (html_attribute list) * (html_node list))
  | HtmlVoidElement of
  (html_elementname * (html_attribute list))
  | HtmlText of string
;;
type html_doctype = string;;
type html_tree = html_doctype * html_node;;

let string_of_html_tree = function (doctype,rootnode) ->
  let string_of_html_attribute (a,v) =
    match v with
    | HtmlTrue -> " " ^ a
    | HtmlVal s  -> " " ^ a ^ "=\"" ^ s ^ "\""
  in
  let rec string_of_html_node = function
    | HtmlText(s) -> s
    | HtmlElement(name, att, content) ->
        "<" ^ name
        ^ (String.concat "" (map string_of_html_attribute att))
        ^ ">\n"
        ^ (String.concat "" (map string_of_html_node content))
        ^ "</" ^ name ^ ">\n"
    | HtmlVoidElement(name, att) ->
        "<" ^ name
        ^ (String.concat "" (map string_of_html_attribute att))
        ^ ">\n"
  in
  doctype ^ (string_of_html_node rootnode)
;;



(* CSS TYPES AND FUNCTIONS *)
type css_prop = string;;
type css_val = string;;
type css_rule_begin = string;;
type css_rule = css_rule_begin * ((css_prop * css_val) list)
type css = css_rule list;;

let string_of_css_rule (b, l) =
  let string_of_css_propval (p,v) =
    "  " ^ p ^ ": " ^ v ^ ";\n"
  in
  b ^ " {\n" ^ (String.concat "" (map string_of_css_propval l)) ^ "}\n"
;;

let string_of_css l =
  String.concat "" (map string_of_css_rule l)
;;


(* CGI I/O *)
let ctt = "text/html; charset=UTF-8";;

let htmlhex_string_of_sapiens_color (r,g,b) =
  Printf.sprintf "#%02x%02x%02x" r g b
;;

let htmlhex_string_of_color c =
  let (r,g,b) = sapiens_color_of_color c in
  Printf.sprintf "#%02x%02x%02x" r g b
;;

(* Colors Test: gives back HTML nodes to put in BODY *)
let testcolors () =
  let afewcolors n =
    let rec aux l k =
      if k >= n then l else aux ((big_int_of_int k)::l) (k+1)
    in
    aux [] 0
  in
  let testcolor c =
    let sc = spectrum_color_of_color c in
    let css_color =
      htmlhex_string_of_sapiens_color (sapiens_color_of_spectrum_color sc)
    in
    HtmlElement
    ("div",
    [("style", HtmlVal ("background-color: " ^ css_color ^ ";"))],
    [HtmlText ((string_of_big_int c) ^ " -&gt; " ^
    (string_of_int sc) ^ " -&gt; " ^ css_color)])
  in
  rev (map testcolor (afewcolors 1000))
;;


(* Renders a altree as HTML: returns a htmlnode list *)
let rec hmtlnodes_of_altree = function
  | HA (c,l) ->
      let css_color = htmlhex_string_of_color c in
      let eachtotd t = HtmlElement("td", [], hmtlnodes_of_altree t) in
      let alltotd l = map eachtotd l in
      [
      HtmlVoidElement ("img", [("style",HtmlVal
      ("background-color: " ^ css_color ^
      ";"));("alt", HtmlVal "Egg");("src", HtmlVal "ha.png")]);
      HtmlElement ("table", [], [(HtmlElement ("tr", [], alltotd l))])
      ]
  | OA l ->
      let eachtotd t = HtmlElement("td", [], hmtlnodes_of_altree t) in
      let alltotd l = map eachtotd l in
      [
      HtmlVoidElement ("img", [("alt", HtmlVal "OA");
      ("src", HtmlVal "oa.png")]);
      HtmlElement ("table", [], [(HtmlElement ("tr", [], alltotd l))])
      ]
  | Egg c -> 
      let css_color = htmlhex_string_of_color c in
      [
      HtmlVoidElement ("img", [("style",HtmlVal
      ("background-color: " ^ css_color ^ ";"));
      ("alt", HtmlVal "Egg");("src", HtmlVal "egg.png")]);
      ]
;;


(* Main CGI program *)
let process (a : Netcgi_types.cgi_activation) =
  let edit_string = "Apply modifications"
  and calc_string = "Calculate next step" in
  let thisfile = "allambdator.cgi" in
  let mydoctype =
    "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\"\n" ^
    "        \"http://www.w3.org/TR/html4/strict.dtd\">\n" in
  let mycss = [("TD", [("text-align", "center");("vertical-align", "top")]);
  ("TABLE", [("width", "100%")]);
  ("IMG", [("width", "100%")])] in
  let mycss_string = string_of_css mycss in
  let myhead =
    HtmlElement ("head",[], [HtmlElement
    ("title", [], [HtmlText appname]);(HtmlElement ("style", [("type",
    HtmlVal "text/css")],
    [HtmlText mycss_string]))])
  in
  let tryit () =
    let b0 = zero_big_int
    and b1 = succ_big_int zero_big_int
    and b2 = succ_big_int (succ_big_int zero_big_int)
    and b3 = succ_big_int (succ_big_int (succ_big_int zero_big_int))
    in
    let myaltree = OA [Egg b3; Egg b0; HA (b3, [Egg b1;Egg b2]);
    Egg b2; Egg b1] in
    let myhtmlals = hmtlnodes_of_altree myaltree in
    let myinbodylist = [HtmlElement ("table", [], [HtmlElement ("tr", [],
    [(HtmlElement ("td", [], myhtmlals))])])] in
    let mysubmitedit = HtmlVoidElement ("input", [("type", HtmlVal
    "submit");("value", HtmlVal edit_string);("name", HtmlVal "do")])
    in
    let mysubmitcalc = HtmlVoidElement ("input", [("type", HtmlVal
    "submit");("value", HtmlVal calc_string);("name", HtmlVal "do")])
    in
    let mysubmitbuttons = HtmlElement ("p", [], [mysubmitcalc;mysubmitedit]) in
    let myinbody = [HtmlElement ("h1", [], [HtmlText (appname)]);
    HtmlElement ("form", [("action", HtmlVal thisfile)],
    (mysubmitbuttons :: myinbodylist))] in
    let mybody = HtmlElement ("body", [], myinbody) in
    let myhtmltree = (mydoctype,HtmlElement ("html",[], [myhead; mybody])) in
    a#set_header ~content_type:ctt ();
    a#output#output_string (string_of_html_tree myhtmltree);
    a#output#commit_work ();
  and ordothat s = 
    let text = match s with
    | None -> "An exception was raised."
    | Some s -> "A Failure exception was raised: " ^ s ^ "."
    in
    let mypre = HtmlElement ("pre", [], [HtmlText text]) in
    let myh1 = HtmlElement ("h1", [], [HtmlText "Error"]) in
    let mybody = HtmlElement ("body", [], [myh1;mypre]) in
    let myhtmltree = (mydoctype,HtmlElement ("html",[], [myhead; mybody])) in
    a#output#rollback_work ();
    a#set_header ~content_type:ctt ();
    a#output#output_string (string_of_html_tree myhtmltree);
    a#output#commit_work ();
  in
  try
    tryit ();
  with
  | Failure s  -> ordothat (Some s)
  | _ -> ordothat None
;;

(* The function that starts CGI *)
let cgi () =
  let ot = Netcgi.buffered_transactional_optype in
  let mycgi = new Netcgi.std_activation ~operating_type:ot () in
  process mycgi;
;;

cgi ();;

