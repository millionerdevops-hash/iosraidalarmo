
import React, { useState, useEffect } from 'react';
import { ScreenLayout } from './components/ScreenLayout';
import { Button } from './components/Button';
import { GetStartedScreen } from './screens/GetStartedScreen';
import { DisclaimerScreen } from './screens/DisclaimerScreen'; // Imported Disclaimer
import { JoinCodeScreen } from './screens/JoinCodeScreen';
import { OnboardingScreen } from './screens/OnboardingScreen';
import { RiskAnalysisScreen } from './screens/RiskAnalysisScreen';
import { HowItWorksScreen } from './screens/HowItWorksScreen'; 
import { AlarmPreviewScreen } from './screens/AlarmPreviewScreen';
import { SetupReadyScreen } from './screens/SetupReadyScreen';
import { PaywallScreen } from './screens/PaywallScreen';
import { PrivacyPolicyScreen } from './screens/PrivacyPolicyScreen';
import { TermsOfServiceScreen } from './screens/TermsOfServiceScreen';
import { DashboardScreen } from './screens/DashboardScreen';
import { SettingsScreen } from './screens/SettingsScreen';
import { RaidCalculatorScreen } from './screens/RaidCalculatorScreen';
import { ScrapCalculatorScreen } from './screens/ScrapCalculatorScreen';
import { CCTVCodesScreen } from './screens/CCTVCodesScreen';
import { TeaCalculatorScreen } from './screens/TeaCalculatorScreen';
import { ServerSearchScreen } from './screens/ServerSearchScreen';
import { ServerDetailScreen } from './screens/ServerDetailScreen';
import { ServerPromoScreen } from './screens/ServerPromoScreen';
import { ServerPromoDetailScreen } from './screens/ServerPromoDetailScreen';
import { PlayerSearchScreen } from './screens/PlayerSearchScreen';
import { CombatSearchScreen } from './screens/CombatSearchScreen';
import { PlayerStatsScreen } from './screens/PlayerStatsScreen'; 
import { AIAnalyzerScreen } from './screens/AIAnalyzerScreen';
import { CraftingCalculatorScreen } from './screens/CraftingCalculatorScreen';
import { GeneCalculatorScreen } from './screens/GeneCalculatorScreen';
import { MLRSCalculatorScreen } from './screens/MLRSCalculatorScreen';
import { DieselCalculatorScreen } from './screens/DieselCalculatorScreen';
import { ElectricitySimulatorScreen } from './screens/ElectricitySimulatorScreen';
import { IndustrialCalculatorScreen } from './screens/IndustrialCalculatorScreen';
import { RecoilTrainerScreen } from './screens/RecoilTrainerScreen';
import { MonumentPuzzleScreen } from './screens/MonumentPuzzleScreen';
import { TechTreeScreen } from './screens/TechTreeScreen';
import { BlueprintTrackerScreen } from './screens/BlueprintTrackerScreen';
import { UpkeepCalculatorScreen } from './screens/UpkeepCalculatorScreen';
import { SmartSwitchesScreen } from './screens/SmartSwitchesScreen';
import { ConnectionManagerScreen } from './screens/ConnectionManagerScreen';
import { SteamLoginScreen } from './screens/SteamLoginScreen';
import { AdminPanelScreen } from './screens/AdminPanelScreen';
import { MarketScreen } from './screens/MarketScreen';
import { NewsFeedScreen } from './screens/NewsFeedScreen'; 
import { GuideDetailScreen } from './screens/GuideDetailScreen';
import { GuideListScreen } from './screens/GuideListScreen';
import { RecyclerGuideScreen } from './screens/RecyclerGuideScreen'; 
import { AnimalGuideScreen } from './screens/AnimalGuideScreen';
import { PartnersScreen } from './screens/PartnersScreen'; 
import { BuildingSimulatorScreen } from './screens/BuildingSimulatorScreen';
import { CrateSimulatorScreen } from './screens/CrateSimulatorScreen'; 
import { MiniGameScreen } from './screens/MiniGameScreen'; 
import { BaseRoastScreen } from './screens/BaseRoastScreen'; 
import { SoundboardScreen } from './screens/SoundboardScreen'; 
import { CodeBreakerScreen } from './screens/CodeBreakerScreen'; 
import { TeamBuilderScreen } from './screens/TeamBuilderScreen'; 
import { LootSimulatorScreen } from './screens/LootSimulatorScreen'; 
import { AimTrainerScreen } from './screens/AimTrainerScreen';
import { ArmorCalculatorScreen } from './screens/ArmorCalculatorScreen';
import { AutomationListScreen } from './screens/AutomationListScreen';
import { AutomationDetailScreen } from './screens/AutomationDetailScreen';
import { BlackjackScreen } from './screens/BlackjackScreen';
import { WheelGameScreen } from './screens/WheelGameScreen';
import { DevicePairingScreen } from './screens/DevicePairingScreen';
import { SkinHubScreen } from './screens/SkinHubScreen';
import { DecayTimersScreen } from './screens/DecayTimersScreen';
import { RetentionDiscountScreen } from './screens/RetentionDiscountScreen';
import { SocialProofScreen } from './screens/SocialProofScreen';
import { NotificationPermissionScreen } from './screens/NotificationPermissionScreen'; 
import { CriticalAlertPermissionScreen } from './screens/CriticalAlertPermissionScreen'; 

