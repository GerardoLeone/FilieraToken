# Filiera-Token

## Introduzione

Benvenuti nel progetto FilieraToken!

Il sistema proposto si concentra sulla gestione della filiera lattiero-casearia attraverso un'applicazione distribuita (DApp) basata su tecnologia blockchain. Questa soluzione innovativa, chiamata FilieraToken, mira a garantire la trasparenza, l'efficienza e la tracciabilità lungo l'intera catena di produzione e distribuzione del formaggio.

### Attori della Filiera:

| Ruolo Attore | Descrizione | Immagine |
| ------------ | ----------- | -------- |
| Centro di Raccolta e Trasformazione del Latte | Il Centro di Raccolta e Trasformazione del Latte svolge un ruolo cruciale nel processo di produzione. È responsabile della raccolta del latte dalle aziende agricole, della sua trasformazione in formaggio e della distribuzione ai successivi attori della filiera. | ![Centro di Raccolta](./docs/milk_farm.jpg) |
| Produttore di Formaggio | Il Produttore di Formaggio riceve il latte trasformato dal Centro di Raccolta e Trasformazione del Latte e lo utilizza per creare i prodotti caseari. Utilizzando la tecnologia blockchain, ogni passaggio nella produzione del formaggio viene registrato in modo sicuro e immutabile. | ![Produttore di Formaggio](./docs/cheeseProducer.jpg) |
| Retailer | Il Retailer è l'ultimo anello della catena di distribuzione prima che il formaggio raggiunga il consumatore finale. Grazie a CheeseChain, il Retailer può garantire ai propri clienti la provenienza e la qualità del formaggio offerto. | ![Retailer](./docs/retailer.jpg) |
| Consumatore | Il Consumatore rappresenta il destinatario finale del formaggio. Grazie alla tracciabilità garantita dalla tecnologia blockchain, il Consumatore può avere fiducia nell'origine e nella qualità del prodotto che sta acquistando. | ![Consumatore](./docs/consumer.jpg) |



### Prodotti:

| Nome del Prodotto | Descrizione | Immagine |
| ----------------- | ----------- | -------- |
| CheeseBlock (Blocco di Formaggio) | Il CheeseBlock rappresenta un'unità di formaggio prodotta e distribuita lungo la filiera. Ogni CheeseBlock è unico e identificabile attraverso il suo hash sulla blockchain di CheeseChain. | ![CheeseBlock](./Filiera-Token-FrontEnd/filiera_token_front_end/assets/cheese_block.png) |
| CheesePiece (Pezzetto di Formaggio) | Il CheesePiece è una frazione più piccola del formaggio, spesso utilizzata per degustazioni o per la preparazione di piatti specifici. Anche il CheesePiece è tracciabile attraverso la blockchain di CheeseChain. | ![CheesePiece](./Filiera-Token-FrontEnd/filiera_token_front_end/assets/cheese_piece.png) |
| MilkBatch (Partita di Latte) | Il MilkBatch è una partita specifica di latte raccolto e trasformato in formaggio. Ogni MilkBatch è registrato sulla blockchain insieme alle informazioni riguardanti la sua origine e il suo percorso nella filiera. | ![MilkBatch](./Filiera-Token-FrontEnd/filiera_token_front_end/assets/milk.png) |


## Architettura

![Immagine Architettura](./docs/architettura.png)

L'architettura del sistema è composta dalle seguenti componenti e tecnologie:

### Componenti:

| Strumento/Framework | Descrizione                                                                                                                                                                            |
|----------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Docker               | Docker permette di creare un ambiente virtuale isolato per l'esecuzione di Firefly. Questo fornisce un'infrastruttura modulare e scalabile per la gestione delle applicazioni blockchain. |
| Firefly              | Firefly rappresenta il nucleo del sistema, fornendo la piattaforma e le funzionalità essenziali per la gestione della filiera lattiero-casearia tramite la tecnologia blockchain.    |
| Hyperledger Besu     | Hyperledger Besu è un client Ethereum completo che implementa la specifica Ethereum Proof of Authority (PoA). È utilizzato per l'interazione con la blockchain Ethereum e per l'esecuzione dei contratti intelligenti. |
| Truffle              | Truffle è un framework di sviluppo per la scrittura e la migrazione di smart contract. Fornisce strumenti per lo sviluppo, il testing e la distribuzione di contratti intelligenti su blockchain Ethereum. |
| HardHat              | Hardhat è un framework di sviluppo per la scrittura e la migrazione di smart contract. Fornisce strumenti per lo sviluppo, il testing e la distribuzione di contratti intelligenti su blockchain Ethereum. |



