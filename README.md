# unstuck

A Claude Code skill that catches fix-break loops before they burn your tokens.

## Install

In Claude Code, run:

```
/plugin marketplace add josharsh/unstuck
```

Or manually:

```bash
mkdir -p ~/.claude/skills/unstuck
curl -sL https://raw.githubusercontent.com/josharsh/unstuck/main/skills/unstuck/SKILL.md \
  -o ~/.claude/skills/unstuck/SKILL.md
```

## Why I Built This

Claude's most expensive failure mode is the one that looks like progress. It edits a file, the test fails, it edits again, fails differently, edits a third time -- each attempt a slight variation of the same broken approach. You burn tokens and time while the actual bug is somewhere it never thought to look.

`/unstuck` adds a circuit breaker. When it detects a loop, Claude has to stop editing and write a structured diagnosis before touching any more code.

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

## Triggers

- **Same-file edits** -- edited the same file 3+ times for the same task
- **Repeated errors** -- same error message appears twice
- **Reverted changes** -- undoes something it just did
- **Same approach twice** -- about to retry something that already failed
- **Escalating changes** -- each fix touches more files than the last

If it hits a 4th trigger, it escalates: "I've been going in circles. Here are three options..."

## Commands

| Command | What it does |
|---------|-------------|
| `/unstuck` | Activate loop detection |
| `/unstuck reset` | Clear tracking state |

## Testing

Tested with [skillmother](https://github.com/josharsh/skillmother):

```bash
skillmother test skills/unstuck/
```

## Uninstalling

```bash
rm -rf ~/.claude/skills/unstuck
```
