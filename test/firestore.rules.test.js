/**
 * Firestore Rules 验收测试
 * 
 * 运行方式：
 * 1. npm install @firebase/rules-unit-testing
 * 2. firebase emulators:start --only firestore
 * 3. npm test 或 npx jest test/firestore.rules.test.js
 * 
 * 或使用 mocha：
 * npx mocha test/firestore.rules.test.js --timeout 10000
 */

const {
  initializeTestEnvironment,
  assertFails,
  assertSucceeds,
} = require('@firebase/rules-unit-testing');
const { readFileSync } = require('fs');
const { resolve } = require('path');

// 读取规则文件
const rulesPath = resolve(__dirname, '../firestore.rules');
const rules = readFileSync(rulesPath, 'utf8');

// 测试环境
let testEnv;

// 测试用户 ID
const USER_A = 'userA';
const USER_B = 'userB';
const USER_C = 'userC';

/**
 * ============================================
 * 前置数据设置
 * ============================================
 */
async function setupTestData(adminDb) {
  // 用户文档
  await adminDb.collection('users').doc(USER_A).set({
    id: USER_A,
    name: 'User A',
    username: 'user_a',
    avatar: 'https://example.com/a.jpg',
    isOnline: true,
  });
  
  await adminDb.collection('users').doc(USER_B).set({
    id: USER_B,
    name: 'User B',
    username: 'user_b',
    avatar: 'https://example.com/b.jpg',
    isOnline: false,
  });
  
  // 事件文档
  await adminDb.collection('events').doc('event1').set({
    id: 1,
    title: 'Test Event',
    creatorId: USER_A,
    participantIds: [USER_A, USER_B],
    date: '2025-01-28',
  });
  
  // 帖子文档
  await adminDb.collection('posts').doc('post1').set({
    id: 1,
    title: 'Test Post',
    userId: USER_A,
    content: 'Hello World',
  });
  
  // 通知文档
  await adminDb.collection('notifications').doc('notif1').set({
    id: 1,
    receiverId: USER_A,
    title: 'New Message',
    message: 'You have a new message',
    isRead: false,
  });
  
  await adminDb.collection('notifications').doc('notif2').set({
    id: 2,
    receiverId: USER_B,
    title: 'New Follower',
    message: 'Someone followed you',
    isRead: false,
  });
  
  // 会话文档
  await adminDb.collection('conversations').doc('conv1').set({
    id: 'conv1',
    type: 'direct',
    participantIds: [USER_A, USER_B],
    name: 'Chat between A and B',
    isActive: true,
  });
  
  // 消息文档
  await adminDb.collection('conversations').doc('conv1')
    .collection('messages').doc('msg1').set({
      id: 'msg1',
      senderId: USER_A,
      content: 'Hello!',
      timestamp: new Date().toISOString(),
    });
}

/**
 * ============================================
 * 测试套件
 * ============================================
 */
