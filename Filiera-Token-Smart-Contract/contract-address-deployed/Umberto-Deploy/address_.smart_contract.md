- Compilato con Truffle di Windows 11 
- Deployato con FireFly di WSL Ubuntu 22.04 

- Definizione delle Interfacce in FireFly SandBox : 

1. Compila con Truffle 

2. Deploy il .json su FireFly 

3. Definisci l'interfaccia andando ad inserire il nome del contratto "FilieraToken" 

4. Registra il contratto con il nome del contratto andando ad inserire anche "Service" -> "FilieraTokenService"

5. Richiama i metodi del contratto "invoke" -> chiamata di POST per cambiare lo stato dello smart contract 
                                    "query" -> chiamata di GET per visualizzare lo stato dello samrt contract



- FilieraToken : Smart Contract 
"address" : "0xac2035beb811680932af7d1e7f3f3f5303e52006" V

-----------------------------------------------------------------------------

- AccessControlProduct:

* - AccessControlProductMilkBatch Address
"address": "0x011be3cbc5c07304cd374fd2839d8359d4cd42bc" V -> deployed 

* - AccessControlProductCheese Address
"address": "0x3e52a7cd211580a96feb2424313a3f18d3e90b18"

* - AccessControlProductCheesePiece Address
"address": "0x3e52a7cd211580a96feb2424313a3f18d3e90b18"



- TransactionManager:

* - TransactionBuyMilkBatch Address
"address": "0x3e52a7cd211580a96feb2424313a3f18d3e90b18"

* - TransactionBuyCheese Address
"address": "0x3e52a7cd211580a96feb2424313a3f18d3e90b18"

* - TransactionBuyCheesePiece Address
"address": "0x3e52a7cd211580a96feb2424313a3f18d3e90b18"