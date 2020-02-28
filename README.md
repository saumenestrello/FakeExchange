# FakeExchange
Truffle project implementing a web exchange where users can trade ETH for ERC20-compliant tokens (and vice versa). The project has been developed for learning purposes and **should not be deployed on a real Ethereum network**.    

## Initial setup
### Node.js and Truffle
Download the latest version of Node.js from the official page (https://nodejs.org/it/download/). The npm package manager is distributed along with it so when you install Node.js you automatically get npm installed on your computer.
Now open the terminal and type
```
 npm install -g truffle
```
to install Truffle globally.

### Setting up the blockchain
The project has been tested on the development blockchain provided by Truffle, however it is theoretically possible to use other tools (like Ganache GUI for example) by modifying the *networks* object inside ```truffle-config``` file. If you're OK with using Truffle's ```develop``` blockchain, there's no need to edit this file because the entry has already been created (*cli* network on port 9545).
To launch the ```develop``` blockchain just open the terminal, move to project base directory and type 
```
truffle develop
```
### Deploy the webpage
To host the webpage you have to install a webserver; the recommended one in this case is ```lite-server```.
To install ```lite-server``` (assuming you have npm already installed) type the following commands in the terminal:
```
cd path_to_project_base_dir
npm install lite-server
```
Now check that ```package.json``` in project base directory has the entry
```
"dev":"lite-server"
```
inside the *scripts* property, otherwise add it. Now you can deploy the webpage running the command
```
npm run dev
```
 



