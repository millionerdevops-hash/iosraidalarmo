
import React, { useState } from 'react';
import { 
  ArrowLeft, 
  Save, 
  Trash2, 
  Plus, 
  Server,
  Upload,
  CheckCircle2,
  AlertTriangle
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName, ServerData } from '../types';

interface AdminPanelScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

// Initial Mock Data (In reality this would be fetched from Supabase)
const INITIAL_SERVERS: ServerData[] = [
    {
        id: 'promo_atlas',
        name: 'Atlas Rust 2x | Main',
        players: 614,
        maxPlayers: 650,
        status: 'online',
        ip: '205.178.168.170',
        port: 28010,
        country: 'GB',
        headerImage: 'https://files.facepunch.com/paddy/20240206/jungle_ruins_header.jpg'
    }
];

export const AdminPanelScreen: React.FC<AdminPanelScreenProps> = ({ onNavigate }) => {
  const [servers, setServers] = useState<ServerData[]>(INITIAL_SERVERS);
  const [activeTab, setActiveTab] = useState<'LIST' | 'ADD'>('LIST');
  
  // Form State
  const [formData, setFormData] = useState({
      name: '',
      ip: '',
      port: '',
      image: '',
      desc: '',
      country: 'US'
  });
  const [successMsg, setSuccessMsg] = useState('');

  const handleAddServer = () => {
      const newServer: ServerData = {
          id: `promo_${Date.now()}`,
          name: formData.name,
          ip: formData.ip,
          port: parseInt(formData.port) || 28015,
          players: 0,
          maxPlayers: 500,
          status: 'online',
          country: formData.country,
          headerImage: formData.image,
          description: formData.desc
      };

      // In real app: await supabase.from('promoted_servers').insert(newServer)
      setServers([...servers, newServer]);
      setSuccessMsg('Server Added Successfully!');
      setTimeout(() => {
          setSuccessMsg('');
          setActiveTab('LIST');
          setFormData({ name: '', ip: '', port: '', image: '', desc: '', country: 'US' });
      }, 1500);
  };

  const handleDelete = (id: string) => {
      if(confirm('Delete this promotion?')) {
          setServers(servers.filter(s => s.id !== id));
      }
  };

  return (
    <div className="flex flex-col h-full bg-zinc-950">
      
      {/* Header */}
      <div className="p-4 pt-6 border-b border-red-900/30 bg-red-950/10 flex items-center justify-between">
        <div className="flex items-center gap-3">
            <button onClick={() => onNavigate('SETTINGS')} className="text-red-400 hover:text-white">
                <ArrowLeft className="w-6 h-6" />
            </button>
            <div>
                <h2 className={`text-xl text-red-500 ${TYPOGRAPHY.rustFont}`}>ADMIN PANEL</h2>
                <p className="text-[10px] text-red-400/60 uppercase tracking-widest font-bold">Authorized Access Only</p>
            </div>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto p-4">
          
          {/* Tabs */}
          <div className="flex bg-zinc-900 p-1 rounded-xl mb-6 border border-zinc-800">
              <button 
                onClick={() => setActiveTab('LIST')}
                className={`flex-1 py-2.5 rounded-lg text-xs font-bold uppercase transition-all ${activeTab === 'LIST' ? 'bg-zinc-800 text-white shadow' : 'text-zinc-500'}`}
              >
                  Active Promos
              </button>
              <button 
                onClick={() => setActiveTab('ADD')}
                className={`flex-1 py-2.5 rounded-lg text-xs font-bold uppercase transition-all ${activeTab === 'ADD' ? 'bg-zinc-800 text-white shadow' : 'text-zinc-500'}`}
              >
                  Add New
              </button>
          </div>

          {activeTab === 'LIST' && (
              <div className="space-y-3">
                  {servers.map(server => (
                      <div key={server.id} className="bg-[#121214] border border-zinc-800 p-3 rounded-xl flex items-center justify-between">
                          <div className="flex items-center gap-3">
                              <img src={server.headerImage} className="w-12 h-12 rounded-lg object-cover bg-zinc-900" alt="" />
                              <div>
                                  <h3 className="font-bold text-white text-sm">{server.name}</h3>
                                  <p className="text-zinc-500 text-xs font-mono">{server.ip}:{server.port}</p>
                              </div>
                          </div>
                          <button onClick={() => handleDelete(server.id)} className="p-2 bg-red-900/20 text-red-500 rounded-lg hover:bg-red-900/40">
                              <Trash2 className="w-4 h-4" />
                          </button>
                      </div>
                  ))}
                  {servers.length === 0 && (
                      <div className="text-center py-10 text-zinc-600 italic">No active promotions.</div>
                  )}
              </div>
          )}

          {activeTab === 'ADD' && (
              <div className="space-y-4">
                  {successMsg && (
                      <div className="bg-green-500/20 text-green-500 p-3 rounded-xl flex items-center gap-2 text-sm font-bold border border-green-500/30">
                          <CheckCircle2 className="w-4 h-4" /> {successMsg}
                      </div>
                  )}

                  <div className="space-y-1">
                      <label className="text-[10px] uppercase font-bold text-zinc-500">Server Name</label>
                      <input 
                        className="w-full bg-zinc-900 border border-zinc-800 p-3 rounded-xl text-white text-sm outline-none focus:border-red-500/50"
                        placeholder="e.g. Rustoria Main"
                        value={formData.name}
                        onChange={e => setFormData({...formData, name: e.target.value})}
                      />
                  </div>

                  <div className="grid grid-cols-2 gap-3">
                      <div className="space-y-1">
                          <label className="text-[10px] uppercase font-bold text-zinc-500">IP Address</label>
                          <input 
                            className="w-full bg-zinc-900 border border-zinc-800 p-3 rounded-xl text-white text-sm outline-none focus:border-red-500/50 font-mono"
                            placeholder="127.0.0.1"
                            value={formData.ip}
                            onChange={e => setFormData({...formData, ip: e.target.value})}
                          />
                      </div>
                      <div className="space-y-1">
                          <label className="text-[10px] uppercase font-bold text-zinc-500">Port</label>
                          <input 
                            className="w-full bg-zinc-900 border border-zinc-800 p-3 rounded-xl text-white text-sm outline-none focus:border-red-500/50 font-mono"
                            placeholder="28015"
                            value={formData.port}
                            onChange={e => setFormData({...formData, port: e.target.value})}
                          />
                      </div>
                  </div>

                  <div className="space-y-1">
                      <label className="text-[10px] uppercase font-bold text-zinc-500">Header Image URL</label>
                      <div className="flex gap-2">
                          <input 
                            className="w-full bg-zinc-900 border border-zinc-800 p-3 rounded-xl text-white text-sm outline-none focus:border-red-500/50"
                            placeholder="https://..."
                            value={formData.image}
                            onChange={e => setFormData({...formData, image: e.target.value})}
                          />
                          <div className="w-12 h-11 bg-zinc-900 rounded-lg border border-zinc-800 flex items-center justify-center shrink-0">
                              {formData.image ? <img src={formData.image} className="w-full h-full object-cover rounded-lg" alt="" /> : <Upload className="w-4 h-4 text-zinc-600" />}
                          </div>
                      </div>
                  </div>

                  <div className="space-y-1">
                      <label className="text-[10px] uppercase font-bold text-zinc-500">Description</label>
                      <textarea 
                        className="w-full bg-zinc-900 border border-zinc-800 p-3 rounded-xl text-white text-sm outline-none focus:border-red-500/50 h-24 resize-none"
                        placeholder="Server details..."
                        value={formData.desc}
                        onChange={e => setFormData({...formData, desc: e.target.value})}
                      />
                  </div>

                  <button 
                    onClick={handleAddServer}
                    className="w-full py-4 bg-red-600 hover:bg-red-500 text-white font-bold uppercase rounded-xl shadow-lg shadow-red-900/30 active:scale-[0.98] transition-all flex items-center justify-center gap-2 mt-4"
                  >
                      <Save className="w-4 h-4" /> Save Promotion
                  </button>
              </div>
          )}

      </div>
    </div>
  );
};
