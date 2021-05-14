package  {
	import flash.display.*;
	import flash.events.*;
	
	public class mc_disc extends MovieClip {
		private var currentColumn:int;
		private var currentPlayer:uint;
		private var par:Main;
		private var currentRow:uint;
		private var fallingDistance:uint = 0;

		public function mc_disc(player:uint) {
			currentPlayer = player;
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		private function onAdded(e:Event) {
			par = this.parent.parent as Main;
			moveHorizontally();
			if (currentPlayer==1) {
				stage.addEventListener(MouseEvent.CLICK, onMouseClick);
			}else{
				computerMove();
			}
			
			gotoAndStop(currentPlayer);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		private function onEnterFrame(e:Event) {
             if (fallingDistance==0) {
				 moveHorizontally();
			 }else{
				 moveVertically();
			 }
         }
		private function moveHorizontally():void {
			 currentColumn=Math.floor((stage.mouseX - this.parent.x)/60);
			 if  (currentColumn<0) {
				  currentColumn = 0;
			 }
			 if  (currentColumn>6) {
				  currentColumn=6;
			 }
			 x = 35+60*currentColumn;
			 y=-40;
		}
		private function moveVertically():void {
			y+=15;
			if (y==fallingDistance) {
				fallingDistance=0;
				 removeEventListener(Event.ENTER_FRAME,onEnterFrame); 
				 checkForVictory();
			}
		}
		private function onMouseClick (e:MouseEvent) {
			if (par.possibleColumns().indexOf(currentColumn) != -1) {
				dropDisc();
			}
		}
		private function dropDisc():void {
			currentRow=par.firstFreeRow(currentColumn,currentPlayer);
            fallingDistance=35+currentRow*60;
			if (currentPlayer == 1) {
				 stage.removeEventListener(MouseEvent.CLICK,onMouseClick);
			}
        }
		private function checkForVictory():void {
			if (! par.checkForVictory(currentRow,currentColumn)) {
				par.placeDisc(3-currentPlayer);
			} else {
				trace("Player "+currentPlayer+" wins!!!");
			}
		}
		private function computerMove():void {
			 var possibleMoves:Array=par.think();
			 var cpuMove:uint=Math.floor(Math.random()*possibleMoves.length);
			 currentColumn=possibleMoves[cpuMove];
			 x=35+60*currentColumn;
			 currentRow=par.firstFreeRow(currentColumn,currentPlayer);
			  fallingDistance=35+currentRow*60;
		}
										  

	}
	
}
