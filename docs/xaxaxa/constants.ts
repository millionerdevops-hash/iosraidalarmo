
import { Question, PlanDetails } from './types';

export const ONBOARDING_QUESTIONS: Question[] = [
  { 
    id: 1, 
    text: "Which Rust server type do you main?", 
    options: [
      "Official", 
      "Community", 
      "Modded", 
      "Private / Friends", 
      "I jump between servers"
    ] 
  },
  { 
    id: 2, 
    text: "What server rate do you usually play on?", 
    options: [
      "Vanilla (1x)", 
      "2x", 
      "3x", 
      "5x", 
      "10x+", 
      "Depends on the wipe"
    ] 
  },
  { 
    id: 3, 
    text: "What wipe cycle do you prefer?", 
    options: [
      "Weekly wipe", 
      "Bi-weekly wipe", 
      "Monthly wipe", 
      "I don’t care, just PvP"
    ] 
  },
  { 
    id: 4, 
    text: "How do you usually play Rust?", 
    options: [
      "Solo 🐺", 
      "Duo 🤝", 
      "Trio 👥", 
      "Small group (4–5)", 
      "Clan (6–12)", 
      "Zerg (12∞) 🐜"
    ] 
  },
  { 
    id: 5, 
    text: "When do you get raided most?", 
    options: [
      "Offline (most of the time) 😴", 
      "Online raids ⚔️", 
      "Both 😭", 
      "I’m the one raiding others 😈"
    ] 
  },
  { 
    id: 6, 
    text: "What’s your biggest Rust nightmare?", 
    options: [
      "Waking up to a fully wiped base 💀", 
      "Losing all my sulfur & loot 💣", 
      "Getting raided while sleeping 😴", 
      "Being raided during work/school 🏫", 
      "Missing the first boom sound 👂"
    ] 
  },
  { 
    id: 7, 
    text: "When are you usually offline?", 
    options: [
      "Sleeping 😴", 
      "At work/school 🏫", 
      "Traveling ✈️", 
      "I play almost all day 🎮", 
      "Random hours 🔀"
    ] 
  },
  { 
    id: 8, 
    text: "How do you usually build your base?", 
    options: [
      "Small hidden base", 
      "Bunker base 🧱", 
      "Compound with turrets", 
      "Multiple small bases", 
      "Whatever survives the wipe"
    ] 
  },
  { 
    id: 9, 
    text: "Do you use Rust+ for raid notifications?", 
    options: [
      "Yes, but notifications are unreliable", 
      "I tried it, didn’t trust it", 
      "I get notifications too late", 
      "I don’t use Rust+ at all"
    ] 
  },
  { 
    id: 10, 
    text: "Have you ever missed a raid because you didn’t hear Rust+?", 
    options: [
      "Yes… more times than I’d like 😞", 
      "Yes, and it wiped my base 💀", 
      "Almost — barely logged in on time 😰"
    ] 
  },
  { 
    id: 11, 
    text: "Why do you usually miss raid notifications?", 
    options: [
      "My phone is on silent/vibrate 🔕", 
      "My phone is in another room 📱", 
      "Battery saver kills notifications 🔋", 
      "I’m sleeping through alerts 😴"
    ] 
  },
  { 
    id: 12, 
    text: "What would actually wake you up during a raid?", 
    options: [
      "🔔 Loud, unstoppable alarm", 
      "🔁 Repeating alarm until you stop it", 
      "📞 Incoming phone call simulation", 
      "⭐ I’d use all of them for maximum safety"
    ] 
  }
];

export const LIFETIME_PLANS: PlanDetails[] = [
  { id: 'SOLO', name: 'LONE WOLF', slots: 1, price: '$17.99' },
  { id: 'DUO', name: 'DUO PARTNER', slots: 2, price: '$29.99' },
  { id: 'TRIO', name: 'TRIO TEAM', slots: 3, price: '$44.99', popular: true },
  { id: 'SQUAD', name: 'SQUAD', slots: 4, price: '$59.99' },
];
