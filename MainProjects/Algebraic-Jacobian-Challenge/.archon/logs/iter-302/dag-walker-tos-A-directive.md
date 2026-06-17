# DAG Walker Directive

## Slug
tos-A

## Seed
lem:tensorobj_inverse_invertible
(`AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse`, the goal of the
`Picard_TensorObjSubstrate` chapter — its cone is the pullback/sheafification/
tensor-comparison machinery.)

## Mission (the USER's explicit directive this iteration)
The user has flagged that **54 Lean helper declarations** in
`AlgebraicJacobian/Picard/TensorObjSubstrate.lean` and `.../DualInverse.lean`
are **isolated lean-aux nodes** (no blueprint entry, `\uses` in/out = 0) and must
be **connected to the graph by adding the correct dependencies**. You handle the
**first cluster** (sheafification / pullback-comparison / tensor-iso machinery)
in `TensorObjSubstrate.lean`. A sibling walker handles the change-of-rings/μ +
Pic cluster, and another handles `DualInverse.lean`. **Stay within the names listed
below** — the other clusters are out of scope to avoid same-file clobbering.

Several of these helpers are already DESCRIBED in prose inside existing proof
bodies of this chapter (with an inline `\lean{}` mid-proof). leandag does **not**
register an inline `\lean{}` as covering a declaration — only the FIRST `\lean{}`
of a `\label`'d block counts. So for each helper you must create its **own**
`\label`'d block (lifting any existing prose into the statement/proof), and then
**wire the existing consumer block(s) to `\uses{}` the new label.** Wiring the
consumers is the whole point: a covered helper that nothing `\uses{}` is still
isolated.

## Targets — create a blueprint block for EACH (all in `TensorObjSubstrate.lean`)
For each: a `\begin{lemma}`/`\begin{definition}` with `\label{...}`, a single
statement-level `\lean{AlgebraicGeometry.Scheme.Modules.<name>}`, an accurate
`\uses{}` (read the **Lean body** — its real invoked project lemmas/instances are
the ground truth), and a `\begin{proof}` that for the sorry-free ones is a short
"Proved directly in Lean — <one-line shape>." note, and for the ONE `sorry`-bodied
node below is a genuine informal proof sketch.

Sorry-free (write a one-line "proved directly in Lean" note + correct `\uses{}`):
- `sheafificationCompPullback_comp`
- `sheaf_unit_comp_pushforward_pullbackComp_inv`
- `pullbackComp_δ`
- `pullbackValIso`
- `pullbackObjUnitToUnitIso`
- `pullbackObjUnitToUnitIso_hom`
- `pullbackSheafifyUnitEtaTriangle`
- `pullback0`
- `pullback0Adjunction`
- `sheafifyTensorUnitIso`
- `sheafifyTensorUnitIso_hom_eq`
- `sheafifyTensorUnitIso_hom_eq'`
- `sheafifyUnitIso`
- `isIso_pbu_of_final`
- `isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta`
- `isIso_sheafifyDelta_unitPair_of_isIso_sheafifyEta`
- `isIso_sheafify_tensorHom_pullbackValIso`
- `W_of_isIso_sheafification`
- `tensorObj_unit_iso`
- `tensorObjIsoOfIso`
- `tensorObj_middleFour`
- `toRingCatSheafHom_comp_hom_reconcile`
- `toPresheaf_map_homMk`
- `restrictIsoUnitOfLE`

**∞ node — write a real informal proof (this is one of the 2 the user wants proven):**
- `sheafificationCompPullback_comp_tail` (`sorry`-bodied in Lean). This is the
  residual "tail" of the composition law `sheafificationCompPullback_comp` for the
  sheafification∘pullback comparison isomorphism along a composite of base ring
  maps. Mathematically: the comparison `sheafificationCompPullback φ` is the
  canonical iso identifying the two left-adjoint presentations of the pullback
  (`Adjunction.leftAdjointUniq` of the sheafified-pullback adjunction against the
  pushforward adjunction). For a composite `h ≫ f` it factors as the pasting of
  the two single-step comparisons conjugated by the pullback pseudofunctor's
  composition cell `pullbackComp`; the **tail** is the final naturality collapse
  showing the unit-comparison square (the `R1/R5` legs) commutes — i.e. that the
  two ways of transporting the adjunction unit across `pullbackComp` agree. Write
  the sketch as: unfold both sides to unit-of-adjunction components, reframe via
  the hom-set adjunction equivalence (`homEquiv`), and reduce to naturality of the
  pushforward composition iso `pushforwardComp` together with the unit naturality
  of the composite adjunction; the residual equation is then `Iso.inv_hom_id`/
  unit-coherence at the unit presheaf. This is an **internal categorical
  construction** (no external paper) — provenance line
  `\textit{Source: internal categorical construction; no external reference.}`.
  Mark its `\uses{}` with the single-step comparison `sheafificationCompPullback_comp`,
  `pullbackComp_δ`/`pullbackComp`, `pushforwardComp` coherence, and the unit
  triangle helpers in this cluster that its Lean body invokes.

## Wiring — add `\uses{}` edges into existing consumers
After creating the blocks, read each helper's Lean reverse-dependencies and add the
new labels to the `\uses{}` of the blocks that consume them. The principal
consumers already in this chapter (DO read their Lean to confirm before editing):
- `lem:tensorobj_inverse_invertible` (`exists_tensorObj_inverse`)
- `lem:pullback_tensor_map` (`pullbackTensorMap`)
- `AlgebraicGeometry.Scheme.Modules.isIso_pullbackTensorMap_of_isIso_sheafifyDelta`
  (block at ~L3462) and `pullbackTensorMap_restrict` (~L4263),
  `pullbackTensorMap_unit_isIso` (~L3806),
  `sheafificationCompPullback_eq_leftAdjointUniq` (~L4098).
Each new helper must lie on a `\uses{}` path into `lem:tensorobj_inverse_invertible`
(directly or transitively). End-state: none of your 25 new blocks is isolated.

## Depth / scope
One cluster, one file. Do NOT touch the change-of-rings/μ, Pic-quotient,
extendScalars, or `DualInverse.lean` helpers (sibling walkers own those). Do NOT
edit any protected chapter (Jacobian/AbelJacobi/Genus). Keep all edits inside
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex`.

## References
- These are internal categorical constructions of the project (the pullback/
  sheafification substrate). No external source is required for the
  "proved directly in Lean" notes. If you judge a statement needs a Mathlib anchor
  (e.g. `Adjunction.leftAdjointUniq`, `Functor.LaxMonoidal`), you MAY add a
  `\mathlibok` anchor pointing `\lean{}` at the real Mathlib declaration — only if
  it genuinely exists in that form.
