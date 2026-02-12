import React, { useState } from 'react';
import { Button } from '../components/Button';
import { ScreenName } from '../types';
import { TYPOGRAPHY } from '../theme';
import { ArrowRight, AlertTriangle } from 'lucide-react';

interface JoinCodeScreenProps {
  onNavigate: (screen: ScreenName) => void;
  onJoinSuccess: () => void;
}

export const JoinCodeScreen: React.FC<JoinCodeScreenProps> = ({ onNavigate, onJoinSuccess }) => {
  const [code, setCode] = useState('');
  const [error, setError] = useState('');

  const handleConnect = () => {
    // Basic validation logic moved here
    if (code.toUpperCase().trim() === 'RUSTGOD') {
      onJoinSuccess();
    } else {
      setError("Invalid code. Try RUSTGOD");
    }
  };

  return (
    <div className="flex flex-col h-full p-6 bg-zinc-950">
      <div className="pt-4">
        <button onClick={() => onNavigate('GET_STARTED')} className="text-zinc-500 hover:text-white flex items-center gap-2 transition-colors">
          <ArrowRight className="w-4 h-4 rotate-180" /> Back
        </button>
      </div>

      <div className="flex-1 flex flex-col justify-center space-y-8">
        <div>
          <h2 className={`text-3xl text-white mb-2 ${TYPOGRAPHY.rustFont}`}>Join Squad</h2>
          <p className="text-zinc-400">Enter the frequency code provided by your team leader.</p>
        </div>
        
        <div className="space-y-6">
          <div className="relative">
            <div className="absolute -top-3 left-3 bg-zinc-950 px-2 text-xs text-orange-500 font-bold uppercase">Frequency Code</div>
            <input 
              type="text" 
              placeholder="RUSTGOD" 
              className="w-full bg-zinc-900/50 border-2 border-zinc-800 p-6 rounded-sm text-center text-3xl font-black tracking-[0.2em] uppercase text-white focus:border-orange-500 outline-none transition-colors placeholder:text-zinc-800 font-mono"
              value={code}
              onChange={(e) => {
                setCode(e.target.value);
                if (error) setError('');
              }}
            />
          </div>
          
          {error && (
            <div className="flex items-center justify-center gap-2 text-red-500 bg-red-950/20 p-3 rounded border border-red-900/50">
              <AlertTriangle className="w-4 h-4" />
              <span className="text-sm font-bold">{error}</span>
            </div>
          )}
          
          <Button onClick={handleConnect}>Connect</Button>
        </div>
      </div>
      
      <div className="pb-6 text-center">
         <p className="text-zinc-600 text-xs">Waiting for connection signal...</p>
      </div>
    </div>
  );
};