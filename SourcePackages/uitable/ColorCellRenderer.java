// ColorCellRenderer - Modified TableCellRenderer for color cells

// Programmed by Yair M. Altman: altmany(at)gmail.com
// $Revision: 1.1 $  $Date: 2010/06/16 15:57:03 $

import java.awt.Color;
import java.awt.Component;

import javax.swing.JTable;
import javax.swing.JComponent;
import javax.swing.table.TableCellRenderer;
import javax.swing.table.DefaultTableCellRenderer;

public class ColorCellRenderer extends DefaultTableCellRenderer implements TableCellRenderer
{
	Color _color;

	public ColorCellRenderer() {
		super();
		setOpaque(true);
	}

	public Component getTableCellRendererComponent(JTable table, Object color, boolean isSelected, boolean hasFocus, int row, int column) {
		JComponent cell = (JComponent) super.getTableCellRendererComponent(table, color, isSelected, hasFocus, row, column);
		try {
			if (color == null)
				_color = new Color(1F,0F,0F);
			else if (color instanceof Color)
				_color = (Color) color;
			else //if (color instanceof String)
			{
				//This works only starting java 1.4...
				String[] rgb = ((String) color).split(",");
				_color = new Color(java.lang.Float.valueOf(rgb[0]).floatValue()/255F, 
								   java.lang.Float.valueOf(rgb[1]).floatValue()/255F, 
								   java.lang.Float.valueOf(rgb[2]).floatValue()/255F);
			}

			// Successfully set the color - now apply it to the background...
			setText("");
			cell.setBackground(_color);
			//setBorderPainted(hasFocus);
			//table.setValueAt(_color,row,column);
		}
		catch (Exception e) {
			System.out.println("=> ColorCellRenderer got: " + color + " => " + e);
		}
		return cell;
	}
}
