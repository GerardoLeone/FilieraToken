# Besu File Configuration 

## How to run Besu 

* besu -> command execution 
* --network=dev : 
* --miner-enabled : 
* --miner-coinbase=0xfe3b557e8fb62b89f4916b721be55ceb828dbd73 :
* --rpc-http-cors-origins="all" : 
* --host-allowlist="*"
* --rpc-ws-enabled :
* --rpc-http-enabled :
* --data-path=/tmp/tmpDatdir :


```sh
besu --network=dev --miner-enabled --miner-coinbase=0xfe3b557e8fb62b89f4916b721be55ceb828dbd73 --rpc-http-cors-origins="all" --host-allowlist="*" --rpc-ws-enabled --rpc-http-enabled --data-path=/tmp/tmpDatdir
```

# Node for Testing : Configuration file 
```sh
network="dev"
miner-enabled=true
miner-coinbase="0xfe3b557e8fb62b89f4916b721be55ceb828dbd73"
rpc-http-cors-origins=["all"]
host-allowlist=["*"]
rpc-ws-enabled=true
rpc-http-enabled=true
data-path="/tmp/tmpdata-path"
```


## How to find a node that running on the dev network 

```sh
curl -X POST --data '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}' localhost:8545
```


# Configure Consensus -- Private Network 

### Genesis File : qbftConfigFile.json
The configuration file defines the QBFT genesis file and the number of node key pairs to generate.

The configuration file has two nested JSON nodes.  
Property : 
1. 'genesis' property : defining the QBFT genesis file, except for the 'extradata'
2. 'blockchain' property defining the number of key pairs to generate.