# Mathlib Analogist Report

## Mode
api-alignment

## Slug
rigidity-hfib

## Iteration
159

## Question
What is the Mathlib idiom for the fibre of a pullback projection
`Limits.pullback.snd X.hom Y.hom` over a `k̄`-rational point of `Y` — is there an existing result
(or a clean idiomatic assembly) showing this fibre is the image of the canonical slice section
`s : X → X ×_{Spec k̄} Y`? Concretely, close
`hfib : (snd X Y).left.base ⁻¹' {y₀pt} ⊆ Set.range s.base`.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Which machinery proves the fibre-over-rational-point fact (Triplet/tensor/carrierEquiv vs. `IsPullback` + `image_preimage_eq_of_isPullback`) | ALIGN_WITH_MATHLIB | major (proposal-stage) |
| How the "y₀ is a section/rational point" hypothesis enters (residue field `κ(y₀pt)=k̄` vs. `Over.w` + `tensorUnit_hom`) | ALIGN_WITH_MATHLIB | major (proposal-stage) |

**There is no single off-the-shelf lemma** "fibre of `pullback.snd` over a rational point = range
of the section" (confirmed: `loogle` on `IsPullback … Set.range` returns nothing; `Scheme.Hom.fiber`
in `Mathlib/AlgebraicGeometry/Fiber.lean` only gives `range_fiberι : range (fiberι) = f ⁻¹' {y}`,
which re-introduces the residue field of `y₀pt`). But there **is** a short, fully idiomatic
assembly that bypasses the entire tensor/residue-field computation.

## Major

Both ALIGN verdicts apply to a proof the prover is *about to write* (not shipped), so the planner
can simply adopt the idiom rather than refactor. The concern is that the iter-158 lane located the
`Triplet`/`tensor`/`carrierEquiv` API and was about to commit to it — that is the heavyweight
parallel route and should be abandoned **before** any prover round on those sub-lemmas.

- **The fibre fact**: use the `IsPullback`-level range lemma
  `AlgebraicGeometry.Scheme.Pullback.image_preimage_eq_of_isPullback`
  (`Mathlib/AlgebraicGeometry/PullbackCarrier.lean:414`):
  `(h : IsPullback fst snd f g)(s : Set X) : snd.base '' (fst.base ⁻¹' s) = g.base ⁻¹' (f.base '' s)`.
  Feed it a single pulled-back square for the slice section, built by the standard pasting
  calculus. The `Triplet`/`tensor`/`carrierEquiv` route would instead force three sub-builds —
  `κ(y₀pt) = k̄`, `Subsingleton (Spec (κ(x) ⊗_{k̄} k̄))`, and `carrierEquiv` plumbing — two of which
  are residue-field / commutative-algebra infrastructure with no off-the-shelf form. **All three
  are unnecessary.**

- **The section hypothesis**: `y₀.left ≫ Y.hom = 𝟙 S` is `rfl`-clean via
  `CategoryTheory.Over.w y₀` + `CategoryTheory.Over.tensorUnit_hom`
  (`Mathlib/CategoryTheory/Monoidal/Cartesian/Over.lean:68`, `:= rfl`). This is what makes the
  outer pasting square a pullback; the residue-field reading "`κ(y₀pt)=k̄`" is never needed.

### Concrete proof skeleton (LSP-verified lemma names, iter-159 Mathlib)

With `p₁ := pullback.fst X.hom Y.hom`, `p₂ := pullback.snd X.hom Y.hom`
(`(snd X Y).left = p₂` by `Over.snd_left`; `s : X.left ⟶ pullback X.hom Y.hom`):

1. `hsp1 : s ≫ p₁ = 𝟙 X.left` — `lift_fst` ▸ `← Over.fst_left` / `← Over.comp_left`.
2. `hsp2 : s ≫ p₂ = X.hom ≫ y₀.left` — `lift_snd` ▸ `← Over.snd_left` / `← Over.comp_left`, plus
   `(toUnit X).left = X.hom` (`Over.w (toUnit X)` + `tensorUnit_hom` + `comp_id`).
