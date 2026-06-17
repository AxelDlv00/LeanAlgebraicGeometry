# Blueprint-writer directive — slug `avr-lane-e-recipe`

## Chapter

`blueprint/src/chapters/AbelianVarietyRigidity.tex`

## Strategy context

Lane E (AbelianVarietyRigidity) is **STUCK** per iter-196 progress-critic.
**5 iters, 0 closures, 9 helpers accumulated**. The analogist recipe at
`analogies/lane-e-proj-appiso-pivot.md` (cross-domain-inspiration mode,
verdict ANALOGUE_FOUND iter-195) identifies the close via
`IsAffineOpen.fromSpec_app_self` mirrored as `Proj.awayι_app_basicOpen`
— but iter-195 prover dispatch errored API 529 before execution, AND
the four preceding iters added 9 helpers without producing a closure.

The progress-critic's primary corrective is **explicit Lean API
specification in the blueprint**. The analogist file is too long
(407 LOC) and is buried under cross-domain prose; the prover needs
the recipe in the BLUEPRINT, with named Mathlib lemmas and explicit
`have`-goal sequences, to convert the analogy into a prover-executable
plan.

## What you must add

In `AbelianVarietyRigidity.tex`, add a new subsection that documents
the Lane E close recipe. Locate it inside the existing chart-bridge
section that discusses `kbarChart1Ring_specMap_fac` (search for that
identifier in the chapter; the relevant area is around the iter-187
Lane E narrative).

Place the new subsection at an appropriate point in the existing
chart-bridge section discussion (preferably AFTER the prose describing
the chart-bridge's iter-188-194 STUCK history and BEFORE the file-end
material).

### New subsection: `\subsection{Iter-195 analogist recipe — `Proj.awayι_app_basicOpen` port}`

This subsection contains 3 new `\lemma` or `\definition` blocks
mirroring the analogist's recipe at
`analogies/lane-e-proj-appiso-pivot.md` (read this file in full first;
it has the substantive math).

#### Lemma 1: `Proj.awayι_app_basicOpen` — port of `IsAffineOpen.fromSpec_app_self`

`\lean{AlgebraicGeometry.Proj.awayι_app_basicOpen}`

Mathematical content (prose, NO Lean code):

For a graded ring `𝒜 : ℕ → σ` (in `A`), a homogeneous element
`f ∈ 𝒜 m` of positive degree `m > 0`, the canonical Spec-morphism
`Proj.awayι 𝒜 f f_deg hm : Spec(HomogeneousLocalization.Away 𝒜 f) ⟶ Proj 𝒜`
factors through the basic open `D₊(f) ⊂ Proj 𝒜`. Its section-level map at
`U = D₊(f)` (`(Proj.awayι 𝒜 f f_deg hm).app (Proj.basicOpen 𝒜 f)`) admits
an explicit formula:

```
(Proj.awayι 𝒜 f f_deg hm).app (Proj.basicOpen 𝒜 f)
  = (Proj.basicOpenIsoAway 𝒜 f f_deg hm).inv ≫
    (Scheme.ΓSpecIso _).inv ≫
    (Spec _).presheaf.map (eqToHom (by simp [opensRange_awayι])).op
```

The proof MIRRORS the proof of `IsAffineOpen.fromSpec_app_self` in
Mathlib (`Mathlib/AlgebraicGeometry/AffineScheme.lean:560-564`) and
proceeds in 4 steps:

1. Unfold `awayι 𝒜 f f_deg hm = basicOpenIsoSpec.inv ≫ basicOpen.ι`
   via the standard `Proj.awayι_eq_isoSpec_ι_comp` (or its iter-195
   analogist-named equivalent). Apply `Scheme.Hom.comp_app`:
   `(g₁ ≫ g₂).app U = g₂.app U ≫ g₁.app(g₂⁻¹ᵁ U)`.

2. The preimage `basicOpen.ι ⁻¹ᵁ basicOpen 𝒜 f = ⊤` (because
   `basicOpen.ι` is the open embedding of `D₊(f)` into `Proj 𝒜` —
   pulling back `D₊(f)` to itself gives the whole subscheme).
   Hence `(basicOpen.ι).app(basicOpen 𝒜 f) = (Proj 𝒜).presheaf.map
   (eqToHom).op`.

3. `basicOpenIsoSpec.inv.app ⊤ = (basicOpenToSpec.app ⊤)⁻¹` by
   `basicOpenIsoSpec_hom`. Then Mathlib's
   `basicOpenToSpec_app_top` at
   `Mathlib/AlgebraicGeometry/ProjectiveSpectrum/Basic.lean:143` gives:
   `(basicOpenToSpec).app ⊤ = ΓSpecIso.hom ≫ awayToSection 𝒜 f ≫
   (basicOpen 𝒜 f).topIso.inv`.

