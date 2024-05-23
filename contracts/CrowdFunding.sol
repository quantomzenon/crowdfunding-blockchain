// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    struct Campaign {
        address Owner;
        string title;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donators;
        uint256[] donations;
    }

    mapping(uint256 => Campaign) public campaigns;

    uint256 public numberofCampaigns = 0;

    function CreateCampaign(address _owner, string memory _title , string memory _description , uint256 _target , uint256 _deadline, string memory _image) public returns(uint256) {
        Campaign storage campaign = campaigns[numberofCampaigns];

        require(campaign.deadline < block.timestamp , "The dealine should be a date in the future.");
        campaign.Owner = _owner;
        campaign.title =_title;
        campaign.target=_target;
        campaign.deadline=_deadline;
        campaign.amountCollected= 0 ;
        campaign.image=_image;

        numberofCampaigns++;

        return numberofCampaigns-1;//Index of the most newly created Campaign
    }
    function donateToCampaign(uint256 _id)public payable {
      uint256 amount = msg.value;

      Campaign storage campaign = campaigns[_id];//The "campaigns" here is reffering to the mapping 
      campaign.donators.push(msg.sender);
      campaign.donations.push(amount);
      

      (bool sent,) = payable(campaign.Owner).call{value: amount}("");//In this line we are sending the amount to the campaign owner 
      //and "calling" the amount and this makes the boolean value sent as true then initiating the if condition below 
      
      if(sent) {
        campaign.amountCollected = campaign.amountCollected + amount ;
      }

    }
    function getDonators(uint256 _id)view public returns(address[] memory,uint256[] memory) {
        return(campaigns[_id].donators,campaigns[_id].donations);
    }
    function getCampaigns() public view returns(Campaign[] memory ){
        Campaign[] memory allCampaigns = new Campaign[](numberofCampaigns);//we are creating an array of empty elements which are equal to the numberofCampaigns

        for(uint i = 0 ;i<numberofCampaigns;i++){
            Campaign storage item = campaigns[i];

            allCampaigns[i]=item;
        }
        return allCampaigns;
    }

}