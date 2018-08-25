pragma solidity ^0.4.18;

contract ethBaccarat {

    uint roomNo;

    uint constant WINSTATUS = uint(0);
    uint constant LOSESTATUS = uint(1);
    uint constant DRAWSTATUS = uint(2);

    struct Room {
        address[] playerAddr;
        uint readyCount;
        uint sizeRoom;
	    uint valueToCreate;
		
    }
	
    mapping(uint => mapping(uint => uint[])) matchPlayerToGame;
    mapping(uint => Room) roomInfo;
    mapping(address => uint) playerToRoom;
	
	
    constructor() public {
        roomNo = 1;
    }

    function createRoom() public returns(uint) {
        playerToRoom[msg.sender] = roomNo;
		
		 roomInfo[roomNo] = Room(new address[](0), 1,3,0);
		
		roomInfo[roomNo].valueToCreate = msg.value;
      
        ++roomNo;
        return roomNo-1;
        
    }
	
	function fineToClose(uint roomNo) public payable  {
	    
	    uint numberPlayer = roomInfo[roomNo].playerAddr.length;
	    uint refund = roomInfo[roomNo].valueToCreate/numberPlayer;
	    
	    for ( uint i = 0 ; i <= numberPlayer ; i++){
	        roomInfo[roomNo].playerAddr[i].transfer(refund);
	    }
    }	

    function joinRoom() public returns(uint) {
        require(playerToRoom[msg.sender] == 0, "This person already joins in another room");
        uint roomID = findEmptyRoom();
        require(roomID != uint(-1), "No room available");
        addPlayerToRoom(roomID);
        return (roomID);
    }

    function endRound(uint roomID) public payable {
        Room memory r = roomInfo[roomID];
        for(uint i=1; i<r.sizeRoom; i++){
            uint status = compareWin(0, i);
            require(status == WINSTATUS || status == DRAWSTATUS || status == LOSESTATUS, "status is invalid");
            if(status == WINSTATUS){

            } else if (status == LOSESTATUS) {

            } else {

            }
            // addressTarget.transfer();
        }
    }

    // function exitRoom() public {
    //     require(playerToRoom[msg.sender] != 0);
    //     uint roomID = findEmptyRoom();
    //     require(roomID != uint(-1));
    //     removePlayerToRoom(roomID);
    // }

    function compareWin(uint playerNo1, uint playerNo2) private pure returns(uint) {
        return WINSTATUS;
    }

    function findEmptyRoom() private view returns(uint) {
        for(uint i=1; i<roomNo; i++){
            Room memory r = roomInfo[i];
            if(r.playerAddr.length != r.sizeRoom){
                return i;
            }
        }
        return uint(-1);
    }

    function addPlayerToRoom(uint roomID) private {
        roomInfo[roomID].readyCount++;
        roomInfo[roomID].playerAddr.push(msg.sender);
        playerToRoom[msg.sender] = roomID;
    }

    // function deletePlayerIndex(uint roomID, uint idxPlayer) private {
    //     uint lstPlayerID = RoomInfo[roomID].player.length-1;
    //     RoomInfo[roomID].player[idxPlayer] = RoomInfo[roomID].player[lstPlayerID];
    //     delete RoomInfo[roomID].player[lstPlayerID];
    //     RoomInfo[roomID].player.length--;
    // }

    // function IndexPlayerInRoom(Room r) private view returns(uint) {
    //     for (uint i=0;i<r.player.length; i++){
    //         if(r.player[i].playerAddr == msg.sender){
    //             return i;
    //         }
    //     }
    //     return uint(-1);
    // }

    // function removePlayerToRoom(uint roomID) private {
    //     RoomInfo[roomID].readyCount--;
    //     playerToRoom[msg.sender] = 0;
    //     Room memory r = RoomInfo[roomID];
    //     uint idxPlayer = IndexPlayerInRoom(r);
    //     deletePlayerIndex(roomID, idxPlayer);
    // }
    function randomCard(uint8 room) private{
    bool duplicate;
    uint256 numPlayers = roomInfo[room].playerAddr.length;
    uint256 numCards = numPlayers * 2;
    uint256 rand;
    uint256[] prev;
    duplicate = false;
    for(uint i = 0; i < numPlayers;i++){
        duplicate = false;
      do{
        rand = uint256(keccak256(now, i));
        for(uint j = 0; j < prev.length;j++){
          if (rand == prev[j]){
            duplicate = true;
            break;
          }
        }
      } 
      while(duplicate);
      matchPlayerToGame[room][uint8(i/2)].push(rand/13);
      prev.push(rand);
    }
    
    
    
    
  }

}