describe('Firestore Security Rules', () => {
  
  beforeAll(async () => {
    testEnv = await initializeTestEnvironment({
      projectId: 'fylo-test',
      firestore: {
        rules,
        host: 'localhost',
        port: 8080,
      },
    });
  });
  
  beforeEach(async () => {
    await testEnv.clearFirestore();
    // 使用 admin 权限设置测试数据
    await testEnv.withSecurityRulesDisabled(async (context) => {
      const adminDb = context.firestore();
      await setupTestData(adminDb);
    });
  });
  
  afterAll(async () => {
    await testEnv.cleanup();
  });
  
  // ============================================
  // 用例 1: 未认证用户读取 events → 失败
  // ============================================
  test('TC-01: Unauthenticated user CANNOT read events', async () => {
    const db = testEnv.unauthenticatedContext().firestore();
    
    await assertFails(
      db.collection('events').doc('event1').get()
    );
  });
  
  // ============================================
  // 用例 2: 认证用户读取 events → 成功
  // ============================================
  test('TC-02: Authenticated user CAN read events', async () => {
    const db = testEnv.authenticatedContext(USER_A).firestore();
    
    await assertSucceeds(
      db.collection('events').doc('event1').get()
    );
  });
  
  // ============================================
  // 用例 3: 用户读取自己的 users 文档 → 成功
  // ============================================
  test('TC-03: User CAN read own profile', async () => {
    const db = testEnv.authenticatedContext(USER_A).firestore();
    
    await assertSucceeds(
      db.collection('users').doc(USER_A).get()
    );
  });
  
  // ============================================
  // 用例 4: 用户读取他人的 users 文档 → 失败
  // ============================================
  test('TC-04: User CANNOT read other user profile', async () => {
    const db = testEnv.authenticatedContext(USER_A).firestore();
    
    await assertFails(
      db.collection('users').doc(USER_B).get()
    );
  });
  
  // ============================================
  // 用例 5: 创建 event 时伪造 creatorId → 失败
  // ============================================
  test('TC-05: CANNOT create event with fake creatorId', async () => {
    const db = testEnv.authenticatedContext(USER_A).firestore();
    
    await assertFails(
      db.collection('events').doc('event2').set({
        id: 2,
        title: 'Fake Event',
        creatorId: USER_B,  // ❌ 伪造为 USER_B
        participantIds: [USER_B],
        date: '2025-02-01',
      })
    );
  });
  
  // ============================================
  // 用例 5b: 创建 event 时 creatorId 正确 → 成功
  // ============================================
  test('TC-05b: CAN create event with correct creatorId', async () => {
    const db = testEnv.authenticatedContext(USER_A).firestore();
    
    await assertSucceeds(
      db.collection('events').doc('event2').set({
        id: 2,
        title: 'My Event',
        creatorId: USER_A,  // ✅ 正确的 creatorId
        participantIds: [USER_A],
        date: '2025-02-01',
      })
    );
  });
  
  // ============================================
  // 用例 6: 非参与者读取 conversation → 失败
  // ============================================
  test('TC-06: Non-participant CANNOT read conversation', async () => {
    const db = testEnv.authenticatedContext(USER_C).firestore();
    
    await assertFails(
      db.collection('conversations').doc('conv1').get()
    );
  });
  
  // ============================================
  // 用例 7: 参与者读取 conversation → 成功
  // ============================================
  test('TC-07: Participant CAN read conversation', async () => {
    const db = testEnv.authenticatedContext(USER_A).firestore();
    
    await assertSucceeds(
      db.collection('conversations').doc('conv1').get()
    );
  });
  
  // ============================================
  // 用例 8: 发送消息时伪造 senderId → 失败
  // ============================================
  test('TC-08: CANNOT send message with fake senderId', async () => {
    const db = testEnv.authenticatedContext(USER_A).firestore();
    
    await assertFails(
      db.collection('conversations').doc('conv1')
        .collection('messages').doc('msg2').set({
          id: 'msg2',
          senderId: USER_B,  // ❌ 伪造为 USER_B
          content: 'Fake message',
          timestamp: new Date().toISOString(),
        })
    );
  });
  
  // ============================================
  // 用例 8b: 发送消息时 senderId 正确 → 成功
  // ============================================
  test('TC-08b: CAN send message with correct senderId', async () => {
    const db = testEnv.authenticatedContext(USER_A).firestore();
    
    await assertSucceeds(
      db.collection('conversations').doc('conv1')
        .collection('messages').doc('msg2').set({
          id: 'msg2',
          senderId: USER_A,  // ✅ 正确的 senderId
          content: 'Real message',
          timestamp: new Date().toISOString(),
        })
    );
  });
  
  // ============================================
  // 用例 9: 非接收者读取 notification → 失败
  // ============================================
  test('TC-09: Non-receiver CANNOT read notification', async () => {
    const db = testEnv.authenticatedContext(USER_A).firestore();
    
    // notif2 的 receiverId 是 USER_B
    await assertFails(
      db.collection('notifications').doc('notif2').get()
    );
  });
  
  // ============================================
  // 用例 10: 接收者读取 notification → 成功
  // ============================================
  test('TC-10: Receiver CAN read own notification', async () => {
    const db = testEnv.authenticatedContext(USER_A).firestore();
    
    // notif1 的 receiverId 是 USER_A
    await assertSucceeds(
      db.collection('notifications').doc('notif1').get()
    );
  });
  
  // ============================================
  // 额外用例: 非参与者无法读取消息
  // ============================================
  test('TC-11: Non-participant CANNOT read messages', async () => {
    const db = testEnv.authenticatedContext(USER_C).firestore();
    
    await assertFails(
      db.collection('conversations').doc('conv1')
        .collection('messages').doc('msg1').get()
    );
  });
  
  // ============================================
  // 额外用例: 非创建者无法删除 event
  // ============================================
  test('TC-12: Non-creator CANNOT delete event', async () => {
    const db = testEnv.authenticatedContext(USER_B).firestore();
    
    // event1 的 creatorId 是 USER_A
    await assertFails(
      db.collection('events').doc('event1').delete()
    );
  });
  
  // ============================================
  // 额外用例: 创建 conversation 时自己必须在参与者中
  // ============================================
  test('TC-13: CANNOT create conversation without self in participants', async () => {
    const db = testEnv.authenticatedContext(USER_A).firestore();
    
    await assertFails(
      db.collection('conversations').doc('conv2').set({
        id: 'conv2',
        type: 'direct',
        participantIds: [USER_B, USER_C],  // ❌ USER_A 不在列表中
        name: 'Chat without creator',
        isActive: true,
      })
    );
  });
});
