//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.4.21 <0.9.0;

contract FoodChain {


    address gov;

    modifier onlyOwner() {
        require(msg.sender == gov);
        _;
    }

    constructor(){
       gov = msg.sender;
    }

    // struct FoodGrains{
    //     string name;
    //     uint quantity;
    //     uint price;
    // }

    struct asset_amount  {
       uint rice;
       uint wheat;
       
    }

    struct beneficiary{
       address fpsId;
       address benId;
       uint rice;
       uint wheat;
 
   }

    event ChangedStock
    (
        address fpsId,
        uint rice,
        uint wheat

    );



    

    mapping(address => bool) public RegisteredBeneficiaryMapping;
    mapping(address => bool) public RegisteredFpsMapping;
    // FoodGrains[] public food;
    mapping(address => asset_amount) public distributingFps;
    mapping(address => beneficiary[]) public beneficiaryMapping;
    event verified(address id);

    uint  allocatedRice =0;
    uint  allocatedWheat =0;
 
    function registerBeneficiary(address ben_id) public {

       if(msg.sender != gov) revert('You are not authorised to register a benificiary');
       if(RegisteredBeneficiaryMapping[ben_id]) revert('You are already registered'); 
       RegisteredBeneficiaryMapping[ben_id] = true;

    }

    function registerFps(address fps_id) public  {

        if(msg.sender != gov) revert('You are not authorised to register FPS');
        if(RegisteredFpsMapping[fps_id]) revert('You are already registered');
        RegisteredFpsMapping[fps_id] = true;

    }

    function foodGrainsAllocationToFPS(address fpsId, uint rice,uint wheat) public onlyOwner {
       
       asset_amount memory foodGrains = distributingFps[fpsId];

       allocatedRice = foodGrains.rice + rice;
       allocatedWheat  = foodGrains.wheat + wheat;
       
       distributingFps[fpsId] = asset_amount(allocatedRice,allocatedWheat);
       emit ChangedStock(fpsId,rice,wheat);
   
    }

    function getGrainAmount() public  view returns (uint,uint){
        return (allocatedRice, allocatedWheat);
    }

    function verifyBenificiary (address ben_id, address fps_id) public{
       if(!RegisteredFpsMapping[fps_id]) revert();
            if(RegisteredBeneficiaryMapping[ben_id] == true)
                emit verified(ben_id); 
    }

    function sellGrains(address ben_id, address fps_id, uint rice, uint wheat)public {

        allocatedRice = allocatedRice - rice;
        allocatedWheat = allocatedWheat - wheat;

        distributingFps[fps_id] = asset_amount(allocatedRice,allocatedWheat);
        beneficiaryMapping[ben_id].push(beneficiary(fps_id,ben_id, rice,wheat));
    }


}