# Mathlib-analogist directive (iter-120)

Advise on the design of the cotangent presheaf of a morphism of schemes
in this project, given a real mathematical bridge issue that surfaced
in iter-119.

## Project context (minimal — no strategy bias)

The project defines, in `AlgebraicJacobian/Differentials.lean`:

```
noncomputable def relativeDifferentialsPresheaf (f : X ⟶ S) : X.PresheafOfModules :=
  let φ' := ((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat f.base).homEquiv _ _).symm f.c
  PresheafOfModules.DifferentialsConstruction.relativeDifferentials' φ'
```

i.e. it pushes the comorphism `f.c : S.presheaf → (Opens.map f.base).op ⋙ X.presheaf`
through the `(pullback ⊣ pushforward)` adjunction (presheaf-level) to a
morphism `φ' : (TopCat.Presheaf.pullback CommRingCat f.base).obj S.presheaf
→ X.presheaf`, then applies the Mathlib presheaf-of-modules differential
construction.

And the project-local lemma (`Differentials.lean:58`, body `rfl`):

```
theorem relativeDifferentialsPresheaf_obj_kaehler (f : X ⟶ S)
    (V : (TopologicalSpace.Opens X.toTopCat)ᵒᵖ) :
    ((relativeDifferentialsPresheaf f).presheaf.obj V : Type _) =
      CommRingCat.KaehlerDifferential
        (((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat
          f.base).homEquiv _ _).symm f.c |>.app V) :=
  rfl
```

identifies the section module on `V ⊆ X` with the Mathlib
`CommRingCat.KaehlerDifferential` of `φ'.app V`, whose **source ring**
is `((TopCat.Presheaf.pullback CommRingCat f.base).obj S.presheaf).obj V`,
i.e. the value at `V` of the LEFT KAN EXTENSION of `S.presheaf` along
`(Opens.map f.base).op`, which by the colimit formula is
`colim_{W : Opens S, f(V) ⊆ W} S.presheaf.obj W`.

## The bridge problem (iter-119 finding)

Smoothness `[SmoothOfRelativeDimension n f]` gives, via the auto-
generated `mk_iff` and `algebraize`, an algebra
`Algebra.IsStandardSmoothOfRelativeDimension n A B` where
`A = Γ(S, U₀)` (an affine open of S containing `f(V₀)`) and
`B = Γ(X, V₀)` (an affine open of X containing the point x).

So we have a ring map `A → B = (f.appLE U₀ V₀ e).hom`, and via the
Mathlib chain (`free_kaehlerDifferential` + `rank_kaehlerDifferential`)
`Ω[B/A]` is free of rank `n` over B.

The project's section module on `V₀` is `KaehlerDifferential
(φ'.app V₀)` where `φ'.app V₀` has source `A' = colim_{f V₀ ⊆ W} S.presheaf(W)`.
We have a canonical map `A → A' → B` (with `A → A'` being the colimit
injection at `W = U₀`, and `A' → B` being `φ'.app V₀`).

The target Kähler module is `Ω[B/A']`, NOT `Ω[B/A]`.

## What we need to know

### Q1. Is Mathlib's `TopCat.Presheaf.pullback` (left Kan extension at the presheaf level) the right idiom for building the cotangent presheaf of a morphism of schemes?

Locate Mathlib's existing way of building `Ω_{X/S}` (as a sheaf or
presheaf of modules). There are two candidates in `b80f227`:

- `AlgebraicGeometry.Scheme.Modules.relativeCotangent` (or similar) —
  is there a Mathlib-blessed cotangent sheaf for a morphism of schemes?
  If so, does it use sheafified pullback or the presheaf-level pullback?
- `PresheafOfModules.DifferentialsConstruction.relativeDifferentials'`
  — this is the building block used by the project. Is it used elsewhere
  in Mathlib for the scheme-morphism case? Or is the project's
  composition with `TopCat.Presheaf.pullback` adjunction transpose a
  pattern with no Mathlib precedent?

