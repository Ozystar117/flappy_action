---
name: prepare-pr
description: Runs the local checks, then drafts commit messages and a pull request description for Flappy Action changes. Use when the user invokes /prepare-pr or explicitly asks to prepare a PR, pull request, or commit message.
disable-model-invocation: true
---

# Prepare PR

## When to use

- Explicit `/prepare-pr`, or a request for a PR description or commit message

## When not to use

- Mid-feature implementation

## Instructions

1. **Run checks** from the repo root and report results:
   - `dart format --output=none --set-exit-if-changed lib test`
   - `flutter analyze`
   - `flutter test`
   If anything fails, stop and report before drafting.
2. **Inspect git** — `git status`, `git diff` (staged and unstaged), and `git log main..HEAD`. Do not invent changes.
3. **Check for mixed concerns** — If the diff mixes feature work with Flutter platform migrations (`ios/`, `android/`, `analysis_options.yaml`) or unrelated changes, recommend separate commits.
4. **Draft commit message(s)** — Short imperative subject in the existing style (e.g. "Implemented pause menu", "Centralize game state transitions in FlappyActionGame").
5. **Draft the PR** in copy-pasteable markdown:

```markdown
## Summary
- …

## Test plan
- [ ] flutter analyze
- [ ] flutter test
- [ ] Simulator: …

## Notes
- …
```

6. **Commit / push / create PR** — Only if the human explicitly asks. Otherwise stop after the draft.

## Failure behaviour

- Do not hide unrelated changes in the summary; call them out.