3. `hsec : y₀.left ≫ Y.hom = 𝟙 (Spec (.of kbar))` — `Over.w y₀` then `tensorUnit_hom`.
4. `houter : IsPullback (s ≫ p₁) X.hom X.hom (y₀.left ≫ Y.hom)` —
   `rw [hsp1, hsec]; exact IsPullback.of_horiz_isIso ⟨by simp⟩`.
5. `hL : IsPullback s X.hom p₂ y₀.left` —
   `IsPullback.of_right houter hsp2 (IsPullback.of_hasPullback X.hom Y.hom)`.
6. `hrange : Set.range s.base = p₂.base ⁻¹' Set.range y₀.left.base` —
   `simpa [Set.image_univ, Set.preimage_univ] using
     Scheme.Pullback.image_preimage_eq_of_isPullback hL.flip Set.univ`.
7. `rw [Over.snd_left, hrange]; exact Set.preimage_mono (Set.singleton_subset_iff.mpr ⟨ptk, rfl⟩)`.

Pasting lemmas used (all `Mathlib/CategoryTheory/Limits/Shapes/Pullback/IsPullback/Basic.lean`,
loogle-verified):
`IsPullback.of_right`, `IsPullback.of_horiz_isIso`, `IsPullback.flip`,
`IsPullback.of_hasPullback`. The orientation of step 5: `of_right` recovers the left square
`IsPullback s X.hom p₂ y₀.left` from the *outer* identity square (step 4, both legs `𝟙` hence
`IsIso`) and the canonical pullback square `IsPullback p₁ p₂ X.hom Y.hom`; its side condition is
exactly `hsp2`. Step 6 needs `.flip` so that the `image '' (preimage)` reads off `s` (not `X.hom`).

Step 6 in fact yields the **equality** `range s.base = p₂⁻¹(range y₀.left)`; with the in-scope
`Subsingleton` instance `hsub` (L131) one gets `range y₀.left = {y₀pt}` and hence
`p₂⁻¹{y₀pt} = range s.base` exactly. The required `⊆` needs only `y₀pt ∈ range y₀.left` (step 7),
so the subsingleton is not even required. **Char-free; no `[IsAlgClosed]`; no residue fields; no
tensor products** — matching the fact that the project's `hfib` carries no `[IsAlgClosed]`.

## Informational

- The `Triplet`/`tensor`/`carrierEquiv` API (`PullbackCarrier.lean:41-291`) is not "wrong" — it is
  the *fine* point-set description of a pullback (a point = a triplet `(x,y,s)` + a prime of
  `κ(x)⊗_{κ(s)}κ(y)`). It is simply the wrong granularity for a "where is the fibre" question.
  `image_preimage_eq_of_isPullback` / `exists_preimage_of_isPullback` (the *coarse* topological
  layer of the same file) are the intended tools here.
- `range_snd : Set.range (pullback.snd f g) = g ⁻¹' Set.range f` (`PullbackCarrier.lean:331`) is the
  same fact specialized to the *chosen* `Limits.pullback`; one could alternatively transport the
  iso `X.left ≅ pullback y₀.left p₂` and apply `range_snd`, but `image_preimage_eq_of_isPullback`
  on `hL.flip` is the direct `IsPullback`-level route and avoids the iso transport.

## Persistent file
- `analogies/rigidity-hfib.md` — design-rationale + full skeleton captured for future iters.

Overall verdict: no off-the-shelf lemma exists, but the project should ALIGN with the
`IsPullback` + `image_preimage_eq_of_isPullback` idiom (≈10-line char-free assembly) and abandon
the located `Triplet`/`tensor`/`carrierEquiv`+residue-field route, which would require three
unnecessary sub-builds.
