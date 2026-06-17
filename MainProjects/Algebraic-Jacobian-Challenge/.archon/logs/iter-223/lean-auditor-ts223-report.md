# Lean Audit Report

## Slug
ts223

## Iteration
223

## Scope
- files audited: 1
- files skipped (per directive): 0

---

## Per-file checklist

### `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

- **outdated comments**: 3 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**:
  - **Focus-area 1 (internalHomEval comment honesty)**: PASS. No survivor of the over-optimistic language the directive warned about. Phrases such as "sorry 4→3", "sub-step 3 RETIRED", "axiom-clean, NO sorryAx" are completely absent from the file. The `internalHomEval` docstring (L1449–1462) correctly states "the `naturality` field is held as a typed `sorry`" and gives the accurate heartbeat-bomb diagnosis. The iter-223 status block in the file header (L50–57) accurately describes the whnf obstacle without claiming the sorry is closed.
  - **Focus-area 2 (sorry-count accuracy)**: PASS. The file header (L41–43) lists exactly 4 typed-sorry residuals: `isLocallyInjective_whiskerLeft_of_W`, `internalHomEval` naturality, `exists_tensorObj_inverse`, and `addCommGroup_via_tensorObj`. Confirmed 4 actual `sorry` bodies: L644, L1498, L1930, L1974. Count is accurate.
  - **Stale comment — `tensorObj_assoc_iso` (L1644)**: The docstring begins "iter-212 status (typed `sorry`; **go/no-go bridge CLEARED, a NEW residual located**)". The declaration's proof body (L1684–1724) contains NO direct sorry; the proof was completed since iter-212 (the direct sorry was removed and replaced with a call to `W_whiskerLeft/Right_of_W`). The "typed `sorry`" phrase is now false at the direct-sorry level. Note: the declaration IS still sorry-transitively impacted through `W_whiskerLeft_of_W` → `isLocallyInjective_whiskerLeft_of_W` (L644 sorry), but the docstring does not document this residual dependency; it just reads as if the declaration is still in its iter-212 sorry-state.
  - **Stale comment — `tensorObjOnProduct` (L1937)**: The docstring ends "iter-202 Lane TS scaffold: typed `sorry`." But the body (L1939–1941) is a complete, non-sorry definition: `⟨tensorObj L.carrier L'.carrier, tensorObj_isLocallyTrivial L.isLocallyTrivial L'.isLocallyTrivial⟩`. The sorry claim is false. The sorry-count header correctly excludes this declaration, but a reader of the docstring is misled.
  - **Stale inline comment — `exists_tensorObj_inverse` (L1926–1927)**: The inline proof comment says "no `MonoidalClosed`/internal-hom on `PresheafOfModules`/`SheafOfModules`". This was accurate when written (before the dual-block build), but the file now defines `InternalHom.internalHom` (L1306–1313) and `dual` (L1359–1362), the presheaf-level internal-hom and dual that were absent when this comment was written. The correct statement is "no *sheaf*-level (`SheafOfModules`) internal-hom/dual/evaluation". The docstring on the same declaration (L1906–1907) says "no `SheafOfModules`-level internal-hom / dual / evaluation object" which is more precise and accurate.
  - **Minor — `restr_map_homMk` docstring (L1444–1447)**: The private lemma was "Extracted as its own lemma so the heavy `whnf` defeq runs once within its own heartbeat budget (the `internalHomEval` naturality proof would otherwise time out)." The `internalHomEval` naturality is still sorry'd; the extraction served to structure the worked-out reduction (cited in the six-step plan at L1493), but the lemma's stated motivating purpose has not yet been realized at the proof level. Not wrong, but worth noting as pointing to incomplete work.
  - **Minor — `@[implicit_reducible]` comment (L1970)**: "iter-218 note: `@[implicit_reducible]` is RETAINED (the plan directive to drop it was not applied)" — the parenthetical mentions a prior plan directive. The technical justification (linter warning on class-type defs) is correct; the historical reference is stale flavor but harmless.
  - No excuse-comments found ("temporary wrong def", "will fix later", "placeholder", "stand-in until").
  - No suspect definition bodies (no `:= True`, `:= rfl` on non-trivial claims, no `Classical.choice _` without authorization).
  - No unauthorized `axiom` declarations.
  - `set_option autoImplicit false` is present (line 100) — good practice.
  - `set_option backward.isDefEq.respectTransparency false` appears in three instances (L312, L328, L345) to suppress a known `isDefEq` regression. Each is scoped (`set_option … in`) to a single declaration — acceptable localized workaround.

