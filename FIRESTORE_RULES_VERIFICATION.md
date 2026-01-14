# Firestore Rules 验收测试指南

## 概述

本文档提供 10 个关键测试用例，验证 `firestore.rules` 的安全性。

---

## 前置条件

### 1. 安装依赖

```bash
# 安装 Firebase 测试工具
npm install --save-dev @firebase/rules-unit-testing firebase-admin

# 或使用 yarn
yarn add -D @firebase/rules-unit-testing firebase-admin
```

### 2. 启动 Firebase Emulator

```bash
# 安装 Firebase CLI（如果尚未安装）
npm install -g firebase-tools

# 初始化 Firebase（如果尚未初始化）
firebase init emulators

# 启动 Firestore Emulator
firebase emulators:start --only firestore
```

Emulator 默认端口：
- Firestore: `localhost:8080`
- UI: `localhost:4000`

### 3. 运行测试

```bash
# 使用 Jest
npx jest test/firestore.rules.test.js --testTimeout=10000

# 或使用 Mocha
npx mocha test/firestore.rules.test.js --timeout 10000
```

---

## 测试用例详情

### 前置数据结构

```javascript
// users 集合
users/userA: { id: 'userA', name: 'User A', ... }
users/userB: { id: 'userB', name: 'User B', ... }

// events 集合
events/event1: { 
  id: 1, 
  title: 'Test Event', 
  creatorId: 'userA',          // 创建者是 userA
  participantIds: ['userA', 'userB'] 
}

// posts 集合
posts/post1: { id: 1, userId: 'userA', title: 'Test Post' }

// notifications 集合
notifications/notif1: { id: 1, receiverId: 'userA', title: '...' }
notifications/notif2: { id: 2, receiverId: 'userB', title: '...' }

// conversations 集合
conversations/conv1: { 
  id: 'conv1', 
  participantIds: ['userA', 'userB'],  // 参与者
  ...
}
conversations/conv1/messages/msg1: { 
  id: 'msg1', 
  senderId: 'userA',  // 发送者
  content: 'Hello!' 
}
```

---

## 10 个关键测试用例

### TC-01: 未认证用户读取 events → ❌ 失败

| 项目 | 内容 |
|-----|-----|
| **操作** | 读取 `events/event1` |
| **身份** | 未认证 (null) |
| **期望结果** | ❌ 失败 (PERMISSION_DENIED) |
| **验证规则** | `allow read: if isAuthenticated()` |

```javascript
// 测试代码
const db = testEnv.unauthenticatedContext().firestore();
await assertFails(db.collection('events').doc('event1').get());
```

---

### TC-02: 认证用户读取 events → ✅ 成功

| 项目 | 内容 |
|-----|-----|
| **操作** | 读取 `events/event1` |
| **身份** | userA (已认证) |
| **期望结果** | ✅ 成功 |
| **验证规则** | `allow read: if isAuthenticated()` |

```javascript
const db = testEnv.authenticatedContext('userA').firestore();
await assertSucceeds(db.collection('events').doc('event1').get());
```

---

### TC-03: 用户读取自己的 users 文档 → ✅ 成功

| 项目 | 内容 |
|-----|-----|
| **操作** | 读取 `users/userA` |
| **身份** | userA |
| **期望结果** | ✅ 成功 |
| **验证规则** | `allow read: if isOwner(userId)` |

```javascript
const db = testEnv.authenticatedContext('userA').firestore();
await assertSucceeds(db.collection('users').doc('userA').get());
```

---

### TC-04: 用户读取他人的 users 文档 → ❌ 失败

| 项目 | 内容 |
|-----|-----|
| **操作** | 读取 `users/userB` |
| **身份** | userA |
| **期望结果** | ❌ 失败 (PERMISSION_DENIED) |
| **验证规则** | `allow read: if isOwner(userId)` (userA ≠ userB) |

```javascript
const db = testEnv.authenticatedContext('userA').firestore();
await assertFails(db.collection('users').doc('userB').get());
```

---

### TC-05: 创建 event 时伪造 creatorId → ❌ 失败

| 项目 | 内容 |
|-----|-----|
| **操作** | 创建 `events/event2`，creatorId 设为 userB |
| **身份** | userA |
| **期望结果** | ❌ 失败 (PERMISSION_DENIED) |
| **验证规则** | `request.resource.data.creatorId == request.auth.uid` |

```javascript
const db = testEnv.authenticatedContext('userA').firestore();
await assertFails(db.collection('events').doc('event2').set({
  id: 2,
  creatorId: 'userB',  // ❌ 伪造
  title: 'Fake Event',
}));
```

---

### TC-06: 非参与者读取 conversation → ❌ 失败

| 项目 | 内容 |
|-----|-----|
| **操作** | 读取 `conversations/conv1` |
| **身份** | userC (不在 participantIds 中) |
| **期望结果** | ❌ 失败 (PERMISSION_DENIED) |
| **验证规则** | `request.auth.uid in resource.data.participantIds` |

