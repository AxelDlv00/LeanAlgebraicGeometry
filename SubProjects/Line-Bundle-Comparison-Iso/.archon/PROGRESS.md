# Project Progress

## Current Stage

prover

## Stages
- [x] init
- [x] autoformalize
- [ ] prover
- [ ] polish

## End-state overview

**Zero inline `sorry` in the dependency cone of the three seed declarations + kernel-only
axioms**, for the **Line-Bundle Comparison Iso** subproject (A.1.c.sub). Seeds:
`lem:pullback_tensor_iso_loctriv` (seed-1, D4′), `lem:dual_isLocallyTrivial` (seed-2, DUAL),
`thm:rel_pic_addcommgroup_via_tensorobj` (seed-3, consumer).

## State (iter-103 turn-in)

**v4.31.0 recovery COMPLETE (089→096); dual-unit FLANK closed step-by-step (098→102):** LEAF (098),
(b)/(d) (099), keystone (a) ASSEMBLED (100), RES1 (101), **RES2 + keystone (a) `dual_unit_iso_restrict_assemble`
CLOSED iter-102** (sorry-free, axiom-clean `[propext, Classical.choice, Quot.sound]`). `lake build
…TensorObjInverse` EXIT 0 (8567 jobs).

**Live open sorries = 1 (keystone path), + 1 dead dup:**
- **(c) `trivialisation_restrict_compat` (private, `TensorObjInverse.lean` L2660; effort 4097)** — the LAST
  keystone obligation, UNBLOCKED by (a) (S4a now supplied). It is the telescope ASSEMBLY of the **5 already-proven
  square-lemmas** S2 `tensorObj_restrict_iso_restrict_compat` / S3 `dual_restrict_iso_restrict_compat` /
  S4a `dual_unit_iso_restrict_compat` / S4b `tensorObj_unit_iso_restrict_compat` / S4c
  `trivialisation_uIota_restrict_compat` (all sorry-free above it). **iter-103 effort-broke the ASSEMBLY**
  (not the squares) into a 3-link chain (effort 4097→2018); blueprint-reviewer `iter103` GATE CLEARED,
  progress-critic `iter103` CONVERGING.
- **Dead private `exists_tensorObj_inverse` dup (`TensorObjSubstrate.lean` L738)** — unconsumed deletion
  candidate (public twin lives in TensorObjInverse, body sorry-free). Harmless; cleanup phase.

## Decision (iter-103) — effort-break (c) ASSEMBLY, then guarded `prove` the 3-seam chain (fast path)

iter-102 review flagged (c) as a monolith (effort 4097) needing blueprint-level atomization BEFORE a prover.
Corrective taken THIS iter (the proven iter-102 template — effort-break → fast-path review → guarded prove):
- **effort-breaker `c-telescope`** split the telescope ASSEMBLY (leaving the 5 proven squares intact) into:
  **Seam1** `trivialisation_restrict_eM_split` (the `eM` bifunctoriality split; heaviest, ≈1215),
  **Seam2** `trivialisation_telescope_assemble` (a GENERIC abstract-`{C}[Category C]` ρ-cocycle collapse,
  sibling of the proven `c2_assemble`/`dual_scp_assemble`/`unit_assemble`; ≈861 — confines ALL `SheafOfModules ≫`
  seam-crossing, applied by `exact`), **Seam3** `trivialisation_restrict_sectionwise` (outer-reindex sectionwise
  eval; ≈584). Target rewritten to invoke Seam1→Seam2→Seam3.
- **HARD GATE: blueprint-reviewer `iter103` = GATE CLEARED (fast path)** — consolidated chapter
  `Picard_TensorObjSubstrate.tex` complete+correct for all 4 blocks (target + 3 seams), 0 must-fix, the 3-link
  chain genuinely proves the target (no gap relabelled away), `leandag unknown_uses = []`, doctor clean.
- **progress-critic `iter103` = CONVERGING, dispatch=OK** (0 churn; net sorry trend 3→2→1, each iter closed a
  named piece; first attempt on a freshly-decomposed gate-cleared target is structurally distinct from a re-grind).

## Current Objectives

