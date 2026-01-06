import React, { useState } from 'react';
import { ArrowLeft, Phone, Plus, Paperclip } from 'lucide-react';
import svgPaths from '../imports/svg-isqvu6sdnq';

interface Message {
  id: string;
  type: 'sent' | 'received' | 'system' | 'checkin' | 'weather' | 'transaction' | 'billsplit';
  text?: string;
  sender?: string;
  senderAvatar?: string;
  timestamp?: string;
}

interface ChatDetailProps {
  chat: {
    id: string;
    name: string;
    avatar?: string;
    isGroup: boolean;
    participants?: number;
    onlineCount?: number;
  };
  onBack: () => void;
}

export const ChatDetail: React.FC<ChatDetailProps> = ({ chat, onBack }) => {
  const [message, setMessage] = useState('');

  // Sample messages based on the Figma design
  const messages: Message[] = chat.isGroup ? [
    {
      id: '1',
      type: 'sent',
      text: "Everyone ready for the hike? Let's check in! 🏔️",
    },
    {
      id: '2',
      type: 'checkin',
      text: 'You checked in',
    },
    {
      id: '3',
      type: 'received',
      text: "I'm here! Perfect day for it",
      sender: 'Tom',
      senderAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop',
    },
    {
      id: '4',
      type: 'checkin',
      text: 'Tom Checked in',
    },
    {
      id: '5',
      type: 'checkin',
      text: 'Alice Chen Checked in',
    },
    {
      id: '6',
      type: 'checkin',
      text: 'Tom Branson Checked in',
    },
    {
      id: '7',
      type: 'checkin',
      text: 'Eve Smith Checked in',
    },
    {
      id: '8',
      type: 'checkin',
      text: 'Kush Singh Checked in',
    },
    {
      id: '9',
      type: 'sent',
      text: 'Still waiting for Helena?',
    },
    {
      id: '10',
      type: 'sent',
      text: 'Should we grab water while we wait?',
    },
    {
      id: '11',
      type: 'checkin',
      text: 'Helena Hills Checked in',
    },
    {
      id: '12',
      type: 'weather',
    },
    {
      id: '13',
      type: 'received',
      text: "Wow 35°C is intense! Everyone bring sunscreen?",
      sender: 'Tom',
      senderAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop',
    },
    {
      id: '14',
      type: 'sent',
      text: 'Yeah good call on the weather alert',
    },
    {
      id: '15',
      type: 'sent',
      text: 'Just bought some water bottles for everyone',
    },
    {
      id: '16',
      type: 'transaction',
    },
    {
      id: '17',
      type: 'received',
      text: 'Thanks for getting the water!',
      sender: 'Alice',
      senderAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&h=100&fit=crop',
    },
    {
      id: '18',
      type: 'received',
      text: 'We should split the costs for today',
      sender: 'Eve',
      senderAvatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&h=100&fit=crop',
    },
    {
      id: '19',
      type: 'received',
      text: "I'll create a bill split for everything",
      sender: 'Tom',
      senderAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop',
    },
    {
      id: '20',
      type: 'billsplit',
    },
    {
      id: '21',
      type: 'sent',
      text: 'Perfect! Just paid my share 💸',
    },
  ] : [
    {
      id: '1',
      type: 'received',
      text: "Hey! How's it going?",
      sender: chat.name,
      senderAvatar: chat.avatar,
    },
    {
      id: '2',
      type: 'sent',
      text: "Pretty good! Just got back from a hike",
    },
    {
      id: '3',
      type: 'received',
      text: "Nice! Where did you go?",
      sender: chat.name,
      senderAvatar: chat.avatar,
    },
    {
      id: '4',
      type: 'sent',
      text: "George Bass coastal walk. The views were amazing!",
    },
    {
      id: '5',
      type: 'received',
      text: "That sounds awesome! Maybe we can go together next time? 🏔️",
      sender: chat.name,
      senderAvatar: chat.avatar,
    },
  ];

  return (
    <div className="fixed inset-0 bg-white z-[100] flex flex-col">
      {/* Header */}
      <div className="bg-white border-b border-gray-200 px-4 py-3 flex items-center gap-3">
        <button onClick={onBack} className="p-1 hover:bg-gray-100 rounded-full transition-colors">
          <ArrowLeft className="w-6 h-6" />
        </button>
        
        <div className="flex items-center gap-3 flex-1">
          {chat.avatar && (
            <img 
              src={chat.avatar} 
              alt={chat.name}
              className="w-8 h-8 rounded-full object-cover"
            />
          )}
          <div className="flex-1 min-w-0">
            <h3 className="truncate">{chat.name}</h3>
            {chat.isGroup && chat.onlineCount && (
              <p className="text-gray-500">{chat.onlineCount} People Online</p>
            )}
          </div>
        </div>

        <button className="p-2 hover:bg-gray-100 rounded-full transition-colors">
          <Phone className="w-5 h-5" />
        </button>
      </div>

      {/* Messages */}
      <div className="flex-1 overflow-y-auto px-4 py-4 space-y-3">
        {messages.map((msg) => {
          if (msg.type === 'system' || msg.type === 'checkin') {
            return (
              <div key={msg.id} className="flex justify-center">
                <p className="text-gray-500 text-center">{msg.text}</p>
              </div>
            );
          }

          if (msg.type === 'weather') {
            return (
              <div key={msg.id} className="flex justify-center my-4">
                <div className="relative w-[320px] h-[151px] rounded-[18px] bg-gradient-to-b from-[#ff6b6b] to-[#ff8e53] shadow-lg p-3 overflow-hidden">
                  {/* Decorative elements */}
                  <div className="absolute top-[-32px] right-[30px] w-[128px] h-[128px] rounded-full bg-gradient-to-b from-[#ffd700] to-[#ffed4e] opacity-40 blur-2xl" />
                  <div className="absolute top-[-16px] right-[15px] w-[80px] h-[80px] rounded-full bg-gradient-to-b from-[#fff200] to-[#ffd700] opacity-60" />
                  
                  <button className="absolute top-2 right-2 w-4 h-4 text-white opacity-60">
                    <svg viewBox="0 0 10 10" fill="none">
                      <path d={svgPaths.p48af40} stroke="currentColor" strokeLinecap="round" strokeLinejoin="round" strokeOpacity="0.6" strokeWidth="1.33333" />
                      <path d={svgPaths.p30908200} stroke="currentColor" strokeLinecap="round" strokeLinejoin="round" strokeOpacity="0.6" strokeWidth="1.33333" />
                    </svg>
                  </button>

                  <div className="flex gap-3 items-start relative z-10">
                    <div className="w-10 h-10 bg-white/20 rounded-full flex items-center justify-center flex-shrink-0 mt-1">
                      <svg viewBox="0 0 20 20" fill="none" className="w-5 h-5">
                        <path d={svgPaths.p3a14cd80} stroke="white" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.66667" />
                      </svg>
                    </div>
                    
                    <div className="flex-1">
                      <div className="flex items-center gap-2 mb-2">
                        <h4 className="text-white">Weather Alert</h4>
                        <span className="bg-white/25 text-white px-2 py-0.5 rounded-full">🔥 35°C</span>
                      </div>
                      
                      <p className="text-white/95 mb-2">
                        High temperature expected during your activity. Stay hydrated and take breaks in the shade! 💧
                      </p>
                      
                      <div className="flex gap-2">
                        <button className="bg-white/25 text-white px-3 py-1.5 rounded-full hover:bg-white/30 transition-colors">
                          Safety Tips
                        </button>
                        <button className="bg-white/10 text-white px-3 py-1.5 rounded-full hover:bg-white/20 transition-colors">
                          Got it
                        </button>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            );
          }

          if (msg.type === 'transaction') {
            return (
              <div key={msg.id} className="flex justify-center my-4">
                <div className="relative w-[320px] rounded-[18px] bg-gradient-to-b from-[#4ade80] to-[#22c55e] shadow-lg p-3">
                  <button className="absolute top-2 right-2 w-4 h-4 text-white opacity-60">
                    <svg viewBox="0 0 10 10" fill="none">
                      <path d={svgPaths.p48af40} stroke="currentColor" strokeLinecap="round" strokeLinejoin="round" strokeOpacity="0.6" strokeWidth="1.33333" />
                      <path d={svgPaths.p30908200} stroke="currentColor" strokeLinecap="round" strokeLinejoin="round" strokeOpacity="0.6" strokeWidth="1.33333" />
                    </svg>
                  </button>

                  <div className="flex gap-3 items-start">
                    <div className="w-10 h-10 bg-white/20 rounded-full flex items-center justify-center flex-shrink-0 mt-1">
                      <svg viewBox="0 0 20 20" fill="none" className="w-5 h-5">
                        <g clipPath="url(#clip0_62_322)">
                          <path d={svgPaths.p34ea8c80} stroke="white" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.66667" />
                          <path d="M16.6667 1.66667V5" stroke="white" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.66667" />
                          <path d="M18.3333 3.33333H15" stroke="white" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.66667" />
                          <path d={svgPaths.p2661f400} stroke="white" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.66667" />
                        </g>
                        <defs>
                          <clipPath id="clip0_62_322">
                            <rect fill="white" height="20" width="20" />
                          </clipPath>
                        </defs>
                      </svg>
                    </div>
                    
                    <div className="flex-1">
                      <div className="flex items-center gap-2 mb-2">
                        <h4 className="text-white">Transaction Detected</h4>
                        <span className="bg-white/25 text-white px-2 py-0.5 rounded-full">💳 $45.99</span>
                      </div>
                      
                      <p className="text-white/95 mb-2">
                        Would you like to record this as an event expense? 📝
                      </p>
                      
                      <div className="flex gap-2">
                        <button className="bg-white text-[#00a63e] px-4 py-1.5 rounded-full shadow hover:bg-gray-50 transition-colors">
                          Record It
                        </button>
                        <button className="bg-white/20 text-white px-3 py-1.5 rounded-full hover:bg-white/30 transition-colors">
                          Skip
                        </button>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            );
          }

          if (msg.type === 'billsplit') {
            return (
              <div key={msg.id} className="flex justify-center my-4">
                <div className="relative w-[320px] rounded-[18px] bg-gradient-to-b from-[#a855f7] to-[#ec4899] shadow-lg p-3">
                  <div className="flex gap-3 items-start">
                    <div className="w-10 h-10 bg-white/20 rounded-full flex items-center justify-center flex-shrink-0 mt-1">
                      <svg viewBox="0 0 20 20" fill="none" className="w-5 h-5">
                        <path d={svgPaths.p3e8f800} stroke="white" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.66667" />
                        <path d={svgPaths.p11d57a00} stroke="white" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.66667" />
                      </svg>
                    </div>
                    
                    <div className="flex-1">
                      <div className="flex items-center gap-2 mb-2">
                        <h4 className="text-white">Bill Split Request</h4>
                        <span className="bg-white/25 text-white px-2 py-0.5 rounded-full">💸 Pending</span>
                      </div>
                      
                      <div className="bg-white/10 rounded-xl p-3 mb-2 space-y-2">
                        <div className="flex justify-between items-center">
                          <span className="text-white/80">Total Amount</span>
                          <span className="text-white">$231</span>
                        </div>
                        <div className="flex justify-between items-center">
                          <span className="text-white/80">Your Share</span>
                          <span className="text-[#d4ff00]">$33</span>
                        </div>
                        <div className="pt-2 border-t border-white/20 flex items-center gap-2">
                          <svg viewBox="0 0 14 14" fill="none" className="w-3.5 h-3.5">
                            <path d={svgPaths.p317fdd80} stroke="white" strokeLinecap="round" strokeLinejoin="round" strokeOpacity="0.7" strokeWidth="1.16667" />
                            <path d={svgPaths.pc62e8b0} stroke="white" strokeLinecap="round" strokeLinejoin="round" strokeOpacity="0.7" strokeWidth="1.16667" />
                            <path d={svgPaths.pe97dd00} stroke="white" strokeLinecap="round" strokeLinejoin="round" strokeOpacity="0.7" strokeWidth="1.16667" />
                            <path d={svgPaths.p31c78b80} stroke="white" strokeLinecap="round" strokeLinejoin="round" strokeOpacity="0.7" strokeWidth="1.16667" />
                          </svg>
                          <span className="text-white/70">2 people haven't paid yet</span>
                        </div>
                      </div>
                      
                      <div className="flex gap-2">
                        <button className="flex-1 bg-white text-[#9810fa] px-4 py-1.5 rounded-full shadow hover:bg-gray-50 transition-colors flex items-center justify-center gap-1">
                          <svg viewBox="0 0 14 14" fill="none" className="w-3.5 h-3.5">
                            <path d="M2.91667 7H11.0833" stroke="currentColor" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.16667" />
                            <path d={svgPaths.pf23dd00} stroke="currentColor" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.16667" />
                          </svg>
                          Pay $33
                        </button>
                        <button className="bg-white/20 text-white px-3 py-1.5 rounded-full hover:bg-white/30 transition-colors">
                          Details
                        </button>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            );
          }

          if (msg.type === 'sent') {
            return (
              <div key={msg.id} className="flex justify-end">
                <div className="bg-[#007aff] text-white rounded-[20px] px-3 py-2 max-w-[70%]">
                  <p className="tracking-[-0.2344px]">{msg.text}</p>
                </div>
              </div>
            );
          }

          if (msg.type === 'received') {
            return (
              <div key={msg.id} className="flex gap-2 items-end">
                {msg.senderAvatar && (
                  <img 
                    src={msg.senderAvatar} 
                    alt={msg.sender}
                    className="w-6 h-6 rounded-full object-cover flex-shrink-0"
                  />
                )}
                <div className="bg-[#e9e9eb] text-black rounded-[20px] px-3 py-2 max-w-[70%]">
                  <p className="tracking-[-0.2344px]">{msg.text}</p>
                </div>
              </div>
            );
          }

          return null;
        })}
      </div>

      {/* Input Bar */}
      <div className="bg-white border-t border-gray-200 p-4">
        <div className="flex items-center gap-3 bg-neutral-100 border border-[#e0e0e0] rounded-full px-3 py-2">
          <button className="w-7 h-7 bg-gradient-to-b from-[#a855f7] to-[#ec4899] rounded-full flex items-center justify-center shadow flex-shrink-0">
            <Plus className="w-4 h-4 text-white" />
          </button>
          
          <input
            type="text"
            value={message}
            onChange={(e) => setMessage(e.target.value)}
            placeholder="Message"
            className="flex-1 bg-transparent outline-none text-gray-600 placeholder-gray-400"
          />
          
          <button className="flex-shrink-0">
            <Paperclip className="w-6 h-6 text-gray-600" />
          </button>
        </div>
      </div>

      {/* iOS Home Indicator */}
      <div className="pb-2 flex justify-center">
        <div className="w-32 h-1 bg-black/30 rounded-full" />
      </div>
    </div>
  );
};
