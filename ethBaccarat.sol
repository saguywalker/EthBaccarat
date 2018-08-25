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
    }
    mapping(uint => mapping(uint => uint[])) _trial;
    mapping(uint => Room) roomInfo;
    mapping(address => uint) playerToRoom;

    constructor() public {
        roomNo = 1;
    }

    function createRoom() public returns(uint) {
        playerToRoom[msg.sender] = roomNo;
        roomInfo[roomNo] = Room(new address[](0), 1,3);
        ++roomNo;
        return roomNo-1;
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
    function randomCard(uint8 room) private payable{
    bool duplicate = false;
    numPlayers = roomInfo[room].playerAddr.length;
    uint8 numCards = numPlayers * 2;
    uint8 rand;
    uint8[] prev;
    duplicate = false;
    for(uint8 i = 0; i < numPlayers;i++){
      do{
        rand = keccak(now + i);
        for(uint8 j = 0; j < prev.length;j++){
          if (rand == prev[j]){
            duplicate = true;
            break;
          }
        }
      }while(duplicate);
      _trial[room][uint8(i/2)].push(rand);
      prev.push();
    }
  }

}
