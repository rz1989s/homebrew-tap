# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with this Homebrew tap repository.

## Repository Purpose

This is a **Homebrew tap** repository that hosts formula files for installing tools via Homebrew on macOS. It serves as a distribution channel for packages not in the official Homebrew core.

**Tap URL**: `rz1989s/tap`
**Install**: `brew tap rz1989s/tap`

## Current Formulas

### claude-code-statusline
Enhanced statusline for Claude Code with themes, cost tracking, and prayer times.

**Main Repository**: https://github.com/rz1989s/claude-code-statusline
**Formula**: `Formula/claude-code-statusline.rb`

```bash
# Install
brew install rz1989s/tap/claude-code-statusline

# Or tap first
brew tap rz1989s/tap
brew install claude-code-statusline
```

**Note**: The curl installer in the main repo is recommended for full automatic setup. Homebrew install requires manual `settings.json` configuration.

## Repository Structure

```
homebrew-tap/
├── Formula/                    # Homebrew formula files
│   └── claude-code-statusline.rb
├── README.md                   # User-facing documentation
└── CLAUDE.md                   # This file (AI assistant guidance)
```

## Formula Maintenance

### Updating a Formula Version

When a new version is released in the main repo:

1. **Create new release tag** in main repo (e.g., `v2.12.0`)
2. **Calculate SHA256** of the release tarball:
   ```bash
   curl -sL https://github.com/rz1989s/claude-code-statusline/archive/refs/tags/v2.12.0.tar.gz | shasum -a 256
   ```
3. **Update formula**:
   - Update `url` with new tag
   - Update `sha256` with new checksum
4. **Test locally**:
   ```bash
   brew install --build-from-source ./Formula/claude-code-statusline.rb
   ```
5. **Commit and push** to this repo

### Formula Template

```ruby
class ClaudeCodeStatusline < Formula
  desc "Enhanced statusline for Claude Code with themes, cost tracking, and prayer times"
  homepage "https://github.com/rz1989s/claude-code-statusline"
  url "https://github.com/rz1989s/claude-code-statusline/archive/refs/tags/vX.Y.Z.tar.gz"
  sha256 "CHECKSUM_HERE"
  license "MIT"
  head "https://github.com/rz1989s/claude-code-statusline.git", branch: "main"

  depends_on "jq"
  depends_on "coreutils" if OS.mac?

  def install
    libexec.install Dir["*"]
    (bin/"claude-statusline").write <<~EOS
      #!/bin/bash
      exec "#{libexec}/statusline.sh" "$@"
    EOS
    (share/"claude-code-statusline").install "Config.toml"
  end

  def post_install
    # Setup user config directory
  end

  def caveats
    # Post-install instructions
  end

  test do
    assert_match "Claude Code Enhanced Statusline", shell_output("#{bin}/claude-statusline --help 2>&1", 0)
  end
end
```

## Adding New Formulas

To add a new tool to this tap:

1. Create `Formula/tool-name.rb` following Homebrew conventions
2. Test with `brew install --build-from-source ./Formula/tool-name.rb`
3. Update README.md with installation instructions
4. Update this CLAUDE.md with formula details

## Related Resources

- **Homebrew Formula Cookbook**: https://docs.brew.sh/Formula-Cookbook
- **Main Project**: https://github.com/rz1989s/claude-code-statusline
- **Main Project CLAUDE.md**: See installation comparison table for curl vs Homebrew

## Commands Reference

```bash
# Tap management
brew tap rz1989s/tap              # Add this tap
brew untap rz1989s/tap            # Remove this tap
brew tap-info rz1989s/tap         # Show tap info

# Formula operations
brew install claude-code-statusline
brew upgrade claude-code-statusline
brew uninstall claude-code-statusline
brew info claude-code-statusline

# Development
brew install --build-from-source ./Formula/claude-code-statusline.rb
brew audit --strict ./Formula/claude-code-statusline.rb
```
