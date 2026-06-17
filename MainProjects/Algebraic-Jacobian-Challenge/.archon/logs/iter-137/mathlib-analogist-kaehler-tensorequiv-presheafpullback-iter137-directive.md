# Mathlib Analogist Directive

## Slug
kaehler-tensorequiv-presheafpullback-iter137

## Design question

**How should the algebra-side base-change-of-Ω equivalence
`KaehlerDifferential.tensorKaehlerEquiv` (Mathlib's
`Mathlib.RingTheory.Kaehler.TensorProduct`) be promoted to a
sheaf-level natural iso of presheaves of modules?**

Specifically, the project needs to construct, for a smooth proper
geometrically irreducible group scheme `G : Over (Spec (.of k))`, an
iso

```
Scheme.relativeDifferentialsPresheaf (fst G G).left ≅
  (PresheafOfModules.pullback
      (Scheme.Hom.toRingCatSheafHom (snd G G).left).hom).obj
    (Scheme.relativeDifferentialsPresheaf G.hom)
```

— informally, `Ω_{(G ⊗ G)/G} ≅ pr_2^* Ω_{G/k}` on `(G ⊗ G).left`,
where the LHS uses the **first** projection `pr_1 := (fst G G)` of
`G ⊗ G ⟶ G` as the structure morphism (so the LHS is the relative
cotangent of `G ⊗ G` viewed as a `G`-scheme via the first projection)
and the RHS uses the **second** projection `pr_2 := (snd G G)` to
pull back `Ω_{G/k}` (i.e. `relativeDifferentialsPresheaf G.hom`).

The closure target is `AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_basechange_along_proj_two`
at `AlgebraicJacobian/Cotangent/GrpObj.lean:480`, currently sorry-bodied
with the iter-135 honest-scaffold signature shown above.

This is piece (i.b) Step 2 of the cotangent-vanishing pile (see
`blueprint/src/chapters/RigidityKbar.tex § lem:GrpObj_omega_basechange_proj`
at L423–L481). The strategy claims it as the **load-bearing
NEEDS_MATHLIB_GAP_FILL** of piece (i.b), with an envelope of
~150–300 LOC per `task_results/mathlib-analogist-mulright-globalises-iter133.md`
Decision 2 + persistent file `analogies/mulright-globalises-cotangent.md`.

## Project artifact(s) under question

- `AlgebraicJacobian/Cotangent/GrpObj.lean:480–488` —
  `relativeDifferentialsPresheaf_basechange_along_proj_two` (sorry
  body; iter-137 prover target).
- `AlgebraicJacobian/Differentials.lean:51–66` —
  `Scheme.relativeDifferentialsPresheaf` definition (project's home-
  grown presheaf-level Ω; built on
  `PresheafOfModules.DifferentialsConstruction.relativeDifferentials'`)
  + the `relativeDifferentialsPresheaf_obj_kaehler` rfl-level chart
  identification.
- `blueprint/src/chapters/RigidityKbar.tex:423–481` — the blueprint
  `lem:GrpObj_omega_basechange_proj` block (statement + proof prose
  sketching the closure chain).
- `analogies/mulright-globalises-cotangent.md § Decision 2` —
  the iter-133 mathlib-analogist's named target and the
  ~150–300 LOC envelope.
- `analogies/phi-compatibility-morphisms.md` — the iter-135 mathlib-
  analogist's verdict on `(Scheme.Hom.toRingCatSheafHom _).hom` as
  the canonical `PresheafOfModules.pullback` compatibility-morphism
  producer; the iter-136 Step 3 closure consumed this verdict
  directly.

## What we ask of you

This is a PROACTIVE pre-design dispatch (BEFORE the iter-137 prover
lane fires). The dispatching planner wants:

1. **The Mathlib idiom for the sheaf-level promotion.** Mathlib has
   `KaehlerDifferential.tensorKaehlerEquiv` (algebra side; for an
   `Algebra.IsPushout R S A B` square, `B ⊗[A] Ω[A/R] ≃ₗ[B] Ω[B/S]`)
   and it has `PresheafOfModules.pullback` (functor on PresheafOfModules
   along a ring-cat sheaf morphism; the iter-136 closure relied on it
   via `Scheme.Hom.toRingCatSheafHom`). It also has
   `TopCat.Presheaf.pullback` (the inverse-image presheaf along a
   continuous map). The question is: what is the **canonical Mathlib-
   aligned chain** that turns `tensorKaehlerEquiv` into the sheaf-level
   natural iso the project needs? Is there a precedent for this exact
   shape in Mathlib (e.g. a Mathlib `*.pullback_*` lemma about
   relative differentials, even at the algebra level, that lifts to a
   sheaf statement)? Spot-check via `lean_leansearch`/`lean_loogle`.

