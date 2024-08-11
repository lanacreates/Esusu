
import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import { CeloProvider } from './context/CeloContext';
import Home from './pages/Home';
import ViewSavings from './pages/ViewSavings';
import CreateSavings from './pages/CreateSavings';
import JoinSavings from './pages/JoinSavings';
import ConnectWalletButton from './components/ConnectWalletButton';
import './styles/global.css';

const App: React.FC = () => {
  return (
    <CeloProvider>
      <Router>
        <div className="container">
          <ConnectWalletButton />
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/view-savings" element={<ViewSavings />} />
            <Route path="/create-savings" element={<CreateSavings />} />
            <Route path="/join-savings" element={<JoinSavings />} />
          </Routes>
        </div>
      </Router>
    </CeloProvider>
  );
};

export default App;
