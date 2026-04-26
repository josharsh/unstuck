# unstuck

A Claude Code skill that catches fix-break loops before they burn your tokens and patience.

## Install

**Via plugin marketplace:**

```sh
claude plugin add josharsh/unstuck
```

**Manual:**

```sh
git clone https://github.com/josharsh/unstuck.git
cd unstuck
bash install.sh
```

This copies the skill to `~/.claude/skills/unstuck/`.

## Demo

You are debugging a login flow. Claude edits `auth.ts`, the test fails, it edits again, the test fails differently, it edits a third time...

```
You: The token refresh still returns 401 after three edits to auth.ts.

Claude: **Loop detected.** I've edited auth.ts 3 times and the test still fails. Stopping to diagnose.

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

## Why This Exists

The "death spiral" is the most common failure mode in agentic coding sessions -- fix one thing, break two more, retry the same failed approach. It wastes tokens, wastes time, and produces worse code with every iteration.

Unstuck adds a circuit breaker. It tracks edit patterns, error recurrence, and reverted changes. When it detects a loop, it forces a structured diagnosis before allowing any more edits. The diagnosis must name a genuinely different approach -- not another variation of what already failed.

## Commands

| Command | What it does |
|---------|-------------|
| `/unstuck` | Activate loop detection for the session |
| `/unstuck reset` | Clear loop tracking state and start fresh |

## Uninstalling

Remove the skill directory:

```sh
rm -rf ~/.claude/skills/unstuck
```

If installed as a plugin:

```sh
claude plugin remove josharsh/unstuck
```
