# Iter 001 — Plan (Quot-Foundations, first prover-stage iteration)

## TL;DR

First plan phase of the freshly-extracted Čech-independent leg. Both mandatory critics returned
must-fix findings; **no chapter cleared the HARD GATE** and the FBC route needed a fundamental
pivot. So iter-001 became a **strategy + blueprint repair iteration**: rewrote STRATEGY.md
(canonical skeleton + route pivots) and ran three blueprint-writers that fixed every flagged
must-fix item. **No prover dispatch** (mechanical gate — documented). Build GREEN throughout.

## State at entry

- `lake build` exit 0 (green). 7 sorry-bearing nodes; 22 proved/anchored.
- DAG frontier = 3 nodes, ALL with `AlgebraicGeometry.TODO.*` lean names (no real decl):
  `lem:base_change_map_affine_local`, `lem:pushforward_base_change_mate_cancelBaseChange`,
  `thm:generic_flatness_algebraic`. These are scaffold-objectives, not fill-the-sorry objectives.
- `archon-protected.yaml` is empty — the seven seeds are unprotected (re-signing permitted).

## What the critics found (both ran first, read-only)

**strategy-critic → CHALLENGE** (all three routes goal-aligned + sound at statement level, but
each needs a corrective; STRATEGY.md format NON-COMPLIANT). **blueprint-reviewer → no chapter
clears the HARD GATE** (all four `correct: partial`; three additionally `complete: partial`).

Convergent must-fix set:
1. FBC billed "Čech-independent" but `thm:flat_base_change_pushforward`'s proof used Čech
   cohomology / spectral sequences (Mathlib-absent). For i=0 unnecessary — H⁰ is the
   sheaf-condition equalizer, preserved by flat `−⊗B`.
2. FBC affine close inherited the parent's abstract adjoint-mate ↔ `cancelBaseChange` cut
   (parent-flagged "Mathlib-scale" wall) + a deferred Mathlib `#37189` dependency with no
   project-side fallback. Cheaper cut: prove directly on global sections via the proved tilde
   dictionaries, reducing to canonical `(R'⊗_R A)⊗_A M ≅ R'⊗_R M`.
3. GF risk of over-building the full Nitsure §4 induction when Mathlib's
   `exists_free_localizedModule_powers` + generic-fibre-is-free may collapse it to a wrapper.
4. `genericFlatness` Lean signature FALSE as written (no coherence hyp) → unprovable sorry.
5. QUOT: `Grassmannian.representable` reinvents `Functor.IsRepresentable`; broken
   `\cref{chap:Picard_FGAPicRepresentability}`; stubs under-typed (coherence/locally-free/rank).
6. RelativeSpec proved only as `IsAffineHom`/`IsAffine` (weaker than blueprint `RepresentableBy`/
   canonical-iso) — blocks the deepest QUOT target only.

## Decision made

**Iter-001 = repair iter; defer all prover dispatch (mechanical gate).** Rationale: dispatching
provers requires a fresh complete+correct blueprint verdict (HARD GATE); all chapters were
`partial`, and the FBC chapter was being rewritten to a new route — any prover work would be
thrown away. The seven seed `.lean` files also still don't faithfully match the blueprint
(`genericFlatness` false-as-signed; QUOT stubs under-typed; three TODO helper decls absent), so
provers genuinely cannot do faithful work on them yet. This is the sanctioned deferral, not idling
— the iter delivered a strategy rewrite + three blueprint rewrites + two audits.

