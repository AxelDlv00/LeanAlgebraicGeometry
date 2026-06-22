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
`lem:pullback_tensor_iso_loctriv` (seed-1, D4′ — DELIVERED iter-042),
`lem:dual_isLocallyTrivial` (seed-2, DUAL — DELIVERED),
`thm:rel_pic_addcommgroup_via_tensorobj` (seed-3, consumer; gated on terminal).

## Build state (iter-055 plan turn)

- **Root `TensorObjSubstrate.lean` GREEN, sorry-free, axiom-clean.** B1/B2/`pullbackTensorMap_restrict`/
  `pullbackTensorMap_natural`/`pullbackUnitIso`/`pullbackObjUnitToUnit_comp` all PROVEN.
- **Terminal `TensorObjInverse.lean` GREEN-mod-sorry (4).** Sorries: S3 `dual_restrict_iso_restrict_compat`
  (L1099), S4a `dual_unit_iso_restrict_compat` (L1123), S4b `tensorObj_unit_iso_restrict_compat` (L1139),
  `trivialisation_restrict_compat` (L1270). **S2 CLOSED iter-054** (5→4, tensor flank, B1-route, sorry-free).

## iter-055 finding — the S4b blueprint route was MATHEMATICALLY WRONG; corrected this iter

- **Root cause (planner-diagnosed from Lean + confirmed by blueprint-reviewer):** the prior S4b blueprint
  proof routed `tensorObj_unit_iso_restrict_compat` through Bridge B1 / `pullbackTensorMap` "as the unit
  evaluation of the base-change tensor comparison." This is FALSE. `tensorObj_unit_iso` (root
  `TensorObjSubstrate.lean:310`) is defined as `sheafification.mapIso (λ_ 𝟙_) ≪≫ counit` — the sheafified
  **presheaf left unitor at the unit**, NOT pullback-based (unlike `tensorObj_restrict_iso`, root L477,
  which IS pullback-based — why B1 applied to S2 but not S4b). The iter-054 prover correctly hit this wall.
- **Corrective executed this iter (NOT a re-dispatch of the same recipe):** mathlib-analogist (api-alignment,
  `analogies/s4b-unitor.md`) → blueprint-writer rewrote the S4b proof → blueprint-clean → blueprint-reviewer.
- **HARD GATE: PASS (blueprint-reviewer iter-055).** S4b is now complete + correct + adequate; its two
  non-trivial inputs (δ-leg = S2, η-leg = S4c) are both genuinely sorry-free in Lean (L1027, L1146); no
  circularity; `\uses` graph clean. The chapter's only remaining correctness gaps are confined to the
  deferred S3/S4a (dual-B1 gap, honestly flagged). So S4b proceeds; S3/S4a stay deferred.
- **progress-critic (iter-055): CONVERGING, dispatch=OK.** Tensor-flank squares route is closing (S2 closed
  iter-054; S4b now on a correct route).

## Decision (iter-055) — `prove` lane on S4b via the CORRECTED bespoke unitor-coherence route

- **Chosen:** one prover on `TensorObjInverse.lean`, target S4b, via the rewritten blueprint route. NOT a
  fresh untouched recipe — the route is concrete (analogist + writer) and both legs are proven.
- **NOT effort-break (yet):** this is the FIRST prove pass on the *corrected* S4b route; the iter-054
  attempt was on a WRONG blueprint, so it does not count as a churning signal for the real route. The route
  has a clean internal seam (inner presheaf-unitor seam vs outer sheafify+counit seam) the prover can split
  if needed. If THIS pass stalls with no structural advance → effort-break those two seams next iter.
- **Reversal signal:** S4b still sorry with no compiling partial progress on either seam → effort-break.

## Current Objectives

