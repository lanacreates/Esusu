import React, { createContext, useContext, useState, useEffect } from 'react';
import { useConnect } from 'wagmi';
import { InjectedConnector } from 'wagmi/connectors/injected';
import { ethers } from 'ethers';
import DecentralizedSavingsABI from '../abi/DecentralizedSavings.json';

interface CeloContextType {
  connect: () => void;
  disconnect: () => void;
  address?: string;
  isConnected: boolean;
  contract?: ethers.Contract;
  isMiniPay: boolean;
}

const CeloContext = createContext<CeloContextType | undefined>(undefined);

export const CeloProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [contract, setContract] = useState<ethers.Contract | undefined>(undefined);
  const [isMiniPay, setIsMiniPay] = useState(false);
  const { connect, disconnect, address, isConnected } = useConnect({
    connector: new InjectedConnector(),
  });

  useEffect(() => {
    if (window.ethereum && window.ethereum.isMiniPay) {
      setIsMiniPay(true);
      connect();
    }
  }, [connect]);

  useEffect(() => {
    if (isConnected && window.ethereum && window.ethereum.isMiniPay) {
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const signer = provider.getSigner();
      const contractAddress = "your_contract_address"; // Replace with your contract address
      const savingsContract = new ethers.Contract(contractAddress, DecentralizedSavingsABI, signer);
      setContract(savingsContract);
    }
  }, [isConnected]);

  return (
    <CeloContext.Provider value={{ connect, disconnect, address, isConnected, contract, isMiniPay }}>
      {children}
    </CeloContext.Provider>
  );
};

export const useCeloContext = () => {
  const context = useContext(CeloContext);
  if (!context) {
    throw new Error("useCeloContext must be used within a CeloProvider");
  }
  return context;
};
