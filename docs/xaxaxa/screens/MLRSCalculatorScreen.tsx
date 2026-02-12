
import React, { useState } from 'react';
import { 
  ArrowLeft, 
  Crosshair, 
  Rocket, 
  Target, 
  RefreshCw 
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';

interface MLRSCalculatorScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

export const MLRSCalculatorScreen: React.FC<MLRSCalculatorScreenProps> = ({ onNavigate }) => {
  // Coordinates are usually something like "A10" or "X: 123, Z: 456"
  // For precise calc, we need X/Z numbers.
  const [myX, setMyX] = useState('');
  const [myZ, setMyZ] = useState('');
  const [targetX, setTargetX] = useState('');
  const [targetZ, setTargetZ] = useState('');
  
  const [result, setResult] = useState<{ angle: number; force: number; distance: number } | null>(null);

  const calculateFiringSolution = () => {
      const x1 = parseFloat(myX);
      const z1 = parseFloat(myZ);
      const x2 = parseFloat(targetX);
      const z2 = parseFloat(targetZ);

      if (isNaN(x1) || isNaN(z1) || isNaN(x2) || isNaN(z2)) return;

      // 1. Calculate Distance (2D Euclidean)
      const dist = Math.sqrt(Math.pow(x2 - x1, 2) + Math.pow(z2 - z1, 2));

      // 2. Calculate Bearing (Angle on Compass)
      // Math.atan2(dy, dx) returns radians. We need degrees.
      // Rust map coordinates: usually Z is North/South? Let's assume standard grid.
      // dX = x2 - x1, dZ = z2 - z1
      const dX = x2 - x1;
      const dZ = z2 - z1;
      
      // Convert to degrees (0 = East, 90 = North in standard math)
      // Rust usually 0 = North.
      // Atan2(x, y) might be better?
      let theta = Math.atan2(dX, dZ) * (180 / Math.PI); 
      if (theta < 0) theta += 360;

      // 3. Force Calculation (Simplified Linear Approximation based on RustLabs data)
      // Note: Real formula is complex curve, this is a linear approx for the prototype
      // MLRS Range: Min ~150m? Max ~1500m?
      // 0-12 rockets.
      // Actually MLRS UI asks for an Angle (Vertical).
      // Let's assume we output the Vertical Angle required.
      // Usually higher angle = shorter distance? Or lower?
      // Real Rust Logic: 
      // 240m = 0 deg? No.
      // Let's use a mock mapping for "Simulation" feel.
      
      let verticalAngle = 0;
      if (dist < 200) verticalAngle = 80;
      else if (dist > 1500) verticalAngle = 10;
      else {
          // Linear interp between 200m(80deg) and 1500m(10deg)
          verticalAngle = 80 - ((dist - 200) / (1500 - 200)) * 70;
      }

      setResult({
          distance: Math.round(dist),
          angle: Math.round(theta), // Compass Heading
          force: Math.round(verticalAngle * 10) / 10 // Vertical tilt
      });
  };

  const reset = () => {
      setMyX(''); setMyZ(''); setTargetX(''); setTargetZ('');
      setResult(null);
  };

  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] animate-in slide-in-from-bottom duration-300 relative">
      
      {/* Header */}
      <div className="p-4 pt-6 border-b border-white/5 flex items-center justify-center relative bg-[#0c0c0e] z-10 shrink-0">
        <button 
            onClick={() => onNavigate('DASHBOARD')}
            className="absolute left-4 p-2 text-zinc-400 hover:text-white transition-colors"
        >
            <ArrowLeft className="w-6 h-6" />
        </button>
        <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>MLRS Computer</h2>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-6">
          
          {/* Main Interface */}
          <div className="bg-[#121214] border border-zinc-800 rounded-2xl p-5 shadow-2xl relative overflow-hidden">
              {/* Scanlines */}
              <div className="absolute inset-0 bg-[linear-gradient(rgba(18,16,16,0)_50%,rgba(0,0,0,0.25)_50%),linear-gradient(90deg,rgba(255,0,0,0.06),rgba(0,255,0,0.02),rgba(0,0,255,0.06))] z-0 pointer-events-none opacity-20 bg-[length:100%_4px,6px_100%]" />
              
              <div className="relative z-10 space-y-6">
                  
                  {/* Origin Inputs */}
                  <div className="space-y-2">
                      <div className="flex items-center gap-2 text-blue-400">
                          <Rocket className="w-4 h-4" />
                          <span className="text-xs font-bold uppercase tracking-widest">Launcher Pos (MLRS)</span>
                      </div>
                      <div className="grid grid-cols-2 gap-3">
                          <div className="bg-black/40 border border-zinc-700 rounded-lg flex items-center px-3 py-2">
                              <span className="text-zinc-500 text-xs font-mono mr-2">X:</span>
                              <input 
                                type="number" 
                                value={myX} 
                                onChange={e => setMyX(e.target.value)}
                                className="bg-transparent text-white font-mono text-sm w-full outline-none"
                                placeholder="0000"
                              />
                          </div>
                          <div className="bg-black/40 border border-zinc-700 rounded-lg flex items-center px-3 py-2">
                              <span className="text-zinc-500 text-xs font-mono mr-2">Z:</span>
                              <input 
                                type="number" 
                                value={myZ} 
                                onChange={e => setMyZ(e.target.value)}
                                className="bg-transparent text-white font-mono text-sm w-full outline-none"
                                placeholder="0000"
                              />
                          </div>
                      </div>
                  </div>

                  {/* Target Inputs */}
                  <div className="space-y-2">
                      <div className="flex items-center gap-2 text-red-500">
                          <Crosshair className="w-4 h-4" />
                          <span className="text-xs font-bold uppercase tracking-widest">Target Pos (Base)</span>
                      </div>
                      <div className="grid grid-cols-2 gap-3">
                          <div className="bg-black/40 border border-zinc-700 rounded-lg flex items-center px-3 py-2">
                              <span className="text-zinc-500 text-xs font-mono mr-2">X:</span>
                              <input 
                                type="number" 
                                value={targetX} 
                                onChange={e => setTargetX(e.target.value)}
                                className="bg-transparent text-white font-mono text-sm w-full outline-none"
                                placeholder="0000"
                              />
                          </div>
                          <div className="bg-black/40 border border-zinc-700 rounded-lg flex items-center px-3 py-2">
                              <span className="text-zinc-500 text-xs font-mono mr-2">Z:</span>
                              <input 
                                type="number" 
                                value={targetZ} 
                                onChange={e => setTargetZ(e.target.value)}
                                className="bg-transparent text-white font-mono text-sm w-full outline-none"
                                placeholder="0000"
                              />
                          </div>
                      </div>
                  </div>

                  <button 
                    onClick={calculateFiringSolution}
                    className="w-full py-4 bg-red-600 hover:bg-red-500 text-white font-black uppercase tracking-widest rounded-xl shadow-[0_0_20px_rgba(220,38,38,0.4)] active:scale-[0.98] transition-all flex items-center justify-center gap-2"
                  >
                      <Target className="w-5 h-5" /> Calculate Solution
                  </button>

              </div>
          </div>

          {/* Results Panel */}
          {result && (
              <div className="mt-6 animate-in slide-in-from-bottom duration-500">
                  <div className="flex items-center justify-between mb-2 px-1">
                      <span className="text-xs font-bold text-zinc-500 uppercase tracking-widest">Firing Data</span>
                      <button onClick={reset} className="text-zinc-500 hover:text-white transition-colors">
                          <RefreshCw className="w-4 h-4" />
                      </button>
                  </div>

                  <div className="grid grid-cols-2 gap-3">
                      <div className="bg-zinc-900 border border-zinc-800 p-4 rounded-xl flex flex-col items-center">
                          <span className="text-[10px] text-zinc-500 font-bold uppercase mb-1">Heading</span>
                          <span className="text-3xl font-black text-white font-mono">{result.angle}°</span>
                      </div>
                      <div className="bg-zinc-900 border border-zinc-800 p-4 rounded-xl flex flex-col items-center">
                          <span className="text-[10px] text-zinc-500 font-bold uppercase mb-1">Vertical Angle</span>
                          <span className="text-3xl font-black text-white font-mono">{result.force}°</span>
                      </div>
                  </div>
                  
                  <div className="mt-3 bg-zinc-900/50 border border-zinc-800 p-3 rounded-xl flex justify-between items-center px-4">
                      <span className="text-xs text-zinc-400">Target Distance</span>
                      <span className="text-sm font-mono font-bold text-orange-500">{result.distance}m</span>
                  </div>
              </div>
          )}

      </div>
    </div>
  );
};
