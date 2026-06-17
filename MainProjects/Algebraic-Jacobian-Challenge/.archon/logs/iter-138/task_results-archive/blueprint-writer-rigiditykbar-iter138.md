# Blueprint Writer Report

## Slug

rigiditykbar-iter138

## Status

COMPLETE

## Target chapter

blueprint/src/chapters/RigidityKbar.tex

## Changes Made

- **Added definition block** `def:GrpObj_schemeHomRingCompatibility` with
  `\lean{AlgebraicGeometry.GrpObj.schemeHomRingCompatibility}` at the
  end of `\cref{lem:GrpObj_mulRight_globalises}`'s proof and before
  `\cref{lem:GrpObj_omega_basechange_proj}`. Captures the
  adjunction-transpose compatibility morphism
  $\varphi_f : f_{\mathrm{top}}^{-1}\,\mathcal O_Z \to \mathcal O_Y$ of
  structure presheaves of rings along a scheme morphism $f \colon Y \to Z$,
  obtained as the symmetric direction of the
  $f_{\mathrm{top}}^{-1} \dashv (f_{\mathrm{top}})_{*}$ adjunction on
  $\mathrm{CommRingCat}$-valued presheaves of $f.c$, mirroring the
  `Differentials.lean:52` `φ'` construction. (~10 LOC.)
- **Added companion remark** `rem:GrpObj_schemeHomRingCompatibility_vs_toRingCatSheafHom`
  contrasting `\varphi_f` (used by `relativeDifferentialsPresheaf`'s
  ring-side input) with the `(Scheme.Hom.toRingCatSheafHom _).hom`
  compatibility morphism that `PresheafOfModules.pullback` expects (used
  in `\cref{lem:GrpObj_omega_basechange_proj}` and
  `\cref{lem:GrpObj_omega_restrict_to_identity_section}`). Records the
  iter-135 mathlib-analogist verdict on the canonical Mathlib idiom for
  the latter. (~7 LOC.)
- **Added `% NOTE iter-137:` block** inside `\begin{proof}` of
  `lem:GrpObj_omega_basechange_proj`, between the existing `\leanok` /
  `\uses{...}` lines and the surviving chart-by-chart prose recipe. The
  block documents:
  - The `PresheafOfModules.pullback` chart-opacity blocker (Mathlib's
    definition `(pullback φ).obj := (pushforward φ).leftAdjoint.obj` is
    abstract; no computable chart-wise description on `.obj`/`.map`).
  - Presheaf-vs-sheaf hazard (no sheafification, so chart-wise
    `Algebra.IsPushout` doesn't lift directly to non-affine opens).
  - **Route (a):** chart-unfolding-helper route — build a stand-alone
    `pullbackObjEquivTensor` helper (~30–60 LOC) unfolding `((pullback
    φ).obj M).obj V` as a tensor product via the
    `pullbackPushforwardAdjunction` unit/counit, then execute the
    iter-137 mathlib-analogist's 5-step recipe (chart-level
    `Algebra.IsPushout` → `pullback` chart-unfold → chart-wise derivation
    $D_V$ → `KaehlerDifferential.lift` → `PresheafOfModules.isoMk`).
    Total ~360–710 LOC.
  - **Route (b):** inverse-direction-via-adjunction-transpose route —
    transpose `(pullback ψ).obj Ω_{G/k} → Ω_{(G⊗G)/G}` to `Ω_{G/k} →
    (pushforward ψ).obj Ω_{(G⊗G)/G}`, observe `pushforward ψ` is
    *transparent* (`pushforward₀ ∘ restrictScalars`, both `@[simps]`),
    apply `DifferentialsConstruction.isUniversal'` to extract the
    correspondence as a pointwise-constructible derivation. Iter-137
    prover validated typeability via `lean_run_code`; sub-goal reduces
    to constructing the derivation $D$. Forward direction still blocked
    by same `pullback` opacity. ~100–200 LOC for the inverse alone.
  - **Interim Lean-side record:** points to the Lean docstring at
    `AlgebraicJacobian/Cotangent/GrpObj.lean:479–499` as the
    authoritative iter-137 analysis until this NOTE is reflected in
    revised prose. Tells iter-138+ provers to consult both the
    blueprint AND the docstring; the surviving chart-by-chart recipe is
    informal motivation only. (~140 LaTeX lines for the whole NOTE
    block.)

