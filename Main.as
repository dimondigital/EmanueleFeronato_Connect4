package {
	
	import flash.display.*;
	
	public class Main extends Sprite {
		private var gameField:Array;
		private var board:mc_board;
		private var disc_cont:Sprite = new Sprite();
		private var disc:mc_disc;
		
	    public function Main () {
			prepareField();
			placeBoard();
			placeDisc(Math.floor(Math.random()*2)+1);
		}
		private function prepareField():void {
			gameField = new Array();
			for ( var i:uint = 0; i<6; i++) {
				gameField[i] = new Array();
				for (var j:uint = 0; j<7; j++) {
					gameField[i].push(0);
				}
			}
		}
		private function placeBoard():void  {
			board = new mc_board();
			addChild(disc_cont);
			disc_cont.x = board.x;
			disc_cont.y = board.y;
			addChild(board);
			
		}
		public function placeDisc(player:uint)	:void {
			disc = new mc_disc(player);
			disc_cont.addChild(disc);
		}
		public function possibleColumns():Array {
			var moves_array = new Array();
			for (var i:uint = 0; i<7; i++) {
				if (gameField [0] [i] == 0) {
					moves_array.push(i);
				}
				}
				return moves_array;
		}
		public function firstFreeRow (column:uint, player:uint):int {
			for (var i:uint = 0; i<6; i++) {
				if (gameField [i] [column] != 0) {
					break;
				}
			}
			gameField [i-1] [column] = player;
			return i-1;
		}
		private function cellValue (row:uint, col:uint):int {
			if (gameField [row] == undefined || gameField [row] [col] == undefined) {
				return -1;
				}else{
					return gameField [row] [col];
				}
		}
		private function getAdj (row:uint,col:uint,row_inc:int,col_inc:int):uint {
            if (cellValue(row,col)==cellValue(row+row_inc,col+col_inc)) {
                   return 1+getAdj(row+row_inc,col+col_inc,row_inc,col_inc);
            } else {
                   return 0;
               }
        }
		public function checkForVictory(row:uint,col:uint):Boolean {
			if (getAdj(row,col,0,1)+getAdj(row,col,0,-1)>2) {
				return true;
			} else {
				if (getAdj(row,col,1,0)>2) {
					return true;
				} else {
					if (getAdj(row,col,-1,1)+getAdj(row,col,1,-1)>2) {
						return true;
					} else {
						if (getAdj(row,col,1,1)+getAdj(row,col,-1,-1)>2) {
							return true;
						} else {
							return false;
						}
					}
				}
			}
		}
		public function think():Array {
			 var possibleMoves:Array=possibleColumns();
			 var aiMoves:Array=new Array();
			 var blocked:uint;
			 var bestBlocked:uint=0;
			 for (var i:uint=0; i<possibleMoves.length; i++) {
				 for (var j:uint=0; j<6; j++) {
					 if (gameField[j][possibleMoves[i]]!=0) {
						 break;
					 }
				 }
				 gameField[j-1][possibleMoves[i]]=1;
				  blocked=getAdj(j-1,possibleMoves[i],0,1)+getAdj(j-1,possibleMoves[i],0,-1);
				  blocked=Math.max(blocked,getAdj(j-1,possibleMoves[i],1,0));
                  blocked=Math.max(blocked,getAdj(j-1,possibleMoves[i],-
1,1)+getAdj(j-1,possibleMoves[i],1,-1));
                  blocked=Math.max(blocked,getAdj(j-1,possibleMoves[i],1,1)+getAdj(j
-1,possibleMoves[i],-1,-1));
				   if (blocked>=bestBlocked) {
					    if (blocked>bestBlocked) {
							 bestBlocked=blocked;
                             aiMoves=new Array();
						}
						 aiMoves.push(possibleMoves[i]);
				   }
				    aiMoves.push(possibleMoves[i]);
			 }
			 return aiMoves;
		}
	}
}