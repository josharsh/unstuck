# Unstuck

A Claude Code skill that catches fix-break loops before they burn your tokens and patience.

## Install

**Via Claude Code plugin system (recommended):**
```
/plugin marketplace add https://github.com/josharsh/unstuck
```

**Via install script:**
```bash
git clone https://github.com/josharsh/unstuck.git
cd unstuck
./install.sh
```

**Manual:** Copy `skills/unstuck/SKILL.md` to `~/.claude/skills/unstuck/`.

## How It Works

Unstuck monitors Claude's behavior during a session and fires when it detects a loop:

- **Same-file edits** -- edited the same file 3+ times for the same task
- **Repeated errors** -- the same error message appears twice
- **Reverted changes** -- Claude undoes something it just did
- **Same approach twice** -- about to try something that already failed
- **Escalating changes** -- each fix touches more files than the last

When a trigger fires, Claude stops editing and outputs a structured diagnosis: what it tried, why it keeps failing, and a genuinely different approach. It only resumes after you respond.

If loops persist (4th trigger), Claude escalates with three options: you debug manually, simplify the approach, or skip it for now.

## Demo

```
You: The token refresh still returns 401 after three edits to auth.ts.

Claude: **Loop detected.** I've edited auth.ts 3 times and the test still fails.
Stopping to diagnose.

## Diagnosis

**What I was trying to do:**
Fix the 401 on token refresh in the login flow.

**What I tried:**
1. Wrapped refresh call in try-catch → Still 401
2. Changed Authorization header format → Still 401
3. Added token expiry check before refresh → Still 401

**Why it keeps failing:**
The refresh token itself is expired. Every fix assumes the token is valid
but the test fixture has a hardcoded token from 2024.

**What I should do differently:**
Read the test fixture to check the token value, instead of editing
the production code again.

Want me to try this different approach, or do you want to steer?
```

In practice, Unstuck tracks these patterns automatically. You don't need to describe the loop yourself.

## Commands

| Command | What it does |
|---------|-------------|
| `/unstuck` | Activate loop detection for the session |
| `/unstuck reset` | Clear loop tracking state and start fresh |

## Why This Exists

The "death spiral" is the most common failure mode in agentic coding sessions. Fix one thing, break two more, retry the same failed approach. It wastes tokens, wastes time, and produces worse code with every iteration.

Unstuck adds a circuit breaker. When it detects a loop, it forces a structured diagnosis before allowing any more edits. The diagnosis must name a genuinely different approach, not another variation of what already failed.

## Testing

Tests are defined in `tests.json` and compatible with [skillmother](https://github.com/josharsh/skillmother):

```bash
skillmother test ~/Development/unstuck/
```

## Uninstalling

```bash
rm -rf ~/.claude/skills/unstuck
```

Or remove via the plugin marketplace:

```
/plugin marketplace remove unstuck
```
