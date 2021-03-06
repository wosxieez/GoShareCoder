/*
 * com.goshare.Sb2Player Project Editor and Player
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

// Slider.as
// John Maloney, February 2013
//
// A simple slider for a fractional value from 0-1. Either vertical or horizontal, depending on its aspect ratio.
// The client can supply an optional function to be called when the value is changed.

package com.goshare.uiwidgets {
    import com.goshare.Sb2Player;

    import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import com.goshare.util.DragClient;

public class Slider extends Sprite implements DragClient {

	public var slotColor:int = 0xBBBDBF;
	public var slotColor2:int = -1; // if >= 0, fill with linear gradient from slotColor to slotColor2

	private var slot:Shape;
	private var knob:Shape;
	private var positionFraction:Number = 0; // range: 0-1

	private var isVertical:Boolean;
	private var isTriangle:Boolean;
	private var dragOffset:int;
	private var scrollFunction:Function;
	private var minValue:Number;
	private var maxValue:Number;

	public function Slider(w:int, h:int, scrollFunction:Function = null,isTriangle:Boolean=false) {
		this.scrollFunction = scrollFunction;
		this.isTriangle=isTriangle;
		minValue = 0;
		maxValue = 1;
		addChild(slot = new Shape());
		addChild(knob = new Shape());
		setWidthHeight(w, h);
		moveKnob();
		addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
	}

	public function get min():Number { return minValue; }
	public function set min(n:Number):void { minValue = n; }

	public function get max():Number { return maxValue; }
	public function set max(n:Number):void { maxValue = n; }

	public function get value():Number { return positionFraction * (maxValue - minValue) + minValue; }
	public function set value(n:Number):void {
		// Update the slider value (0-1).
		var newFraction:Number = Math.max(0, Math.min((n - minValue) / (maxValue - minValue), 1));
		if (newFraction != positionFraction) {
			positionFraction = newFraction;
			moveKnob();
		}
	}

	public function setWidthHeight(w:int, h:int):void {
		isVertical = h > w;
		drawSlot(w, h);
		drawKnob(w, h);
	}

	private function drawSlot(w:int, h:int):void {
		var g:Graphics = slot.graphics;
		if (isTriangle) {
			g.beginFill(slotColor,1); 
			g.moveTo(0,h/2.0+.5);
			g.lineTo(w,h);
			g.lineTo(w,0);
			g.lineTo(0,h/2.0-0.5);
			g.endFill();
		}
		else {
			const slotRadius:int = 9;
			g.clear();
			if (slotColor2 >= 0) {
				var m:Matrix = new Matrix();
				m.createGradientBox(w, h, (isVertical ? -Math.PI / 2 : Math.PI), 0, 0);
				g.beginGradientFill(GradientType.LINEAR, [slotColor, slotColor2], [1, 1], [0, 255], m);
			} else {
				g.beginFill(slotColor);
			}
			g.drawRoundRect(0, 0, w, h, slotRadius, slotRadius);
			g.endFill();
		}
	}

	private function drawKnob(w:int, h:int):void {
		const knobOutline:int = 0x707070;
		const knobFill:int = 0xEBEBEB;
		const knobRadius:int = 6; // 3;
		var knobW:int,knobH:int,o:int=0.5;
		if (isTriangle) {
			knobW = isVertical ? w + 3 : 7;
			knobH = isVertical ? 7 : h + 3;
			o+=2
		}
		else {
			knobW = isVertical ? w + 7 : 7;
			knobH = isVertical ? 7 : h + 7;
		}
		var g:Graphics = knob.graphics;
		g.clear();
		g.lineStyle(1, knobOutline);
		g.beginFill(knobFill);
		g.drawRoundRect(o, o, knobW, knobH, knobRadius, knobRadius);
		g.endFill();
	}

	private function moveKnob():void {
		if (isVertical) {
			knob.x = -4;
			knob.y = Math.round((1 - positionFraction) * (slot.height - knob.height));
		} else {
			knob.x = Math.round(positionFraction * (slot.width - knob.width));
			knob.y = -4;
		}
	}

	private function mouseDown(evt:MouseEvent):void {
		Sb2Player.app.gh.setDragClient(this, evt);
	}

	public function dragBegin(evt:MouseEvent):void {
		var sliderOrigin:Point = knob.localToGlobal(new Point(0, 0));
		if (isVertical) {
			dragOffset = evt.stageY - sliderOrigin.y;
			dragOffset = Math.max(5, Math.min(dragOffset, knob.height - 5));
		} else {
			dragOffset = evt.stageX - sliderOrigin.x;
			dragOffset = Math.max(5, Math.min(dragOffset, knob.width - 5));
		}
		dragMove(evt);
	}

	public function dragMove(evt:MouseEvent):void {
		var range:int, frac:Number;
		var localP:Point = globalToLocal(new Point(evt.stageX, evt.stageY));
		if (isVertical) {
			range = slot.height - knob.height;
			positionFraction = 1 - (localP.y - dragOffset) / range;
		} else {
			range = slot.width - knob.width;
			positionFraction = (localP.x - dragOffset) / range;
		}
		positionFraction = Math.max(0, Math.min(positionFraction, 1));
		moveKnob();
		if (scrollFunction != null) scrollFunction(this.value);
	}

	public function dragEnd(evt:MouseEvent):void {
		dispatchEvent(new Event(Event.COMPLETE));
	}

}}
