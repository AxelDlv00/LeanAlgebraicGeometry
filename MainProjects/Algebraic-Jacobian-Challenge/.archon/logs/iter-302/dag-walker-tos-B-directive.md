# DAG Walker Directive

## Slug
tos-B

## Seed
lem:tensorobj_inverse_invertible
(`AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse`.)

## Mission (the USER's explicit directive this iteration)
Connect the **change-of-rings / lax-monoidal-μ / `extendScalars` adjunction /
relative-Pic-quotient** cluster of isolated lean-aux helpers in
`AlgebraicJacobian/Picard/TensorObjSubstrate.lean` into the blueprint graph by
creating a `\label`'d block for each and **wiring the existing consumer blocks to
`\uses{}` them**. A sibling walker handles the sheafification/pullback cluster and
another handles `DualInverse.lean`; **stay within the names below** to avoid
same-file clobbering. (Wait — this dispatch is serialized after cluster A, so the
cluster-A blocks already exist; build on them, do not duplicate.)

leandag registers a declaration only by the FIRST `\lean{}` of a `\label`'d block,
not by an inline `\lean{}` inside a proof. So each helper needs its own block.

## Targets — create a blueprint block for EACH (all sorry-free; all in `TensorObjSubstrate.lean`)
For each: `\begin{lemma}`/`\begin{definition}` + `\label{...}` +
`\lean{AlgebraicGeometry.Scheme.Modules.<name>}` + accurate `\uses{}` read from the
**Lean body** + a `\begin{proof}` one-line "Proved directly in Lean — <shape>." note.
- `extendScalars`  — the change-of-base-ring (extension of scalars) functor on
  presheaves/sheaves of modules.
- `extendScalarsAdjunction` — `extendScalars ⊣ restrictScalars`.
- `restrictScalarsIsRightAdjoint` — `restrictScalars` is a right adjoint (instance).
- `restrictScalarsId_map` — action of `restrictScalars (𝟙)` on morphisms.
- `pushforward₀IsRightAdjoint` — the presheaf-level pushforward is a right adjoint.
- `pushforward_μ_eq` — the lax-monoidal structure map `μ` of pushforward equals the
  restrictScalars `μ` on pushforward₀ objects.
- `pushforward_map_restrictScalars_μ_app_tmul` — section/`tmul`-level formula for the
  pushforward of the restrictScalars `μ`.
- `pushforwardComp_lax_μ` — the lax-monoidal comparison `μ` for the pushforward
  composition cell ("pushforwardComp is monoidal"), the change-of-rings coherence.
- `restrictScalars_μ_app` and `restrictScalars_μ_app_tmul` — the lax-monoidal unit/
  multiplication of `restrictScalars`, at an object and on a pure tensor.
- `forget_map_pushforward_map` — the forgetful-functor image of a pushforward map
  (the STEP-1 binding reconciliation; `rfl`).
- `forget₂_restrictScalars_μ_hom_tmul` — `forget₂`-image of the restrictScalars `μ`
  hom on a pure tensor.
- `picSetoid` — the setoid (isomorphism relation) on invertible sheaves defining the
  Picard group as a quotient.
- `picMul` — the multiplication on `Pic` induced by `tensorObj`.
- `picInv` — the inverse on `Pic` induced by the dual/inverse of an invertible sheaf.

## Wiring — add `\uses{}` edges into existing consumers
Read each helper's Lean reverse-dependencies; add its new label to the `\uses{}` of
the blocks that consume it. Likely consumers already in the chapter: the
change-of-rings `μ`/`δ` lemmas around `pullbackComp_δ` /
`pushforward_μ_eq` (cluster A, now present), the monoidality lemmas feeding
`lem:pullback_tensor_map`, and — for `picSetoid`/`picMul`/`picInv` — the relative
Picard group-object construction in this chapter or the chapter goal
`lem:tensorobj_inverse_invertible`. If a `pic*` helper's natural consumer lives in
another chapter (`Picard_RelPicFunctor` / `Picard_IdentityComponent`), do NOT edit
that chapter — instead wire it to the most specific consumer present here, or note
the cross-chapter edge under "Notes for dispatcher". End-state: none of your new
blocks is isolated.

## Depth / scope
One cluster, one file. Do NOT touch the sheafification/pullback cluster (already
done by cluster A), the `DualInverse.lean` helpers, or any protected chapter. All
edits inside `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`.

## References
Internal categorical constructions; "proved directly in Lean" notes need no
external source. Genuine Mathlib results you lean on (`Adjunction`, `Functor.LaxMonoidal`,
`ModuleCat.restrictScalars`, `extendRestrictScalarsAdj`) MAY be recorded as
`\mathlibok` anchors only if they exist in Mathlib in the stated form.
