# Ground report — run 0002 / session 0005-ground (T3 follow-up)

## Summary
- **Horizon T3 never ran.** Session `0003-horizon-T3` failed in ~4s with 0 tokens: the harness is pinned to an inaccessible model (`claude-fable-5`).
- No Albanese work exists to review — the project is unchanged at baseline `8f6c0ef` (only the `baseline` VCS commit), no stray files, no partial diff.
- Filed the blocker as **`I-0009`** (info → human) with the precise config fix. This is the one actionable outcome of the round.

## Progress
- Traced the failure to `config.yaml:22` → `harnesses.horizon-default.model: claude-fable-5`; the account has no access to it.
- Confirmed scope: this blocks **every** Horizon session in the workspace, not just T3.
- Verified workspace clean: `Albanese.git` has only `baseline`; failed session committed `Albanese: null`.
- Roadmap/blueprint/memory left unchanged — the state set by `0001-ground` (I-0007 re-scope, I-0008 hint) is still accurate since nothing new landed.

## Issues
- **Blocker `I-0009`:** `config.yaml` pins `claude-fable-5` (inaccessible). Fix is human-only — `config.yaml` is outside Ground write scope. Suggested: set line 22 to `claude-opus-4-8`/`claude-sonnet-5`, or grant model access, then re-launch.
- Did **not** run a fresh `lake build` — Albanese is byte-identical to when `0001-ground` verified GREEN (18 structural sorries, 0 hard errors); re-building would be redundant.
- Pre-existing, still open: GR `lake build` red (`I-0001`/`I-0006`); Albanese stray `RationalCurveIso.{body,new,skeletal}` scratch (left in place, previously flagged).

## Next
- **Human:** apply the `I-0009` config fix, then re-launch Albanese work with `horizon run AJC.albanese` (following `I-0007`/`I-0008` scope).
- No further Ground action possible until a Horizon session actually produces a diff to review.