```javascript
const db = testEnv.authenticatedContext('userC').firestore();
await assertFails(db.collection('conversations').doc('conv1').get());
```

---

### TC-07: 参与者读取 conversation → ✅ 成功

| 项目 | 内容 |
|-----|-----|
| **操作** | 读取 `conversations/conv1` |
| **身份** | userA (在 participantIds 中) |
| **期望结果** | ✅ 成功 |
| **验证规则** | `request.auth.uid in resource.data.participantIds` |

```javascript
const db = testEnv.authenticatedContext('userA').firestore();
await assertSucceeds(db.collection('conversations').doc('conv1').get());
```

---

### TC-08: 发送消息时伪造 senderId → ❌ 失败

| 项目 | 内容 |
|-----|-----|
| **操作** | 在 `conversations/conv1/messages` 创建消息，senderId 设为 userB |
| **身份** | userA |
| **期望结果** | ❌ 失败 (PERMISSION_DENIED) |
| **验证规则** | `request.resource.data.senderId == request.auth.uid` |

```javascript
const db = testEnv.authenticatedContext('userA').firestore();
await assertFails(
  db.collection('conversations').doc('conv1')
    .collection('messages').doc('msg2').set({
      senderId: 'userB',  // ❌ 伪造
      content: 'Fake message',
    })
);
```

---

### TC-09: 非接收者读取 notification → ❌ 失败

| 项目 | 内容 |
|-----|-----|
| **操作** | 读取 `notifications/notif2` (receiverId = userB) |
| **身份** | userA |
| **期望结果** | ❌ 失败 (PERMISSION_DENIED) |
| **验证规则** | `resource.data.receiverId == request.auth.uid` |

```javascript
const db = testEnv.authenticatedContext('userA').firestore();
await assertFails(db.collection('notifications').doc('notif2').get());
```

---

### TC-10: 接收者读取 notification → ✅ 成功

| 项目 | 内容 |
|-----|-----|
| **操作** | 读取 `notifications/notif1` (receiverId = userA) |
| **身份** | userA |
| **期望结果** | ✅ 成功 |
| **验证规则** | `resource.data.receiverId == request.auth.uid` |

```javascript
const db = testEnv.authenticatedContext('userA').firestore();
await assertSucceeds(db.collection('notifications').doc('notif1').get());
```

---

## 手动验收步骤

如果无法运行自动化测试，可通过 Firebase Emulator UI 手动验证：

### 步骤 1: 启动 Emulator

```bash
firebase emulators:start --only firestore
```

### 步骤 2: 打开 Emulator UI

访问 `http://localhost:4000`

### 步骤 3: 创建测试数据

在 Firestore Emulator 中手动创建上述前置数据。

### 步骤 4: 使用 Rules Playground

1. 在 Emulator UI 中选择 "Firestore"
2. 点击 "Rules Playground"
3. 选择操作类型 (get/create/update/delete)
4. 输入路径和认证信息
5. 验证结果是否符合预期

---

## 测试结果检查清单

| 用例 | 预期 | 实际 | 通过 |
|-----|-----|-----|-----|
| TC-01: 未认证读 events | ❌ 失败 | | ☐ |
| TC-02: 认证读 events | ✅ 成功 | | ☐ |
| TC-03: 读自己 users | ✅ 成功 | | ☐ |
| TC-04: 读他人 users | ❌ 失败 | | ☐ |
| TC-05: 伪造 creatorId | ❌ 失败 | | ☐ |
| TC-06: 非参与者读 conversation | ❌ 失败 | | ☐ |
| TC-07: 参与者读 conversation | ✅ 成功 | | ☐ |
| TC-08: 伪造 senderId | ❌ 失败 | | ☐ |
| TC-09: 非接收者读 notification | ❌ 失败 | | ☐ |
| TC-10: 接收者读 notification | ✅ 成功 | | ☐ |

---

## 常见问题

### Q1: 测试连接不上 Emulator

确保 Emulator 正在运行，且端口正确：

```javascript
testEnv = await initializeTestEnvironment({
  projectId: 'fylo-test',
  firestore: {
    rules,
    host: 'localhost',
    port: 8080,  // 确保与 Emulator 端口一致
  },
});
```

### Q2: 规则未生效

确保 `firestore.rules` 文件路径正确：

```javascript
const rulesPath = resolve(__dirname, '../firestore.rules');
const rules = readFileSync(rulesPath, 'utf8');
```

### Q3: 测试超时

增加测试超时时间：

```bash
npx jest --testTimeout=30000
```

---

## 相关文件

- `firestore.rules` - 安全规则定义
- `test/firestore.rules.test.js` - Node.js 测试脚本
- `test/firestore_rules_test.dart` - Dart 测试结构（需要 fake_cloud_firestore）

---

*生成时间：2025-01-27*
