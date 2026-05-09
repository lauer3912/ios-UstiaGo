# TestFlight 上传配置指南

## 📁 证书文件（已保存到项目目录）

```
ios/certs/
├── certificate.p12          ← 证书（需要转成 base64 上传到 GitHub Secrets）
├── profile.mobileprovision  ← Provisioning Profile（需要转成 base64 上传到 GitHub Secrets）
└── .gitignore               ← 防止误提交敏感文件
```

**注意：这些证书文件不应该提交到 Git 仓库（已通过 .gitignore 排除）**

---

## 🔐 你需要在 GitHub 添加的 Secrets

**步骤：**
1. 打开 https://github.com/lauer3912/ios-UstiaGo/settings/secrets/actions
2. 点 **New repository secret**，按下方表格添加

| Secret 名称 | 值 | 说明 |
|-----------|---|------|
| `CERTIFICATE_P12` | （见下方生成结果） | 证书 base64 |
| `PROVISIONING_PROFILE` | （见下方生成结果） | Profile base64 |
| `CERTIFICATE_PASSWORD` | `hapsion1985` | 导出 p12 时设置的密码 |
| `KEYCHAIN_PASSWORD` | 随机字符串，如 `abcd1234` | 临时钥匙串密码，自己定 |
| `APP_STORE_CONNECT_USERNAME` | 你的 Apple ID 邮箱 | 用于上传认证 |
| `APP_STORE_CONNECT_PASSWORD` | 你的 Apple ID 密码或 App 专用密码 | 建议用 App 专用密码 |

**App 专用密码获取：**
https://appleid.apple.com → 安全 → App 专用密码 → 生成一个

---

## 📊 GitHub Actions 触发方式

配置完成后，你去 GitHub 仓库页面：
- **Actions** 标签 → 选择 **TestFlight Upload** → 点 **Run workflow**

---

## ⚠️ 注意事项

- `CERTIFICATE_P12` 和 `PROVISIONING_PROFILE` 的 base64 内容从 `/tmp/ustiago-repo/ios/certs/` 里的原文件计算
- 直接在 GitHub 网页粘贴 base64 内容（超长，但必须完整）
- `CERTIFICATE_PASSWORD` 是你导出 p12 时设置的密码，从文件名看应该是 `hapsion1985`

---

## 📝 快速复制 base64 内容（可选方法）

如果你发现 GitHub 网页粘贴 base64 太长，可以改用 GitHub Actions 的 GITHUB_TOKEN + 加密文件方式，或者用 `Apple-GitHub-Actions/setup-keychain` 直接传文件路径（需要先上传 artifact）。

需要我改成"先上传 certs 文件到 GitHub Releases，再用 Actions 下载"的方式吗？会更简单。
