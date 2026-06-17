# DAG Walker Directive

## Slug
tensor-isolated

## Seed
chap:Picard_TensorObjSubstrate (the whole `Scheme.Modules.tensorObj` substrate chapter).
Concretely: the 54 Lean helper declarations listed below currently have **no blueprint
entry at all** (they are `lean_aux` isolated nodes — `leandag show isolated`), and 2 of
them have effort = ∞. Your job is to give every one of them a blueprint block, wire it
into the chapter, and write the 2 missing informal proofs.

## Strategy context
This chapter blueprints the A.1.c.SubT "tensor-object substrate": the construction that
gives the relative Picard sheaf `Pic_{C/k}` its abelian-group structure via tensor product
of line bundles on `Scheme.Modules` (sheaves of modules over a scheme's structure sheaf).
The chapter already covers the public API (`tensorObj`, `tensorObj_assoc_iso`,
`exists_tensorObj_inverse`, the monoidal/braiding structure, the dual). The 54 declarations
below are the internal helper lemmas/definitions the prover extracted while building that
API — they are real Lean declarations the chapter's theorems depend on, but were never
transcribed into the blueprint, so the DAG shows them as isolated.

## Depth / scope
**Add one blueprint block per Lean declaration below**, each in
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex`, with:
- a `\label{}` (use a `lem:`/`def:` slug derived from the Lean name),
- a `\lean{<full Lean name>}` annotation (names below are the exact full names),
- a concise mathematical statement (NO Lean syntax in the body — ordinary prose/LaTeX),
- a `\uses{}` listing the blueprint labels its mathematics actually depends on
  (look at the Lean source to see what it uses; reference existing chapter labels where
  possible, and the new sibling labels you create),
- a proof block. **For the 52 declarations already proved sorry-free in Lean**, a one-line
  `\begin{proof}\leanok? NO — do not add \leanok. Just: "Proved directly in Lean." \end{proof}`
  is correct and sufficient (do NOT write `\leanok`; that is a separate deterministic phase).
  For the 2 ∞ declarations, write a genuine informal proof (see below).

**Wire them in.** After adding the blocks, ensure each new block is reachable from the
chapter's public theorems: add the missing `\uses{}` edges on the consuming theorems so the
new helpers are not left isolated. The chapter's main results (`tensorObj_assoc_iso`,
`tensorObj_left_unitor`/`right_unitor`, `tensorObj_braiding`, `exists_tensorObj_inverse`,
`tensorObjOnProduct`, the dual `dual_restrict_iso`, and `pullback_tensor_map` /
`pullback_tensorObj`) are the natural consumers — connect each helper to whichever consumer
genuinely uses it.

**Also wire the over-equivalence chapter's consumer side:** the TensorObjSubstrate dual /
chart-over construction consumes `def:sheafofmodules_over_equivalence` (and
`def:linebundle_chart_over_iso`) from chapter `Picard_SheafOverEquivalence`. If a tensor-chapter
declaration's proof uses the over-equivalence (the `dual_restrict_iso` / `chartOverIso` route),
add `\uses{def:sheafofmodules_over_equivalence}` (or the precise label) on that tensor block.
This connects the over-equivalence chapter into the cone from the consumer side.

### The 54 declarations to blueprint

From `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (40):
W_of_isIso_sheafification, extendScalars, extendScalarsAdjunction, forget_map_pushforward_map,
forget₂_restrictScalars_μ_hom_tmul, isIso_pbu_of_final,
isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta,
isIso_sheafifyDelta_unitPair_of_isIso_sheafifyEta, isIso_sheafify_tensorHom_pullbackValIso,
picInv, picMul, picSetoid, pullback0, pullback0Adjunction, pullbackComp_δ,
pullbackObjUnitToUnitIso, pullbackObjUnitToUnitIso_hom, pullbackSheafifyUnitEtaTriangle,
pullbackValIso, pushforwardComp_lax_μ, pushforward_map_restrictScalars_μ_app_tmul,
pushforward_μ_eq, pushforward₀IsRightAdjoint, restrictIsoUnitOfLE, restrictScalarsId_map,
restrictScalarsIsRightAdjoint, restrictScalars_μ_app, restrictScalars_μ_app_tmul,
sheaf_unit_comp_pushforward_pullbackComp_inv, sheafificationCompPullback_comp,
sheafificationCompPullback_comp_tail (∞), sheafifyTensorUnitIso, sheafifyTensorUnitIso_hom_eq,
sheafifyTensorUnitIso_hom_eq', sheafifyUnitIso, tensorObjIsoOfIso, tensorObj_middleFour,
tensorObj_unit_iso, toPresheaf_map_homMk, toRingCatSheafHom_comp_hom_reconcile
(all with namespace prefix `AlgebraicGeometry.Scheme.Modules.`).

From `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean` (14):
`AlgebraicGeometry.Scheme.Modules.`: dualUnitRingSwap, dualUnitRingSwapHom, dualUnitRingSwapInv,
dualUnitRingSwapInv_comp_dualUnitRingSwap, dualUnitRingSwap_comp_dualUnitRingSwapInv,
image_preimage_of_le, isIso_ε_restrictScalars_appIso, isIso_ε_restrictScalars_appIso_hom,
presheafDualUnitIso, sliceDualTransportInv (∞), topSectionToHom, topSectionToHom_app;
`PresheafOfModules.`: dualUnitIsoGen, unitDualSectionEquiv.

### The 2 ∞ declarations — write genuine informal proofs

1. `AlgebraicGeometry.Scheme.Modules.sheafificationCompPullback_comp_tail`
   (in TensorObjSubstrate.lean, ~line 2536; read the docstring there). Mathematical content:
   the sheaf-level comparison isomorphism `sheafificationCompPullback`
   (`sheafify ∘ f^* ≅ f^* ∘ sheafify` for sheaves of modules) is **compatible with composition**
   of scheme morphisms `h ≫ f`. The proof recovers the two factor-comparison units as
   adjunction units (uniqueness of left adjoints), slides the `pushforwardComp` natural iso past
   them by naturality, and collapses via the composite-adjunction unit formula
   (`comp_unit_app` + unit naturality). Write this as a coherence/mate-calculus proof sketch in
   prose: it is the pseudofunctor associativity coherence for the pullback comparison, the
   "tail" obligation of `lem:pullback_tensor_map` (Sq1) — state it as such, cite the chapter's
   `lem:pullback_tensor_map` and the adjunction-mate machinery (Mathlib `Adjunction.comp`,
   `conjugateEquiv`).

2. `AlgebraicGeometry.Scheme.Modules.sliceDualTransportInv`
   (in DualInverse.lean, ~line 273; read the docstring there). Mathematical content: it is the
   **inverse map** of the slice dual-transport equivalence `sliceDualTransport` across an open
   immersion `f : Y ↪ X`. Given a dual section of `(f_* M)^∨` over the slice `Over V` on Y, it
   produces the X-slice dual section of `M^∨` over `Over (f(V))`, by the mirror of the forward
   transport conjugated by the relabelling isomorphisms from the preimage round-trip
   `f(f⁻¹(W')) = W'` (only propositional, hence the `eqToHom` conjugation) together with a
   change-of-rings reconciliation collapsing `restrictScalars` along the ring identity
   `β ∘ f.appIso = 𝟙`. Write the informal proof as: "the two triangle identities exhibiting it as
   the inverse of the constructed equivalence; the reindexing is the Beck–Chevalley base change
   of the dual along the open immersion's slice." Cite the chapter's `lem:dual_restrict_iso` /
   the dual-transport development.

## References
- `references/kleiman-picard.md` (§2 group structure on Pic via tensor of line bundles) — only
  if a statement needs a source; most of these are categorical-infrastructure helpers backed by
  Mathlib's `SheafOfModules`/`PresheafOfModules` API and need a `% SOURCE: Mathlib ...` note, not
  an external PDF. Do NOT fabricate citations; for Mathlib-backed infrastructure, note the Mathlib
  source in a `% SOURCE:` comment.

## Out of scope
- Do NOT edit any chapter other than `Picard_TensorObjSubstrate.tex`.
- Do NOT add `\leanok` markers anywhere.
- Do NOT restate or modify existing blocks except to ADD `\uses{}` edges that wire the new
  helpers into their consumers.
