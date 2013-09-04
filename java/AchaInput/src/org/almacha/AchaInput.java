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
import java.awt.Container;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Writer;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import javax.swing.BorderFactory;
import javax.swing.BoxLayout;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextField;
import javax.swing.JTextPane;
import javax.swing.text.BadLocationException;
import javax.swing.text.MutableAttributeSet;
import javax.swing.text.StyleConstants;
import javax.swing.text.StyledDocument;


public class AchaInput implements KeyListener {
	
	private final static Color errorColor = Color.RED;
	
	private final long t0 = (new Date()).getTime();
	
	private JTextPane messageArea;
	private StyledDocument messageAreaStyledDocument;
	private MutableAttributeSet messageAreaDocumentAttributes;
	
	private Set<Character> pressedKeys = new HashSet<Character>();
	
	private int windowMinimalWidth = 640;
	private int windowDefaultWidth = 1024;
	
	private JPanel colorArea;
	
	private char[] logChars = {'0', '2'};
	private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyyMMdd-aahhmm");
	private Writer logWriter;
	
	public String getPressedKeysAsString() {
		int n = pressedKeys.size();
		char[] A = new char[n];
		int i = 0;
		for (Character c: pressedKeys) {
			A[i] = c;
			i++;
		}
		String s = new String(A);
		return "[" + s + "]";
	}
	
	public String getPressedKeysAsString2() {
		int n = pressedKeys.size();
		int[] active = new int[logChars.length+1];
		for (int i=0; i<logChars.length; i++) {
			if (pressedKeys.contains(logChars[i])) {
				active[i] = 1;
				n--;
			}
		}
		if (n>0) {
			active[active.length-1] = 1;
		}
		
		String s = "";
		for (int i=0; i<active.length; i++) {
			s += "\t" + active[i];
		}
		return s;
	}
	
	public String getState() {
		long t = (new Date()).getTime();
		return (t-t0) + getPressedKeysAsString2();
	}
	
	public void outputState() {
		String s = getState();
		println(s);
		try {
			logWriter.write(s + "\n");
			logWriter.flush();
		} catch (IOException e) {
			errln(e.getMessage());
			e.printStackTrace();
		}
		colorArea.repaint();
	}

	public void keyPressed(KeyEvent ev) {
		char c = ev.getKeyChar();
		if (!pressedKeys.contains((Character) c)) {
			pressedKeys.add(c);
			outputState();
		}
	}

	public void keyReleased(KeyEvent ev) {
		char c = ev.getKeyChar();
		pressedKeys.remove((Character) c);
		outputState();
	}

	public void keyTyped(KeyEvent ev) {
	}
	
	
	
    
    private void addOutputArea(Container pane) {
    	JPanel zone = new JPanel();
    	zone.setLayout(new BoxLayout(zone, BoxLayout.LINE_AXIS));
    	zone.setBorder(BorderFactory.createTitledBorder("State changes:"));
    	zone.setMinimumSize(new Dimension(windowMinimalWidth, 240));
    	zone.setPreferredSize(new Dimension(windowDefaultWidth, 240));
    	
    	messageArea = new JTextPane();
    	messageArea.setEditable(false);
    	messageAreaStyledDocument = messageArea.getStyledDocument();
    	messageAreaDocumentAttributes = messageArea.getInputAttributes();

    	JScrollPane messageAreaJScrollPane = new JScrollPane(messageArea);
    	zone.add(messageAreaJScrollPane);
    	
    	pane.add(zone);
    }
    
    private void addInputArea(Container pane) {
    	JTextField typingArea = new JTextField(20);
    	typingArea.addKeyListener(this);
    	typingArea.setEditable(false);
    	typingArea.setMinimumSize(new Dimension(windowMinimalWidth, 20));
    	typingArea.setMaximumSize(new Dimension(1000000, 20));
    	typingArea.setText("Put the focus in this area to have the input work.");
    	pane.add(typingArea);
    }
    
	private class ColorArea extends JPanel {
		private static final long serialVersionUID = 7810422704731619329L;

		public void paintComponent(Graphics g) {
			super.paintComponent(g);
			
			Dimension displayAreaSize = getSize();
			int n = pressedKeys.size();
			g.setColor(Color.white);
			g.fillRect(0, 0, displayAreaSize.width, displayAreaSize.height);
			if (n > 0) {
				int dx = displayAreaSize.width/n;
				int i=0;
				for (Character c: pressedKeys) {
					switch ((char) c) {
					case '0':
						g.setColor(Color.green);
						break;
					case '2':
						g.setColor(Color.yellow);
						break;
					default:
						g.setColor(Color.red);
					}
					g.fillRect(i*dx, 0, dx, displayAreaSize.height);
					i++;
				}
			}
		}
	}
    
    private void addColorArea(Container pane) {
    	colorArea = new ColorArea();
    	colorArea.setMinimumSize(new Dimension(windowMinimalWidth, 240));
    	colorArea.setPreferredSize(new Dimension(windowDefaultWidth, 240));
    	pane.add(colorArea);
    }
    

    private void addComponentsToPane(Container pane) {
        pane.setLayout(new BoxLayout(pane, BoxLayout.PAGE_AXIS));
        
    	addInputArea(pane);
        addOutputArea(pane);
        addColorArea(pane);
    }

    /**
     * Create the GUI and show it.  For thread safety,
     * this method should be invoked from the
     * event-dispatching thread.
     */
    private void createAndShowGUI() {
        JFrame frame = new JFrame("AchaInput");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        addComponentsToPane(frame.getContentPane());
        frame.pack();
        frame.setResizable(true);
        frame.setVisible(true);
    }
    

    public void run() {
        javax.swing.SwingUtilities.invokeLater(new Runnable() {
            public void run() {
                createAndShowGUI();
                println("Welcome.");
                Date now = new Date();
                String date = DATE_FORMAT.format(now);
                File file = new File("log-" + date + ".txt");
                println("Opening log file " + file + "...");
                try {
					logWriter = new BufferedWriter(new FileWriter(file, false));
				} catch (IOException e) {
					errln(e.getMessage());
				}
				outputState();
            }
        });
    }

    public static void main(String[] args) {
    	(new AchaInput()).run();
    }
    

	public void print(String message) {
		try {
			messageAreaStyledDocument.insertString(messageAreaStyledDocument.getLength(), message, messageAreaDocumentAttributes);
		} catch (BadLocationException e) {
			e.printStackTrace();
		}
	}
	
	public void println(String message) {
		print(message + "\n");
	}
	
	public void err(String message) {
		Color oldColor = StyleConstants.getForeground(messageAreaDocumentAttributes);
		StyleConstants.setForeground(messageAreaDocumentAttributes, errorColor);
		try {
			messageAreaStyledDocument.insertString(messageAreaStyledDocument.getLength(), message, messageAreaDocumentAttributes);
		} catch (BadLocationException e) {
			e.printStackTrace();
		}
		StyleConstants.setForeground(messageAreaDocumentAttributes, oldColor);
	}
	
	public void errln(String message) {
		err(message + "\n");
	}
	
	public void res(String message) {
		boolean oldWeight = StyleConstants.isBold(messageAreaDocumentAttributes);
		StyleConstants.setBold(messageAreaDocumentAttributes, true);
		try {
			messageAreaStyledDocument.insertString(messageAreaStyledDocument.getLength(), message, messageAreaDocumentAttributes);
		} catch (BadLocationException e) {
			e.printStackTrace();
		}
		StyleConstants.setBold(messageAreaDocumentAttributes, oldWeight);
	}
	

	public void resln(String message) {
		res(message + "\n");
	}

}
