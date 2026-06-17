# Iter-017 plan — clear iter-016 review debt, dispatch 2 ready P3b lanes, redesign STUCK P3 (Q4 re-sign)

## Entering state (verified)
iter-016 ran 3 parallel lanes, all axiom-clean (+21 decls, 0 new sorries):
- **P3b free `FreePresheafComplex.lean`**: `cechFreePresheafComplex` (`def:cech_free_presheaf_complex`)
  via the simplicial route (+8 decls). `cechFreeComplex_quasiIso` absent (needs O_𝒰 augmentation).
- **P3b section `PresheafCech.lean`**: `sectionCechComplex` (Ab-valued) + `freeYonedaHomAddEquiv` (+4).
- **P3 `CechAcyclic.lean`**: dependent-coefficient L3 port (+9, `depDiff_exact`). `CechAcyclic.affine`
  still 1 sorry (line 109).

iter-016 review (processed this iter) left: 2 must-fix blueprint reconciliations (Ab vs O_X(U)-modules
on `def:section_cech_complex` + `lem:cech_complex_hom_identification`), 19-helper coverage debt, and a
key structural fact discovered here: **`FreePresheafComplex.lean` imports `PresheafCech.lean`**, so
`cechComplex_hom_identification` (needs BOTH complexes) cannot live in PresheafCech — that was
iter-016's "cross-file block". `lake build` green (8325 jobs).

## What I did this iter
1. **Processed iter-016 results** (task_done/task_pending updated, result files cleared).
2. **blueprint-writer `iter017`** (whole-chapter content pass): reconciled section/hom-id target
   category to **abelian groups (Ab)** (matching the Lean + the Stacks quote); added the O_𝒰
   augmentation block `def:cover_structure_presheaf`; added `[Finite]`/coproduct prose + `\lean` hints
   to the free complex; **bundled all 19** unmatched helpers (`archon dag-query unmatched` now 0/0).
3. **refactor `cechbridge`**: created `CechBridge.lean` (imports FreePresheafComplex → sees both
   complexes; hosts the bridge) + wired the barrel. Build green 8325.
4. **mathlib-analogist `p5a`**: `higher_direct_image_presheaf` (01XJ) → **PROCEED** (all 4 building
   blocks confirmed; `analogies/p5a.md`). P5a lane opens next iter.
5. **progress-critic `iter017`**: **P3 STUCK**, P3b-free/bridge UNCLEAR. Acted on STUCK (below).
6. **mathlib-analogist `l1bridge`** (the STUCK corrective consult): L1 bridge **NOT-FEASIBLE as one
   lane** — see Decision.
7. **blueprint-writer `l1redesign`** (the STUCK structural corrective): re-stated `lem:cech_acyclic_affine`
   to the section-complex form + decomposed L1 into `def:qcoh_sections_localized` +
   `lem:section_cech_homology_exact`. leandag clean (0 isolated, 0 unknown_uses).
8. **blueprint-reviewer `iter017`**: **HARD GATE CLEARS** the two P3b lanes (free + bridge).
9. Wrote PROGRESS.md (2 lanes), updated STRATEGY.md (Q4 + P5a), fixed the dangling
   `analogies/p3-localisation.md` reference (it never existed → `analogies/l1-bridge.md`).

## Decision made

### D1 — P3 STUCK corrective: redesign, not re-run (Q4 re-sign to the section-complex form)
- **The critic's read is correct**: `CechAcyclic.affine` sorry has been 1→1 for two iters while 18
  helpers accumulated. The blocker is the **L1 categorical→module bridge**. Re-dispatching prove/mathlib
  -build at the same statement would hit the same wall a third time.
