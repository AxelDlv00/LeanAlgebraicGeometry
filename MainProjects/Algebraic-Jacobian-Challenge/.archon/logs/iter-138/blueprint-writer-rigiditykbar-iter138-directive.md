# Blueprint Writer Directive

## Slug
rigiditykbar-iter138

## Target chapter

blueprint/src/chapters/RigidityKbar.tex

## Strategy context

This chapter carries the M2 critical-path proof decomposition (pieces
(i)+(ii)+(iii) of the cotangent-vanishing pile). Within § Piece (i.b),
the lemma `lem:GrpObj_omega_basechange_proj` (statement at L423–469,
proof at L471–481) is the load-bearing NEEDS_MATHLIB_GAP_FILL helper
for the shear-iso globalisation (~360–710 LOC envelope per iter-137
mathlib-analogist).

The iter-137 prover lane on this lemma's Lean target
`AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_basechange_along_proj_two`
returned PARTIAL with a load-bearing **blueprint adequacy finding**: the
chapter's proof recipe prescribes a chart-by-chart approach via
`KaehlerDifferential.tensorKaehlerEquiv` + `TopCat.Presheaf.pullback`,
but does NOT anticipate that Mathlib's `PresheafOfModules.pullback` is
OPAQUE on `.obj`/`.map` (defined as `(pushforward φ).leftAdjoint`),
making the chart-by-chart route inaccessible without an intermediate
~30–60 LOC chart-unfolding helper.

The iter-137 mathlib-analogist (persistent file
`analogies/kaehler-tensorequiv-presheafpullback.md` Decision 4) flagged
this blocker and prescribed an alternative universal-property-at-
presheaf-level route via `PresheafOfModules.isoMk`, NOT chart-affine-
cover-and-glue. The iter-137 prover further validated (Attempt 2 in
`task_results/Cotangent_GrpObj.lean.md` L40–89) an inverse-direction-
via-adjunction-transpose route that bypasses `PresheafOfModules.pullback`
opacity entirely on the inverse side.

Your job: add a `% NOTE iter-137:` block in `RigidityKbar.tex` near
L471 (the start of the proof of `lem:GrpObj_omega_basechange_proj`)
that documents (a) the `PresheafOfModules.pullback` chart-opacity
blocker, (b) the two alternative closure paths the iter-137 finding
identified, and (c) the Lean docstring at
`AlgebraicJacobian/Cotangent/GrpObj.lean:479–499` as the interim Lean-
side record. The chapter's existing chart-by-chart prose recipe at
L471–480 should be **preserved** but bracketed with the NOTE so future
provers understand the recipe is informal motivation, not the actual
Lean recipe.

DO NOT delete or rewrite the existing chart-by-chart recipe; ADD the
NOTE block + a one-paragraph forward-reference to the two alternative
closure paths. Keep the lemma's statement block (L423–469) intact.

## Required content

1. **Add `% NOTE iter-137:` block at L471 (just inside the `\begin{proof}`
   of `lem:GrpObj_omega_basechange_proj`).** Document:

   - The `PresheafOfModules.pullback` chart-opacity blocker: Mathlib
     defines `PresheafOfModules.pullback φ := (PresheafOfModules.pushforward φ).leftAdjoint`,
     so `(pullback φ).obj M` has NO computable chart-wise description
     on `.obj`/`.map`. The chart-by-chart recipe prescribed in the
     surrounding paragraph requires expressing `((pullback ψ).obj M_G).obj V`
     as a tensor product for affine V, which is not direct.
   - Two alternative closure paths the iter-137 finding identified
     (cite `analogies/kaehler-tensorequiv-presheafpullback.md` for the
     5-step recipe + the Lean docstring at
     `AlgebraicJacobian/Cotangent/GrpObj.lean:479–499` for the iter-137
     analysis):

     **(a) Chart-unfolding-helper route** (~30–60 LOC for the helper +
     ~250–500 LOC for the body): build a Mathlib-shaped helper
     `pullbackObjEquivTensor` unfolding `((pullback ψ).obj M).obj V` as
     a tensor product via the `pullbackPushforwardAdjunction` unit/counit
     (left-adjoint definition + tensor-`B`-`A` shape), then run the
     5-step universal-property-at-presheaf-level recipe of
     `analogies/kaehler-tensorequiv-presheafpullback.md` (Step 1
     chart-level `Algebra.IsPushout` from `pullbackSpecIso`; Step 2
     `PresheafOfModules.pullback` chart-unfolding via the new helper;
     Step 3 chart-wise derivation `D_V` via `tensorKaehlerEquiv`; Step 4
     `KaehlerDifferential.lift` to get the morphism; Step 5
     `PresheafOfModules.isoMk` assembly). Total ~360–710 LOC.

     **(b) Inverse-direction-via-adjunction-transpose route** (~100–200
     LOC for the derivation construction + assembly): for the inverse
     direction `(pullback ψ).obj M_G ⟶ LHS`, use the
     `pullbackPushforwardAdjunction` to transpose to a morphism
     `M_G ⟶ (pushforward ψ).obj LHS`. By the universal property of
     `relativeDifferentialsPresheaf G.hom = relativeDifferentials' φ_G`
     (`DifferentialsConstruction.isUniversal'`), this corresponds to a
     `(pushforward ψ).obj LHS`-derivation of `φ_G`. The pushforward
     `(pushforward ψ).obj LHS` is **transparent** on `.obj`/`.map`
     (`pushforward` is `pushforward₀ ⋙ restrictScalars` per
     `ModuleCat/Presheaf/Pushforward.lean:39, 86`), making the
     derivation constructible pointwise. The forward direction would
     then have to be built separately (still requires the chart-
     unfolding helper, or an alternative argument that the inverse is
     an iso via local checks on presheaf-of-modules generators). The
     iter-137 prover validated route (b)'s inverse-direction skeleton
     as compiling-typeable via `lean_run_code`, reducing closure to a
     single concrete sub-goal: constructing the derivation `D`.

   - **Interim Lean-side record**: until this NOTE block is reflected
     in revised proof prose, the Lean docstring at
     `AlgebraicJacobian/Cotangent/GrpObj.lean:479–499` carries the
     authoritative iter-137 analysis. Future iter-138+ provers should
     consult both the blueprint prose AND the Lean docstring.

