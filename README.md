# FakeExchange
Truffle project implementing a web exchange where users can trade ETH for ERC20-compliant tokens (and vice versa).

## Initial setup

### Setting up the blockchain


To host the webpage you have to install a webserver; the recommended one in this case is ```lite-server```.
To install ```lite-server``` (assuming you have npm already installed) type the following commands in the terminal:
```
cd path_to_project_base_dir
npm install lite-server
```
Now check that *package.json* in project base directory has the entry
```
"dev":"lite-server"
```
inside the *scripts* property, otherwise add it. Now you can deploy the webpage running the command
```
npm run dev
```
 



