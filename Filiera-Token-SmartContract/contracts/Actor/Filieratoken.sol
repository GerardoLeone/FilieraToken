// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Filieratoken is ERC20 {

  // Nome del token
  string private constant _name = "FilieraToken";

  // Simbolo del token
  string private constant _symbol = "FLT";

  // Fornitura totale di token
  uint256 private constant _totalSupply = 1000000000; // Modifica questo valore in base alle tue esigenze

  constructor() ERC20(_name, _symbol) {
    // Assegna la fornitura totale al deployer
    _mint(address(this), _totalSupply);
  }

  // Funzione per visualizzare il saldo di un utente
  function balanceOf(address account) public view override returns (uint256) {
    return super.balanceOf(account);
  }

  // Funzione per trasferire token da un utente all'altro
  function transfer(address to, uint256 amount) public  override returns (bool) {
     super.transferFrom(address(this), to, amount);
     return true;
  }


  function burnToken(address user, uint256 balance) public  returns (bool) {
    super._burn(user, balance);
    return true;
  }

  // Funzione per approvare un altro spender a trasferire token per tuo conto
  function approve(address spender, uint256 amount) public override returns (bool) {
    return super.approve(spender, amount);
  }

  function transferBuyProduct(address to, address from, uint256 amount) public returns (bool){
    super.transferFrom(from, to, amount);
    return true;
  }



}