2. **The `Algebra.IsPushout` source for the chart-level square.** The
   blueprint at `RigidityKbar.tex:474–478` claims the binary-product
   universal property in `Over (Spec k)` supplies an
   `Algebra.IsPushout k B_1 B_2 B` square where `B_1, B_2` are the
   chart algebras of `G` via the two projections and `B` is the chart
   of `G ⊗ G`. Does Mathlib have an existing precedent for deriving
   `Algebra.IsPushout` from a categorical binary product of affine
   opens, or does the project need to build the
   `Algebra.IsPushout`-from-affine-product helper? If the latter,
   what's the LOC cost? If a Mathlib precedent exists, name it.

3. **The naturality assembly.** Once the chart-level `tensorKaehlerEquiv`
   value identity is established, the project needs to package it
   as a natural transformation of presheaves of modules on `(G ⊗ G).left`,
   then upgrade to an isomorphism. Is there a Mathlib idiom for
   "promote a pointwise/chart-wise value iso to a `PresheafOfModules`-
   level natural iso" that the iter-137 prover should use, or is the
   project going to have to assemble it by hand from `presheaf.map`
   on each chart inclusion?

4. **Compatibility morphism shape.** The signature uses
   `(Scheme.Hom.toRingCatSheafHom (snd G G).left).hom` as the
   `PresheafOfModules.pullback` compatibility morphism. The iter-135
   mathlib-analogist already verified this is the canonical Mathlib
   shape (per `analogies/phi-compatibility-morphisms.md`). Confirm
   for Step 2 that the same convention holds and that there is no
   subtle convention drift between `pullbackPushforwardAdjunction`
   (the route used by `relativeDifferentialsPresheaf`'s own
   construction in `Differentials.lean`) and `Scheme.Hom.toRingCatSheafHom`
   (the route used by the iter-136 closure and the iter-137 target).

5. **Verdict + LOC envelope refinement.** Render PROCEED / ALIGN_WITH_MATHLIB
   / NEEDS_MATHLIB_GAP_FILL / REJECT verdict on the iter-135 honest
   scaffold's signature shape. Update the ~150–300 LOC envelope if
   your idiom-finding suggests a different range. If you find a
   Mathlib precedent that materially shortens the proof, name it +
   the new LOC envelope.

6. **Literal Lean text for the analogist's recommended closure
   skeleton**, if the iter-137 prover lane will need it (the iter-135
   analogist provided literal Lean text for the 3 honest scaffold
   signatures; this iter's analogist may need to provide literal text
   for the closure recipe). If the recipe is too long for a literal
   skeleton, give the prover a 5-step prose outline + named Mathlib
   lemmas at each step.

## Required outputs

1. **`analogies/kaehler-tensorequiv-presheafpullback.md`** — the
   persistent design-rationale file the iter-137 prover (and future
   iters) will consult.

2. **`.archon/task_results/mathlib-analogist-kaehler-tensorequiv-presheafpullback-iter137.md`** — the standard analogist report
   with verdict, alternatives considered, cost analysis.

## Stance

Be strict. If Mathlib has a canonical idiom for sheaf-level base-
change-of-Ω and the project's chosen chain is parallel to it, report
ALIGN_WITH_MATHLIB and name the canonical idiom. If the project's
chain IS the canonical idiom (because Mathlib has no scheme-level
relative cotangent at all, per iter-133 Decision 2's
NEEDS_MATHLIB_GAP_FILL verdict), confirm and pin the LOC envelope.

Do **not** rubber-stamp the iter-135 honest scaffold signature as
"works"; the iter-134 placeholder pattern was caught only because
both iter-134 review-phase audits looked critically at the type
shape vs the docstring intent. Apply the same critical lens to the
iter-135 scaffold signature: does the displayed sheaf-level iso
actually express the load-bearing claim the project needs from the
RHS-blueprint reading "`Ω_{(G ⊗ G)/G} ≅ pr_2^* Ω_{G/k}`"?

If you find the iter-135 signature is subtly wrong (e.g. the LHS
should use `(snd G G).left` not `(fst G G).left` as the structure
morphism; or the RHS pullback should be along `(fst G G).left` not
`(snd G G).left`), flag it as CRITICAL — better to refactor the
signature in iter-137 plan phase (via a refactor sub-dispatch) than
to ship 150–300 LOC of body against a wrong-shaped target.
