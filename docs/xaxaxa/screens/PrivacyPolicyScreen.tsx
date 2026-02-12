import React from 'react';
import { ArrowLeft } from 'lucide-react';
import { TYPOGRAPHY } from '../theme';

interface PrivacyPolicyScreenProps {
  onBack: () => void;
}

export const PrivacyPolicyScreen: React.FC<PrivacyPolicyScreenProps> = ({ onBack }) => {
  return (
    <div className="flex flex-col h-full bg-zinc-950 text-zinc-300">
      <div className="p-6 pt-8 border-b border-zinc-900 bg-zinc-950 z-10 flex items-center gap-4">
        <button onClick={onBack} className="p-2 -ml-2 hover:bg-zinc-900 rounded-full transition-colors">
          <ArrowLeft className="w-6 h-6 text-white" />
        </button>
        <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Privacy Policy</h2>
      </div>

      <div className="flex-1 overflow-y-auto p-6 space-y-6 text-sm leading-relaxed font-mono">
        <p>Last Updated: October 2023</p>

        <section>
          <h3 className="text-white font-bold mb-2 uppercase">1. Data Collection</h3>
          <p>RAID ALARM collects minimal data required to function. We process your device ID for push notifications and team pairing functionality. We do not store your Rust game credentials.</p>
        </section>

        <section>
          <h3 className="text-white font-bold mb-2 uppercase">2. Rust+ Integration</h3>
          <p>This app acts as a bridge for Rust+ notifications. By using this service, you acknowledge that we interface with the official Facepunch API but are not affiliated with Facepunch Studios.</p>
        </section>

        <section>
          <h3 className="text-white font-bold mb-2 uppercase">3. Local Storage</h3>
          <p>Team configurations and alarm preferences are stored locally on your device where possible to ensure privacy and speed.</p>
        </section>

        <section>
          <h3 className="text-white font-bold mb-2 uppercase">4. Third Party Services</h3>
          <p>We may use third-party services for payment processing (Google Play Billing / Apple App Store). Financial data is handled exclusively by these providers.</p>
        </section>

        <div className="h-20" /> {/* Bottom padding */}
      </div>
    </div>
  );
};