const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Greeter", function () {
  it("Should return the new greeting once it's changed", async function () {
    const Greeter = await ethers.getContractFactory("GalleryChild");
    const greeter = await Greeter.deploy("Hol", "Hol", "0xb5505a6d998549090530911180f38aC5130101c6");
    await greeter.deployed();

    expect(await greeter.getChainId()).to.not.equal(0);

    //log the chain id
    console.log("Chain ID:", await greeter.getChainId());

  });
});
