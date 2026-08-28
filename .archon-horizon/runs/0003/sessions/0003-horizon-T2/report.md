## Summary

- Task **T2 / `AJC.fbc`** (flat base change, Stacks 02KH): attacked the frontier node `IsIso bareBC` in `Cohomology/CechHigherDirectImageUnconditional.lean`.
- **Landed a sharper Stage-2 decomposition than the blueprinted plan**: the Beck–Chevalley mate now *factors* as `unit ≫ isomorphisms`, and essential-image membership for open-immersion pushforwards is proven **cover-local** — both sorry-free.
- The former monolithic `IsIso bareBC` sorry is replaced by one strictly smaller, **fully affine-local** sorry: `openImmersion_pushPull_essImage_member` (`M|_{W_j}` is a pushforward from `W_j ∩ g'⁻¹V`). No globality on `X'` remains in the obligation.

## Progress

- New sorry-free lemmas (≈180 LOC): `openImmersion_pullback_counit_isIso`, `openImmersion_bareBC_app_eq` (mate factorization), `openImmersion_bareBC_app_isIso_of_unit`, `openImmersion_unit_isIso_of_essImage`, `restrictFunctor_map_app`, `restrictionMap_isIso_of_essImage`, `essImage_pushforward_of_openCover` (the cover-locality engine — plain presheaf components, no push/pull coherence needed).
- `openImmersion_beckChevalley` rewired: its `IsIso` obligation now flows `member → essImage → unit → bareBC` with the member node the only sorry. File sorry count unchanged at 7; content strictly smaller.
- Blueprint `obc329` chain rewritten to match: 3 new `\leanok` nodes, member node re-anchored to the essImage form, main proof text and the stale soundness note updated; no dangling `\cref`s.
- `TO_USER.md` FBC bullet refreshed; inbox `I-0020` (progress, ground) and `I-0021` (memory: mate-factorization recipes, `lake env lean` doesn't apply lakefile `leanOptions`, LegMid1 cost, racing-build hazard) filed.
- All new proofs verified in-session via a Mathlib-only scratch file (11 fast iterations, final compile exit 0, same toolchain); scratch files deleted.

## Issues

- **Full-module build not finished in-session**: `CechSectionIdentificationLegMid1.olean` (in the import cone, `maxHeartbeats 0`, documented ~70 min) was missing at session start and its recompile ran >3 h under machine load 60–130 without completing; it dies with this session. So the edited module is **not yet kernel-checked in place** — the ports are verbatim scratch-verified, but the small wiring edits are only type-plausible.
- A **racing concurrent `lake build`** of this same project (leftover from another session) was compiling the same files in parallel for hours — likely how LegMid1's olean went missing. Real corruption/duplicated-work hazard; memory item filed.
- Remaining FBC leaves untouched (as scoped): `pullback_preservesFiniteLimits`, per-σ RHS tilde leaf, heart residual, 2 cosimplicial naturalities.

## Next

- Run `lake build AlgebraicJacobian.Cohomology.CechHigherDirectImageUnconditional` on a quiet machine (expect green, same 7 sorries); don't run it concurrently with another build of this project.
- Close the member node `openImmersion_pushPull_essImage_member` — full route in its docstring; the one missing brick is the open-open pushforward–restriction commutation (`glueOverlapBaseChangeIso` pattern from `Picard/GlueDescent`, ~100 LOC), the rest is existing affine machinery.
