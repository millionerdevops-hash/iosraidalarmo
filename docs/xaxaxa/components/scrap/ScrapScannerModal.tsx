import React, { useRef } from 'react';
import { X, ScanEye, Camera, Loader2, AlertTriangle } from 'lucide-react';
import { Button } from '../Button';

interface ScrapScannerModalProps {
    onClose: () => void;
    onScan: (base64: string) => void;
    scanning: boolean;
    scanImage: string | null;
    scanError: string | null;
    setScanImage: (img: string | null) => void;
}

export const ScrapScannerModal: React.FC<ScrapScannerModalProps> = ({ 
    onClose, 
    onScan, 
    scanning, 
    scanImage, 
    scanError, 
    setScanImage 
}) => {
    const fileInputRef = useRef<HTMLInputElement>(null);

    const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const file = e.target.files?.[0];
        if (file) {
            const reader = new FileReader();
            reader.onloadend = () => {
                const base64 = reader.result as string;
                setScanImage(base64);
                onScan(base64);
            };
            reader.readAsDataURL(file);
        }
    };

    return (
        <div className="absolute inset-0 z-50 flex flex-col bg-[#0c0c0e] animate-in slide-in-from-bottom duration-300">
              <div className="p-4 border-b border-zinc-800 flex items-center justify-between">
                  <h3 className="text-white font-black uppercase text-lg flex items-center gap-2">
                      <ScanEye className="w-5 h-5 text-orange-500" /> Scan Inventory
                  </h3>
                  <button onClick={onClose} className="text-zinc-500 hover:text-white transition-colors">
                      <X className="w-6 h-6" />
                  </button>
              </div>

              <div className="flex-1 p-6 flex flex-col items-center justify-center">
                  {!scanImage && !scanning ? (
                      <div className="w-full flex flex-col items-center gap-6">
                          <div className="w-full aspect-video bg-black rounded-2xl border-2 border-dashed border-zinc-700 flex flex-col items-center justify-center relative overflow-hidden">
                              <div className="absolute inset-0 opacity-20 bg-[url('https://www.transparenttextures.com/patterns/carbon-fibre.png')]" />
                              <ScanEye className="w-12 h-12 text-zinc-600 mb-4" />
                              <p className="text-zinc-500 text-xs text-center max-w-[200px] leading-relaxed">
                                  Take a photo of your storage box or inventory screen.
                              </p>
                          </div>
                          
                          <input 
                              type="file" 
                              accept="image/*" 
                              className="hidden" 
                              ref={fileInputRef}
                              onChange={handleFileChange}
                          />
                          <Button onClick={() => fileInputRef.current?.click()}>
                              <Camera className="w-4 h-4" /> Take Photo / Upload
                          </Button>
                      </div>
                  ) : (
                      <div className="w-full flex flex-col items-center gap-6">
                          <div className="relative w-full aspect-video bg-black rounded-2xl overflow-hidden border border-orange-500/30 shadow-2xl">
                              <img src={scanImage || ''} alt="Scan Preview" className={`w-full h-full object-cover transition-all ${scanning ? 'opacity-50 blur-sm scale-105' : 'opacity-100'}`} />
                              
                              {scanning && (
                                  <div className="absolute inset-0 z-10 flex flex-col items-center justify-center">
                                      <div className="absolute inset-0 bg-gradient-to-b from-orange-500/20 to-transparent h-[50%] w-full animate-[scan_2s_linear_infinite] border-b-2 border-orange-500" />
                                      <div className="bg-black/80 backdrop-blur px-4 py-2 rounded-full border border-orange-500/50 flex items-center gap-3">
                                          <Loader2 className="w-4 h-4 animate-spin text-orange-500" />
                                          <span className="text-orange-500 font-mono text-xs font-bold uppercase">Identifying Items...</span>
                                      </div>
                                  </div>
                              )}
                          </div>

                          {scanError && (
                              <div className="bg-red-950/30 border border-red-900/50 rounded-xl p-4 w-full flex items-center gap-3 text-red-200 text-xs">
                                  <AlertTriangle className="w-4 h-4 text-red-500 shrink-0" />
                                  <span>{scanError}</span>
                              </div>
                          )}

                          {!scanning && scanError && (
                              <button onClick={() => setScanImage(null)} className="text-zinc-500 text-xs underline hover:text-white">
                                  Try Another Image
                              </button>
                          )}
                      </div>
                  )}
              </div>
          </div>
    );
};