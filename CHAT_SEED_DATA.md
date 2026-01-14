# 聊天功能验收 - 种子数据与测试步骤

## 1. 最小必需字段说明

### Conversation 文档 (`conversations/{conversationId}`)

| 字段 | 类型 | 必需 | 说明 |
|------|------|------|------|
| `id` | string | ✅ | 文档 ID（与 Firestore doc id 一致） |
| `type` | string | ✅ | `direct` / `group` / `activity` |
| `name` | string | ✅ | 会话名称 |
| `participantIds` | array | ✅ | 参与者 uid 列表（**Rules 依赖此字段**） |
| `participantNames` | map | ✅ | `{uid: displayName}` |
| `participantAvatars` | map | ✅ | `{uid: avatarUrl}` |
| `createdAt` | string | ✅ | ISO8601 时间 |
| `updatedAt` | string | ✅ | ISO8601 时间 |
| `isActive` | boolean | ⚡ | 默认 `true`（query 依赖此字段） |
| `lastMessageContent` | string | 可选 | 最后一条消息内容 |
| `lastMessageSenderId` | string | 可选 | 最后一条消息发送者 |
| `lastMessageTime` | string | 可选 | ISO8601 时间 |
| `unreadCount` | number | 可选 | 未读数（默认 0） |

### Message 文档 (`conversations/{conversationId}/messages/{messageId}`)

| 字段 | 类型 | 必需 | 说明 |
|------|------|------|------|
| `id` | string | ✅ | 消息 ID |
| `conversationId` | string | ✅ | 所属会话 ID |
| `senderId` | string | ✅ | 发送者 uid（**Rules 要求 == auth.uid**） |
| `senderName` | string | ✅ | 发送者显示名 |
| `senderAvatar` | string | ✅ | 发送者头像 URL |
| `type` | string | ✅ | `text` / `image` / `video` 等 |
| `content` | string | ✅ | 消息内容 |
| `timestamp` | string | ✅ | ISO8601 时间 |
| `status` | string | ⚡ | `sending` / `sent` / `delivered` / `read` |
| `readBy` | array | 可选 | 已读用户列表 |

---

## 2. 种子数据示例（JSON）

> 将以下数据导入 Firestore（可使用 Firebase Console 或 Emulator）

### 测试用户 UID
- **User A**: `testUserA123`
- **User B**: `testUserB456`
- **User C (非参与者)**: `testUserC789`

### 2.1 Conversation 文档

**路径**: `conversations/conv_test_001`

```json
{
  "id": "conv_test_001",
  "type": "direct",
  "name": "Test Chat",
  "avatar": null,
  "participantIds": ["testUserA123", "testUserB456"],
  "participantNames": {
    "testUserA123": "Alice Test",
    "testUserB456": "Bob Test"
  },
  "participantAvatars": {
    "testUserA123": "",
    "testUserB456": ""
  },
  "lastMessageContent": "Hey Bob!",
  "lastMessageSenderId": "testUserA123",
  "lastMessageTime": "2026-01-14T10:00:00.000Z",
  "unreadCount": 1,
  "createdAt": "2026-01-14T09:00:00.000Z",
  "updatedAt": "2026-01-14T10:00:00.000Z",
  "activityId": null,
  "isActive": true,
  "mutedBy": {}
}
```

### 2.2 Message 文档

**路径**: `conversations/conv_test_001/messages/msg_001`

```json
{
  "id": "msg_001",
  "conversationId": "conv_test_001",
  "senderId": "testUserA123",
  "senderName": "Alice Test",
  "senderAvatar": "",
  "type": "text",
  "content": "Hey Bob!",
  "mediaUrls": null,
  "activityId": null,
  "timestamp": "2026-01-14T10:00:00.000Z",
  "status": "sent",
  "readBy": [],
  "replyToMessageId": null
}
```

**路径**: `conversations/conv_test_001/messages/msg_002`

```json
{
  "id": "msg_002",
  "conversationId": "conv_test_001",
  "senderId": "testUserB456",
  "senderName": "Bob Test",
  "senderAvatar": "",
  "type": "text",
  "content": "Hi Alice! How are you?",
  "mediaUrls": null,
  "activityId": null,
  "timestamp": "2026-01-14T10:01:00.000Z",
  "status": "sent",
  "readBy": [],
  "replyToMessageId": null
}
```

**路径**: `conversations/conv_test_001/messages/msg_003`

```json
{
  "id": "msg_003",
  "conversationId": "conv_test_001",
  "senderId": "testUserA123",
  "senderName": "Alice Test",
  "senderAvatar": "",
  "type": "text",
  "content": "I'm great! Ready for the hike tomorrow? 🏔️",
  "mediaUrls": null,
  "activityId": null,
  "timestamp": "2026-01-14T10:02:00.000Z",
  "status": "sent",
  "readBy": [],
  "replyToMessageId": null
}
```

---

## 3. 验收用例

| # | 执行者 | 操作 | 预期结果 |
|---|--------|------|----------|
| 1 | User A | 登录后打开 Messages 页面 | ✅ 能看到 "Test Chat" 会话 |
| 2 | User A | 点击进入 Test Chat | ✅ 能看到 3 条消息 |
| 3 | User A | 发送新消息 "Testing!" | ✅ 消息成功写入，UI 实时更新 |
| 4 | User B | 登录后打开 Messages 页面 | ✅ 能看到 "Test Chat" 会话 |
| 5 | User B | 进入 Test Chat | ✅ 能看到 A 发送的所有消息（包括 "Testing!"） |
| 6 | User B | 发送消息 "Got it!" | ✅ 消息成功写入 |
| 7 | User C | 登录后打开 Messages | ✅ 看不到 "Test Chat"（不在 participantIds） |
| 8 | User C | 尝试直接访问 conv_test_001 | ❌ permission-denied（Rules 生效） |

---

## 4. 验收命令（可选 - Firebase Emulator）

```bash
# 启动 Emulator（如果使用）
firebase emulators:start --only firestore

# 导入种子数据
firebase emulators:exec --only firestore 'node seed_chat_data.js'
```

---

## 5. sendMessage 已包含 conversation 更新

`FirebaseService.sendMessage()` 方法已经自动更新以下字段：
- `lastMessageContent`
- `lastMessageSenderId`
- `lastMessageTime`
- `updatedAt`

✅ 无需额外补丁。
