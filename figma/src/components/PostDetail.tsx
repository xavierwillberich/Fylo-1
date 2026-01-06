import { useState } from "react";
import {
  ArrowLeft,
  Heart,
  MessageCircle,
  Share2,
  Send,
  MoreVertical,
} from "lucide-react";
import { Avatar, AvatarFallback, AvatarImage } from "./ui/avatar";
import { Button } from "./ui/button";
import { Textarea } from "./ui/textarea";
import { ScrollArea } from "./ui/scroll-area";
import type { Post } from "./PoolPage";

interface Comment {
  id: number;
  user: {
    name: string;
    username: string;
    avatar: string;
  };
  text: string;
  timestamp: string;
  likes: number;
  isLiked: boolean;
  replies?: Comment[];
}

interface PostDetailProps {
  post: Post;
  onClose: () => void;
  onViewProfile: (username: string, avatar: string) => void;
  onViewActivity?: (activityId: string) => void;
}

export function PostDetail({ post, onClose, onViewProfile, onViewActivity }: PostDetailProps) {
  const [commentText, setCommentText] = useState("");
  const [isLiked, setIsLiked] = useState(post.isLiked);
  const [likesCount, setLikesCount] = useState(post.likes);
  const [comments, setComments] = useState<Comment[]>([
    {
      id: 1,
      user: {
        name: "Mike Rodriguez",
        username: "@mike_games",
        avatar: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100",
      },
      text: "This looks amazing! Can't wait to try it!",
      timestamp: "1 hour ago",
      likes: 12,
      isLiked: false,
    },
    {
      id: 2,
      user: {
        name: "Sarah Mitchell",
        username: "@sarah_m",
        avatar: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100",
      },
      text: "I was there too! Such a great experience 😊",
      timestamp: "45 min ago",
      likes: 8,
      isLiked: true,
      replies: [
        {
          id: 3,
          user: {
            name: post.user.name,
            username: post.user.username,
            avatar: post.user.avatar,
          },
          text: "Glad you enjoyed it! Let's do it again sometime!",
          timestamp: "30 min ago",
          likes: 3,
          isLiked: false,
        },
      ],
    },
    {
      id: 4,
      user: {
        name: "Jessica Park",
        username: "@jess_runs",
        avatar: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100",
      },
      text: "Count me in for next time!",
      timestamp: "20 min ago",
      likes: 5,
      isLiked: false,
    },
  ]);

  // Double tap to like
  const [lastTap, setLastTap] = useState(0);

  const handleDoubleTap = () => {
    const now = Date.now();
    if (now - lastTap < 300) {
      setIsLiked(true);
      if (!isLiked) {
        setLikesCount(likesCount + 1);
      }
    }
    setLastTap(now);
  };

  const handleLike = () => {
    setIsLiked(!isLiked);
    setLikesCount(isLiked ? likesCount - 1 : likesCount + 1);
  };

  const handleAddComment = () => {
    if (commentText.trim()) {
      const newComment: Comment = {
        id: comments.length + 1,
        user: {
          name: "Alice Chen",
          username: "@alice_chen",
          avatar: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100",
        },
        text: commentText,
        timestamp: "Just now",
        likes: 0,
        isLiked: false,
      };
      setComments([...comments, newComment]);
      setCommentText("");
    }
  };

  const handleCommentLike = (commentId: number) => {
    setComments(
      comments.map((comment) => {
        if (comment.id === commentId) {
          return {
            ...comment,
            isLiked: !comment.isLiked,
            likes: comment.isLiked ? comment.likes - 1 : comment.likes + 1,
          };
        }
        return comment;
      })
    );
  };

  return (
    <div className="bg-white min-h-screen">
      <div className="max-w-md mx-auto bg-white min-h-screen pb-24">
        {/* Sticky Header */}
        <div className="sticky top-0 bg-white z-10 flex items-center justify-between p-5 border-b border-gray-200">
          <button
            onClick={onClose}
            className="p-2 -ml-2 hover:bg-gray-100 rounded-full transition-all"
          >
            <ArrowLeft className="w-6 h-6" />
          </button>
          <h1 className="text-black">Post</h1>
          <div className="w-10"></div>
        </div>

        {/* Post Content - Same as Pool */}
        <div className="border-b-8 border-gray-100">
          <div className="p-4">
            {/* User Info */}
            <div className="flex items-center justify-between mb-3">
              <div
                className="flex items-center gap-3 cursor-pointer"
                onClick={() => onViewProfile(post.user.username, post.user.avatar)}
              >
                <Avatar className="w-10 h-10">
                  <AvatarImage src={post.user.avatar} />
                  <AvatarFallback>{post.user.name.substring(0, 2)}</AvatarFallback>
                </Avatar>
                <div>
                  <p className="text-black">{post.user.name}</p>
                  <p className="text-xs text-gray-500">{post.timestamp}</p>
                </div>
              </div>
              <button className="p-2 hover:bg-gray-100 rounded-full transition-all">
                <MoreVertical className="w-5 h-5 text-gray-600" />
              </button>
            </div>

            {/* Post Content */}
            <div onDoubleClick={handleDoubleTap}>
              {post.content.text && (
                <p className="text-black mb-3">
                  {post.content.text}
                </p>
              )}

              {/* Images */}
              {post.content.images && post.content.images.length > 0 && (
                <div 
                  className={`mb-3 rounded-xl overflow-hidden ${
                    post.content.images.length === 1
                      ? "aspect-[4/3]"
                      : post.content.images.length === 2
                        ? "grid grid-cols-2 gap-1"
                        : "grid grid-cols-2 gap-1"
                  }`}
                >
                  {post.content.images.map((image, idx) => (
                    <img
                      key={idx}
                      src={image}
                      alt={`Post image ${idx + 1}`}
                      className={`w-full h-full object-cover ${
                        post.content.images!.length === 1 ? "" : "aspect-square"
                      }`}
                    />
                  ))}
                </div>
              )}

              {/* Related Activity */}
              {post.relatedActivity && (
                <div 
                  className="p-3 bg-gray-50 rounded-lg border border-gray-200 mb-3 cursor-pointer hover:bg-gray-100 transition-all"
                  onClick={() => {
                    if (onViewActivity) {
                      onViewActivity(post.relatedActivity!.id);
                    }
                  }}
                >
                  <p className="text-xs text-gray-500 mb-1">Related Activity</p>
                  <p className="text-sm text-black">{post.relatedActivity.title}</p>
                  <p className="text-xs text-gray-400 mt-1">{post.relatedActivity.id}</p>
                </div>
              )}
            </div>

            {/* Actions */}
            <div className="flex items-center gap-6">
              <button
                onClick={handleLike}
                className="flex items-center gap-2 hover:opacity-70 transition-all"
              >
                <Heart
                  className={`w-7 h-7 ${
                    isLiked ? "fill-red-500 stroke-red-500" : "stroke-black"
                  }`}
                />
                <span className="text-black">{likesCount}</span>
              </button>
              <div className="flex items-center gap-2">
                <MessageCircle className="w-7 h-7 stroke-black" />
                <span className="text-black">{comments.length}</span>
              </div>
              {post.isPublic && (
                <button className="hover:opacity-70 transition-all">
                  <Share2 className="w-7 h-7 stroke-black" />
                </button>
              )}
            </div>
          </div>
        </div>

        {/* Comments Section */}
        <div className="px-4 pt-6 space-y-6">
          <h3 className="text-black">Comments</h3>
          
          {comments.map((comment) => (
            <div key={comment.id}>
              <div className="flex gap-3">
                <Avatar
                  className="w-10 h-10 cursor-pointer"
                  onClick={() => onViewProfile(comment.user.username, comment.user.avatar)}
                >
                  <AvatarImage src={comment.user.avatar} />
                  <AvatarFallback>{comment.user.name.substring(0, 2)}</AvatarFallback>
                </Avatar>
                <div className="flex-1">
                  <div className="bg-gray-50 rounded-2xl px-4 py-3">
                    <p
                      className="text-black mb-1 cursor-pointer"
                      onClick={() => onViewProfile(comment.user.username, comment.user.avatar)}
                    >
                      {comment.user.name}
                    </p>
                    <p className="text-gray-700">{comment.text}</p>
                  </div>
                  <div className="flex items-center gap-4 mt-2 ml-4">
                    <span className="text-xs text-gray-500">{comment.timestamp}</span>
                    <button
                      onClick={() => handleCommentLike(comment.id)}
                      className="text-xs text-gray-600 hover:text-black transition-all"
                    >
                      {comment.isLiked ? "Liked" : "Like"} · {comment.likes}
                    </button>
                    <button className="text-xs text-gray-600 hover:text-black transition-all">
                      Reply
                    </button>
                  </div>

                  {/* Replies */}
                  {comment.replies && comment.replies.length > 0 && (
                    <div className="mt-4 ml-6 space-y-4">
                      {comment.replies.map((reply) => (
                        <div key={reply.id} className="flex gap-3">
                          <Avatar
                            className="w-8 h-8 cursor-pointer"
                            onClick={() => onViewProfile(reply.user.username, reply.user.avatar)}
                          >
                            <AvatarImage src={reply.user.avatar} />
                            <AvatarFallback>{reply.user.name.substring(0, 2)}</AvatarFallback>
                          </Avatar>
                          <div className="flex-1">
                            <div className="bg-gray-50 rounded-2xl px-4 py-3">
                              <p
                                className="text-black mb-1 cursor-pointer"
                                onClick={() => onViewProfile(reply.user.username, reply.user.avatar)}
                              >
                                {reply.user.name}
                              </p>
                              <p className="text-gray-700 text-sm">{reply.text}</p>
                            </div>
                            <div className="flex items-center gap-4 mt-2 ml-4">
                              <span className="text-xs text-gray-500">{reply.timestamp}</span>
                              <button className="text-xs text-gray-600 hover:text-black transition-all">
                                Like · {reply.likes}
                              </button>
                            </div>
                          </div>
                        </div>
                      ))}
                    </div>
                  )}
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}