- **The consult (`l1bridge`) revealed WHY**: the current statement vanishes the *relative* complex
  `CechComplex f 𝒰 F`, whose terms are wrapped in `pushforward f`. `pushforward f` is a right adjoint
  — it preserves kernels, NOT homology — and affine-pushforward exactness is **absent from Mathlib**.
  So `IsZero (homology p)` of the pushed complex is not reducible to module exactness via the
  localisation route. This is the decisive blocker (analogist's "Q4").
- **Q4 decision**: re-state `cech_acyclic_affine` to vanish the **absolute section Čech complex**
  `sectionCechComplex` (already built this project, Ab-valued) on the standard cover — NO pushforward.
  I verified this is safe + correct by reading the downstream consumers: `injective_cech_acyclic`,
  `ses_cech_h1`, `cech_to_cohomology_on_basis` (01EO), `affine_serre_vanishing` (02KG) are ALL about
  the absolute section complex; the relative complex's acyclicity (needed only for P5b) is supplied
  separately via `affine_serre_vanishing` + `cech_term_pushforward_acyclic` (P5a), which never call
  `cech_acyclic_affine`. The blueprint prose for the lemma already said "affine scheme Spec A"
  (absolute) — the iter-016 Lean had over-generalised to a morphism, introducing the trap.
- **Corrective executed THIS iter** (concrete, per the CHURNING/STUCK rule): (a) the analogist consult
  [done], (b) blueprint-writer `l1redesign` re-architected the lemma + decomposed L1 into two buildable
  sub-lanes (`qcoh_sections_localized` ~150 LOC qcoh-globalisation; `section_cech_homology_exact`
  ~250–400 LOC categorical↔module id). **No P3 prover this iter** — the redesigned blocks need a fresh
  gate (next iter's mandatory reviewer) + a Lean re-sign refactor first. Bonus: `cech_acyclic_affine`'s
  L1 now lands on top of the section complex P3b just built, unifying P3 and P3b's section side.
- **Cheapest reversal signal**: if the next-iter blueprint-reviewer rejects the section-complex
  re-statement (e.g. a downstream consumer genuinely needs the relative form), revert the re-sign and
  instead build affine-pushforward exactness as a separate brick. I judge this unlikely (the Stacks
  architecture is unambiguous that 01EO consumes absolute Čech vanishing).

### D2 — Dispatch the two READY P3b lanes this iter (free quasiIso + bridge hom-id)
- Both are gate-cleared (blueprint-reviewer `iter017`), build-new-declaration objectives, mathlib-build.
  `cechFreeComplex_quasiIso` (with its O_𝒰 dep) and `cechComplex_hom_identification` are independent of
  each other and of the P3 redesign, so they run cleanly in parallel. The CechBridge file (new, imports
  FreePresheafComplex) resolves the iter-016 cross-file block.

### D3 — Defer P5a one more iter (despite the parallelism directive)
- `higher_direct_image_presheaf` is confirmed feasible (analogist `p5a`) and P3/P3b-independent, but
  opening it needs a new file + scaffolding. With P3 mid-redesign and 2 P3b lanes already dispatched,
  holding P5a to next iter keeps this iter focused (a STUCK-redesign iter should not also open a brand-
  new phase). It is the #1 parallel lane to open next iter. Recorded in PROGRESS Next-iter plan.

## Why only 2 prover lanes (not 3–4)
The standing parallelism directive favors more lanes, but: P3 is mid-redesign (no validated target to
prove — dispatching would re-hit the STUCK wall); P5a needs a new-file scaffold and is best opened
fresh next iter; PresheafCech's section side is done. The two dispatched lanes are exactly the ready,
gate-cleared, mutually-independent work. Quality over lane-count immediately after a STUCK verdict.

## Subagent skips
- strategy-critic: STRATEGY.md route unchanged since iter-011 and prior verdict was SOUND for all
  routes with no live CHALLENGE (recorded iter-015 & iter-016). This iter's STRATEGY edits are
  bookkeeping (Q4 re-sign within Route A's existing P3/P3b decomposition + P5a status NEXT) — no route
  swap, no new route, no decomposition reversal. The strategy a fresh mathematician would see is
  unchanged. (Re-dispatch if a future iter changes a route.)

## Tool substitutions
- none (no external-LLM tool was needed; the L1 de-risking used the mathlib-analogist subagent, which
  is the catalog's equivalent for the "is this Mathlib-feasible?" check).