2. **Promote `schemeHomRingCompatibility` to a `\lean{...}` block**
   (the iter-137 `lean-vs-blueprint-checker-cotangent-grpobj-review137`
   minor finding #3). The Lean declaration at
   `AlgebraicJacobian/Cotangent/GrpObj.lean:423` is a packaging helper
   for the `adj.homEquiv.symm f.c` shape used by
   `relativeDifferentialsPresheaf`'s scheme-morphism inputs. The
   pointer chapter (`AlgebraicJacobian_Cotangent_GrpObj.tex` L34–42)
   mentions it informally; promote it to a proper `\lemma` or
   `\definition` block under `RigidityKbar.tex` § Piece (i.b) — either
   as a standalone lemma block (with `\lean{AlgebraicGeometry.GrpObj.schemeHomRingCompatibility}`)
   or as a sub-paragraph of the existing piece (i.b) prose. Brief
   description (1–2 sentences in math, no Lean syntax): for a
   scheme morphism `f : X ⟶ Y`, this packages the canonical map
   `(snd Y X)*  → (snd Y X)^* f` of structure presheaves used as the
   compatibility input to `relativeDifferentialsPresheaf`'s adjunction
   recipe. Aim for ~10–20 LOC of LaTeX.

## Out of scope

- Do NOT delete or rewrite the chapter's existing chart-by-chart prose
  recipe at L471–480. The NOTE bracket adds context; the recipe stays
  as informal motivation.
- Do NOT touch the lemma's statement block (L423–469).
- Do NOT touch the rest of § Piece (i.b) (the four other lemmas:
  `lem:GrpObj_mulRight_globalises`, `lem:GrpObj_omega_restrict_to_identity_section`,
  `lem:GrpObj_omega_free`, `lem:GrpObj_omega_rank_eq_dim`).
- Do NOT touch § Piece (i.a), § Piece (i.c), § Piece (ii), § Piece (iii),
  § Use in the project, § Iter-131 Classical.choose-chain body shape.
- Do NOT touch other chapters.
- Do NOT add `\leanok` / `\mathlibok` / `\notready` markers (managed by
  `sync_leanok` and the review agent).
- Do NOT cite specific iter sidecars by path.

## References

- `analogies/kaehler-tensorequiv-presheafpullback.md` (iter-137 mathlib-
  analogist's persistent file): the 5-step universal-property-at-presheaf-
  level recipe + Decision 4 (presheaf vs sheaf hazard, NOT chart-affine-
  cover-and-glue) + Decision 5 (LOC envelope refinement to ~250–500 LOC).
- `analogies/mulright-globalises-cotangent.md` (iter-133 mathlib-analogist):
  parent lemma decomposition + Decision 2 originally identifying this gap.
- `analogies/phi-compatibility-morphisms.md` (iter-135 mathlib-analogist):
  the `Scheme.Hom.toRingCatSheafHom` canonical idiom (relevant for the
  `schemeHomRingCompatibility` promotion target).
- `AlgebraicJacobian/Cotangent/GrpObj.lean:479–499` (the Lean docstring
  capturing the iter-137 PARTIAL analysis).
- `task_results/Cotangent_GrpObj.lean.md` Attempt 2 (the iter-137 prover
  task result, lines 40–89): the validated-as-compiling-typeable inverse-
  direction skeleton.

## Expected outcome

After your edits, the chapter at `RigidityKbar.tex` near L471 contains a
`% NOTE iter-137:` block (~30–60 LaTeX lines, mathematical prose, no
Lean syntax) bracketing the existing chart-by-chart recipe with: (a) the
chart-opacity blocker, (b) the two alternative closure paths, (c) a
forward-reference to the Lean docstring as the interim authoritative
record. The chapter additionally carries a new `\lemma` or `\definition`
block for `schemeHomRingCompatibility` (~10–20 LaTeX lines) somewhere in
§ Piece (i.b) prose. All existing prose at L423–481 is preserved; no
other chapter is touched.