**FBC route pivot (the highest-leverage call):** adopt the strategy-critic's direct-on-sections +
H⁰-equalizer route. It (a) dissolves the parent's "Mathlib-scale" mate-coherence wall, (b) drops
the `#37189` upstream dependency entirely, (c) is genuinely Čech-free (matches the leg's billing).
The FBC writer verified the needed Mathlib names exist (`Module.Flat.ker_lTensor_eq`,
`eqLocus_lTensor_eq`, `LinearMap.tensorKerEquiv`, `tensorEqLocusEquiv`, `cancelBaseChange`) and
flagged the orientation subtlety `Γ(α) = cancelBaseChange⁻¹`. Cheapest signal that would reverse
it: the affine-lemma attempt next iter discovering the section-level identification still hides an
irreducible mate computation (then reconsider). Low risk — the route uses only proved lemmas +
verified Mathlib.

## Actions taken this iter

- Rewrote STRATEGY.md to the canonical skeleton (6-column `Phases & estimations`,
  `Open strategic questions`, dropped non-canonical `Out of scope`, moved parent-history out of
  table cells) and folded in all three route pivots.
- blueprint-writer ×3 (parallel), each scoped to one chapter + `references/**`:
  - `fbc-route` → FBC route pivot (direct-on-sections affine lemma; Čech-free equalizer
    globalization; element-level mate↔cancelBaseChange sketch; `\mathlibok` anchor for the
    flat-preserves-equalizer input). COMPLETE.
  - `gf-core` → GF Mathlib-first framing + intended `genericFlatnessAlgebraic` signature +
    corrected `genericFlatness` target (`[IsQuasicoherent]`+`[IsFiniteType]`). COMPLETE.
  - `quot-defs` → fixed broken cref; tightened stub signatures in prose; `IsRepresentable`
    alignment + universe note; `Grassmannian` via `QuotFunctor`; RelativeSpec gap recorded.
    COMPLETE.
- Updated STRATEGY Mathlib-gaps with two new QUOT predicate gaps the QUOT writer surfaced.

## New facts surfaced (carry forward)

- Mathlib has **no `IsCoherent` predicate** at the pin; coherence = `IsQuasicoherent` +
  `IsFiniteType` (both verified present).
- QUOT re-sign is blocked on two absent-at-pin predicates: schematic-support/proper-support
  (`IsProper` exists; the schematic-support closed subscheme does not) and rank-`r`
  local-freeness (`SheafOfModules.IsLocallyFree` is upstream-only + rank-agnostic). These are
  project-side sub-builds (Mathlib-gradient) before the QUOT stubs can be re-signed honestly.
- FBC `Γ(α) = cancelBaseChange⁻¹` (orientation) — scaffold must state the helper in the
  provable orientation.

## Prior critique status (strategy-critic CHALLENGE — how addressed)

- FBC Čech / scope: ADDRESSED — STRATEGY FBC route now states the H⁰-equalizer Čech-free route;
  FBC chapter proof rewritten accordingly.
- FBC `#37189` deferral: ADDRESSED — removed; route now uses only proved lemmas + verified
  `Flat/Equalizer` Mathlib.
- GF over-build: ADDRESSED — GF chapter restructured Mathlib-first (wrapper primary, §4 residue
  fallback); STRATEGY GF-alg risk updated.
- QUOT `IsRepresentable` + universe: ADDRESSED — chapter restated target as `IsRepresentable`
  with universe-pin note; STRATEGY records it.
- Format NON-COMPLIANT: ADDRESSED — STRATEGY rewritten to canonical skeleton.
- (No rebuttals — every challenge accepted and acted on. Strategy-critic re-confirmation deferred
  to iter-002's mandatory dispatch; the adjustments mirror the critic's own recommendations.)

## Subagent skips

- progress-critic: no prior prover phase exists in this subproject (iter-001 is the first
  prover-stage iter; extraction carried no prover trajectory) — no convergence data to assess.
- blueprint-clean: its trigger ("after a writer round AND before dispatching provers") is not met
  — no provers run this iter. Running it now would strip the deliberate `% INTENDED LEAN
  SIGNATURE:` / coherence-encoding scaffold guidance the writers added (blueprint-clean removes
  "Lean implementation strategies / typeclass notes"), destroying content the iter-002 scaffold
  pass needs. Queued for iter-002 AFTER the scaffold consumes those signatures and BEFORE the
  prover dispatch.
- lean-vs-blueprint-checker / lean-auditor: review-phase subagents; no `.lean` files were modified
  this iter (blueprint + state only).

## Tool substitutions

- None. All reference material was already on disk; Mathlib existence checks used
  `lean_leansearch`/`lean_loogle` (existence-only, per the planner boundary).
