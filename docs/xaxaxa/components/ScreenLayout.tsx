import React from 'react';

interface ScreenLayoutProps {
  children: React.ReactNode;
  className?: string;
  showScanline?: boolean;
}

export const ScreenLayout: React.FC<ScreenLayoutProps> = ({ children, className = '', showScanline = true }) => {
  return (
    <div className={`h-[100dvh] w-full bg-zinc-950 text-white relative flex flex-col overflow-hidden max-w-md mx-auto shadow-2xl border-x border-zinc-900 ${className}`}>
      {showScanline && <div className="scan-line pointer-events-none" />}
      <div className="relative z-10 flex-1 flex flex-col h-full overflow-hidden">
        {children}
      </div>
    </div>
  );
};