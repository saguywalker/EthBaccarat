pragma solidity ^0.4.18;

contract ethBaccarat {

    uint roomNo;

    uint constant WINSTATUS = uint(0);
    uint constant LOSESTATUS = uint(1);
    uint constant DRAWSTATUS = uint(2);

    struct Room {
        address[] playerAddr;
        bool[] playerReady;
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

    function CreateRoom() public payable returns(uint) {
        uint roomID = roomNo;
        roomInfo[roomID] = Room(new address[](0), new bool[](0), 0,3, msg.value);
        addPlayerToRoom(roomID, msg.sender);
        ++roomNo;
        return roomID;
    }
	
    function FineToClose(uint roomID) public payable  {
        uint numberPlayer = roomInfo[roomID].playerAddr.length;
        uint refund = roomInfo[roomID].valueToCreate/numberPlayer;

        for ( uint i = 0 ; i <= numberPlayer ; i++){
            roomInfo[roomID].playerAddr[i].transfer(refund);
        }
    }	

    function JoinRoom() public returns(uint) {
        require(playerToRoom[msg.sender] == 0, "This person already joins in another room");
        uint roomID = findEmptyRoom();
        require(roomID != uint(-1), "No room available");
        addPlayerToRoom(roomID, msg.sender);
        return roomID;
    }

    function ExitRoom() public {
        uint roomID = playerToRoom[msg.sender];
        require(roomID != 0, "This person is not in any room yet.");
        removePlayerInRoom(roomID, msg.sender);
    }
    
    function SetReady() public {
        uint roomID = playerToRoom[msg.sender];
        Room memory r = roomInfo[roomID];
        uint idxPlayer = IndexPlayerInRoom(r, msg.sender);
        if(roomInfo[roomID].playerReady[idxPlayer] == false){
            roomInfo[roomID].playerReady[idxPlayer] = true;
            ++roomInfo[roomID].readyCount;
        }
    }
    
    function GetRoomByRoomNo(uint roomID) public view returns(address[], bool[], uint, uint) {
        Room memory r = roomInfo[roomID];
        return (r.playerAddr, r.playerReady, r.readyCount, r.sizeRoom);
    }

    function GetCards(uint roomID, uint idxPerson) public view returns(uint[]) {
        return matchPlayerToGame[roomID][idxPerson];
    }

    function endRound(uint roomID) public payable {
        Room memory r = roomInfo[roomID];
        for(uint i = 1; i<r.sizeRoom; i++){
            uint status = compareWin(0, i);
            require(status == WINSTATUS || status == DRAWSTATUS || status == LOSESTATUS, "status is invalid");
            if(status == WINSTATUS){

            } else if (status == LOSESTATUS) {

            } else {

            }
            // addressTarget.transfer();
        }
    }

    function compareWin(uint playerNo1, uint playerNo2) private pure returns(uint) {
        return WINSTATUS;
    }

    function findEmptyRoom() private view returns(uint) {
        for(uint i = 1; i<roomNo; i++){
            Room memory r = roomInfo[i];
            if(r.playerAddr.length != r.sizeRoom){
                return i;
            }
        }
        return uint(-1);
    }

    function addPlayerToRoom(uint roomID, address playerAddr) private {
        roomInfo[roomID].readyCount++;
        roomInfo[roomID].playerAddr.push(playerAddr);
        roomInfo[roomID].playerReady.push(false);
        playerToRoom[playerAddr] = roomID;
    }

    // IndexPlayerInRoom returns the index of the playerAddr list in the room. 
    function IndexPlayerInRoom(Room r, address playerAddr) private pure returns(uint) {
        for (uint i = 0; i < r.playerAddr.length ; i++) {
            if(r.playerAddr[i] == playerAddr){
                return i;
            }
        }
        return uint(-1);
    }

    // removePlayerFromAddrList removes the given playerIdx in the playerAddr list from the given room.
    function removePlayerFromAddrList(uint roomID, uint playerIdx) private {
        uint lstPlayerID = roomInfo[roomID].playerAddr.length-1;
        roomInfo[roomID].playerAddr[playerIdx] = roomInfo[roomID].playerAddr[lstPlayerID];
        delete roomInfo[roomID].playerAddr[lstPlayerID];
        roomInfo[roomID].playerAddr.length--;
    }

    // removePlayerFromAddrList removes the given playerIdx in the playerReady list from the given room.
    function removePlayerFromReadyList(uint roomID, uint playerIdx) private {
        uint lstPlayerID = roomInfo[roomID].playerReady.length-1;
        roomInfo[roomID].playerReady[playerIdx] = roomInfo[roomID].playerReady[lstPlayerID];
        delete roomInfo[roomID].playerReady[lstPlayerID];
        roomInfo[roomID].playerReady.length--;
    }
    
    // removePlayerInRoom removes the playerAddr out of the given room.
    function removePlayerInRoom(uint roomID, address playerAddr) private {
        Room memory r = roomInfo[roomID];
        uint idxPlayer = IndexPlayerInRoom(r, playerAddr);
        require(idxPlayer != uint(-1), "cannot find playerAddress in the room");
        require(idxPlayer != 0, "caller is a host");

        roomInfo[roomID].readyCount--;
        playerToRoom[playerAddr] = 0;
        removePlayerFromAddrList(roomID, idxPlayer);
        removePlayerFromReadyList(roomID, idxPlayer);
    }

    function randomCard(uint8 room) private {
        bool duplicate;
        uint256 numPlayers = roomInfo[room].playerAddr.length;
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
            } while(duplicate);
            matchPlayerToGame[room][uint8(i/2)].push(rand/13);
            prev.push(rand);
        }
    }
}
