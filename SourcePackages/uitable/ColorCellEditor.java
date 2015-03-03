// ColorCellEditor - Modified CellEditor for color cells

// Programmed by Yair M. Altman: altmany(at)gmail.com
// $Revision: 1.1 $  $Date: 2010/06/16 15:57:03 $

import java.awt.Color;
import java.awt.Component;

import javax.swing.AbstractCellEditor;
import javax.swing.JTable;
import javax.swing.table.TableCellEditor;

import com.jidesoft.combobox.ColorComboBox;

public class ColorCellEditor extends AbstractCellEditor implements TableCellEditor
{
    Color _color;
    ColorComboBox _cb = new ColorComboBox();

	public ColorCellEditor() {
		super();
        _cb.setColorValueVisible(false);
	}

	public Component getTableCellEditorComponent(JTable table, Object color, boolean isSelected, int row, int column) {
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
			_cb.setSelectedColor(_color);
		}
		catch (Exception e) {
			System.out.println("=> ColorCellEditor got: " + color + " => " + e);
		}
		return _cb;
	}

	public Object getCellEditorValue() {
		return _cb.getSelectedColor();
	}
}
