# Refactor Report

## Slug
cotangent-grpobj-docstring-refresh-iter133

## Status
COMPLETE — All 6 directive edits applied to `AlgebraicJacobian/Cotangent/GrpObj.lean`; file compiles cleanly (`lean_diagnostic_messages` → `[]`); rank lemma axioms unchanged (kernel-only `{propext, Classical.choice, Quot.sound}`).

## Directive

### Problem (summary)
The iter-132 prover lane closed `cotangentSpaceAtIdentity_finrank_eq` at line 244 of `AlgebraicJacobian/Cotangent/GrpObj.lean`. Five docstring sites (file header, `## Status` block, three sites in the `cotangentSpaceAtIdentity` declaration docstring) were authored under the iter-130/iter-131 assumption that the rank lemma would live in a follow-up file/iter. With the iter-132 in-file addition, those docstring claims are now factually wrong. Additionally, the iter-132 lean-vs-blueprint-checker flagged the rank-lemma proof body's `set ... with hU_def` / `with hV_def` / `with he_def` introductions as introducing hypothesis names never consumed in the proof body.

### Changes Requested (summary)
- 5 docstring refreshes (file-level header, `## Status` block, three sites in `cotangentSpaceAtIdentity` declaration docstring).
- 1 optional style nit (`set ... with _def` → `let`) at the top of the rank-lemma proof body.

All edits restricted to `AlgebraicJacobian/Cotangent/GrpObj.lean`; no theorem statement, definition body, or proof body semantics changed.

## Changes Made

### File: `AlgebraicJacobian/Cotangent/GrpObj.lean`

**Edit 1 — File-level header (lines 28–33)**
- **What:** Replaced the future-tense "deferred to iter-132+ for blueprint-RHS-pinning work; not in this file" paragraph with a present-tense description of file contents: definition (line 149), acceptance lemma (line 198), and rank lemma (line 244; closed iter-132).
- **Why:** Directive Edit 1 — original wording was authored when the rank lemma was deferred elsewhere; now incorrect since the rank lemma lives in this very file at line 244.
- **Cascading:** None (docstring only).

**Edit 2 — `## Status` block (lines 35–66)**
- **What:** Retitled `## Status (iter-131 fix-up: pure-term body refactor)` → `## Status (iter-132 close: rank lemma)`. Preserved the iter-128 / iter-129 / iter-130 / iter-131 history paragraph; trimmed the trailing "lives in a follow-up declaration (not in this file)" claim about `cotangentSpaceAtIdentity_finrank_eq` (now obsolete); appended a new iter-132 paragraph describing the close via parallel `Classical.choose`-chain extraction on `Scheme.smooth_locally_free_omega`, reducing through `Module.finrank_baseChange` + `Module.finrank_eq_of_rank_eq`.
- **Why:** Directive Edit 2 — narrative chain needed extension to acknowledge iter-132's in-file close.
- **Cascading:** None (docstring only).

**Edit 3 — `cotangentSpaceAtIdentity` declaration docstring (lines ~104–108)**
- **What:** Changed `iter-132+ companion rank lemma 'cotangentSpaceAtIdentity_finrank_eq' (in a follow-up declaration)` → `iter-132 companion rank lemma 'cotangentSpaceAtIdentity_finrank_eq' (at line 244 below)`.
- **Why:** Directive Edit 3 — the parenthetical was authored when the lemma was assumed to be in a follow-up.
- **Cascading:** None (docstring only).

**Edit 4 — `cotangentSpaceAtIdentity` declaration docstring (around line ~145)**
- **What:** Changed `the iter-132+ rank lemma can rewrite against` → `the iter-132 rank lemma 'cotangentSpaceAtIdentity_finrank_eq' (line 244 below) rewrites against`.
- **Why:** Directive Edit 4 — past-tense framing for a now-closed lemma.
- **Cascading:** None (docstring only).

**Edit 5 — `cotangentSpaceAtIdentity` declaration docstring (around lines ~152–158)**
- **What:** Split the closing structural-properties enumeration. Old wording: `"The structural properties ('Module.Free k', 'Module.Finite k', rank '= n') are content for the iter-132+ rank lemma 'cotangentSpaceAtIdentity_finrank_eq'; the structural-shape accessibility needed by that lemma is witnessed here by 'cotangentSpaceAtIdentity_eq_extendScalars'."` New wording: `"The rank ('= n') is now pinned by 'cotangentSpaceAtIdentity_finrank_eq' (line 244 below; closed iter-132). The free/finite structural properties ('Module.Free k', 'Module.Finite k') are content for follow-up companion lemmas (not yet in this file); the structural-shape accessibility needed by those lemmas is witnessed here by 'cotangentSpaceAtIdentity_eq_extendScalars' (line 198 below)."`
- **Why:** Directive Edit 5 — `rank = n` half is closed (so should be present-tense / attributed to the iter-132 lemma); `Module.Free k` and `Module.Finite k` remain genuine future work (so should be split out as deferred follow-ups).
- **Cascading:** None (docstring only).

