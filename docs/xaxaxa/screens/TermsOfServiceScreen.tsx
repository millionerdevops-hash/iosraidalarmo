import React from 'react';
import { ArrowLeft } from 'lucide-react';
import { TYPOGRAPHY } from '../theme';

interface TermsOfServiceScreenProps {
  onBack: () => void;
}

export const TermsOfServiceScreen: React.FC<TermsOfServiceScreenProps> = ({ onBack }) => {
  return (
    <div className="flex flex-col h-full bg-zinc-950 text-zinc-300">
      <div className="p-6 pt-8 border-b border-zinc-900 bg-zinc-950 z-10 flex items-center gap-4">
        <button onClick={onBack} className="p-2 -ml-2 hover:bg-zinc-900 rounded-full transition-colors">
          <ArrowLeft className="w-6 h-6 text-white" />
        </button>
        <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Terms of Service</h2>
      </div>

      <div className="flex-1 overflow-y-auto p-6 space-y-6 text-sm leading-relaxed font-mono">
        <p>Last Updated: October 2023</p>

        <section>
          <h3 className="text-white font-bold mb-2 uppercase">1. Acceptance of Terms</h3>
          <p>By downloading or using RAID ALARM, you agree to be bound by these terms. If you disagree with any part of the terms, you may not use our services.</p>
        </section>

        <section>
          <h3 className="text-white font-bold mb-2 uppercase">2. Lifetime License</h3>
          <p>Purchases labeled "Lifetime" grant you access to the specific features described at the time of purchase for the lifetime of the application on the supported platform.</p>
        </section>

        <section>
          <h3 className="text-white font-bold mb-2 uppercase">3. User Conduct</h3>
          <p>You agree not to misuse the team pairing system or attempt to reverse engineer the notification relay system.</p>
        </section>

        <section>
          <h3 className="text-white font-bold mb-2 uppercase">4. Liability</h3>
          <p>RAID ALARM is a utility tool. We are not responsible for any in-game losses (loot, bases, etc.) incurred due to network failures, notification delays, or device settings (Do Not Disturb, etc.).</p>
        </section>

        <div className="h-20" /> {/* Bottom padding */}
      </div>
    </div>
  );
};