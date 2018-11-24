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

// MotionAndPenPrims.as
// John Maloney, April 2010
//
// Scratch motion and pen primitives.

package primitives {
    import com.goshare.blocks.*;

    import com.goshare.gpip.GpipManager;

    import flash.utils.Dictionary;

    import interpreter.*;

    public class GoSharePrims {

        private var app:Scratch;
        private var interp:Interpreter;

        public function GoSharePrims(app:Scratch, interpreter:Interpreter) {
            this.app = app;
            this.interp = interpreter;
        }

        public function addPrimsTo(primTable:Dictionary):void {
            primTable["goShareTTS:"] = primGoShareTTS;
            primTable["goSharePDF:"] = primGoSharePDF;
            primTable["goShareSWF:"] = primGoShareSWF;
            primTable["goShareMove:"] = primGoShareSWF;
            primTable["connectGpip:"] = connectGpip;
            primTable["classPlan:"] = classPlan;
        }

        private function primGoShareTTS(b:Block):void {
            trace('do tts')
            GpipManager.getInstance().tts(interp.arg(b, 0))
        }

        private function primGoSharePDF(b:Block):void {
            trace('do tts')
            GpipManager.getInstance().tts(interp.arg(b, 0))
        }

        private function primGoShareSWF(b:Block):void {
            trace('do tts')
            GpipManager.getInstance().tts(interp.arg(b, 0))
        }


        private function connectGpip(b:Block):void {
            trace('do connectGpip')
            GpipManager.getInstance().init('192.168.1.247', 19090)
        }

        private function classPlan(b:Block):void {
            trace('do classPlan')
            GpipManager.getInstance().tts('收到课程计划 ' +  interp.arg(b, 0) + '要上' + interp.arg(b, 1) + '课')
        }

    }}
