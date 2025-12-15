class ClaudeCodeStatusline < Formula
  desc "Enhanced statusline for Claude Code with themes, cost tracking, and prayer times"
  homepage "https://github.com/rz1989s/claude-code-statusline"
  url "https://github.com/rz1989s/claude-code-statusline/archive/refs/tags/v2.11.6.tar.gz"
  sha256 "a18b768af22cf13f0192dfec9a0183a90c8fcbba0330f647a301a7dab9468a77"
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
    config_dir = Pathname.new(Dir.home)/".claude/statusline"
    config_dir.mkpath unless config_dir.exist?
    user_config = config_dir/"Config.toml"
    unless user_config.exist?
      cp share/"claude-code-statusline/Config.toml", user_config
      ohai "Created default config at #{user_config}"
    end
  end

  def caveats
    <<~EOS
      To complete setup, run the full installer:
        curl -sSfL https://raw.githubusercontent.com/rz1989s/claude-code-statusline/main/install.sh | bash

      Or manually add to Claude Code settings.json:
        "env": { "CLAUDE_CODE_STATUSLINE": "~/.claude/statusline/statusline.sh" }

      Config: ~/.claude/statusline/Config.toml
      Docs: https://github.com/rz1989s/claude-code-statusline
    EOS
  end

  test do
    assert_match "Claude Code Enhanced Statusline", shell_output("#{bin}/claude-statusline --help 2>&1", 0)
  end
end
