/*
 * Copyright (c) 2010 Raphael CHAMPEIMONT
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

package org.almacha;

import java.awt.Color;
import java.awt.Component;
import java.awt.Container;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.swing.BorderFactory;
import javax.swing.BoxLayout;
import javax.swing.JApplet;
import javax.swing.JButton;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextPane;
import javax.swing.text.SimpleAttributeSet;
import javax.swing.text.StyleConstants;
import javax.swing.text.StyledDocument;

public class AchaCheckDatesFrench extends JApplet implements ActionListener {

	private static final long serialVersionUID = -8304809779613373167L;
	private JTextPane textArea;
	
	private JButton validationButton;
	private JButton clearButton;
	
	private String[] daysOfWeek = {"dimanche", "lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi"};
	private Map<String,Integer> daysOfWeekMap = new HashMap<String,Integer>();
	
	private String[] monthsArray = {"janvier", "février", "mars", "avril", "mai", "juin", "juillet", "aout", "septembre", "octobre", "novembre", "décembre"};
	private Map<String,Integer> monthsMap = new HashMap<String,Integer>();
	
	private Pattern searchPattern;

	public AchaCheckDatesFrench() {
		for (int i=1; i<=7; i++) {
			daysOfWeekMap.put(daysOfWeek[i-1], i);
		}
		
		monthsMap.put("janvier", 0);
		monthsMap.put("février", 1);
		monthsMap.put("fevrier", 1);
		monthsMap.put("mars", 2);
		monthsMap.put("avril", 3);
		monthsMap.put("mai", 4);
		monthsMap.put("juin", 5);
		monthsMap.put("juillet", 6);
		monthsMap.put("aout", 7);
		monthsMap.put("août", 7);
		monthsMap.put("septembre", 8);
		monthsMap.put("octobre", 9);
		monthsMap.put("novembre", 10);
		monthsMap.put("décembre", 11);
		monthsMap.put("decembre", 11);
		
		String patternString = "(";
		for (int i=0; i<daysOfWeek.length; i++) {
			if (i != daysOfWeek.length-1) {
				patternString += daysOfWeek[i] + "|";
			} else {
				patternString += daysOfWeek[i];
			}
		}
		patternString += ") *(\\d+) (";
		List<String> allMonths = new ArrayList<String>();
		for (String monthString: monthsMap.keySet()) {
			allMonths.add(monthString);
		}
		for (int i=0; i<allMonths.size(); i++) {
			if (i != allMonths.size()-1) {
				patternString += allMonths.get(i) + "|";
			} else {
				patternString += allMonths.get(i);
			}
		}
		patternString += ")( +(\\d+))?";
		//System.out.println(patternString);
		searchPattern = Pattern.compile(patternString, Pattern.CASE_INSENSITIVE | Pattern.UNICODE_CASE | Pattern.MULTILINE | Pattern.UNIX_LINES);
	}
	
	
	public int dayNumFromDayString(String dayAsString) {
		return daysOfWeekMap.get(dayAsString.toLowerCase());
	}
	
	public String dayStringFromDayNum(int dayAsNum) {
		return daysOfWeek[dayAsNum-1];
	}
	
	public int monthNumFromMonthString(String monthAsString) {
		return monthsMap.get(monthAsString.toLowerCase());
	}
	
	public String monthStringFromMonthNum(int monthAsNum) {
		return monthsArray[monthAsNum];
	}
	
	
	/**
	 * We use the convention from java.util.Calendar:
	 * Sunday = 1, Monday = 2, ...
	 * January = 0, February = 1, ...
	 */
	public int whichDayOfWeekIs(int dayOfMonth, int month, int year) {
		Calendar cal = Calendar.getInstance();
		cal.set(year, month, dayOfMonth);
		return cal.get(Calendar.DAY_OF_WEEK);
	}
	
	public boolean isDayOfWeekCorrect(int dayOfWeek, int dayOfMonth, int month, int year) {
		return (dayOfWeek == whichDayOfWeekIs(dayOfMonth, month, year));
	}
	
	public int thisYear() {
		return Calendar.getInstance().get(Calendar.YEAR);
	}
	
	
	public void clearColor() {
		StyledDocument styledDocument = textArea.getStyledDocument();
		styledDocument.setCharacterAttributes(0, textArea.getText().length(), new SimpleAttributeSet(), true);
	}
	
	
	public void check() {
		StyledDocument styledDocument = textArea.getStyledDocument();
		
		// Remove colors
		clearColor();
		
		// Analyze
		String text = textArea.getText().replace("\r\n", "\n");
		Matcher matcher = searchPattern.matcher(text);
		while (matcher.find()) {
			String dayOfWeekString = matcher.group(1);
			String dayOfMonthString = matcher.group(2);
			String monthString = matcher.group(3);
			String yearString = matcher.group(5);
			int dayOfWeek = dayNumFromDayString(dayOfWeekString);
			int dayOfMonth = Integer.parseInt(dayOfMonthString);
			int month = monthNumFromMonthString(monthString);
			int year;
			//System.out.println("yearString : >" + yearString + "<");
			if (yearString != null && yearString != "") {
				if (yearString.length() == 4) {
					// We have a 4 digit number, a good chance it is the year
					year = Integer.parseInt(yearString);
				} else {
					// We have for example "mardi 16 nomvebre 20 H 30",
					// and "20" does not mean AD 20!
					// We will just assume we are talking about current year.
					year = thisYear();
				}
			} else {
				// No year specified, assume current year
				year = thisYear();
			}
			//System.out.print("Checking " + dayStringFromDayNum(dayOfWeek) + " " + dayOfMonth + " " + monthStringFromMonthNum(month) + " " + year + "... ");
			boolean correct = isDayOfWeekCorrect(dayOfWeek, dayOfMonth, month, year);
			//System.out.println((correct ? "ok" : "incorrect") + ".");

			// Underline
			SimpleAttributeSet attributes = new SimpleAttributeSet(textArea.getCharacterAttributes());
			StyleConstants.setBackground(attributes, correct ? Color.GREEN : Color.RED);
			//System.out.println("start=" + matcher.start() + " end=" + matcher.end());
			styledDocument.setCharacterAttributes(matcher.start(), matcher.end()-matcher.start(), attributes, false);
		}
		
	}
	
	

	public void actionPerformed(ActionEvent e) {
		if (e.getSource() == validationButton) {
			check();
		} else if (e.getSource() == clearButton) {
			clearColor();
		}
	}

	
	
    
    private void addTextArea(Container pane) {
    	JPanel area = new JPanel();
    	area.setLayout(new BoxLayout(area, BoxLayout.LINE_AXIS));
    	area.setBorder(BorderFactory.createTitledBorder("Text to check:"));
    	//area.setMinimumSize(new Dimension(windowMinimalWidth, 240));
    	//area.setPreferredSize(new Dimension(windowDefaultWidth, 240));
    	
    	textArea = new JTextPane();
    	textArea.setEditable(true);
    	textArea.getStyledDocument();
    	textArea.getInputAttributes();

    	JScrollPane messageAreaJScrollPane = new JScrollPane(textArea);
    	area.add(messageAreaJScrollPane);
    	
    	pane.add(area);
    }
    
    private void addButtonArea(Container pane) {
    	JPanel area = new JPanel();
    	area.setLayout(new BoxLayout(area, BoxLayout.LINE_AXIS));
    	
    	{
	    	JButton button = new JButton("Check");
	    	validationButton = button;
	        button.setAlignmentX(Component.CENTER_ALIGNMENT);
	    	area.add(button);
	    	button.addActionListener(this);
    	}
    	
    	{
	    	JButton button = new JButton("Clear color");
	    	clearButton = button;
	        button.setAlignmentX(Component.CENTER_ALIGNMENT);
	    	area.add(button);
	    	button.addActionListener(this);
    	}
    	
        pane.add(area);
    }

    

    private void addComponentsToPane(Container pane) {
        pane.setLayout(new BoxLayout(pane, BoxLayout.PAGE_AXIS));
        
    	addTextArea(pane);
        addButtonArea(pane);
    }


    public void init() {
        addComponentsToPane(getContentPane());
        getContentPane().setVisible(true);
		getContentPane().repaint();
    }

}
