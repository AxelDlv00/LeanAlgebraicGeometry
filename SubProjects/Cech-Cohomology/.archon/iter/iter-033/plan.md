# Iter-033 plan — toSheaf gap RESOLVED to a bounded build; two parallel mathlib-build lanes (toSheaf cover-system + tilde-exactness)

## Entering state (verified)
iter-032's two lanes processed:
- **Lane A `AffineSerreVanishing.lean` PARTIAL (+1).** `standard_cover_cofinal` (Tag 009L) axiom-clean,
  realized in the indexed-cover/refinement form. Blocked on `toSheaf_preservesEpimorphisms`, which the
  prover discovered is NOT a small instance but `PreservesFiniteColimits (SheafOfModules.toSheaf)` (toSheaf
  right-exactness) — absent from Mathlib (only the limit dual ships).
- **Lane B `QcohTildeSections.lean` COMPLETE (+7).** P1b `isLocalizedModule_of_span_cover` + 6 private
  helpers, axiom-clean — the entire assigned objective. The prior CHURNING corrective (P1→P1a/P1b split,
  dispatch only the independent P1b) worked.

Project sorry = 2 (both frozen/superseded). Build green. `unmatched` 8 (7 new QcohTilde helpers + dead node).

## What I did this iter (plan phase)
1. Processed both lanes (task_done += standard_cover_cofinal + P1b/6 helpers; task_pending refreshed; PROGRESS
   rewritten). Bundled the 7 QcohTilde private helpers into `lem:isLocalizedModule_of_span_cover` `\lean{}`
   (`unmatched` 8→1; residual = documented dead `CechAcyclic.affine`).
2. **progress-critic `iter033`:** both routes **CONVERGING** (0 CHURNING/STUCK). Route A SLIPPING on
   calendar (4 elapsed vs ~2–3 est) — watch OVER_BUDGET at iter-035 if iter-034 partials again; advised a
   spot-check of the toSheaf blueprint fix before re-dispatch (done via fast-path re-review). Route B
   ON_SCHEDULE; the P1→P1a/P1b corrective is confirmed to have worked.
3. **mathlib-analogist `tosheaf-epi` (api-alignment):** the toSheaf blocker = `NEEDS_MATHLIB_GAP_FILL`, a
   genuine but BOUNDED single-lemma build (~80–150 LOC). Route A confirmed: build
   `PreservesFiniteColimits (SheafOfModules.toSheaf R)` via the sheafification square
   `sheafificationCompToSheaf` + the left-adjoint reflector `L`, NEVER through `forget` (a right adjoint —
   the structural wall all four prover attempts hit). Every dependency verified present in Mathlib. Then
   epi-preservation is a one-liner; `IsLocallySurjective` follows in term-mode (dodges the `Balanced` rw
   failure). Persisted `analogies/tosheaf-epi.md`.
4. **blueprint-writer `tosheaf` then `tosheaf-fix`:** rewrote the WRONG "left adjoint" proof of
   `lem:to_sheaf_preserves_epi`; added sub-lemma `lem:toSheaf_preservesFiniteColimits` (the colimit build) +
   3 `\mathlibok` anchors; corrected `lem:standard_cover_cofinal` to the realized indexed-cover form. The
   first reviewer pass flagged Step-2 prose as illegible + a missing `\uses` edge; the `tosheaf-fix` round
   rewrote Step 2 as a 3-clause retract-via-counit-iso descent + added `\uses{lem:mod_pmod_adjunction}`.
5. **blueprint-clean `iter033`:** stripped two stale `% NOTE` history blocks; verified all new `\uses`
   resolve and `standard_cover_cofinal` source quotes verbatim.
6. **blueprint-reviewer `iter033` (whole) + `tosheaf-rereview` (fast-path scoped):** **Gate 2 (tilde) CLEARS**
   directly; **Gate 1 (toSheaf) CLEARS** after the fast-path re-review of the Step-2 fix. Both lanes cleared
   to dispatch THIS iter.
7. **strategy-critic `iter033`: SOUND** — toSheaf re-estimate is honest (Mathlib corroborates only the limit
   dual ships); no circularity (toSheaf right-exactness is cohomology-independent structural infra); the
   two-front 02KG-vs-01I8 structure holds. Updated STRATEGY: 02KG row (`Iters left` ~3, LOC ~280–430, Mathlib
   needs = the colimit BUILD), the toSheaf gap bullet, and the `surj_of_vanishing` open-question bullet.
8. Wrote PROGRESS.md (two mathlib-build lanes, scaffold keywords on both path lines), task ledgers, this
   sidecar, objectives.md, TO_USER.md.

## Decisions made

### D1 — This iter's two lanes: toSheaf cover-system build (Route A) + tilde-exactness P3 (Route B).
**Chosen.** Both are now blueprint-gate-cleared, independent files, and high-value:
- Lane A `AffineSerreVanishing.lean` builds the whole toSheaf chain (`toSheaf_preservesFiniteColimits` →
  `toSheaf_preservesEpimorphisms` → `affine_surj_of_vanishing` → `affineCoverSystem`). This is the LAST
  structural gate on the 02KG cover-system (the top qcoh theorem stays gated on 01I8, expected).
- Lane B `TildeExactness.lean` (NEW file) builds `tildePreservesFiniteLimits` (01I8 Route-P P3), independent
  of the toSheaf and P1a work. Put in its own file (per the parallelism standing directive) so it stays
  parallelizable with the QcohTilde P1a lane next iter.

### D2 — Defer the P1a effort-break to iter-034 (do not run it this iter).
**Chosen.** `lem:isQuasicoherent_restrict_basicOpen` (P1a geometry) is the next Route-B piece, but the
effort-breaker edits the SAME consolidated chapter the toSheaf writer just edited — running it concurrently
risks a write race, and serializing it would over-extend this already subagent-heavy prep iter. P1a is not
needed for either lane dispatched this iter. Scheduled as the iter-034 lead-off (PROGRESS "Next iter plan"
item 2). Reversal signal: if both lanes COMPLETE quickly, pull P1a forward.

## Prior critique status
- progress-critic iter-032 CHURNING on Route B → corrective (P1→P1a/P1b split, dispatch only P1b) — ADDRESSED
  (P1b COMPLETE iter-032; progress-critic iter-033 confirms the corrective worked, Route B now CONVERGING).
- strategy-critic iter-032 CHALLENGE (01I8 effort under-count) → ADDRESSED iter-032 (own phase row). No live
  challenge entering iter-033; iter-033 verdict SOUND.

## Subagent skips
- (none) — all mandatory plan-phase subagents dispatched: progress-critic `iter033`, strategy-critic
  `iter033`, blueprint-reviewer `iter033` (+ fast-path `tosheaf-rereview`). Plus mathlib-analogist,
  blueprint-writer ×2, blueprint-clean.

## Tool substitutions
- (none) — no external-LLM key in env, but no step this iter required `archon-informal-agent.py`; the
  mathlib-analogist subagent supplied the Mathlib route directly.
