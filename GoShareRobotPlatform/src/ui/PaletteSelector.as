/*
 * Scratch Project Editor and Player
 * Copyright (C) 2014 Massachusetts Institute of Technology
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

// PaletteSelector.as
// John Maloney, August 2009
//
// PaletteSelector is a UI widget that holds set of PaletteSelectorItems
// and supports changing the selected category. When the category is changed,
// the blocks palette is filled with the blocks for the selected category.

package ui {
	import flash.display.*;
	import translation.Translator;
	import scratch.PaletteBuilder;

public class PaletteSelector extends Sprite {

	private static const categories:Array = [
		'Motion', 'Looks', 'Sound', 'Pen', 'Data', // column 1
		'Events', 'Control', 'Sensing', 'Operators', 'More Blocks', 'GoShare']; // column 2

	public var selectedCategory:int = 0;
	private var app:Scratch;

	public function PaletteSelector(app:Scratch) {
		this.app = app;
		initCategories();
	}

	public static function strings():Array {
		return categories.concat([
			'when Stage clicked'
		]);
	}
	public function updateTranslation():void { initCategories() }

	public function select(id:int, shiftKey:Boolean = false):void {
		for (var i:int = 0; i < numChildren; i++) {
			var item:PaletteSelectorItem = getChildAt(i) as PaletteSelectorItem;
			item.setSelected(item.categoryID == id);
		}
		var oldID:int = selectedCategory;
		selectedCategory = id;
		app.getPaletteBuilder().showBlocksForCategory(selectedCategory, (id != oldID), shiftKey);
	}

	private function initCategories():void {
		while (numChildren > 0) removeChildAt(0); // remove old contents
		for (var i:int = 0; i < categories.length; i++) {
			var entry:Array = Specs.entryForCategory(categories[i]);
			var item:PaletteSelectorItem = new PaletteSelectorItem(entry[0], Translator.map(entry[1]), entry[2]);
			item.x = 0;
			item.y = 46 * i;
			addChild(item);
		}
		setWidthHeightColor(50, 46 * categories.length);
	}

	private function setWidthHeightColor(w:int, h:int):void {
		var g:Graphics = graphics;
		g.clear();
		g.beginFill(0xFFFFFF); // invisible (alpha = 0) rectangle used to set size
		g.drawRect(0, 0, w - 1, h);
	}

}}
