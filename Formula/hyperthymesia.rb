class Hyperthymesia < Formula
  desc "Local-first, privacy-focused AI search and code assistant"
  homepage "https://github.com/johntharian/hyperthymesia"
  url "https://github.com/johntharian/hyperthymesia/archive/refs/heads/main.zip"
  version "1.0.0"
  sha256 "6dffb3e72515d6d8eb9f730dab414398e8d916ef43539a57f173e98ed246f993"

  depends_on "ollama"
  depends_on "python@3.11"

  def install
    python = Formula["python@3.11"].opt_bin/"python3"

    # Install package from root
    system python, "-m", "pip", "install", "--prefix=#{prefix}", "."
  end

  def post_install
    puts "Setting up Ollama service..."
    system "brew", "services", "start", "ollama"
    puts "Waiting for Ollama to start..."
    sleep 3

    if system("curl", "-s", "http://localhost:11434/api/tags", out: File::NULL)
      puts "✓ Ollama is running"
    else
      puts "⚠ Could not verify Ollama is running"
      puts "Try: brew services restart ollama"
    end

    puts "Downloading llama3.2:3b model (this may take a few minutes)..."
    system "ollama", "pull", "llama3.2:3b"

    puts ""
    puts "✓ Installation complete!"
    puts ""
    puts "Quick start:"
    puts "  1. Index your code:  hyperthymesia index add /path/to/code"
    puts "  2. Ask a question:   hyperthymesia agent \"how does X work?\""
    puts ""
  end

  # test do
  #   python = Formula["python@3.11"].opt_bin/"python3"
  #   system python, "-c", "import core.local_llm; print('OK')"
  # end
end