1. **`AlgebraicJacobian/Picard/TensorObjInverse.lean`** — **TERMINAL lane, SOLO. Close the TENSOR-flank
   square S4b `tensorObj_unit_iso_restrict_compat` (L1139) via the CORRECTED bespoke unitor-coherence route.**
   Blueprint: `chapters/Picard_TensorObjSubstrate.tex` (consolidated; `% archon:covers …/TensorObjInverse.lean`;
   S4b = `lem:tensorobj_unit_iso_restrict_compat`, proof block REWRITTEN iter-055 L7568+). Analogist route:
   `analogies/s4b-unitor.md`.
   - **The route (do NOT use Bridge B1 — `tensorObj_unit_iso` is NOT pullback-based):**
     1. Peel `tensorObj_unit_iso = sheafification.mapIso (λ_ 𝟙_) ≪≫ counit` (root def L310). Both U- and
        V-built contractions have this shape; restriction along `j` commutes through the outer sheafification
        + counit legs by functoriality. Split into an INNER presheaf-unitor seam + an OUTER sheafify–counit seam.
     2. **Inner seam:** push the presheaf left unitor `λ_ 𝟙_` past restriction using the SHAPE of Mathlib's
        monoidal-functor left-unitor coherence `Functor.Monoidal.map_leftUnitor` /
        `Functor.OplaxMonoidal.left_unitality_hom` [verified — `Mathlib.CategoryTheory.Monoidal.Functor`]
        (`F(λ_) = δ ; (η ▷ FX) ; λ_`). The restriction functor carries NO `Functor.Monoidal` instance, so use
        this ONLY as the proof shape, instantiated by hand: δ-leg = `tensorObj_restrict_iso j 𝒪 𝒪` whose
        restriction-naturality is S2 `tensorObj_restrict_iso_restrict_compat` [verified sorry-free L1027];
        η-leg = `unitRestrictIso j` / `pullbackUnitIso` whose coherence is S4c
        `trivialisation_uIota_restrict_compat` [verified sorry-free L1146].
     3. **Outer seam (formal):** close via `Functor.mapIso` / `toSheafify` naturality [`toSheafify_naturality`
        expected] and `sheafificationAdjunction.counit` naturality (`counit` is a `NatTrans` — naturality free).
        This is the SAME idiom already used in this file for the B1-crux engine and `dualIsoOfIso`
        (`sheafification.mapIso` of a presheaf construction) and the dual-side `presheafDualUnitIso_naturality`.
   - **Reuse:** the 9 helpers added iter-054 (`tensorObj_functoriality_comp`/`_comp3`,
     `pullbackTensorMap_restrict_cancel`, `restrictFunctorIsoPullback_comp_compat_leg`, etc.) and the
     whnf-seam idiom (prefer `exact`/`refine` of a FULLY-APPLIED generic lemma over `erw`/placeholder-`refine`
     on sheafification-carrier goals; isolate any seam `erw` into a small helper).
   - **Soft note (blueprint-reviewer iter-055):** the proof prose mentions `ρ = restrictCompReindex`, but the
     frozen Lean S4b statement has no such binder (`_hjι` is unused) — for the FIXED unit the reindexing is
     absorbed into `unitRestrictIso`; the itemized δ/η legs are the operative guide.
   - **Attempt to completion.** If stuck, leave compiling partial progress + name which seam (inner unitor vs
     outer sheafify–counit) is unclosed — NOT a fresh untouched sorry.
   - **AUTHORITATIVE = `lake build AlgebraicJacobian.Picard.TensorObjInverse` EXIT 0, NOT LSP.** Across the
     `SheafOfModules ≫` defeq-not-syntactic seam apply category lemmas TERM-MODE (`Eq.trans`/`congrArg`/
     `exact`); `rw [Category.assoc]`/`rw [Functor.map_comp]` MISS, `erw [Category.assoc]` whnf-bombs.
     DEAD probes (do NOT retry): `restrictFunctorComp.hom.naturality`; subst/rcases on `hVU:V≤U`;
     `simp[restrictIsoUnitOfLE]`; `congr 1`/`Iso.eq_inv_comp`/`Hom.ext`; NEVER `ext` a conjugate goal.
   [prover-mode: prove]

## Deferred this iter (NOT prover objectives)

- **S3 `dual_restrict_iso_restrict_compat` (L1099) + S4a `dual_unit_iso_restrict_compat` (L1123)** — BLOCKED on
  the confirmed dual-B1 gap (no `pullbackDualMap`/internal-hom base-change cone exists). Strategy decision
  pending: build the dual cone OR adopt the analogist's `Functor.Monoidal (pullback φ)` refactor (it would
  supply the dual-B1 cone too — see STRATEGY open questions). To be taken AFTER S4b lands. Do NOT dispatch here.
- **`trivialisation_restrict_compat` (L1270)** — telescope of all 5 squares; gated transitively.
- **Consumer seed-3 `PicSharp.addCommGroup_via_tensorObj` (`RelPicFunctor.lean`)** — not in Lean; gated on the
  terminal close. `map_add` ← seed-1; `map_zero` ← `pullbackUnitIso`; inverse ← `exists_tensorObj_inverse`.
- **Coverage / file-split debt:** ~114 isolated `lean_aux` nodes (incl. iter-054's 9 helpers);
  `TensorObjSubstrate.lean` (>4800 LOC) split — scheduled cleanup phase after the terminal lands.
- **AJC Lan-decomposition block** — NOT ported (dead code; not in any seed cone).
- **Extraction note:** module names / paths / labels unchanged from the parent for clean merge-back.
