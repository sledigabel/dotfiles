---
name: gh-release
description: Publish draft GitHub release or create new release from commits
license: MIT
compatibility: opencode
metadata:
  audience: maintainers
  workflow: github
---

## What I do

- Check for draft releases and enhance/publish them
- Create new releases from commits since last release
- Generate changelogs using conventional commits
- Handle version bumping (major, minor, patch)
- Synchronize git tags with releases
- **Create releases even when there are zero commits since last release**

## When to use me

Use this skill when you want to:
- Publish a draft release that was created by release-drafter
- Create a new release from recent commits
- Create a release for administrative purposes (even with no new commits)

## Guardrails

- NEVER modify or delete published releases - only drafts or create new
- ALWAYS verify the latest release exists before calculating next version
- Preserve existing release-drafter content when enhancing drafts
- Ask for confirmation ONLY when >5 commits since last release OR breaking changes detected
- Handle missing commits gracefully by auto-adding to appropriate changelog sections
- **Allow release creation even when there are zero commits since last release**
- Create git tags automatically when publishing to keep tags in sync with releases
- Detect breaking changes (!) in commits and suggest major version bump

## Steps

### 1. Discovery Phase

- Check for draft releases: `gh release list --exclude-drafts=false --json tagName,isDraft`
- Identify latest published release: `gh release list --limit 1 --json tagName,publishedAt`
- Verify git tag exists for latest release: `git tag -l <tag>`
- Fetch all commits since last release: `git log <tag>..HEAD --pretty=format:"%h|%s|%an"`

### 2. Analysis Phase

- Parse commits using conventional commit regex: `^(feat|fix|docs|chore|refactor|improve|test)(!)?(\(.+?\))?:\s*(.+)$`
- Detect breaking changes (commits with `!` after type, e.g., `feat!:`, `fix!:`)
- Categorize commits by type for emoji-prefixed sections
- Count total commits and identify if confirmation needed (>5)
- Extract unique contributors from commit authors
- **Handle zero commits:** If no commits since last release, still proceed with release creation

### 3. Decision Logic

**If draft exists:**
- Read draft: `gh release view <tag> --json body,tagName`
- Compare draft changelog with actual git commits to find missing commits
- Enhance changelog by adding missing commits to appropriate sections
- Update draft: `gh release edit <tag> --notes "<enhanced-changelog>"`
- Ask confirmation if >5 total commits: "Publish <tag> with X commits? (y/n)"
- Publish: `gh release edit <tag> --draft=false`
- Create git tag if missing: `git tag <tag> && git push origin <tag>`

**If no draft:**
- Analyze for breaking changes
- Calculate next version:
  - Parse user input for explicit version (e.g., `v1.0.0`) or bump type (`major`, `minor`, `patch`)
  - If breaking changes detected → suggest major bump and ask user
  - Default → patch bump
- Generate complete changelog from all commits (or minimal changelog if zero commits)
- Format using release-drafter style with emoji categories
- **If zero commits:** Use simplified changelog: "No changes since last release"
- Ask confirmation if >5 commits or breaking changes
- Create release: `gh release create <tag> --title "v<version>" --notes "<changelog>" --latest --target main`
- Verify tag was created: `git fetch --tags && git tag -l <tag>`

### 4. Changelog Generation

Use this format structure:

```
## What's Changed

### 🚀 Features
- feat(scope): description @author
- feat(api)!: breaking change @author ⚠️ BREAKING CHANGE

### 🐛 Bug Fixes
- fix(scope): description @author

### 📝 Documentation
- docs(scope): description @author

### 🔧 Maintenance
- chore(scope): description @author
- refactor(scope): description @author

## New Commits
- `abc1234` full commit message
- `def5678` full commit message

## Contributors
@author1, @author2
```

**Zero commits case:** Use simplified format:

```
## What's Changed

No changes since last release.
```

Category mapping:
- `feat` → 🚀 Features
- `fix` → 🐛 Bug Fixes
- `docs` → 📝 Documentation
- `chore`, `refactor`, `improve`, `test` → 🔧 Maintenance

Additional rules:
- Mark breaking changes with ⚠️ emoji and "BREAKING CHANGE" label
- Include PR numbers if present in commit message: `(#123)`
- Sort commits within each category by commit order

### 5. Version Calculation

- Parse current version from latest release tag (e.g., `v0.9.5` → major:0, minor:9, patch:5)
- Handle user input priority:
  1. Explicit version: `v1.0.0` → use v1.0.0
  2. Bump type: `major` → calculate bump
  3. Breaking changes detected → suggest major bump (ask user)
  4. Default → patch bump
- Bump logic:
  - `patch`: v0.9.5 → v0.9.6
  - `minor`: v0.9.5 → v0.10.0
  - `major`: v0.9.5 → v1.0.0
- Validate version doesn't already exist: `gh release view <tag>` should error

### 6. Git Tag Synchronization

- When publishing draft: Check `git tag -l <tag>`
  - If missing: `git tag <tag> && git push origin <tag>`
  - If exists: Skip
- When creating new release: `gh release create` auto-creates tag
  - Verify: `git fetch --tags && git tag -l <tag>`
- Handle errors gracefully (e.g., tag push failures due to permissions)

### 7. Verification

- Confirm release published: `gh release view <tag> --json isDraft,publishedAt`
- Confirm git tag exists: `git tag -l <tag>`
- Display success message with release URL
- Remind user that deployment workflow will trigger automatically

## Reference

- Release-drafter config: `.github/release-drafter.yml`
- Release-drafter workflow: `.github/workflows/release-drafter.yml`
- Deployment workflow: `.github/workflows/release-image.yml` (triggers on release publish)
- Conventional commit types: feat, fix, docs, chore, refactor, improve, test
- Breaking change syntax: `feat!:`, `fix!:`, etc. (exclamation after type)
- Changelog categories: 🚀 Features, 🐛 Bug Fixes, 📝 Documentation, 🔧 Maintenance
- Version format: `vMAJOR.MINOR.PATCH` (e.g., v0.9.6)
- Entry format: `- <type>(<scope>): <description> @<author>`