---

## Must-fix-this-iter

None.

(The 4 sorry bodies are properly documented infrastructure gaps. No excuse-comments, no weakened-wrong definitions, no parallel-API copies, no unauthorized axioms.)

---

## Major

- `TensorObjSubstrate.lean:1644` — Stale sorry-status claim in `tensorObj_assoc_iso` docstring. The text "iter-212 status (typed `sorry`; go/no-go bridge CLEARED, a NEW residual located)" implies the declaration is still in its iter-212 sorry-state. The direct sorry has since been removed (proof body at L1684–1724 is complete), though the declaration remains sorry-transitively impacted through `isLocallyInjective_whiskerLeft_of_W`. The docstring should be updated to reflect the current state (e.g. "ROUTE (d) closed at direct-sorry level; sorry-transitive via `isLocallyInjective_whiskerLeft_of_W`").
- `TensorObjSubstrate.lean:1937` — False sorry-status claim in `tensorObjOnProduct` docstring. "iter-202 Lane TS scaffold: typed `sorry`" but the body (L1939–1941) is a complete, non-sorry definition. The file-header sorry inventory correctly excludes this declaration, but the docstring states it is a sorry when it is not.
- `TensorObjSubstrate.lean:1926–1927` — Stale scope claim in `exists_tensorObj_inverse` inline comment: "no `MonoidalClosed`/internal-hom on `PresheafOfModules`/`SheafOfModules`". The project has since built the presheaf-level `InternalHom.internalHom` (L1306) and `dual` (L1359) in this same file. The comment should be narrowed to "no *SheafOfModules*-level internal-hom/dual".

---

## Minor

- `TensorObjSubstrate.lean:1444–1447` — `restr_map_homMk` docstring says it was extracted to prevent the `internalHomEval` naturality proof from timing out; that proof remains sorry'd, so the extraction's stated purpose is unrealized at the proof-assembly level. Not wrong, but marks the helper as pending.
- `TensorObjSubstrate.lean:1970` — "iter-218 note: `@[implicit_reducible]` is RETAINED (the plan directive to drop it was not applied)" — stale reference to a historical plan directive; the technical justification is correct but the framing is stale.

---

## Excuse-comments (always called out separately)

None found. All sorry-bearing declarations carry substantive mathematical-obstacle explanations (Mathlib gaps, heartbeat bombs, missing infrastructure), not defensive placeholders.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 3
- **minor**: 2
- **excuse-comments**: 0

---

## Focus-area verdicts

1. **internalHomEval comment honesty**: CLEAN. No over-optimistic language ("sorry 4→3", "sub-step 3 RETIRED", "axiom-clean, NO sorryAx") survived the revert. The sorry is properly documented throughout.
2. **Sorry-count accuracy**: ACCURATE. Header lists 4; file contains exactly 4 sorry bodies (L644, L1498, L1930, L1974).
3. **General**: 3 stale comments (major), 2 minor observations, 0 excuse-comments.

Overall verdict: 1 file audited, 5 issues (major: 3 / minor: 2 / must-fix: 0). The primary risks are two stale "typed sorry" claims in docstrings of declarations that are now (fully or partially) closed, and one over-broad scope claim in an inline comment. The focus-area checks on `internalHomEval` and the sorry count both pass.
