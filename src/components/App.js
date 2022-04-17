import React, { Component } from 'react';
import Web3 from 'web3';
import detectEthereumProvider from '@metamask/detect-provider';
import KryptoBird from '../abis/KryptoBird.json';

class App extends Component {
  async componentDidMount() {
    await this.loadWeb3();
    await this.loadBlockchainData();
  }

  // 1. Detect Ethereum Provider
  async loadWeb3() {
    const provider = await detectEthereumProvider();

    // Modern browsers
    // If there is a provider then let's log that it's working and access the window fro the doc to set Web3 to the provider

    if (provider) {
      console.log('Etherem wallet is connected');
      window.web3 = new Web3(provider);
    } else {
      // No Etheruem Provider
      console.log('No Ethereum wallet detected');
    }
  }

  async loadBlockchainData() {
    const web3 = window.web3;
    const accounts = await window.web3.eth.getAccounts();
    this.setState({ account: accounts });
    
    const networkId = await web3.eth.net.getId();
    const networkData = KryptoBird.networks[networkId]; // Comes from the ABI

    if (networkData) {
      const abi = KryptoBird.abi;
      // Where the contract was deployed
      const address = networkData.address;
      const contract = new web3.eth.Contract(abi, address);
      console.log(contract);
    }
  }

  constructor(props) {
    super(props);
    this.state = {
      account: ''
    };
  }

  render() {
    return (
      <div>
        <nav className='navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow'>
          <div 
            className='navbar-brand col-md-3 mr-0'
            style={{ color: 'white' }}
          >
            Krypto Birdz NFTs (Non Fungible Tokens)
          </div>
          <ul className='navbar-nav px-3'>
            <li className='nav-item  text-nowrap do-none d-sm-none d-sm-block'>
              <small className='text-white'>
                {this.state.account}
              </small>
            </li>
          </ul>
        </nav>
      </div>
    );
  }
};

export default App;