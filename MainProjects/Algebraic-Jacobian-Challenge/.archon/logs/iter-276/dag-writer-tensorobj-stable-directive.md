# Blueprint-writer directive — Picard_TensorObjSubstrate.tex (STABLE-file 1-to-1 coverage)

## Chapter
- Slug: `Picard_TensorObjSubstrate`
- File: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

## Goal of this dispatch (narrow, additive, mechanical)

Add **1-to-1 "Proved directly in Lean" coverage blocks** for exactly the **69
internal helper declarations** listed below. Every one is **sorry-free in Lean**
(I verified: 0 sorries in all three source files). They currently have no
`\lean{}`-pinned blueprint block, so `leandag` reports them as uncovered
`lean-aux`. This dispatch closes that coverage debt for the three *stabilised*
source files of the TensorObj substrate.

This is purely additive coverage. **Do not rewrite, restructure, or delete any
existing block.** Append your new blocks; wire them into existing prose only via
`\uses{}`.

## CRITICAL scope boundary — do NOT touch the two churning files

The consolidated chapter covers five Lean files. Two of them
(`TensorObjSubstrate.lean`, `DualInverse.lean`) were edited **today** by an active
prover lane and still carry sorries; their internal helper names turn over each
iteration. **Do NOT add coverage blocks for any declaration from those two files.**
Concretely, do **not** create blocks for names such as `pullbackComp_δ`,
`sheafifyTensorUnitIso`, `pullback0`, `extendScalars`, `restrictScalars_μ_app`,
`dualUnitRingSwap`, `sliceDualTransportInv`, `presheafDualUnitIso`,
`isIso_ε_restrictScalars_appIso`, `topSectionToHom`, etc. Those are deliberately
deferred until their prover lane stabilises. Cover **only** the 69 names listed
below.

## The three stabilised source files and their exact declarations

Read each Lean file to extract the faithful mathematical statement of each
declaration (signature + docstring). Use the **fully-qualified Lean name** below
verbatim in each block's `\lean{...}`.

### Group A — `AlgebraicJacobian/Picard/TensorObjSubstrate/PresheafInternalHom.lean` (32)

The sheaf internal-hom machinery for `O_X`-modules (the ⊗-inverse construction):
restrict-scalars monoidal transport along a ring iso, the global-section scalar
action on a presheaf of modules, the internal-hom presheaf and its restriction
maps, the evaluation linear map, and the lax-monoidal structure maps.

```
PresheafOfModules.InternalHom.globalSMul
PresheafOfModules.InternalHom.globalSMul_one
PresheafOfModules.InternalHom.globalSMul_zero
PresheafOfModules.InternalHom.globalSMul_add
PresheafOfModules.InternalHom.globalSMul_mul
PresheafOfModules.InternalHom.globalSMul_hom_apply
PresheafOfModules.InternalHom.hom_app_heq
PresheafOfModules.InternalHom.internalHomPresheaf
PresheafOfModules.InternalHom.restr
PresheafOfModules.InternalHom.restrictionMap_id
PresheafOfModules.InternalHom.restrictionMap_comp
PresheafOfModules.InternalHom.restrictionMap_comp_hom
PresheafOfModules.InternalHom.restrictionMap_add
PresheafOfModules.InternalHom.restrictionMap_zero
PresheafOfModules.InternalHom.restrictionMap_smul
PresheafOfModules.InternalHom.restrictionMap_globalSMul
PresheafOfModules.InternalHom.restrictionMapAddHom
PresheafOfModules.InternalHom.termRingMap
PresheafOfModules.InternalHom.termRingMap_naturality
PresheafOfModules.InternalHom.termRingMap_terminal
PresheafOfModules.evalLin
PresheafOfModules.evalLin_add
PresheafOfModules.evalLin_smul
PresheafOfModules.internalHomEvalApp
PresheafOfModules.internalHomEvalApp_tmul
PresheafOfModules.pushforwardCongr_hom_app_app
PresheafOfModules.pushforwardCongr_inv_app_app
PresheafOfModules.pushforwardNatTrans_app_app_apply
PresheafOfModules.restr_map_homMk
PresheafOfModules.restrictScalarsLaxε
PresheafOfModules.restrictScalarsLaxμ
restrictScalarsRingIsoTensorEquiv_apply_tmul
```

### Group B — `AlgebraicJacobian/Picard/TensorObjSubstrate/StalkTensor.lean` (24)

The varying-ring stalk–tensor commutation substrate: the balanced bilinear map
on stalks, the descent of the tensor product through germs, and the "reverse"
inner/outer-leg bookkeeping used to identify the two stalk-of-tensor maps.

