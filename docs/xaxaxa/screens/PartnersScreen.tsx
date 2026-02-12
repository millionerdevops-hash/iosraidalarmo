
import React from 'react';
import { 
  ArrowLeft, 
  ShieldCheck, 
  ArrowRight, 
  CheckCircle2, 
  Zap
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';

interface PartnersScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

// --- DATA STRUCTURES ---

interface HostingPartner {
    id: string;
    name: string;
    description: string;
    uptime: string;
    locations: string;
    price: string;
    link: string;
    bgImage: string;
    features: string[];
    specs?: { label: string; value: string }[];
    isPremium?: boolean;
    theme?: {
        primary: string; // Tailwind color name (e.g., 'green', 'cyan')
        gradient: string;
        shadow: string;
    }
}

const HOST_PARTNERS: HostingPartner[] = [
    {
        id: 'pine',
        name: 'Pine Hosting',
        description: 'Premium Rust hosting. Industry-leading performance with custom control panel designed for serious server owners.',
        uptime: '99.99%',
        locations: 'Global (12+)',
        price: '$14.99/mo',
        link: 'https://pinehosting.com/clientarea/aff.php?aff=1101', 
        bgImage: 'https://files.facepunch.com/paddy/20201006/hardcore_header.jpg',
        features: ['Anycast DDoS Shield', 'One-Click Mod Install', 'Mobile Control Panel', 'Instant Setup'],
        specs: [
            { label: 'CPU', value: 'Ryzen 9' },
            { label: 'RAM', value: 'DDR4/5' },
            { label: 'Disk', value: 'NVMe SSD' }
        ],
        isPremium: true,
        theme: {
            primary: 'green',
            gradient: 'from-[#0f172a] via-[#0f172a] to-[#022c22]',
            shadow: 'rgba(34,197,94,0.4)'
        }
    },
    {
        id: 'gportal',
        name: 'G-Portal',
        description: 'High-end Gamecloud hosting. Switch between games instantly. protected by Bulwark™ & Corero™ multi-layer defense.',
        uptime: '99.9%',
        locations: '18 Regions',
        price: '$14.00/mo',
        link: 'https://www.g-portal.com/', 
        bgImage: 'https://files.facepunch.com/paddy/20210504/hdrp_backport_header.jpg',
        features: ['Gamecloud Switching', 'Bulwark™ DDoS', 'NVMe SSD Hardware', '24/7 Premium Support'],
        specs: [
            { label: 'Network', value: 'Corero™' },
            { label: 'Storage', value: 'NVMe' },
            { label: 'Locs', value: '14 Global' }
        ],
        isPremium: true,
        theme: {
            primary: 'cyan',
            gradient: 'from-[#111] via-[#162a35] to-[#083344]',
            shadow: 'rgba(34,211,238,0.4)'
        }
    },
    {
        id: 'hosthavoc',
        name: 'Host Havoc',
        description: 'Enterprise hardware with 99.9% uptime. 24/7 support with <10min response times. The reliable choice for modded servers.',
        uptime: '99.9%',
        locations: '13 Locations',
        price: '$16.00/mo',
        link: 'https://hosthavoc.com/billing/aff.php?aff=2420',
        bgImage: 'https://files.facepunch.com/paddy/20220804/trainyard_header.jpg',
        features: ['uMod/Oxide Installer', 'Anycast DDoS Shield', 'NVMe SSD Storage', '72hr Refund Guarantee'],
        specs: [
            { label: 'CPU', value: 'Ryzen/Xeon' },
            { label: 'Network', value: '10Gbps' },
            { label: 'Rating', value: '4.7/5' }
        ],
        isPremium: true,
        theme: {
            primary: 'rose',
            gradient: 'from-[#1a0505] via-[#2c0a0a] to-[#4c0519]',
            shadow: 'rgba(244,63,94,0.4)'
        }
    }
];

export const PartnersScreen: React.FC<PartnersScreenProps> = ({ onNavigate }) => {
  const openLink = (url: string) => {
      window.open(url, '_blank');
  };

  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] animate-in slide-in-from-right duration-300 relative">
      
      {/* Header */}
      <div className="p-4 pt-6 border-b border-white/5 flex items-center justify-between bg-[#0c0c0e] z-20 shrink-0">
        <div className="flex items-center gap-4">
            <button 
                onClick={() => onNavigate('DASHBOARD')}
                className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 active:text-white active:bg-zinc-800 transition-all"
            >
                <ArrowLeft className="w-5 h-5" />
            </button>
            <div>
                <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Tactical Supply</h2>
                <div className="flex items-center gap-1.5">
                    <ShieldCheck className="w-3 h-3 text-green-500" />
                    <p className="text-zinc-500 text-xs font-mono uppercase tracking-wider">Trusted Server Hosting</p>
                </div>
            </div>
        </div>
      </div>

      {/* Main Content */}
      <div className="flex-1 overflow-y-auto no-scrollbar p-4 pt-6 pb-12">
          <div className="space-y-6 animate-in slide-in-from-bottom duration-500">
              
              {HOST_PARTNERS.map((host) => {
                  if (host.isPremium && host.theme) {
                      const { theme } = host;
                      
                      // Map dynamic colors based on theme prop
                      let borderColor, badgeBg, iconColor, btnColor, glowColor;

                      if (theme.primary === 'cyan') {
                          borderColor = 'border-cyan-500/30 active:border-cyan-500';
                          badgeBg = 'bg-cyan-500';
                          iconColor = 'text-cyan-400';
                          btnColor = 'bg-cyan-600 active:bg-cyan-500';
                          glowColor = 'shadow-[0_0_15px_rgba(34,211,238,0.4)]';
                      } else if (theme.primary === 'rose') {
                          borderColor = 'border-rose-500/30 active:border-rose-500';
                          badgeBg = 'bg-rose-600';
                          iconColor = 'text-rose-400';
                          btnColor = 'bg-rose-700 active:bg-rose-600';
                          glowColor = 'shadow-[0_0_15px_rgba(244,63,94,0.4)]';
                      } else {
                          // Default Green
                          borderColor = 'border-green-500/30 active:border-green-500';
                          badgeBg = 'bg-green-500';
                          iconColor = 'text-green-400';
                          btnColor = 'bg-green-600 active:bg-green-500';
                          glowColor = 'shadow-[0_0_15px_rgba(34,197,94,0.4)]';
                      }

                      return (
                        <div 
                            key={host.id}
                            onClick={() => openLink(host.link)}
                            className={`relative w-full rounded-[2rem] overflow-hidden border-2 transition-all shadow-2xl bg-[#0f172a] active:scale-[0.98] ${borderColor}`}
                        >
                            {/* Custom Gradient Background */}
                            <div className={`absolute inset-0 bg-gradient-to-br ${theme.gradient} z-0`} />
                            
                            {/* Decorative Grid */}
                            <div className="absolute inset-0 opacity-10 bg-[url('https://www.transparenttextures.com/patterns/carbon-fibre.png')] pointer-events-none" />

                            {/* Content */}
                            <div className="relative z-10 p-6 pt-6">
                                
                                {/* Header / Badges Row */}
                                <div className="flex justify-between items-center mb-4">
                                    {/* Official Partner Tag */}
                                    <div className="flex items-center gap-1.5">
                                        <div className={`w-1.5 h-1.5 rounded-full animate-pulse ${badgeBg}`} />
                                        <span className={`text-[10px] font-bold uppercase tracking-widest ${iconColor}`}>Official Partner</span>
                                    </div>

                                    {/* High Performance Badge */}
                                    <div className={`${badgeBg} text-white text-[9px] font-black px-2 py-1 rounded uppercase ${glowColor} flex items-center gap-1`}>
                                        <Zap className="w-3 h-3 fill-current" /> High Performance
                                    </div>
                                </div>

                                {/* Clean Title */}
                                <h3 className="text-4xl font-black text-white italic tracking-tighter uppercase leading-none mb-4">
                                    {host.name}
                                </h3>

                                {/* Description */}
                                <p className="text-zinc-400 text-sm leading-relaxed mb-6 font-medium">
                                    {host.description}
                                </p>

                                {/* Specs Grid */}
                                {host.specs && (
                                    <div className="grid grid-cols-3 gap-2 mb-6">
                                        {host.specs.map((spec, i) => (
                                            <div key={i} className="bg-black/40 border border-white/5 rounded-lg p-2.5 text-center">
                                                <div className="text-[9px] text-zinc-500 uppercase font-bold mb-0.5">{spec.label}</div>
                                                <div className="text-xs font-black text-white font-mono">{spec.value}</div>
                                            </div>
                                        ))}
                                    </div>
                                )}

                                {/* Features List */}
                                <div className="grid grid-cols-2 gap-y-2 gap-x-4 mb-6">
                                    {host.features.map((f, i) => (
                                        <div key={i} className="flex items-center gap-2">
                                            <CheckCircle2 className={`w-4 h-4 shrink-0 ${iconColor}`} />
                                            <span className="text-xs text-zinc-300 font-bold">{f}</span>
                                        </div>
                                    ))}
                                </div>

                                {/* Pricing & CTA */}
                                <div className="flex items-center justify-between bg-black/40 p-1.5 rounded-xl border border-white/5">
                                    <div className="pl-4">
                                        <span className="text-[10px] text-zinc-500 uppercase font-bold block">Starting at</span>
                                        <span className="text-xl font-black text-white">{host.price}</span>
                                    </div>
                                    <button className={`${btnColor} text-white font-black uppercase text-xs px-6 py-3 rounded-lg transition-colors flex items-center gap-2 shadow-lg`}>
                                        Configure <ArrowRight className="w-4 h-4" />
                                    </button>
                                </div>

                            </div>
                        </div>
                      );
                  }
                  return null; 
              })}

          </div>
      </div>
    </div>
  );
};
