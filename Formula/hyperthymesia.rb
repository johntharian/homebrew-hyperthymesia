class Hyperthymesia < Formula
  desc "Local-first, privacy-focused AI search and code assistant"
  homepage "https://github.com/johntharian/hyperthymesia"
  url "https://github.com/johntharian/hyperthymesia/archive/refs/heads/main.zip"
  version "1.0.0"
  sha256 "6dffb3e72515d6d8eb9f730dab414398e8d916ef43539a57f173e98ed246f993"

  depends_on "ollama"
  depends_on "python@3.11"

  # This prevents Homebrew from expecting bottles or needing Xcode
  pour_bottle? { false }

  def install
    python = Formula["python@3.11"].opt_bin/"python3"

    cd "hyperthymesia_cli" do
      # Install into Homebrew’s libexec directory (standard for Python apps)
      system python, "-m", "pip", "install", "--upgrade", "pip"
      system python, "-m", "pip", "install", "--no-deps", "--prefix=#{libexec}", "."

      # Symlink the CLI into bin/
      bin.install Dir["#{libexec}/bin/*"]
      bin.env_script_all_files(libexec/"bin", PYTHONPATH: "#{libexec}/lib/python3.11/site-packages")
    end
  end

  def post_install
    ohai "Setting up Ollama service..."
    system "brew", "services", "start", "ollama"

    puts "Waiting for Ollama to start..."
    sleep 3

    if system("curl", "-s", "http://localhost:11434/api/tags", out: File::NULL)
      ohai "Ollama is running"
    else
      opoo "Could not verify Ollama is running"
      puts "Try: brew services restart ollama"
    end

    ohai "Downloading llama3.2:3b model..."
    system "ollama", "pull", "llama3.2:3b"

    puts ""
    puts "Installation complete!"
    puts ""
    puts "Quick start:"
    puts "  1. Index code:  hyperthymesia index add /path/to/code"
    puts "  2. Ask:         hyperthymesia agent \"how does X work?\""
  end

  test do
    python = Formula["python@3.11"].opt_bin/"python3"
    system python, "-c", "from core.local_llm import LocalLLM; print('OK')"
  end
end
