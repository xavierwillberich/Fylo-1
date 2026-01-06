import { useState } from "react";
import { motion, AnimatePresence } from "motion/react";
import {
  ArrowLeft,
  Wallet,
  ArrowUpRight,
  ArrowDownLeft,
  Eye,
  EyeOff,
  TrendingUp,
  TrendingDown,
  Plus,
  Send,
  Clock,
  CreditCard,
  DollarSign,
  Gift,
  Sparkles,
  History,
  Filter,
} from "lucide-react";
import { Button } from "./ui/button";
import { ScrollArea } from "./ui/scroll-area";
import { Separator } from "./ui/separator";
import { Badge } from "./ui/badge";
import { Avatar, AvatarFallback, AvatarImage } from "./ui/avatar";

interface Transaction {
  id: string;
  type: 'income' | 'expense' | 'refund' | 'reward';
  title: string;
  description: string;
  amount: number;
  date: string;
  time: string;
  status: 'completed' | 'pending' | 'failed';
  avatar?: string;
  activityId?: string;
}

interface WalletPageProps {
  onClose: () => void;
}

export function WalletPage({ onClose }: WalletPageProps) {
  const [showBalance, setShowBalance] = useState(true);
  const [activeTab, setActiveTab] = useState<'all' | 'income' | 'expense'>('all');

  // Mock data
  const balance = 1248.50;
  const monthlyIncome = 850.00;
  const monthlyExpense = 420.00;
  const points = 3240;

  const transactions: Transaction[] = [
    {
      id: '1',
      type: 'expense',
      title: 'Mount Rainier Hiking',
      description: 'Activity participation fee',
      amount: -45.00,
      date: 'Today',
      time: '2:30 PM',
      status: 'completed',
      activityId: 'HIK-001234',
      avatar: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=150'
    },
    {
      id: '2',
      type: 'reward',
      title: 'Event Completion Bonus',
      description: 'Attended Beach Volleyball',
      amount: 20.00,
      date: 'Today',
      time: '11:15 AM',
      status: 'completed',
      activityId: 'SPO-005678'
    },
    {
      id: '3',
      type: 'income',
      title: 'Wallet Top-up',
      description: 'Credit card ****1234',
      amount: 100.00,
      date: 'Yesterday',
      time: '4:20 PM',
      status: 'completed'
    },
    {
      id: '4',
      type: 'expense',
      title: 'Coffee & Board Games',
      description: 'Activity participation fee',
      amount: -15.00,
      date: 'Yesterday',
      time: '10:30 AM',
      status: 'completed',
      activityId: 'SOC-002345',
      avatar: 'https://images.unsplash.com/photo-1511920170033-f8396924c348?w=150'
    },
    {
      id: '5',
      type: 'refund',
      title: 'Activity Cancelled',
      description: 'Weekend Camping Trip',
      amount: 85.00,
      date: 'Nov 2',
      time: '3:45 PM',
      status: 'completed',
      activityId: 'CAM-003456'
    },
    {
      id: '6',
      type: 'expense',
      title: 'Rock Climbing Session',
      description: 'Activity participation fee',
      amount: -35.00,
      date: 'Nov 1',
      time: '6:00 PM',
      status: 'completed',
      activityId: 'SPO-007890',
      avatar: 'https://images.unsplash.com/photo-1522163182402-834f871fd851?w=150'
    },
    {
      id: '7',
      type: 'reward',
      title: 'First Event of Month',
      description: 'Achievement reward',
      amount: 10.00,
      date: 'Nov 1',
      time: '12:00 AM',
      status: 'completed'
    },
    {
      id: '8',
      type: 'expense',
      title: 'Photography Workshop',
      description: 'Activity participation fee',
      amount: -55.00,
      date: 'Oct 30',
      time: '2:15 PM',
      status: 'completed',
      activityId: 'WKS-004567',
      avatar: 'https://images.unsplash.com/photo-1452587925148-ce544e77e70d?w=150'
    },
  ];

  const filteredTransactions = transactions.filter(t => {
    if (activeTab === 'all') return true;
    if (activeTab === 'income') return t.type === 'income' || t.type === 'reward' || t.type === 'refund';
    if (activeTab === 'expense') return t.type === 'expense';
    return true;
  });

  const getTransactionIcon = (type: Transaction['type']) => {
    switch (type) {
      case 'income':
        return <ArrowDownLeft className="w-4 h-4 text-green-600" />;
      case 'expense':
        return <ArrowUpRight className="w-4 h-4 text-red-600" />;
      case 'refund':
        return <ArrowDownLeft className="w-4 h-4 text-blue-600" />;
      case 'reward':
        return <Gift className="w-4 h-4 text-orange-600" />;
    }
  };

  const getAmountColor = (type: Transaction['type']) => {
    switch (type) {
      case 'income':
      case 'reward':
      case 'refund':
        return 'text-green-600';
      case 'expense':
        return 'text-red-600';
    }
  };

  return (
    <motion.div
      initial={{ opacity: 0, x: "100%" }}
      animate={{ opacity: 1, x: 0 }}
      exit={{ opacity: 0, x: "100%" }}
      transition={{ duration: 0.3, ease: "easeOut" }}
      className="fixed inset-0 z-[150] bg-gray-50"
    >
      <div className="fixed inset-0 max-w-md mx-auto bg-gray-50">
        <ScrollArea className="h-full">
          {/* Header - Gradient Background Section */}
          <div className="relative bg-gradient-to-br from-indigo-600 via-purple-600 to-pink-500 overflow-hidden rounded-b-[40px] shadow-xl">
            {/* Animated Background Blobs */}
            <motion.div
              animate={{
                scale: [1, 1.2, 1],
                rotate: [0, 90, 0],
              }}
              transition={{
                duration: 20,
                repeat: Infinity,
                ease: "linear",
              }}
              className="absolute top-0 right-0 w-64 h-64 bg-white/10 rounded-full blur-3xl"
            />
            <motion.div
              animate={{
                scale: [1.2, 1, 1.2],
                rotate: [0, -90, 0],
              }}
              transition={{
                duration: 15,
                repeat: Infinity,
                ease: "linear",
              }}
              className="absolute bottom-0 left-0 w-64 h-64 bg-white/10 rounded-full blur-3xl"
            />

            {/* Header Bar */}
            <div className="relative z-10 flex items-center justify-between px-5 py-5">
              <motion.button
                whileHover={{ scale: 1.1, backgroundColor: "rgba(255,255,255,0.15)" }}
                whileTap={{ scale: 0.9 }}
                onClick={onClose}
                className="p-2.5 -ml-2 hover:bg-white/10 rounded-full transition-all"
              >
                <ArrowLeft className="w-6 h-6 text-white" />
              </motion.button>
              <motion.h1 
                initial={{ opacity: 0, y: -10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.1 }}
                className="text-white text-xl"
              >
                My Wallet
              </motion.h1>
              <motion.button
                whileHover={{ scale: 1.1, backgroundColor: "rgba(255,255,255,0.15)" }}
                whileTap={{ scale: 0.9 }}
                className="p-2.5 -mr-2 hover:bg-white/10 rounded-full transition-all"
              >
                <History className="w-6 h-6 text-white" />
              </motion.button>
            </div>

            {/* Balance Card - Glassmorphism Style */}
            <motion.div
              initial={{ opacity: 0, y: 30, scale: 0.9 }}
              animate={{ opacity: 1, y: 0, scale: 1 }}
              transition={{ delay: 0.15, type: "spring", stiffness: 200, damping: 20 }}
              className="relative z-10 mx-5 mb-6 p-8 bg-white/15 backdrop-blur-xl rounded-[32px] shadow-2xl border border-white/20"
            >
              {/* Decorative elements */}
              <div className="absolute top-0 right-0 w-32 h-32 bg-gradient-to-br from-white/20 to-transparent rounded-full blur-2xl" />
              <div className="absolute bottom-0 left-0 w-24 h-24 bg-gradient-to-tr from-white/20 to-transparent rounded-full blur-2xl" />

              <div className="relative">
                <div className="flex items-center justify-between mb-6">
                  <motion.div 
                    initial={{ opacity: 0, x: -20 }}
                    animate={{ opacity: 1, x: 0 }}
                    transition={{ delay: 0.2 }}
                    className="flex items-center gap-3"
                  >
                    <div className="p-2.5 bg-white/20 rounded-2xl backdrop-blur-sm">
                      <Wallet className="w-5 h-5 text-white" />
                    </div>
                    <span className="text-white/90 text-sm">Available Balance</span>
                  </motion.div>
                  <motion.button
                    initial={{ opacity: 0, scale: 0 }}
                    animate={{ opacity: 1, scale: 1 }}
                    transition={{ delay: 0.25, type: "spring", stiffness: 300 }}
                    whileHover={{ scale: 1.1, backgroundColor: "rgba(255,255,255,0.25)" }}
                    whileTap={{ scale: 0.9 }}
                    onClick={() => setShowBalance(!showBalance)}
                    className="p-2.5 hover:bg-white/20 rounded-2xl transition-all backdrop-blur-sm"
                  >
                    <AnimatePresence mode="wait">
                      {showBalance ? (
                        <motion.div
                          key="eye"
                          initial={{ rotate: -180, opacity: 0 }}
                          animate={{ rotate: 0, opacity: 1 }}
                          exit={{ rotate: 180, opacity: 0 }}
                          transition={{ duration: 0.3 }}
                        >
                          <Eye className="w-5 h-5 text-white" />
                        </motion.div>
                      ) : (
                        <motion.div
                          key="eye-off"
                          initial={{ rotate: -180, opacity: 0 }}
                          animate={{ rotate: 0, opacity: 1 }}
                          exit={{ rotate: 180, opacity: 0 }}
                          transition={{ duration: 0.3 }}
                        >
                          <EyeOff className="w-5 h-5 text-white" />
                        </motion.div>
                      )}
                    </AnimatePresence>
                  </motion.button>
                </div>

                <AnimatePresence mode="wait">
                  {showBalance ? (
                    <motion.div
                      key="balance"
                      initial={{ opacity: 0, y: 10 }}
                      animate={{ opacity: 1, y: 0 }}
                      exit={{ opacity: 0, y: -10 }}
                      transition={{ duration: 0.3 }}
                      className="mb-8"
                    >
                      <motion.h2
                        initial={{ scale: 0.8 }}
                        animate={{ scale: 1 }}
                        transition={{ type: "spring", stiffness: 200 }}
                        className="text-white text-5xl mb-2 font-light tracking-tight"
                      >
                        ${balance.toFixed(2)}
                      </motion.h2>
                      <motion.p 
                        initial={{ opacity: 0 }}
                        animate={{ opacity: 1 }}
                        transition={{ delay: 0.1 }}
                        className="text-white/70 text-sm"
                      >
                        USD
                      </motion.p>
                    </motion.div>
                  ) : (
                    <motion.div
                      key="hidden"
                      initial={{ opacity: 0, y: 10 }}
                      animate={{ opacity: 1, y: 0 }}
                      exit={{ opacity: 0, y: -10 }}
                      transition={{ duration: 0.3 }}
                      className="mb-8"
                    >
                      <div className="text-white text-5xl mb-2">••••••</div>
                      <p className="text-white/70 text-sm">Hidden</p>
                    </motion.div>
                  )}
                </AnimatePresence>

                {/* Action Buttons */}
                <div className="grid grid-cols-2 gap-4">
                  <motion.button
                    initial={{ opacity: 0, x: -20 }}
                    animate={{ opacity: 1, x: 0 }}
                    transition={{ delay: 0.3, type: "spring" }}
                    whileHover={{ scale: 1.03, y: -2 }}
                    whileTap={{ scale: 0.97 }}
                    className="group relative overflow-hidden flex items-center justify-center gap-2 p-4 bg-white text-purple-600 rounded-2xl transition-all shadow-lg hover:shadow-xl"
                  >
                    <motion.div
                      className="absolute inset-0 bg-gradient-to-r from-purple-50 to-pink-50 opacity-0 group-hover:opacity-100 transition-opacity"
                    />
                    <Plus className="w-5 h-5 relative z-10" />
                    <span className="relative z-10">Top Up</span>
                  </motion.button>
                  <motion.button
                    initial={{ opacity: 0, x: 20 }}
                    animate={{ opacity: 1, x: 0 }}
                    transition={{ delay: 0.35, type: "spring" }}
                    whileHover={{ scale: 1.03, y: -2 }}
                    whileTap={{ scale: 0.97 }}
                    className="group relative overflow-hidden flex items-center justify-center gap-2 p-4 bg-white/20 text-white rounded-2xl transition-all border border-white/30 backdrop-blur-sm hover:bg-white/30"
                  >
                    <Send className="w-5 h-5 relative z-10" />
                    <span className="relative z-10">Withdraw</span>
                  </motion.button>
                </div>
              </div>
            </motion.div>

            {/* Stats Cards - Overlapping the gradient section */}
            <motion.div
              initial={{ opacity: 0, y: 40 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.4, type: "spring", stiffness: 150 }}
              className="relative z-10 grid grid-cols-3 gap-3 mx-5 pb-6"
            >
              <motion.div 
                whileHover={{ scale: 1.05, y: -4 }}
                whileTap={{ scale: 0.95 }}
                className="p-4 bg-white/20 backdrop-blur-xl rounded-3xl border border-white/30 shadow-lg cursor-pointer"
              >
                <motion.div 
                  initial={{ scale: 0 }}
                  animate={{ scale: 1 }}
                  transition={{ delay: 0.5, type: "spring", stiffness: 200 }}
                  className="flex items-center gap-2 mb-3"
                >
                  <div className="p-1.5 bg-green-400/30 rounded-xl">
                    <TrendingUp className="w-3.5 h-3.5 text-green-100" />
                  </div>
                  <span className="text-white/90 text-xs">Income</span>
                </motion.div>
                <motion.p 
                  initial={{ opacity: 0 }}
                  animate={{ opacity: 1 }}
                  transition={{ delay: 0.6 }}
                  className="text-white text-xl"
                >
                  ${monthlyIncome.toFixed(0)}
                </motion.p>
              </motion.div>

              <motion.div 
                whileHover={{ scale: 1.05, y: -4 }}
                whileTap={{ scale: 0.95 }}
                className="p-4 bg-white/20 backdrop-blur-xl rounded-3xl border border-white/30 shadow-lg cursor-pointer"
              >
                <motion.div 
                  initial={{ scale: 0 }}
                  animate={{ scale: 1 }}
                  transition={{ delay: 0.55, type: "spring", stiffness: 200 }}
                  className="flex items-center gap-2 mb-3"
                >
                  <div className="p-1.5 bg-red-400/30 rounded-xl">
                    <TrendingDown className="w-3.5 h-3.5 text-red-100" />
                  </div>
                  <span className="text-white/90 text-xs">Expense</span>
                </motion.div>
                <motion.p 
                  initial={{ opacity: 0 }}
                  animate={{ opacity: 1 }}
                  transition={{ delay: 0.65 }}
                  className="text-white text-xl"
                >
                  ${monthlyExpense.toFixed(0)}
                </motion.p>
              </motion.div>

              <motion.div 
                whileHover={{ scale: 1.05, y: -4 }}
                whileTap={{ scale: 0.95 }}
                className="p-4 bg-white/20 backdrop-blur-xl rounded-3xl border border-white/30 shadow-lg cursor-pointer"
              >
                <motion.div 
                  initial={{ scale: 0 }}
                  animate={{ scale: 1 }}
                  transition={{ delay: 0.6, type: "spring", stiffness: 200 }}
                  className="flex items-center gap-2 mb-3"
                >
                  <div className="p-1.5 bg-yellow-400/30 rounded-xl">
                    <Sparkles className="w-3.5 h-3.5 text-yellow-100" />
                  </div>
                  <span className="text-white/90 text-xs">Points</span>
                </motion.div>
                <motion.p 
                  initial={{ opacity: 0 }}
                  animate={{ opacity: 1 }}
                  transition={{ delay: 0.7 }}
                  className="text-white text-xl"
                >
                  {points}
                </motion.p>
              </motion.div>
            </motion.div>
          </div>

          {/* Transaction Section */}
          <div className="px-5 py-5 pb-32">
            {/* Tab Filters */}
            <motion.div
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.3 }}
              className="flex gap-2 mb-5"
            >
              {(['all', 'income', 'expense'] as const).map((tab) => (
                <motion.button
                  key={tab}
                  whileHover={{ scale: 1.05 }}
                  whileTap={{ scale: 0.95 }}
                  onClick={() => setActiveTab(tab)}
                  className={`px-5 py-2 rounded-full text-sm transition-all ${
                    activeTab === tab
                      ? 'bg-gray-900 text-white'
                      : 'bg-white text-gray-700 hover:bg-gray-100'
                  }`}
                >
                  {tab.charAt(0).toUpperCase() + tab.slice(1)}
                </motion.button>
              ))}
            </motion.div>

            {/* Transaction Header */}
            <div className="flex items-center justify-between mb-4">
              <div className="flex items-center gap-2">
                <History className="w-5 h-5 text-gray-600" />
                <h2 className="text-black">Transaction History</h2>
              </div>
              <span className="text-sm text-gray-500">
                {filteredTransactions.length} transactions
              </span>
            </div>

            {/* Transaction List */}
            <div className="space-y-3">
              <AnimatePresence mode="popLayout">
                {filteredTransactions.map((transaction, index) => (
                  <motion.div
                    key={transaction.id}
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    exit={{ opacity: 0, scale: 0.9 }}
                    transition={{ delay: index * 0.05 }}
                    whileHover={{ scale: 1.02, backgroundColor: "#f9fafb" }}
                    whileTap={{ scale: 0.98 }}
                    className="p-4 bg-white rounded-2xl shadow-sm border border-gray-100 cursor-pointer transition-all"
                  >
                    <div className="flex items-center gap-4">
                      {/* Icon/Avatar */}
                      <div className="flex-shrink-0">
                        {transaction.avatar ? (
                          <div className="relative">
                            <Avatar className="w-12 h-12">
                              <AvatarImage src={transaction.avatar} />
                              <AvatarFallback>
                                {transaction.title.substring(0, 2)}
                              </AvatarFallback>
                            </Avatar>
                            <div className="absolute -bottom-1 -right-1 p-1 bg-white rounded-full shadow-sm">
                              {getTransactionIcon(transaction.type)}
                            </div>
                          </div>
                        ) : (
                          <div className={`w-12 h-12 rounded-full flex items-center justify-center ${
                            transaction.type === 'income' || transaction.type === 'reward' || transaction.type === 'refund'
                              ? 'bg-green-50'
                              : 'bg-red-50'
                          }`}>
                            {getTransactionIcon(transaction.type)}
                          </div>
                        )}
                      </div>

                      {/* Details */}
                      <div className="flex-1 min-w-0">
                        <div className="flex items-start justify-between gap-2 mb-1">
                          <h3 className="text-black truncate">
                            {transaction.title}
                          </h3>
                          <span className={`text-lg ${getAmountColor(transaction.type)}`}>
                            {transaction.amount > 0 ? '+' : ''}${Math.abs(transaction.amount).toFixed(2)}
                          </span>
                        </div>
                        <div className="flex items-center justify-between gap-2">
                          <p className="text-sm text-gray-500 truncate">
                            {transaction.description}
                          </p>
                          <span className="text-xs text-gray-400 whitespace-nowrap">
                            {transaction.time}
                          </span>
                        </div>
                        {transaction.activityId && (
                          <Badge variant="outline" className="mt-2 text-xs">
                            {transaction.activityId}
                          </Badge>
                        )}
                      </div>
                    </div>
                  </motion.div>
                ))}
              </AnimatePresence>
            </div>

            {/* Empty State */}
            {filteredTransactions.length === 0 && (
              <motion.div
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                className="text-center py-12"
              >
                <div className="w-20 h-20 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
                  <History className="w-10 h-10 text-gray-400" />
                </div>
                <p className="text-gray-600 mb-2">No transactions found</p>
                <p className="text-sm text-gray-500">
                  Try changing the filter or make your first transaction
                </p>
              </motion.div>
            )}
          </div>
        </ScrollArea>
      </div>
    </motion.div>
  );
}