### Tecnologie:

| Tecnologia | Descrizione | Immagine |
| ---------- | ----------- | -------- |
| Python | Python è il linguaggio di programmazione utilizzato per lo sviluppo di Firefly. Offre flessibilità e facilità di sviluppo per implementare le funzionalità del sistema. | ![Python](inserisci-il-tuo-link-all-immagine-python.png) |
| Solidity | Solidity è il linguaggio di programmazione utilizzato per lo sviluppo di Hyperledger Besu. È noto per le sue prestazioni elevate e la concorrenza incorporata, rendendolo ideale per applicazioni blockchain. | ![Solidity](inserisci-il-tuo-link-all-immagine-solidity.png) |
| Flutter | Flutter è un framework open-source sviluppato da Google per la creazione di app mobili multi-piattaforma. Utilizza il linguaggio di programmazione Dart e offre un'ampia gamma di widget personalizzabili e un sistema di rendering veloce. | ![Flutter](inserisci-il-tuo-link-all-immagine-flutter.png) |
| JWT (JSON Web Token) | JWT è uno standard aperto (RFC 7519) che definisce un modo compatto e autonomo per trasmettere informazioni in sicurezza tra due parti come un oggetto JSON. È comunemente utilizzato per autenticare e autorizzare gli utenti in applicazioni web e API RESTful. | ![JWT](inserisci-il-tuo-link-all-immagine-jwt.png) |
| Metamask | Metamask è un'estensione del browser che consente agli utenti di gestire facilmente il proprio portafoglio Ethereum e interagire con le DApp (Decentralized Applications) sulla blockchain Ethereum direttamente dal browser. | ![Metamask](inserisci-il-tuo-link-all-immagine-metamask.png) |


![Immagine Architettura](./docs/docker_architecture.png)


## Navigazione

Gli utenti hanno accesso alle seguenti pagine in base al loro ruolo:

![Immagine Architettura](./docs/navigazione_utente.png)

- **Guest**: L'utente in modalità guest può accedere solo alle pagine di Login e SignUp per registrarsi o accedere al sistema.
- **MilkHub**: L'utente MilkHub ha accesso alle pagine di Inventory e Setting per gestire i propri dati e le proprie preferenze.
- **CheeseProducer**: L'utente CheeseProducer ha accesso alle pagine di Shop, Inventory, Setting e Product Buyed per gestire i propri prodotti, visualizzare gli acquisti passati e modificare le impostazioni.
- **Retailer**: L'utente Retailer ha accesso alle pagine di Shop, Inventory, Setting e Product Buyed per visualizzare e gestire i propri prodotti, nonché per modificare le impostazioni.
- **Consumer**: L'utente Consumer ha accesso alle pagine di Shop, Product Buyed e Setting per navigare tra i prodotti disponibili, visualizzare gli acquisti passati e modificare le impostazioni del proprio account.


### Pagine:

