# Analogy: composite-adjunction unit cocycle without dependent-δ-splice

## Mode
cross-domain-inspiration

## Slug
d3cocycle006

## Iteration
006

## Structural problem (abstracted)
Prove an associativity/coherence (cocycle) identity for the unit — and the
oplax-monoidal comparison δ — of a composite of LEFT ADJOINTS stacked across
three categories (X→Y→Z), where each "leg" is itself a COMPOSITE adjunction
`(pullbackPushforward φ').comp sheafAdj`. The naive proof evaluates the mate /
conjugate at a component `.app P` and then tries to splice a local δ-square (or a
recovered `sheafCompPb·.hom` factor) into a long dependent composite by
`congrArg`/`conv`/`reassoc_of% key`. The splice never lands because the component
composite carries dependent indices — `eqToHom` of base-map equalities,
`Over.map`/`opensFunctor` reindex — so the rewrite motive is ill-typed.

## Failed approaches (from directive)
- Direct `rw`/`erw` of the δ-square into the component composite: dependent indices block it.
- `congrArg`/`conv` to the δ-subterm: ill-typed motive under the dependent composite.
- Re-prove `sheafificationCompPullback_comp` wholesale via surjective/injective reduction
  of `leftAdjointCompNatTrans_assoc`: reduction opens but the final step is the same δ-splice.

## Core finding (the technique that AVOIDS the splice)

The dependent indices (`eqToHom`, `Over.map`/`opensFunctor` reindex) exist ONLY at
the **component** (`.app P`) level, AFTER the conjugate/mate has been evaluated into
a concrete composite of base-changed module objects. Mathlib's
`Mathlib.CategoryTheory.Adjunction.Mates` proves EVERY composite-adjunction
coherence at the level of **natural transformations** — objects are functors, not
the dependent base-changed modules — where composition is plain whisker/`≫` and no
`eqToHom`/reindex term can appear. The whole identity is rewritten at the
transformation level and `.app P` is evaluated exactly ONCE, at the very end. There
is never a "splice a component δ-square into a dependent composite" step.

The mate cocycle calculus (all in `Mathlib/CategoryTheory/Adjunction/Mates.lean`):

- `conjugateEquiv_comp` (Mates.lean): `conjugateEquiv adj₁ adj₂ α ≫ conjugateEquiv adj₂ adj₃ β
  = conjugateEquiv adj₁ adj₃ (β ≫ α)`. **The abstract δ-/factor-splice**, as a NatTrans
  equation. Combining two legs' conjugates into the composite's conjugate is one rewrite
  with NO dependent indices.
- `iterated_mateEquiv_conjugateEquiv` (Mates.lean): the iterated mate of a TwoSquare across
  two stacked adjunctions = the conjugate of the COMPOSITE adjunction `adj₁.comp adj₄`. **This
  IS the composite-adjunction coherence**, stated as a whole-transformation equality.
- `mateEquiv_vcomp` / `mateEquiv_hcomp` / `mateEquiv_square` (Mates.lean): the bicategorical
  functoriality of mates (vertical/horizontal/4-square paste) — each ONE transformation
  equation, the analogue of the project's "4 interleaved δ-squares".
- `unit_conjugateEquiv` (Mates.lean): unit-naturality of the mate, `adj₁.unit ≫ (conj α).app(L₁ ·)
  = adj₂.unit ≫ R₂.map (α ·)`. **Already used by the project** (`sheaf_unit_comp_pushforward_pullbackComp_inv`, L2422).
- `conjugateEquiv_mateEquiv_vcomp` / `mateEquiv_conjugateEquiv_vcomp`: mixed whisker-composition
  of a conjugate with a mate — the abstract form of the project's `hwr := conjugateEquiv_whiskerRight`
  device (L2598).

Mathlib's PROOF technique for these: `ext` once to a component, then `simp` with the
explicit whiskered `mateEquiv_apply` normal form + the unit/counit triangle identities
(`Adjunction.left_triangle_components` etc.). The cocycle lemmas are CONSUMED by rewriting
at the transformation level, NOT by splicing into a component.

## Analogues found

### Analogue: `CategoryTheory.conjugateEquiv_comp` (`Mathlib/CategoryTheory/Adjunction/Mates.lean`)
- **Domain**: category theory / adjunction-mate calculus (one shelf over from sheaves-of-modules).
- **Same problem there**: combine the conjugates (mates) of two composable left-adjoint NatTrans
  into the conjugate of their composite — exactly the "glue the f-leg and h-leg factors into the
  (h≫f) factor" step, but at the transformation level.
- **Technique**: a single equation between right-adjoint NatTrans. Contravariant composition
  `conj β ≫ conj α = conj (β ≫ α)`. No component, no `eqToHom`.
- **Mapping to project**: the project recovers `R1 = (pullback h).map (sheafCompPb f).hom.app P`
  and `R5 = (sheafCompPb h).hom.app (PrPb_f P)` and wants to fuse them into the `(h≫f)` unit. Via
  `sheafificationCompPullback_eq_leftAdjointUniq` (L1534) each `sheafCompPb·.hom` is
  `(leftAdjointUniq A· B·).hom`, whose `homEquiv`-transpose is `conjugateEquiv B· A· (…)` /
  `B·.unit` (`homEquiv_leftAdjointUniq_hom_app`, used L1586/1626/2726). So R1≫R5 fuse by
  `conjugateEquiv_comp` into the single `(h≫f)`-conjugate = `B_{h≫f}.unit` — replacing the failed
  `reassoc_of% key` splice (L2786) and the un-consumable `hwr` component device (L2598).
