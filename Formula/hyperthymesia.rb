class Hyperthymesia < Formula
  desc "Local-first, privacy-focused AI search and code assistant"
  homepage "https://github.com/johntharian/hyperthymesia"
  url "https://github.com/johntharian/hyperthymesia/archive/refs/heads/main.zip"
  version "1.0.0"
  sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"  # Update with actual SHA256

  depends_on "ollama"
  depends_on "python@3.11"

  def install
    # Create symbolic links for dependencies
    python = Formula["python@3.11"].opt_bin/"python3"

    # Navigate to the CLI directory
    cd "hyperthymesia_cli"

    # Install the package in development mode
    system python, "-m", "pip", "install", "--prefix=#{prefix}", "."
  end

  def post_install
    # Start Ollama service if not running
    puts "Setting up Ollama service..."
    system "brew", "services", "start", "ollama"

    # Wait for Ollama to be ready
    puts "Waiting for Ollama to start..."
    sleep 3

    # Check if Ollama is running
    if system("curl", "-s", "http://localhost:11434/api/tags", out: File::NULL)
      puts "✓ Ollama is running"
    else
      puts "⚠ Could not verify Ollama is running"
      puts "Try: brew services restart ollama"
    end

    # Pull the default model
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

  test do
    # Test that Python imports work
    python = Formula["python@3.11"].opt_bin/"python3"
    system python, "-c", "from core.local_llm import LocalLLM; print('OK')"
  end
end