| Nome della Pagina | Descrizione | Immagine |
| ----------------- | ----------- | -------- |
| Login | Pagina di accesso per gli utenti registrati. Qui gli utenti possono inserire le proprie credenziali per accedere al sistema. | ![Login](inserisci-il-tuo-link-all-immagine-login.png) |
| SignUp | Pagina di registrazione per i nuovi utenti. Qui gli utenti possono creare un nuovo account fornendo le informazioni richieste. | ![SignUp](inserisci-il-tuo-link-all-immagine-signup.png) |
| Shop | Pagina principale del negozio, dove gli utenti possono visualizzare e acquistare i prodotti disponibili. | ![Shop](inserisci-il-tuo-link-all-immagine-shop.png) |
| Product Buyed | Pagina dove gli utenti possono visualizzare i prodotti che hanno acquistato in passato. | ![Product Buyed](inserisci-il-tuo-link-all-immagine-product-buyed.png) |
| Inventory | Pagina dove gli utenti possono gestire i propri prodotti e metterli in vendita nel negozio. | ![Inventory](inserisci-il-tuo-link-all-immagine-inventory.png) |
| Setting | Pagina delle impostazioni, dove gli utenti possono visualizzare e modificare le proprie informazioni personali e le preferenze del sistema. | ![Setting](inserisci-il-tuo-link-all-immagine-setting.png) |

## Dapp : 
![Immagine Architettura](./docs/dapp.png)

| Microservizio         | Descrizione                                                                                                                                                           | Immagine                   |
|-----------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------|
| MilkHub Microservice  | Il microservizio MilkHub gestisce le operazioni relative alla catena di distribuzione del latte, inclusa la raccolta, la trasformazione e la distribuzione ai clienti. | ![MilkHub](./docs/milkhub_micro.png)           |
| CheeseProducer Microservice | Il microservizio CheeseProducer gestisce le operazioni relative alla produzione di formaggio, compresa la lavorazione del latte e la creazione di prodotti caseari. | ![CheeseProducer](./docs/cheese_producer_micro.png) |
| Retailer Microservice | Il microservizio Retailer gestisce le operazioni di vendita al dettaglio, inclusa la gestione degli ordini, la gestione del magazzino e l'interazione con i clienti. | ![Retailer](./docs/retailer_micro.png)         |
| Consumer Microservice | Il microservizio Consumer gestisce le operazioni relative agli utenti finali che acquistano prodotti, inclusa la visualizzazione dei prodotti disponibili e la gestione degli ordini. | ![Consumer](./docs/consumer_micro.png)         |





## UseCase

- Questi risultano essere i principali Use Case sviluppati durante il progetto : 

## Selezione del Prodotto

L'utente che può acquistare i prodotti, andrà a cliccare sulla card del prodotto e si aprirà una finestra di Dialog dove si dovrà inserire la quantità che si vuole acquistare.

![Step 1 - Selezione del Prodotto](./docs/acquisto/selezione_acquisto.png) ![Step 3 - Conversione del Prodotto](inserisci-il-tuo-link-all-immagine-conversione-prodotto.png) 
## Acquisto del Prodotto

L'utente una volta selezionato il prodotto e una volta inserita la quantità riceverà una notifica di avvenuta conferma dell'applicazione oppure di errore.

| | | |
| --- | --- | --- |
| ![Step 2 - Acquisto del Prodotto](./docs/acquisto/acquisto1.png) | ![Step 2 - Acquisto del Prodotto](./docs/acquisto/acquisto2.png) | ![Step 2 - Acquisto del Prodotto](./docs/acquisto/acquisto3.png) |
| | | |
| ![Step 2 - Acquisto del Prodotto](./docs/acquisto/acquisto_api.png) | | |


## Conversione del Prodotto

L'utente che avrà completato l'acquisto del prodotto, ha la possibilità di andare nei prodotti acquistati e provare a convertire il prodotto con la stessa modalità di acquisto: inserisce la quantità che vuole convertire e il prezzo con il quale andare a vendere il prodotto.

![Step 3 - Conversione del Prodotto](inserisci-il-tuo-link-all-immagine-conversione-prodotto.png) ![Step 3 - Conversione del Prodotto](inserisci-il-tuo-link-all-immagine-conversione-prodotto.png) ![Step 3 - Conversione del Prodotto](inserisci-il-tuo-link-all-immagine-conversione-prodotto.png) 

### Sottosezione 1
Descrizione di un caso d'uso specifico.

### Sottosezione 2
Altri casi d'uso rilevanti.

## Conclusioni
Sintesi delle principali conclusioni tratte dal documento.

## Riferimenti
Eventuali riferimenti o fonti utilizzate.