**Edit 6 — Rank-lemma proof body (lines 264–266)**
- **What:** Replaced `set U : ... := h.choose with hU_def`, `set V : ... := h.choose_spec.choose with hV_def`, `set e : ... := h.choose_spec.choose_spec.choose with he_def` with their `let` equivalents (dropping the unused `with ..._def` clauses entirely). The `hU_def`, `hV_def`, `he_def` hypothesis names introduced by `with` were never consumed downstream in the proof body. The `let` form (chosen over the alternative `set` without `with`) matches the surrounding proof's style (cf. `let ηleft := ...`, `let x₀ := ...`, `let h := ...`, `let ψV := ...`).
- **Why:** Directive Edit 6 — iter-132 lean-vs-blueprint-checker flagged the unused `with`-introduced names as a style nit; replacement was optional bundling, agreed per HIGH-A + MED-D of `recommendations.md`.
- **Cascading:** None — proof still closes (verified by `lean_diagnostic_messages` → `[]` and `lean_verify` axioms unchanged).

## New Sorries Introduced
- None.

## Compilation Status
- `AlgebraicJacobian/Cotangent/GrpObj.lean`: compiles cleanly. `lean_diagnostic_messages` returns `[]`.
- `lean_verify AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_finrank_eq`: axioms = `{propext, Classical.choice, Quot.sound}` (kernel-only, unchanged from iter-132 close). The `lean_verify` "opaque" pattern warnings at lines 50, 53, 204 are docstring matches for the literal word "opaque" (used in the iter-131 description of the `Classical.choose`-chain accessors as "named-but-opaque" and in the body docstring's "Caveat on canonicity" paragraph) — not source-level `opaque` declarations.
- File LOC: 296 (from 285 at directive issuance, +11 net — the iter-132 status paragraph added a few lines; structural-properties split added a couple; the `let`-for-`set` swap is line-neutral).
- Sorry count: 0 (unchanged).

## Notes for Plan Agent

- **All 5 docstring refreshes + the 1 style nit landed as a single bundled refactor on one file**, per HIGH-A + MED-D of `recommendations.md` and the directive's "Optional bundling" guidance.
- **No `archon-protected.yaml` edits** — the protected `cotangentSpaceAtIdentity` and `cotangentSpaceAtIdentity_finrank_eq` signatures were left verbatim; only the surrounding docstring text and the rank-lemma proof body's `set`/`let` choice were changed.
- **No theorem statement, definition body, or other proof body semantics changed.** This is a pure documentation refresh + 1 style polish.
- **Three `lean_verify` `opaque` warnings remain**, all at docstring sites (lines 50, 53, 204). They are false positives from the source-scan pattern matcher: the word "opaque" appears in the iter-131 status block's description of `Classical.choose` accessors ("named-but-opaque accessors", "as named-but-opaque accessors") and in the `cotangentSpaceAtIdentity` body docstring's "Caveat on canonicity" paragraph ("opaque to downstream `unfold`/`whnf`" — describing the pre-iter-131 opacity defect that iter-131 *fixed*). These are unchanged from the pre-refactor state and are documentation artefacts, not actual `opaque` declarations.
- **Follow-up work** (out of scope this iter; flagged for the plan agent):
  - `Module.Free k cotangentSpaceAtIdentity` and `Module.Finite k cotangentSpaceAtIdentity` companion instances/lemmas remain genuine future work. The refreshed docstring at the bottom of `cotangentSpaceAtIdentity` (Edit 5) flags this explicitly so a future iter's plan agent can pick them up.
  - The `iter-130+` deferred mention of `lem:GrpObj_cotangent_bridge` (canonical stalk-side cotangent `𝔪 / 𝔪²` presentation) in the "Caveat on canonicity" paragraph (around line ~140) was *not* updated this iter — the directive did not list it among the 5 stale sites, and the bridge lemma is genuinely still deferred per the iter-132 blueprint state. Plan agent may want to verify that wording on the next blueprint-vs-Lean reconciliation pass.
- **Mathematical justification was sufficient** to guide all 6 edits; no cascading fixes needed since the changes were docstring + 1 trivial proof-body keyword swap.