1. **`AlgebraicJacobian/Picard/TensorObjInverse.lean`** — close the LAST keystone sorry (c)
   `trivialisation_restrict_compat` (L2660) by proving the iter-103 3-seam decomposition. Blueprint:
   `chapters/Picard_TensorObjSubstrate.tex` (`% archon:covers` this file; HARD GATE CLEARED iter-103;
   `lem:trivialisation_restrict_compat` + the 3 new seam blocks). Create the 3 private sub-lemmas BEFORE
   `trivialisation_restrict_compat` (L2591); namespace `AlgebraicGeometry.Scheme.Modules`.

   - **Seam1 `trivialisation_restrict_eM_split`** (`lem:trivialisation_restrict_em_split`). Applying
     `restrict j` to the U-side `tensorObjIsoOfIso eM (dual_restrict_iso U.ι L ≪≫ (dualIsoOfIso eM).symm ≪≫
     dual_unit_iso)` splits via `tensorObjIsoOfIso_trans` into the `eM`-leg — whose V-refinement IS
     `restrictIsoUnitOfLE hVU eM = (restrict j) eM` — and the dual-chain leg, where `dualIsoOfIso_trans`
     (contravariant) carries `(dualIsoOfIso eM).symm` through `restrict j`, leaving the bare dual-restriction
     covered by S3 + S4a. HEAVIEST seam; if it resists, it is the re-break candidate (split the
     `restrictIsoUnitOfLE = restrict j eM` identification from the 3-leg dual-chain carry).
   - **Seam2 `trivialisation_telescope_assemble`** (`lem:trivialisation_telescope_assemble`) — GENERIC, keep it
     instance-agnostic `{C} [Category C]` (mirror `c2_assemble`). Given the five square equations
     `(restrict j)(c^U_k) = ρ_{k-1}.inv ≫ c^V_k ≫ ρ_k` composed in order, the adjacent
     ρ (`restrictCompReindex j hjι` / `unitRestrictIso j`) factors cancel telescopically, leaving the outer
     hobjU/hobjV. Pure `Category.assoc` cocycle collapse; **apply it to the concrete chain by `exact`/`refine`,
     NEVER `rw`/`ext`** — this is what confines the seam-crossing.
   - **Seam3 `trivialisation_restrict_sectionwise`** (`lem:trivialisation_restrict_sectionwise`) — thread the
     two outer `eqToHom`s `image_preimage_of_le U hVU` / `image_preimage_of_le V le_rfl` and evaluate
     `.val.presheaf.map`/`.val.app` over the preimage open `U.ι ⁻¹ᵁ V`, yielding the asserted section equality.
   - **Target `trivialisation_restrict_compat`** — REWRITE the body to invoke Seam1 → Seam2 → Seam3
     (the chart `j := Scheme.Hom.resLE (𝟙 X) U V hVU'`, `hjι : j ≫ U.ι = V.ι`, `IsOpenImmersion j` are already
     set up in the existing body L2619–2628; keep them).
   - **NO-GRIND GUARD (must obey):** Seam2 + Seam3 + the target rewrite should close. For Seam1, if it resists
     after a focused effort, leave it as a **single clean `sorry`** and report whether the `eM`-leg
     identification or the dual-chain carry failed — do NOT grind the monolith or reintroduce a whole-(c) sorry.
     A clean Seam1 sorry + Seam2/Seam3/target closed is acceptable progress (Seam1 is the pre-mapped re-break
     target for next iter).
   - **Seam discipline ([[seam-split-fold-idiom]]):** across `SheafOfModules ≫`, syntactic `rw`/`simp`/`erw`
     of a category lemma chokes → term-mode `exact`/`refine` of a generic single-`[Category C]` lemma (defeq
     matches). Under `sheafification.map`/`forget`, `congrArg`/`Functor.map_comp` term-mode, NOT keyed `rw`.
     Trust `lake build …TensorObjInverse` EXIT 0 only (LSP dead). DEAD probes for this telescope:
     `restrictFunctorComp.hom.naturality φ` (morphism-level, iter-040); subst/rcases on `hVU`;
     `simp[restrictIsoUnitOfLE]`; `congr 1`/`Iso.eq_inv_comp`/`Hom.ext`.

   [prover-mode: prove]

## NEXT iter (committed)
- **If (c) closes (⇒ keystone path sorry-free):** dispatch the **public terminal `exists_tensorObj_inverse`
  body** (`TensorObjInverse.lean`) — its A-bridge (SheafOfModules morphism descent / gluing local trivialising
  isos) + B-connector `isIso_of_isIso_restrict` rides (c). Then **consumer seed-3
  `PicSharp.addCommGroup_via_tensorObj` (`RelPicFunctor.lean`)** scaffolds + fills.
- **If Seam1 returns a clean sorry (per no-grind guard):** Seam2/Seam3/target closed = acceptable progress, NOT
  a churn PARTIAL. Re-dispatch effort-breaker on Seam1 FINE (split the `restrictIsoUnitOfLE = restrict j eM`
  identification from the dual-chain carry), then fine-grained prover. Do NOT re-prove Seam1 whole.
- **If no Seam2/Seam3/target progress / a monolithic (c) sorry reappears:** decomposition didn't take →
  mathlib-analogist (cross-domain) on the `tensorObjIsoOfIso`/`dualIsoOfIso` bifunctoriality-at-SheafOfModules
  shape, or re-break sentence-by-sentence.
- **Coverage + cleanup phase** (post-keystone): blueprint entries for `adj_unit_counit_collapse` (iter-102) +
  the 3 iter-103 seam lemmas (once Lean-scaffolded, sync will match `\lean{}`); delete the dead private
  `exists_tensorObj_inverse` dup (`TensorObjSubstrate.lean` L738); prune dead IsIso-witness scaffolding; clear
  remaining `lean_aux` coverage debt; split `TensorObjSubstrate.lean` (>3600 LOC).
- **Extraction note:** decl names / namespaces / labels unchanged for clean merge-back.