4. Invert the formula in (3) and combine with (2) — the algebraic
   simplification produces exactly the RHS of the lemma statement.

LOC estimate: ~10-15 LOC.

#### Lemma 2: `Proj.awayι_appIso_top_inv_apply_isLocElem` — pointwise value of `appIso ⊤ .inv` at `isLocElem`

`\lean{AlgebraicGeometry.Proj.awayι_appIso_top_inv_apply_isLocElem}`

Mathematical content (prose):

The induced section-level isomorphism on `⊤ ⊂ Spec(HomogeneousLocalization.Away 𝒜 f)`,
`(Proj.awayι 𝒜 f f_deg hm).appIso ⊤`, evaluated in inverse direction at the
generator `isLocElem : HomogeneousLocalization.Away 𝒜 f` (equivalently
`IsLocalization.mk' (Localization.Away f) 1 ⟨f, 1, rfl⟩` for the homogeneous
case), gives a specific element of `Γ(Proj 𝒜, D₊(f))`.

Combine `Scheme.Hom.appIso_hom` from
`Mathlib/AlgebraicGeometry/OpenImmersion.lean:199` with Lemma 1
(`Proj.awayι_app_basicOpen`) and apply `Iso.eq_inv_apply` to reduce
the inverse-evaluation to the forward equation:

```
basicOpenIsoAway.hom (HomogeneousLocalization.mk_isLocElem)
  = (awayι 𝒜 f).app(basicOpen 𝒜 f) (isLocElem)
```

The forward equation evaluates by `awayToSection_apply`
(`Mathlib/AlgebraicGeometry/ProjectiveSpectrum/Scheme.lean`) — closed
form on `IsLocalization.map _ HomogeneousLocalization.val`.

LOC estimate: ~5-10 LOC.

#### Lemma 3: `kbarChart1Ring_specMap_fac_close` — consumer of Lemmas 1+2

(This is not a new declaration; it's the consumer of the analogist
recipe at `AlgebraicJacobian/AbelianVarietyRigidity.lean:273`. Document
in prose how the iter-196 prover will use Lemmas 1+2 to close the
existing `kbarChart1Ring_specMap_fac` sorry.)

Mathematical content (prose):

The existing typed sorry at `AbelianVarietyRigidity.lean:273` in
`kbarChart1Ring_specMap_fac` reduces, after Lemma 2 is in scope, to a
forward equation between two ring-map expressions on `appTop`. The
prover dispatches via `simp only [Proj.awayι_appIso_top_inv_apply_isLocElem]`
to rewrite the LHS into the closed form supplied by Lemma 2, then
finishes via `ext_of_isAffine` + `awayToSection_apply` to identify the
RHS.

LOC estimate at consumer site: ~5-10 LOC.

### Source citations

The recipe is a 1:1 port of Mathlib's `IsAffineOpen.fromSpec_app_self`
(verified by the iter-195 mathlib-analogist `lane-e-proj-appiso-pivot`,
cross-domain-inspiration mode). Cite this:

```
% SOURCE: Mathlib `Mathlib/AlgebraicGeometry/AffineScheme.lean:560-564`
% (the `IsAffineOpen.fromSpec_app_self` formula) and
% `Mathlib/AlgebraicGeometry/ProjectiveSpectrum/Basic.lean:143-185`
% (the `basicOpenToSpec_app_top` + `basicOpenIsoSpec` + `basicOpenIsoAway`
% chain). Read by the iter-195 mathlib-analogist
% `lane-e-proj-appiso-pivot` (cross-domain-inspiration mode);
% verdict ANALOGUE_FOUND.
```

No new external sources needed; no reference-retriever dispatch
required.

## What you must NOT do

- Do NOT add or remove any `\leanok` or `\mathlibok` markers.
- Do NOT modify any Lean file.
- Do NOT touch other chapters.
- Do NOT alter or summarise the existing iter-187/188/192/193/194
  history narrative in the chapter — those are informational notes
  the project keeps for review purposes.

## Verification step

The blueprint should compile (LaTeX syntactically valid). The 2 new
`\lean{...}` pins (`Proj.awayι_app_basicOpen` and
`Proj.awayι_appIso_top_inv_apply_isLocElem`) name NEW declarations the
iter-196 prover will land.

## Report shape

In `task_results/blueprint-writer-avr-lane-e-recipe.md`:
- LOC delta of the chapter (one number).
- The 2 new `\lean{...}` pins introduced.
- One paragraph per lemma describing the structure of the proof sketch
  and the named Mathlib substrate it invokes.

Out-of-scope items reported under `## Strategy-modifying findings`
ONLY if the rewrite surfaces a strategic issue.
