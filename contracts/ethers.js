import { expect } from "chai";
imprt { ethers } from "hardhat";
import { NFT__factory } from "../typechain-types";

describe("NFT Test", function() {
    it("should deploy and allow minting", async function() {
        const [_, addr1] = await ethers.getSigners(); //won't need the first array destructure item (owner)
        const NFTFactory = (await ethers.getContractFactory("NFT")) as NFT__factory;

        const nft = await NFTFactory.deploy(
            "My NFT Collection",
            "NFT",
            "https://nft.api.com/"
        );

        await nft.deploymentTransaction()?.wait();

        const mintPrice = ethers.parseEther("0.01");
        await nft.connect(addr1).mint(1, { value: mintPrice });

        const totalSupply = await nft.totalSupply();
        expect(totalSupply).to.equal(1);

        const ownerOfToken = await nft.ownerOf(1);
        expect(ownerOfToken).to.equal(addr1.address);
    });
});