```
PresheafOfModules.stalkTensorBilin
PresheafOfModules.stalkTensorBilin_balanced
PresheafOfModules.stalkTensorDescU
PresheafOfModules.stalkTensorDescU_tmul
PresheafOfModules.stalkTensorDescU_smul
PresheafOfModules.stalkTensorDesc_germ
PresheafOfModules.stalkTensorDesc_germ_tmul
PresheafOfModules.germ_stalkTensorDesc
PresheafOfModules.germ_tensorObj_map_tmul
PresheafOfModules.stalkTensorLinearMap_germ_tmul
PresheafOfModules.stalkTensorRev
PresheafOfModules.stalkTensorRev_germ_tmul
PresheafOfModules.revBihom
PresheafOfModules.revBihom_balanced
PresheafOfModules.revBihom_germ_tmul
PresheafOfModules.revBihom_balanced_germ
PresheafOfModules.germ_revBihom
PresheafOfModules.revInner
PresheafOfModules.revInner_germ
PresheafOfModules.germ_revInner
PresheafOfModules.revInnerLeg
PresheafOfModules.revInnerLeg_apply
PresheafOfModules.revOuterLeg
PresheafOfModules.revOuterLeg_apply
```

### Group C — `AlgebraicJacobian/Picard/TensorObjSubstrate/Vestigial.lean` (13)

Off-path sheafification-`W`-class whiskering helpers and the stalk linear-map /
local-(in)jectivity bridges (the `overEquiv` dense-subsite scaffolding).

```
PresheafOfModules.toPresheaf_whiskerLeft_app_tmul
PresheafOfModules.toPresheaf_whiskerLeft_app_apply
PresheafOfModules.isLocallySurjective_whiskerLeft
PresheafOfModules.isLocallyInjective_whiskerLeft_of_flat
PresheafOfModules.W_whiskerRight_of_flat
PresheafOfModules.W_whiskerRight_of_W
PresheafOfModules.stalkLinearMap_germ
PresheafOfModules.stalkLinearMap_bijective_of_isIso
PresheafOfModules.stalkLinearEquivOfIsIso
PresheafOfModules.isLocallyInjective_of_injective_stalk
PresheafOfModules.injective_stalk_of_isLocallyInjective
AlgebraicGeometry.Scheme.Modules.overEquivInverseIsDenseSubsite
AlgebraicGeometry.Scheme.Modules.overEquiv_image_cover_iff
```

## Block format (match the established project style)

For each declaration, emit a `\begin{definition}` (for `def`/`instance`) or
`\begin{lemma}` (for `lemma`/`theorem`) with:

- a `\label{...}` using the project's kebab convention (e.g.
  `def:internal_hom_presheaf`, `lem:stalk_tensor_desc_germ_tmul`);
- a `\lean{<fully-qualified name>}` exactly as listed above;
- a faithful one-sentence mathematical statement in prose (NO Lean syntax, NO
  code fences — only the `\lean{}` line names Lean);
- a `\begin{proof}` containing a **statement-level** `\uses{...}` of the
  blueprint labels this declaration genuinely depends on, then the single line
  `Proved directly in Lean.` (optionally one clause naming the construction,
  e.g. "the balanced bilinear map descends to the tensor product by the
  universal property").

Group the 69 blocks into **three new subsections** (A/B/C above) appended near
the chapter's existing internal-hom / stalk-tensor material (the chapter already
has a "Sheaf internal-hom" section near line 5236 and a varying-ring stalk–tensor
section near line 1875 — place Group A and Group B coverage adjacent to the
matching existing prose; Group C in a short "Vestigial / off-path helpers"
subsection). Use your judgement on exact placement; keep it readable.

## `\uses{}` wiring rule (the leandag quirk — read carefully)

`leandag` builds a dependency edge **only from a statement-level `\uses{}`** — a
`\uses{}` that sits inside `\begin{proof}` contributes the edge for the proof
relationship, which is what we want here (these are "proved in Lean" leaves whose
dependency is the construction they're built from). Put each block's `\uses{}`
inside its `\begin{proof}` referencing the labels of the constructions it uses
(the `def` it is an `_apply`/`_germ`/`_balanced` lemma about, the carrier it
restricts, etc.). **Every new block must have at least one `\uses{}` edge in or
out** so that none of them lands isolated. The lemma-about-a-def blocks should
`\uses{}` that def's label; the def blocks should `\uses{}` the prior
constructions they are built on (and an existing consumer in the chapter should,
where natural, `\uses{}` the new def — but do NOT edit protected/frozen blocks).

## Out of scope (do NOT do)

- Do NOT add `\leanok` (managed by the deterministic sync phase).
- Do NOT add blocks for `TensorObjSubstrate.lean` or `DualInverse.lean` decls.
- Do NOT edit existing blocks except to add a `\uses{}` edge to a new label where
  it is clearly the real dependency and the block is not protected.
- Do NOT fix the chapter's pre-existing `math-delim` / `literal-ref` rendering
  issues in this pass (separate task); just don't introduce new ones — use one
  delimiter style (`\( … \)`) per formula and never `\cref` a non-existent label.
- No external references needed — these are internal helpers with no external
  source, so no `% SOURCE` citation blocks are required.

## Self-check before finishing

After writing, run:
```
leandag build >/dev/null 2>&1 && leandag query --isolated --json
```
Confirm none of your 69 new labels appears in the isolated list, and that
`leandag` reports zero broken `\uses{}`. Report the before/after uncovered
`lean-aux` count for the chapter in your report.
