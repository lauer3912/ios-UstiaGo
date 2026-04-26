# UstiaGo 功能清单

## App 基本信息
- **App Store 名称**: UstiaGo
- **Bundle ID**: com.ggsheng.UstiaGo
- **功能总数**: 65个
- **版本**: 1.0.0

---

## 核心功能（≥60）

| # | 功能名称 | 描述 | 优先级 |
|---|---------|------|--------|
| 1 | Screen Time Dashboard | 今日屏幕使用时间仪表盘 | P0 |
| 2 | Screen Time Ring | 环形进度显示使用时间 | P0 |
| 3 | App Usage List | 各App使用时间列表 | P0 |
| 4 | App Usage Bar Chart | App使用时间条形图 | P0 |
| 5 | Daily Goal | 每日屏幕时间目标 | P0 |
| 6 | Goal Progress | 目标完成进度 | P0 |
| 7 | Streak Counter | 连续达标天数 | P0 |
| 8 | Weekly Summary | 周屏幕时间总结 | P0 |
| 9 | Monthly Report | 月度屏幕时间报告 | P1 |
| 10 | Focus Timer | 专注计时器 | P0 |
| 11 | Custom Focus Duration | 自定义专注时长 | P0 |
| 12 | Focus Modes | 专注模式选择（工作/学习/运动/创作）| P0 |
| 13 | Focus Statistics | 专注统计数据 | P0 |
| 14 | Focus History | 专注历史记录 | P0 |
| 15 | Ambient Sounds | 环境音（海浪/雨声/森林/白噪音）| P0 |
| 16 | Sound Mixer | 环境音混合 | P1 |
| 17 | Wind Down Mode | 睡前放松模式 | P0 |
| 18 | Sleep Reminder | 睡眠提醒 | P0 |
| 19 | Bedtime Schedule | 就寝时间安排 | P0 |
| 20 | Relaxation Exercises | 放松练习（呼吸/冥想）| P1 |
| 21 | App Limits | App使用限制 | P1 |
| 22 | Block App | 临时屏蔽App | P1 |
| 23 | Unlock Schedule | 解锁时间安排 | P1 |
| 24 | Insights Dashboard | 数据洞察仪表盘 | P0 |
| 25 | Weekly Chart | 周使用时间图表 | P0 |
| 26 | Most Used Apps | 最常用App排行 | P0 |
| 27 | Usage Trends | 使用趋势分析 | P0 |
| 28 | Peak Usage Hours | 高峰使用时段 | P1 |
| 29 | Category Breakdown | 按类别分析（社交/娱乐/游戏）| P1 |
| 30 | Compare Weeks | 周对比数据 | P1 |
| 31 | Best Day Highlight | 最佳使用日高亮 | P1 |
| 32 | Daily Notifications | 每日使用报告通知 | P0 |
| 33 | Goal Achieved Alert | 目标达成提醒 | P0 |
| 34 | Screen Time Warning | 使用时间过长警告 | P0 |
| 35 | Focus Reminder | 专注提醒 | P1 |
| 36 | Wind Down Reminder | 放松提醒 | P1 |
| 37 | Dark Mode | 深色模式 | P0 |
| 38 | Light Mode | 浅色模式 | P0 |
| 39 | System Theme | 跟随系统主题 | P0 |
| 40 | Haptic Feedback | 触觉反馈 | P0 |
| 41 | Sound Effects | 音效反馈 | P0 |
| 42 | Widget Today | 今日数据小部件 | P0 |
| 43 | Widget Quick Stats | 快速统计部件 | P1 |
| 44 | Widget Focus Timer | 专注计时部件 | P1 |
| 45 | Widget Wind Down | 放松部件 | P1 |
| 46 | Achievements System | 成就系统 | P1 |
| 47 | First Goal Met | 首次达成目标 | P2 |
| 48 | 7 Day Streak | 连续7天达标 | P2 |
| 49 | 30 Day Streak | 连续30天达标 | P2 |
| 50 | Low Usage Day | 低使用日成就 | P2 |
| 51 | Focus Master | 专注大师成就 | P2 |
| 52 | Export Data | 导出使用数据 | P2 |
| 53 | Privacy Dashboard | 隐私仪表盘 | P1 |
| 54 | App Categories | App分类管理 | P1 |
| 55 | Custom Categories | 自定义分类 | P2 |
| 56 | Usage Forecast | 使用时间预测 | P2 |
| 57 | Smart Suggestions | 智能建议 | P1 |
| 58 | Focus Score | 专注评分 | P1 |
| 59 | Weekly Goals | 周目标设置 | P1 |
| 60 | Monthly Goals | 月目标设置 | P1 |
| 61 | Exclusion Apps | 排除的App列表 | P1 |
| 62 | Child Mode | 儿童模式 | P2 |
| 63 | Family Sharing | 家庭共享 | P2 |
| 64 | Screen Time Lock | 屏幕时间锁定 | P2 |
| 65 | Backup/Restore | 数据备份/恢复 | P2 |

---

## 用户交互

| 交互 | 描述 |
|------|------|
| 点击使用时间 | 查看详细App使用 |
| 长按App | 显示使用选项 |
| 下拉刷新 | 刷新今日数据 |
| 左滑App | 查看使用详情 |
| 点击专注按钮 | 开始专注会话 |
| 点击部件 | 打开对应功能 |

---

## 无障碍功能

| 功能 | 状态 |
|------|------|
| VoiceOver标签 | 所有可交互元素设置accessibilityLabel |
| Dynamic Type | 使用相对字号 |
| 颜色对比度 | ≥7:1 (WCAG AA) |
| 点击区域 | ≥44×44pt |

---

## 离线功能

| 功能 | 状态 |
|------|------|
| 本地数据存储 | UserDefaults |
| 离线状态UI | 正常功能 |
| 启动无网络依赖 | ✅ 完全支持 |