### Q2. What is the algebraic-geometry-correct relationship between the appLE algebra `A → B` and the colimit ring `A' = (f⁻¹_{psh} O_S)(V)`?

Specifically:
- Under `IsAffineOpen U`, `IsAffineOpen V`, `V ≤ f⁻¹ U`, is the canonical
  map `A → A' → B` such that `image(A) = image(A')` in `B`? (This would
  make the surjection `Ω[B/A] → Ω[B/A']` an iso.)
- Equivalently: is `A → A'` a "localization in some sense" (more
  precisely: is `Ω[A'/A] = 0`)? If yes, the iso `Ω[B/A] ≃ Ω[B/A']` is
  free.
- If neither of the above holds, is the iso between the Kähler modules
  still true (perhaps for a non-trivial reason), or does the project's
  current definition of `relativeDifferentialsPresheaf` not match
  `Ω_{X/S}` in the usual sense?

### Q3. Three structural options for closing iter-119's PARTIAL:

Compare these from the Mathlib-alignment perspective:

- **Option (i): Project-local helper lemma**
  `relativeDifferentialsPresheaf_iso_kaehler_appLE` returning a
  `Γ(X, V)`-linear iso `((relativeDifferentialsPresheaf f).presheaf.obj
  (.op V) : Type _) ≃ₗ[Γ(X, V)] Ω[Γ(X, V) ⁄ Γ(S, U)]` under `IsAffineOpen`
  hypotheses. Estimated 50–150 LOC; correctness depends on Q2's answer.
- **Option (ii): Refactor `relativeDifferentialsPresheaf` to use the
  SHEAFIFIED inverse-image.** The sheafified pullback on a scheme is the
  inverse-image **sheaf** `f^{-1}_{\text{sh}} O_S`, whose sections on an
  affine `V` with image inside affine `U` ARE `Γ(S, U)` (modulo a
  cofinality argument that's standard for sheafification on a basis).
  If Mathlib has this, the project should use it.
- **Option (iii): Refactor the statement of `smooth_locally_free_omega`
  to use `Ω[Γ(X,V) ⁄ Γ(S,U)]` directly** (the appLE algebra Kähler
  module), eliminating the bridge entirely from the theorem's content.
  The theorem becomes: "for each x ∈ X there exist affine `U ⊆ S`,
  affine `V ⊆ X` containing x with `f V ⊆ U`, such that the algebra map
  `Γ(S, U) → Γ(X, V)` makes `Ω[Γ(X,V) ⁄ Γ(S,U)]` free of rank n."

Recommend ONE option (or a hybrid). For your recommendation, name:
- The Mathlib idiom it aligns with (if any).
- The cost (LOC, prover-iter count).
- The downstream consumers of `relativeDifferentialsPresheaf` /
  `smooth_locally_free_omega` (currently NONE in the live project —
  this is a leaf theorem).

### Q4. Latent design risks

Specifically, the user's directive this iter is "complete blueprints for
all components." Is there any other component in this project that
exhibits a similar "parallel-API" or "blueprint-Lean signature
mismatch" pattern that might lurk undiscovered until a prover hits it?

You may scan `references/challenge.lean` (the original definitions) +
the project files under `AlgebraicJacobian/` for things that look like
"this is built ad-hoc, not aligned with a Mathlib idiom."

## Output

Write `task_results/mathlib-analogist-cotangent-presheaf.md` AND, if
your recommendation involves a design change, a persistent note at
`analogies/cotangent-presheaf-design.md` (this is your write-domain).

The plan agent for iter-120 will read your report and use it to decide
between options (i), (ii), (iii), or a hybrid; whether to dispatch
a blueprint-writer / refactor / prover lane this iter.

## Important

You may NOT propose adding axioms or modifying protected signatures.
The project's protected declarations are listed in
`archon-protected.yaml`.
