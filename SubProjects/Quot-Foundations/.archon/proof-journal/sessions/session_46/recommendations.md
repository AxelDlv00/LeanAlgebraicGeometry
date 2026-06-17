# Recommendations — next plan iter (post iter-046)

## MUST-FIX (blueprint, blocks downstream on `lem:modules_annihilator_ideal`)
1. **Rewrite `lem:modules_annihilator_ideal` statement** (`Picard_QuotScheme.tex` ~L2413) to the GLOBAL
   finiteness hypothesis `hfin : ∀ V : X.affineOpens, Module.Finite Γ(X,V) Γ(F,V)` (matches the Lean
   `annihilator_ideal`). Drop the single-`U` `Module.Finite Γ(X,U) Γ(F,U)` phrasing. (lvb must-fix #1; a
   `% NOTE:` already flags it in the chapter.)
2. **Delete the false proof step** in the same lemma's proof block (~L2441–2453): "the section over `U` is
   the infimum over basic opens `D(f) ⊆ U` of the comaps of the local annihilators" is FALSE for `ofIdeals`
   (= largest *coherent* sub-sheaf, not the naive inf). Replace with the actual argument: assemble the
   honest `IdealSheafData` from the family + `annihilator_map_basicOpen` coherence, then `ofIdeals_ideal`
   reads off the value at every affine open. (lvb must-fix #2.)

## HIGH — coverage debt (1-to-1 Lean↔tex)
3. **`annihilator_map_basicOpen` needs its own blueprint block** (`Picard_QuotScheme.tex`). Currently
   `lean_aux`/unmatched (only described in `def:modules_annihilator` prose). Suggested label
   `lem:annihilator_map_basicOpen`. Proof depends on: `Module.annihilator_isLocalizedModule_eq_map`
   (`lem:annihilator_localization_eq_map`), `isLocalizedModule_basicOpen`
   (`lem:qcoh_section_localization_basicOpen`), `IsAffineOpen.isLocalization_basicOpen`,
   `algebra_section_section_basicOpen`, `restrictBasicOpenₗ`. Add
   `\uses{lem:annihilator_localization_eq_map, lem:qcoh_section_localization_basicOpen}`. Then update
   `lem:modules_annihilator_ideal` `\uses` to cite this new node + `IdealSheafData.ofIdeals_ideal` (Mathlib).
   (lvb major #3.) `archon dag-query unmatched` will then drop 1→0.

## MEDIUM — blueprint-doctor structural bug
4. **`\Rrightarrow` undefined macro** in `Cohomology_FlatBaseChange.tex` (L2230–2246, FBC keystone
   adjunction prose). `leanblueprint web` will crash on it. Add `\providecommand{\Rrightarrow}{...}` to
   `blueprint/src/macros/common.tex` (planner domain — outside review's chapter-only write scope). Note
   `\Rrightarrow` is a standard amssymb glyph; plastex just needs it declared.

## Closest-to-completion / ready next
- **GF base case** (`gf_qcoh_fintype_finite_sections`) — effort-broke into 3 seams iter-046 along the
  "affine-qcoh exactness of Γ / exact-functor transport across gap1/gap2 descent" route (Stacks 01PB).
  Blueprint-reviewer must re-confirm complete+correct before a prover lane (HARD GATE). When it lands it
  discharges `annihilator_ideal`'s `hfin` for finite-type `F` (a one-line specialization).
- **SNAP** — chapter `Picard_SectionGradedRing.tex` authored iter-046 (3-layer decomposition). Same HARD
  GATE: needs a fresh complete+correct blueprint-reviewer verdict before prover dispatch.

## Blocked — do NOT re-assign without structural change
- **Single-`U` `annihilator_ideal`** — PROVEN unprovable (`ofIdeals` is the largest coherent sub-sheaf; the
  single-`U` reverse inclusion via `le_of_isLocalized_span` over a `D(fᵢ)` cover is circular). Would require
  Mathlib-absent ideal-sheaf restriction-along-`U↪X` infra. The global `hfin` form is the correct deliverable
  and is DONE.
- **FBC `_legs_conj`** — PARKED (kill-criterion fired iter-045; off critical path; resumable on user steer).
  Do not re-open as an in-loop lane without a USER_HINTS directive.

## Reusable patterns (also in PROJECT_STATUS Knowledge Base)
- `ofIdeals` = largest coherent sub-sheaf ⇒ affine-value characterizations need a GLOBAL finiteness
  hypothesis + the `IdealSheafData` assembly + `ofIdeals_ideal`, mirroring Mathlib `Hom.ker_apply`. Local
  `compHom`-module + `IsScalarTower.of_algebraMap_smul` + gap2 `isLocalizedModule_basicOpen` is the standard
  per-affine instance preamble; `set_option backward.isDefEq.respectTransparency false` for the
  structure-literal defeq.
