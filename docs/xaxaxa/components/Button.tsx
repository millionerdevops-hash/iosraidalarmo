import React from 'react';

interface ButtonProps {
  children: React.ReactNode;
  onClick?: () => void;
  variant?: 'primary' | 'secondary' | 'outline' | 'danger' | 'ghost';
  className?: string;
  disabled?: boolean;
}

export const Button: React.FC<ButtonProps> = ({ 
  children, 
  onClick, 
  variant = 'primary', 
  className = '',
  disabled = false
}) => {
  // Updated baseStyles:
  // Removed "active:translate-y-1" (the downward movement)
  // Kept "active:scale-[0.98]" for a subtle press feeling which is standard in mobile apps
  const baseStyles = "w-full py-3.5 px-6 rounded-sm font-black uppercase tracking-wider transition-all active:scale-[0.98] disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2 relative overflow-hidden";
  
  const variants = {
    // Removed "shadow-[0_4px_0_rgb(127,29,29)]" and "active:shadow-none"
    // Added standard diffuse shadow "shadow-lg shadow-red-900/40"
    primary: "bg-gradient-to-r from-red-700 to-red-600 hover:from-red-600 hover:to-red-500 text-white shadow-lg shadow-red-900/40 border border-red-500/50",
    
    // Removed "shadow-[0_4px_0_rgb(39,39,42)]"
    secondary: "bg-zinc-800 hover:bg-zinc-700 text-zinc-100 border border-zinc-600 shadow-md",
    
    // Ghost/Link
    ghost: "bg-transparent text-zinc-500 hover:text-zinc-300",

    // Outline
    outline: "bg-transparent border-2 border-zinc-700 text-zinc-400 hover:border-zinc-500 hover:text-white hover:bg-zinc-900",
    
    // Hazard/Alert
    danger: "bg-red-950/40 border border-red-500/50 text-red-500 animate-pulse hover:bg-red-900/40"
  };

  return (
    <button 
      onClick={onClick} 
      className={`${baseStyles} ${variants[variant]} ${className}`}
      disabled={disabled}
    >
      {children}
    </button>
  );
};