import { 
  ONBOARDING_QUESTIONS, 
  LIFETIME_PLANS 
} from './constants';
import { 
  ScreenName, 
  AppState, 
  PlanType, 
  ServerData, 
  UpkeepState, 
  TargetPlayer, 
  ActiveRaid 
} from './types';
import { TYPOGRAPHY, PALETTE } from './theme';
import { 
  Siren,
  Crosshair,
  Skull,
  Timer,
  CheckCircle2,
  XCircle,
  Trophy
} from 'lucide-react';

export default function App() {
  const [state, setState] = useState<AppState>({
    currentScreen: 'SPLASH',
    userRole: 'FREE',
    plan: null,
    teamSize: 0,
    currentMembers: 0,
    onboardingData: {},
    savedServer: null,
    isOnlineInGame: false,
    wipeAlertEnabled: false,
    wipeAlertMinutes: 30,
    upkeep: {
      wood: { costPerDay: 0, amount: 0 },
      stone: { costPerDay: 0, amount: 0 },
      metal: { costPerDay: 0, amount: 0 },
      hqm: { costPerDay: 0, amount: 0 },
      lastUpdated: Date.now()
    },
    trackedTargets: [],
    // Initialize from localStorage so refreshing doesn't bypass limit
    aiUsageCount: parseInt(localStorage.getItem('raidalarm_ai_usage') || '0')
  });

  const [onboardingIndex, setOnboardingIndex] = useState(0);
  const [showInviteModal, setShowInviteModal] = useState(false);
  const [selectedPromoServer, setSelectedPromoServer] = useState<ServerData | null>(null);
  const [selectedGuideId, setSelectedGuideId] = useState<string>('getting_started');
  
  // State for passing player data to stats screen
  const [statsPlayer, setStatsPlayer] = useState<{ id: string; name: string } | null>(null);

  // --- RAID INTERACTION STATE ---
  const [pendingRaidTarget, setPendingRaidTarget] = useState<TargetPlayer | null>(null);
  const [activeRaid, setActiveRaid] = useState<ActiveRaid | null>(null);
  const [showOutcomeDialog, setShowOutcomeDialog] = useState<ActiveRaid | null>(null);

  // --- Navigation Helpers ---
  const navigate = (screen: ScreenName) => {
    setState(prev => ({ ...prev, currentScreen: screen }));
  };

  // --- Logic Handlers ---

  useEffect(() => {
    if (state.currentScreen === 'SPLASH') {
      const timer = setTimeout(() => {
        // CHANGED: Go to DISCLAIMER instead of GET_STARTED
        navigate('DISCLAIMER');
      }, 2500);
      return () => clearTimeout(timer);
    }
  }, [state.currentScreen]);

  const handleAnswer = (option: string) => {
    const currentQuestion = ONBOARDING_QUESTIONS[onboardingIndex];
    if (!currentQuestion) return;

    setState(prev => ({
      ...prev,
      onboardingData: { ...prev.onboardingData, [currentQuestion.id]: option }
    }));

    if (onboardingIndex < ONBOARDING_QUESTIONS.length - 1) {
      setOnboardingIndex(prev => prev + 1);
    } else {
      navigate('RISK_ANALYSIS');
    }
  };

  const handleJoinSuccess = () => {
    setState(prev => ({
      ...prev,
      userRole: 'MEMBER',
      plan: 'CLAN',
      teamSize: 5,
      currentMembers: 4,
      currentScreen: 'DASHBOARD'
    }));
  };

  const handlePurchase = (planId: PlanType) => {
    const selectedPlan = LIFETIME_PLANS.find(p => p.id === planId);
    setState(prev => ({
      ...prev,
      userRole: 'OWNER',
      plan: planId,
      teamSize: selectedPlan?.slots || 1,
      currentMembers: 1,
      currentScreen: 'DASHBOARD'
    }));
  };

  const handleSkipPaywall = () => {
    setState(prev => ({ ...prev, userRole: 'FREE', currentScreen: 'DASHBOARD' }));
  };

  const handleRestore = () => {
    console.log("Restore purchases triggered");
    alert("Restore functionality would connect to store APIs here.");
  };

  const handleSaveServer = (server: ServerData | null) => {
    setState(prev => ({ ...prev, savedServer: server }));
  };

  const handleSelectPromoServer = (server: ServerData) => {
    setSelectedPromoServer(server);
    navigate('SERVER_PROMO_DETAIL');
  };

  const handleToggleOnlineStatus = () => {
    setState(prev => ({ ...prev, isOnlineInGame: !prev.isOnlineInGame }));
  };

  const handleToggleWipeAlert = (enabled: boolean) => {
    setState(prev => ({ ...prev, wipeAlertEnabled: enabled }));
  };

  const handleSetWipeAlertMinutes = (minutes: number) => {
    setState(prev => ({ ...prev, wipeAlertMinutes: minutes }));
  };

  const handleUpdateUpkeep = (newUpkeep: UpkeepState) => {
    setState(prev => ({ ...prev, upkeep: newUpkeep }));
  };

  const handleUpdateTargets = (targets: TargetPlayer[]) => {
    setState(prev => ({ ...prev, trackedTargets: targets }));
  };

  // --- VIEW STATS HANDLER ---
  const handleViewStats = (id: string, name: string) => {
      setStatsPlayer({ id, name });
      navigate('PLAYER_STATS');
  };

  // --- TRIGGER: TARGET WENT OFFLINE ---
  const handleTargetOffline = (target: TargetPlayer) => {
      // Check if we already have an active raid or pending dialog to avoid spam
      if (pendingRaidTarget || activeRaid) return;
      
      // Show the "Opportunity" Dialog
      setPendingRaidTarget(target);
  };

  // --- ACTION: START RAID ---
  const confirmRaidStart = () => {
      if (!pendingRaidTarget) return;

      const newRaid: ActiveRaid = {
          targetName: pendingRaidTarget.name,
          targetId: pendingRaidTarget.id,
          startTime: Date.now()
      };

      setActiveRaid(newRaid);
      setPendingRaidTarget(null);

      // Start Timer for Follow-up
      // NOTE: Using 10 seconds for DEMO purposes. 
      // In production change to: 15 * 60 * 1000 (15 minutes)
      setTimeout(() => {
          setActiveRaid(null); // Clear active status
          setShowOutcomeDialog(newRaid); // Trigger report
      }, 10000); 
  };

  const ignoreRaidOpportunity = () => {
      setPendingRaidTarget(null);
  };

  const submitRaidReport = (success: boolean) => {
      setShowOutcomeDialog(null);
      // Logic to save stats could go here
      console.log(`Raid on ${showOutcomeDialog?.targetName} was ${success ? 'Successful' : 'Failed'}`);
  };

  // --- AI USAGE LOGIC ---
  const handleCheckAiLimit = (): boolean => {
    // If PAID user, always allow
    if (state.userRole === 'OWNER' || state.userRole === 'MEMBER') {
      return true;
    }

    // If FREE, check limit (Max 3)
    if (state.aiUsageCount >= 3) {
      return false;
    }

    // Increment usage
    const newCount = state.aiUsageCount + 1;
    setState(prev => ({ ...prev, aiUsageCount: newCount }));
    localStorage.setItem('raidalarm_ai_usage', newCount.toString());
    return true;
  };

  // PROTOTYPE ONLY: Simulate a member joining when in Invite Modal
  const simulateIncomingJoin = () => {
    setState(prev => {
       const nextCount = prev.currentMembers + 1;
       // If adding this member fills the team, close modal to show the alert
       if (nextCount >= prev.teamSize) {
           setShowInviteModal(false);
       }
       return { ...prev, currentMembers: Math.min(nextCount, prev.teamSize) };
    });
  };

  // --- Renders ---

  const renderSplash = () => (
    <div className="flex flex-col items-center justify-center h-full bg-black relative">
      <div className="w-32 h-32 relative mb-8">
        <div className="absolute inset-0 bg-red-600 rounded-full animate-ping opacity-20"></div>
        <div className="relative z-10 w-full h-full bg-gradient-to-br from-red-600 to-red-900 rounded-full flex items-center justify-center border-4 border-red-950 shadow-[0_0_50px_rgba(220,38,38,0.5)]">
          <Siren className="w-16 h-16 text-white" />
        </div>
      </div>
      <h1 className={`text-5xl text-white glitch-effect ${TYPOGRAPHY.rustFont}`}>RAID ALARM</h1>
      <div className="mt-4 flex items-center gap-2">
        <div className="w-2 h-2 bg-red-500 rounded-full animate-pulse" />
        <p className="text-zinc-500 font-mono text-sm tracking-widest uppercase">System Initializing...</p>
      </div>
    </div>
  );

  return (
    <ScreenLayout showScanline={state.currentScreen !== 'SPLASH' && state.currentScreen !== 'DISCLAIMER' && state.currentScreen !== 'STEAM_LOGIN' && state.currentScreen !== 'ADMIN_PANEL' && state.currentScreen !== 'GUIDE_DETAIL' && state.currentScreen !== 'GUIDE_LIST' && state.currentScreen !== 'RECYCLER_GUIDE' && state.currentScreen !== 'ANIMAL_GUIDE' && state.currentScreen !== 'PARTNERS' && state.currentScreen !== 'BUILDING_SIMULATOR' && state.currentScreen !== 'CRATE_SIMULATOR' && state.currentScreen !== 'MINI_GAME' && state.currentScreen !== 'BASE_ROAST' && state.currentScreen !== 'SOUNDBOARD' && state.currentScreen !== 'CODE_BREAKER' && state.currentScreen !== 'TEAM_BUILDER' && state.currentScreen !== 'LOOT_SIMULATOR' && state.currentScreen !== 'AIM_TRAINER' && state.currentScreen !== 'ARMOR_CALCULATOR' && state.currentScreen !== 'AUTOMATION_LIST' && state.currentScreen !== 'AUTOMATION_DETAIL' && state.currentScreen !== 'BLACKJACK' && state.currentScreen !== 'WHEEL_GAME' && state.currentScreen !== 'SKIN_HUB' && state.currentScreen !== 'DECAY_TIMERS' && state.currentScreen !== 'RETENTION_DISCOUNT' && state.currentScreen !== 'SOCIAL_PROOF' && state.currentScreen !== 'NOTIFICATION_PERMISSION' && state.currentScreen !== 'CRITICAL_ALERT_PERMISSION'}>
      {state.currentScreen === 'SPLASH' && renderSplash()}
      
      {/* NEW DISCLAIMER SCREEN */}
      {state.currentScreen === 'DISCLAIMER' && (
        <DisclaimerScreen 
          onAccept={() => navigate('GET_STARTED')}
        />
      )}

      {state.currentScreen === 'GET_STARTED' && <GetStartedScreen onNavigate={navigate} />}
      {state.currentScreen === 'JOIN_CODE' && <JoinCodeScreen onNavigate={navigate} onJoinSuccess={handleJoinSuccess} />}
      {state.currentScreen === 'ONBOARDING' && ONBOARDING_QUESTIONS[onboardingIndex] && (
        <OnboardingScreen 
          question={ONBOARDING_QUESTIONS[onboardingIndex]}
          currentStepIndex={onboardingIndex}
          totalSteps={ONBOARDING_QUESTIONS.length}
          onAnswer={handleAnswer}
        />
      )}
      {state.currentScreen === 'RISK_ANALYSIS' && <RiskAnalysisScreen onNavigate={navigate} onboardingData={state.onboardingData} />}
      {state.currentScreen === 'HOW_IT_WORKS' && <HowItWorksScreen onNavigate={navigate} />}
      {state.currentScreen === 'ALARM_PREVIEW' && <AlarmPreviewScreen onNavigate={navigate} />}
      
      {state.currentScreen === 'SETUP_READY' && <SetupReadyScreen onNavigate={navigate} />}
      
      {state.currentScreen === 'PAYWALL' && (
        <PaywallScreen 
          onPurchase={handlePurchase} 
          onSkip={handleSkipPaywall} 
          onRestore={handleRestore}
          onPrivacyPolicy={() => navigate('PRIVACY_POLICY')}
          onTerms={() => navigate('TERMS_OF_SERVICE')}
        />
      )}

      {/* NEW: NOTIFICATION PERMISSION */}
      {state.currentScreen === 'NOTIFICATION_PERMISSION' && (
        <NotificationPermissionScreen 
          onNavigate={navigate}
        />
      )}

      {/* NEW: CRITICAL ALERT PERMISSION */}
      {state.currentScreen === 'CRITICAL_ALERT_PERMISSION' && (
        <CriticalAlertPermissionScreen 
          onNavigate={navigate}
        />
      )}

      {/* NEW: RETENTION DISCOUNT SCREEN */}
      {state.currentScreen === 'RETENTION_DISCOUNT' && (
        <RetentionDiscountScreen 
          onNavigate={navigate}
          onPurchase={handlePurchase}
        />
      )}

      {/* NEW: SOCIAL PROOF SCREEN */}
      {state.currentScreen === 'SOCIAL_PROOF' && (
        <SocialProofScreen 
          onNavigate={navigate}
        />
      )}

      {state.currentScreen === 'PRIVACY_POLICY' && <PrivacyPolicyScreen onBack={() => navigate('PAYWALL')} />}
      {state.currentScreen === 'TERMS_OF_SERVICE' && <TermsOfServiceScreen onBack={() => navigate('PAYWALL')} />}
      {state.currentScreen === 'DASHBOARD' && (
        <DashboardScreen 
          state={state} 
          onNavigate={navigate} 
          onShowInviteModal={setShowInviteModal} 
          showInviteModal={showInviteModal}
          onSimulateJoin={simulateIncomingJoin}
          onToggleOnlineStatus={handleToggleOnlineStatus}
          onUpdateUpkeep={handleUpdateUpkeep}
          onUpdateTargets={handleUpdateTargets}
          onTargetOffline={handleTargetOffline} 
          onViewStats={handleViewStats} 
        />
      )}
      {state.currentScreen === 'SETTINGS' && (
        <SettingsScreen 
          onNavigate={navigate} 
          state={state} 
        />
      )}
      {state.currentScreen === 'RAID_CALCULATOR' && <RaidCalculatorScreen onNavigate={navigate} />}
      {state.currentScreen === 'CCTV_CODES' && <CCTVCodesScreen onNavigate={navigate} />}
      {state.currentScreen === 'TEA_CALCULATOR' && <TeaCalculatorScreen onNavigate={navigate} />}
      {state.currentScreen === 'CRAFTING_CALCULATOR' && <CraftingCalculatorScreen onNavigate={navigate} />}
      {state.currentScreen === 'GENE_CALCULATOR' && <GeneCalculatorScreen onNavigate={navigate} />}
      {state.currentScreen === 'MLRS_CALCULATOR' && <MLRSCalculatorScreen onNavigate={navigate} />}
      {state.currentScreen === 'DIESEL_CALCULATOR' && <DieselCalculatorScreen onNavigate={navigate} />}
      {state.currentScreen === 'ELECTRICITY_SIMULATOR' && <ElectricitySimulatorScreen onNavigate={navigate} />}
      {state.currentScreen === 'INDUSTRIAL_CALCULATOR' && <IndustrialCalculatorScreen onNavigate={navigate} />}
      {state.currentScreen === 'RECOIL_TRAINER' && <RecoilTrainerScreen onNavigate={navigate} />}
      {state.currentScreen === 'MONUMENT_PUZZLES' && <MonumentPuzzleScreen onNavigate={navigate} />}
      {state.currentScreen === 'TECH_TREE' && <TechTreeScreen onNavigate={navigate} />}
      {state.currentScreen === 'BLUEPRINT_TRACKER' && <BlueprintTrackerScreen onNavigate={navigate} />}
      {state.currentScreen === 'UPKEEP_CALCULATOR' && <UpkeepCalculatorScreen onNavigate={navigate} />}
      {state.currentScreen === 'SMART_SWITCHES' && <SmartSwitchesScreen onNavigate={navigate} />}
      {state.currentScreen === 'DEVICE_PAIRING' && <DevicePairingScreen onNavigate={navigate} />}
      {state.currentScreen === 'CONNECTION_MANAGER' && <ConnectionManagerScreen onNavigate={navigate} />}
      {state.currentScreen === 'STEAM_LOGIN' && <SteamLoginScreen onNavigate={navigate} />}
      {state.currentScreen === 'NEWS_FEED' && <NewsFeedScreen onNavigate={navigate} />} 
      
      {/* GUIDES */}
      {state.currentScreen === 'GUIDE_LIST' && (
        <GuideListScreen 
          onNavigate={navigate} 
          onSelectGuide={setSelectedGuideId}
        />
      )}
      
      {state.currentScreen === 'GUIDE_DETAIL' && (
        <GuideDetailScreen 
          onNavigate={navigate} 
          guideId={selectedGuideId}
        />
      )}

      {/* NEW: RECYCLER GUIDE */}
      {state.currentScreen === 'RECYCLER_GUIDE' && (
        <RecyclerGuideScreen 
          onNavigate={navigate} 
        />
      )}

      {/* NEW: ANIMAL GUIDE */}
      {state.currentScreen === 'ANIMAL_GUIDE' && (
        <AnimalGuideScreen 
          onNavigate={navigate} 
        />
      )}

      {/* NEW: PARTNERS / AFFILIATE SCREEN */}
      {state.currentScreen === 'PARTNERS' && (
        <PartnersScreen 
          onNavigate={navigate} 
        />
      )}

      {/* NEW: SKIN HUB / CODES */}
      {state.currentScreen === 'SKIN_HUB' && (
        <SkinHubScreen 
          onNavigate={navigate} 
        />
      )}

      {/* NEW: DECAY TIMERS */}
      {state.currentScreen === 'DECAY_TIMERS' && (
        <DecayTimersScreen 
          onNavigate={navigate} 
        />
      )}

      {/* BUILDING SIMULATOR */}
      {state.currentScreen === 'BUILDING_SIMULATOR' && (
        <BuildingSimulatorScreen 
          onNavigate={navigate} 
        />
      )}

      {/* CRATE SIMULATOR */}
      {state.currentScreen === 'CRATE_SIMULATOR' && (
        <CrateSimulatorScreen 
          onNavigate={navigate} 
        />
      )}

      {/* MINI GAME */}
      {state.currentScreen === 'MINI_GAME' && (
        <MiniGameScreen 
          onNavigate={navigate} 
        />
      )}

      {/* BASE ROAST */}
      {state.currentScreen === 'BASE_ROAST' && (
        <BaseRoastScreen 
          onNavigate={navigate} 
        />
      )}

      {/* SOUNDBOARD */}
      {state.currentScreen === 'SOUNDBOARD' && (
        <SoundboardScreen 
          onNavigate={navigate} 
        />
      )}

      {/* CODE BREAKER */}
      {state.currentScreen === 'CODE_BREAKER' && (
        <CodeBreakerScreen 
          onNavigate={navigate} 
        />
      )}

      {/* TEAM BUILDER */}
      {state.currentScreen === 'TEAM_BUILDER' && (
        <TeamBuilderScreen 
          onNavigate={navigate} 
        />
      )}

      {/* NEW: LOOT PANIC (Replaces Fishing) */}
      {state.currentScreen === 'LOOT_SIMULATOR' && (
        <LootSimulatorScreen 
          onNavigate={navigate} 
        />
      )}

      {/* NEW: AIM TRAINER */}
      {state.currentScreen === 'AIM_TRAINER' && (
        <AimTrainerScreen 
          onNavigate={navigate} 
        />
      )}

      {/* NEW: ARMOR CALC */}
      {state.currentScreen === 'ARMOR_CALCULATOR' && (
        <ArmorCalculatorScreen 
          onNavigate={navigate} 
        />
      )}

      {/* NEW: AUTOMATION */}
      {state.currentScreen === 'AUTOMATION_LIST' && (
        <AutomationListScreen 
          onNavigate={navigate} 
        />
      )}
      {state.currentScreen === 'AUTOMATION_DETAIL' && (
        <AutomationDetailScreen 
          onNavigate={navigate} 
        />
      )}

      {/* NEW: BLACKJACK */}
      {state.currentScreen === 'BLACKJACK' && (
        <BlackjackScreen 
          onNavigate={navigate} 
        />
      )}

      {/* NEW: WHEEL GAME */}
      {state.currentScreen === 'WHEEL_GAME' && (
        <WheelGameScreen 
          onNavigate={navigate} 
        />
      )}

      {state.currentScreen === 'ADMIN_PANEL' && <AdminPanelScreen onNavigate={navigate} />}
      
      {/* MARKET MONITOR */}
      {state.currentScreen === 'MARKET_MONITOR' && <MarketScreen onNavigate={navigate} />}

      {/* NEW: Combat Search Screen */}
      {state.currentScreen === 'COMBAT_SEARCH' && (
        <CombatSearchScreen 
          onNavigate={navigate} 
          onViewStats={handleViewStats}
        />
      )}

      {/* NEW: Player Stats Screen */}
      {state.currentScreen === 'PLAYER_STATS' && statsPlayer && (
        <PlayerStatsScreen 
          onNavigate={navigate} 
          playerId={statsPlayer.id}
          playerName={statsPlayer.name}
        />
      )}

      {/* Pass AI props to Scrap Calc */}
      {state.currentScreen === 'SCRAP_CALCULATOR' && (
        <ScrapCalculatorScreen 
          onNavigate={navigate} 
          onCheckAiLimit={handleCheckAiLimit}
          aiUsageCount={state.aiUsageCount}
          userRole={state.userRole}
        />
      )}
      
      {/* Pass AI props to Analyzer */}
      {state.currentScreen === 'AI_ANALYZER' && (
        <AIAnalyzerScreen 
          onNavigate={navigate}
          onCheckAiLimit={handleCheckAiLimit}
          aiUsageCount={state.aiUsageCount}
          userRole={state.userRole}
        />
      )}
      
      {state.currentScreen === 'SERVER_SEARCH' && (
        <ServerSearchScreen 
          onNavigate={navigate}
          onSaveServer={handleSaveServer}
        />
      )}

      {/* New Server Promo Screen */}
      {state.currentScreen === 'SERVER_PROMO' && (
        <ServerPromoScreen 
          onNavigate={navigate}
          onSelectServer={handleSelectPromoServer}
        />
      )}

      {/* New Server Promo Detail Screen */}
      {state.currentScreen === 'SERVER_PROMO_DETAIL' && selectedPromoServer && (
        <ServerPromoDetailScreen 
          server={selectedPromoServer}
          onBack={() => navigate('SERVER_PROMO')}
          onMonitor={() => {
              handleSaveServer(selectedPromoServer);
              navigate('SERVER_DETAIL');
          }}
        />
      )}
      
      {state.currentScreen === 'SERVER_DETAIL' && state.savedServer && (
        <ServerDetailScreen 
          onNavigate={navigate}
          savedServer={state.savedServer}
          onSaveServer={handleSaveServer}
          wipeAlertEnabled={state.wipeAlertEnabled}
          onToggleWipeAlert={handleToggleWipeAlert}
          wipeAlertMinutes={state.wipeAlertMinutes}
          onSetWipeAlertMinutes={handleSetWipeAlertMinutes}
          trackedTargets={state.trackedTargets}
          onUpdateTargets={handleUpdateTargets}
        />
      )}

      {/* Player Search (Directory) */}
      {state.currentScreen === 'PLAYER_SEARCH' && (
        <PlayerSearchScreen 
          onNavigate={navigate} 
          isFree={state.userRole === 'FREE'}
          onViewStats={handleViewStats}
        />
      )}

      {/* --- DIALOGS (GLOBAL OVERLAYS) --- */}

      {/* 1. RAID OPPORTUNITY DIALOG */}
      {pendingRaidTarget && (
          <div className="absolute inset-0 z-[100] flex items-center justify-center bg-black/90 backdrop-blur-sm p-6 animate-in zoom-in-95 duration-200">
              <div className="w-full max-w-sm bg-[#18181b] border border-red-600 rounded-2xl overflow-hidden shadow-[0_0_50px_rgba(220,38,38,0.3)]">
                  <div className="bg-red-600/20 p-4 border-b border-red-600/30 flex items-center gap-3">
                      <div className="w-10 h-10 rounded-full bg-red-600 flex items-center justify-center animate-pulse">
                          <Crosshair className="w-6 h-6 text-white" />
                      </div>
                      <div>
                          <h3 className="text-white font-black uppercase text-lg leading-none">Target Offline</h3>
                          <p className="text-red-300 text-xs font-mono uppercase mt-1">Opportunity Detected</p>
                      </div>
                  </div>
                  <div className="p-6 text-center">
                      <div className="mb-6">
                          <p className="text-zinc-400 text-sm mb-2">Player is now offline:</p>
                          <div className="text-2xl font-black text-white bg-zinc-900 py-3 rounded-xl border border-zinc-800">
                              {pendingRaidTarget.name}
                          </div>
                      </div>
                      <p className="text-white font-bold text-lg mb-6">Initiate Raid Operation?</p>
                      
                      <div className="grid grid-cols-2 gap-3">
                          <button 
                              onClick={ignoreRaidOpportunity}
                              className="py-3.5 rounded-xl border border-zinc-700 text-zinc-400 font-bold uppercase text-xs hover:bg-zinc-800 hover:text-white transition-colors"
                          >
                              Ignore
                          </button>
                          <button 
                              onClick={confirmRaidStart}
                              className="py-3.5 rounded-xl bg-red-600 text-white font-bold uppercase text-xs hover:bg-red-500 shadow-lg shadow-red-900/40 flex items-center justify-center gap-2 transition-all active:scale-95"
                          >
                              <Skull className="w-4 h-4" /> Launch Raid
                          </button>
                      </div>
                  </div>
              </div>
          </div>
      )}

      {/* 2. RAID REPORT DIALOG */}
      {showOutcomeDialog && (
          <div className="absolute inset-0 z-[100] flex items-center justify-center bg-black/90 backdrop-blur-sm p-6 animate-in zoom-in-95 duration-200">
              <div className="w-full max-w-sm bg-[#18181b] border border-zinc-700 rounded-2xl overflow-hidden shadow-2xl">
                  <div className="bg-zinc-900 p-4 border-b border-zinc-800 flex items-center gap-3">
                      <div className="w-10 h-10 rounded-full bg-blue-600 flex items-center justify-center">
                          <Timer className="w-6 h-6 text-white" />
                      </div>
                      <div>
                          <h3 className="text-white font-black uppercase text-lg leading-none">AAR Report</h3>
                          <p className="text-zinc-500 text-xs font-mono uppercase mt-1">After Action Report</p>
                      </div>
                  </div>
                  <div className="p-6 text-center">
                      <p className="text-zinc-300 text-sm mb-6">
                          Operation against <span className="text-white font-bold">{showOutcomeDialog.targetName}</span> has concluded.
                      </p>
                      <p className="text-white font-bold text-xl mb-8 uppercase tracking-wide">
                          Mission Outcome?
                      </p>
                      
                      <div className="space-y-3">
                          <button 
                              onClick={() => submitRaidReport(true)}
                              className="w-full py-4 rounded-xl bg-green-600 text-white font-black uppercase text-sm hover:bg-green-500 shadow-lg shadow-green-900/40 flex items-center justify-center gap-2 transition-all active:scale-95"
                          >
                              <Trophy className="w-5 h-5" /> Loot Secured
                          </button>
                          <button 
                              onClick={() => submitRaidReport(false)}
                              className="w-full py-4 rounded-xl bg-zinc-900 border border-zinc-700 text-zinc-400 font-bold uppercase text-xs hover:text-white hover:border-red-500 hover:bg-red-950/20 transition-all flex items-center justify-center gap-2"
                          >
                              <XCircle className="w-4 h-4" /> Failed / Aborted
                          </button>
                      </div>
                  </div>
              </div>
          </div>
      )}

    </ScreenLayout>
  );
}