The pre-existing statement block of `lem:GrpObj_omega_basechange_proj`
(L423–469 in the pre-edit file, L440–486 after the new definition +
remark) is **unchanged**. The chart-by-chart prose recipe at L474–480
(post-edit L631–637) is **preserved verbatim**. No other lemma in §
Piece (i.b), § Piece (i.a), § Piece (i.c), § Piece (ii), § Piece (iii),
§ Use in the project, or § Iter-131 Classical.choose-chain body shape
is touched.

## Cross-references introduced

- `\uses{def:GrpObj_schemeHomRingCompatibility}` added to the
  `\begin{proof}` of `lem:GrpObj_omega_basechange_proj`. The new
  definition exists in the same chapter (above the proof).
- `\uses{def:relative_kaehler_presheaf}` added to
  `def:GrpObj_schemeHomRingCompatibility`. Existing label
  `def:relative_kaehler_presheaf` lives in `Differentials.tex`
  (verified via grep below); cross-chapter `\uses` of that label is
  already used elsewhere in `RigidityKbar.tex` (e.g. inside the proof
  of `lem:GrpObj_omega_basechange_proj` itself), so the reference is
  consistent with the established pattern.
- `\uses{def:GrpObj_schemeHomRingCompatibility}` added to
  `rem:GrpObj_schemeHomRingCompatibility_vs_toRingCatSheafHom`. Same
  chapter.

(Grep verification: `def:relative_kaehler_presheaf` is defined at
`blueprint/src/chapters/Differentials.tex:14` — established label.)

## Macros needed (if any)

None. All commands used (`\cref`, `\lean`, `\uses`, `\label`,
`\texttt`, `\emph`, `\textbf`, `\mathcal`, `\mathrm`, `\Spec`,
`\Omega_`, `\Over`, `\pr`, `\sharp`, `\dashv`, `\sim`, etc.) are
already in use in this chapter.

## Reference-retriever dispatches (if any)

None. All references named in the directive
(`analogies/kaehler-tensorequiv-presheafpullback.md`,
`analogies/mulright-globalises-cotangent.md`,
`analogies/phi-compatibility-morphisms.md`,
`AlgebraicJacobian/Cotangent/GrpObj.lean:479–499`,
`task_results/Cotangent_GrpObj.lean.md` Attempt 2) were already on
disk and were consulted during drafting. No external source needed.

## Notes for Plan Agent

- The new `% NOTE iter-137:` block bracketing the chart-by-chart recipe
  is large (~140 LaTeX lines including the bullet list). If a future
  iteration revises the proof prose to reflect the actual Lean recipe
  (either Route (a) or Route (b)), the NOTE block can be collapsed or
  removed.
- The pointer chapter `AlgebraicJacobian_Cotangent_GrpObj.tex:34–42`
  still describes `schemeHomRingCompatibility` informally. Now that
  `RigidityKbar.tex` carries the proper `\definition` block, the
  pointer-chapter description could be tightened to a simple cross-
  reference (`\cref{def:GrpObj_schemeHomRingCompatibility}`), but the
  directive forbade touching other chapters — leaving the pointer
  chapter's informal description for the next blueprint-reviewer round.
- The pre-edit `lem:GrpObj_omega_basechange_proj` proof block already
  carries a `\leanok` marker (L473 pre-edit, L490 post-edit). Since the
  Lean body is `sorry`, `sync_leanok` will remove this — and the
  surrounding statement block already carries `\notready`. This is the
  same state as before my edit; I did not touch the marker.
- The new `def:GrpObj_schemeHomRingCompatibility` block has no
  `\leanok` marker. The Lean target `schemeHomRingCompatibility` is a
  closed-form `noncomputable def` (no `sorry`); `sync_leanok` will add
  `\leanok` on its next run if appropriate.

## Strategy-modifying findings

None. The added prose surfaces tactical infrastructure decisions
(Route (a) vs Route (b) for the load-bearing helper), not strategy-
level shifts. The over-all M2.a strategy (cotangent-vanishing pile
pieces (i)+(ii)+(iii); piece (i.b) via the shear iso + base-change-of-Ω
helper + section-restriction helper + compose main lemma) is
unchanged.