- **Porting cost**: low. The model lemma `pullbackObjUnitToUnit_comp` (L920–993) is the
  bare-adjunction instance of this exact assembly (it uses `homEquiv_naturality_left/right` +
  `unit_conjugateEquiv` + `pushforwardComp.hom.naturality`, NO component splice). The sheafification
  version differs only in that B_f/B_h are COMPOSITE adjunctions, so the single bare
  `pushforwardComp.hom.naturality` slide (model L989) becomes a `conjugateEquiv_comp` fuse.
- **Verdict**: ANALOGUE_FOUND.

### Analogue: `CategoryTheory.iterated_mateEquiv_conjugateEquiv` (`Mates.lean`)
- **Domain**: category theory / mate calculus.
- **Same problem there**: the mate of a square taken across TWO stacked adjunctions equals the
  conjugate of the single COMPOSITE adjunction — the composite-adjunction coherence itself.
- **Technique**: whole-transformation equality; the stacking `adj₁.comp adj₄` is handled once,
  abstractly, with no per-component reindex.
- **Mapping to project**: this is the abstract statement of "B_{h≫f}.unit decomposes through B_f, B_h
  + the pseudofunctor coherences" that `sheafificationCompPullback_comp_tail` is trying to prove by
  hand. Frame the tail as `conjugateEquiv` of the composite `sheafAdj.comp (PrPbPush (h≫f))` and let
  this lemma + `conjugateEquiv_comp` discharge the stacking, instead of the manual `hinner`/`hcomp'`
  twin + splice.
- **Porting cost**: medium. Needs the project's three adjunctions cast as the `adj₁..adj₄` stack and
  the TwoSquare identified; heavier than just `conjugateEquiv_comp`, but it is the principled frame.
- **Verdict**: ANALOGUE_FOUND.

### Analogue: `CategoryTheory.Adjunction.isMonoidal_comp` + `Functor.OplaxMonoidal.comp_δ` (`Mathlib/CategoryTheory/Monoidal/Functor.lean`)
- **Domain**: monoidal category theory (the δ / tensorator side).
- **Same problem there**: the oplax-monoidal structure (δ) of a composite of left adjoints is the
  composite oplax structure; `comp_δ` expresses δ of a composite functor via the two legs' δ — a
  TRANSFORMATION identity, not a component splice.
- **Technique**: `isMonoidal_comp` supplies `(adj.comp adj').IsMonoidal` so the composite's δ is
  definitionally the legs' δ glued; `comp_δ` is the rewrite. No dependent component appears until
  evaluation.
- **Mapping to project**: `pullbackTensorMap_restrict` (D3′, L2824) splices the δ-square of
  `pullback φ'_{h≫f}` into the dependent 4-fold composite. Instead: identify `pullback φ'_{h≫f}`'s
  oplax δ with the composite via `isMonoidal_comp` + `comp_δ` + the already-CLOSED project lemma
  `pullbackComp_δ` (L2282), at the transformation level, then conjugate the WHOLE 4-fold composite
  once via the `(h≫f)`-adjunction `homEquiv` (mirroring `mateEquiv_square`, the 4-square paste as one
  equation) before evaluating `.app`. Avoids the in-place δ-square `rw`.
- **Porting cost**: medium. Needs `OplaxMonoidal`/`IsMonoidal` instances on the project's pullback
  adjunctions plumbed through (the D1′ `show … from`/`let φ' : … ⋙ forget₂` monoidal-pinning device,
  noted L2888–2895); `pullbackComp_δ` is already done.
- **Verdict**: ANALOGUE_FOUND.

## Top suggestion

Start with `sheafificationCompPullback_comp_tail` (L2467) using `conjugateEquiv_comp` (Mates.lean).
The model `pullbackObjUnitToUnit_comp` (L920–993) is a working, axiom-clean template of the SAME
cocycle at the bare-adjunction level — it never touches a component splice, assembling entirely via
`homEquiv_naturality_left/right`, `unit_conjugateEquiv`, and `pushforwardComp.hom.naturality`. Port it
by: (1) keep the whole-equation transpose the caller already does (`homEquiv.injective`, L2721–2724) —
do NOT split back to components; (2) recover R1/R5 as `B_f`/`B_h` conjugates through
`sheafificationCompPullback_eq_leftAdjointUniq` (L1534) + `homEquiv_leftAdjointUniq_hom_app`; (3) fuse
them with `conjugateEquiv_comp` into the single `(h≫f)`-conjugate `= B_{h≫f}.unit`, replacing the
failed `reassoc_of% key` splice (L2786) and the dangling `hwr` component device (L2598). The discipline
to import from Mates.lean: **every rewrite stays at the NatTrans level; `.app P` is evaluated once, at
the end.** Then reuse the identical discipline for D3′ via `isMonoidal_comp`/`comp_δ`/`pullbackComp_δ`.
