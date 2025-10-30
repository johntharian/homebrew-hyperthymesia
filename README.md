# Hyperthymesia Homebrew Tap

Official Homebrew tap for Hyperthymesia - a local-first, privacy-focused AI search and code assistant.

## Installation

```bash
brew tap johntharian/homebrew-hyperthymesia
brew install hyperthymesia
```

That's it! Homebrew will:
- ✓ Install Ollama
- ✓ Install Python 3.11
- ✓ Install Hyperthymesia and dependencies
- ✓ Start Ollama service
- ✓ Download the llama3.2:3b model

## Quick Start

After installation:

```bash
# Index your code
hyperthymesia index add /path/to/your/code

# Ask a question
hyperthymesia agent "how does authentication work?"

# See reasoning
hyperthymesia agent "your question" --verbose
```

## Updating

```bash
brew upgrade hyperthymesia
```

## Uninstalling

```bash
brew uninstall hyperthymesia
```

## Troubleshooting

### Ollama issues
```bash
# Check if running
brew services list | grep ollama

# Restart
brew services restart ollama
```

### Need help?
See the main repository: https://github.com/johntharian/hyperthymesia

## Development

To test the formula locally:

```bash
brew install --build-from-source ./Formula/hyperthymesia.rb
```

To update the SHA256:

```bash
brew install hyperthymesia --verbose
```
