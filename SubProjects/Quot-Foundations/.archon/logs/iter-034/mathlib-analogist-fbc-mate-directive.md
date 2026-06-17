# mathlib-analogist directive — FBC mate re-encoding (iter-034)

## Mode: cross-domain-inspiration

## Structural problem
We must show the canonical i=0 flat base-change comparison map for pushforward of quasi-coherent
modules — `g^* f_* F ⟶ f'_* g'^* F` for the affine square (Stacks 02KH part 2) — is an isomorphism.
At the MODULE level this map is the natural regroup iso `R' ⊗_R M ≅ R' ⊗_R A ⊗_A M` (already proved
axiom-clean). The obstacle is transporting that module iso to the SHEAF-level canonical map being an
iso. The abstract shape: we have a **pasted square of adjunctions** and need the **mate (Beck–Chevalley)
2-cell** of that square to be invertible. Concretely two composite adjunctions
- `adjL = (tilde ⊣ Γ)_R ∘ (g^* ⊣ g_*)`
- `adjR = (extend ⊣ restrict)_ψ ∘ (tilde ⊣ Γ)_{R'}`
related by a natural iso `β = gammaPushforwardNatIso ψ`, and the comparison is the **conjugate /
mate** of a unit (`base_change_mate_unit_value`, "Seam 1", was closed via
`CategoryTheory.unit_conjugateEquiv_symm` on two composed adjunctions). The current crux ("`_legs`")
is the SAME conjugate argument transported one functor layer up — through `(Spec φ)_*` — and it has no
term-mode factor-by-factor expression under the `X.Modules` instance diamond.

## Question
Does Mathlib's mate/conjugate calculus express the mate of a **pasted square of (composite)
adjunctions** directly, so the comparison's iso-ness follows abstractly (each constituent unit/counit
iso ⟹ mate iso) WITHOUT splicing inside the diamond? Specifically:
- `CategoryTheory.mateEquiv`, `CategoryTheory.conjugateEquiv`, `CategoryTheory.Adjunction.comp`,
  `mateEquiv_conjugateEquiv` and the horizontal/vertical composition lemmas for mates
  (`mateEquiv_vcomp`, `mateEquiv_hcomp`, `conjugateEquiv_comp`, …) — do these compose to give the
  "mate of a pasted square is the paste of the mates", and an `IsIso`-of-mate-from-`IsIso`-of-2-cell
  lemma? Name the exact declarations and their current signatures in pinned Mathlib.
- Is there a Beck–Chevalley / base-change package in Mathlib (search: `BeckChevalley`, base change of
  pushforward, `Functor.leftAdjoint` mate, sheaf pushforward base change) that already states "the
  mate is invertible when the square commutes up to iso"?

## Failed approaches
- Explicit factor telescoping inside the locked `_legs` goal (term-mode `congrArg`/`.trans`): bottoms
  out at the cross-layer naturality of `gammaPushforwardIso ψ`; ~15 iters, sorry never eliminated.
- Keyed `rw`/`simp`/`erw`/`conv`: uniformly dead under the `X.Modules` (Spec→ringedspace→modules)
  instance diamond — even a `rfl`-proven `= 𝟙` fact whose LHS is the printed goal factor is not located.

## Search radius: narrow (CategoryTheory adjunction/mate + AlgebraicGeometry base-change), then wide if empty.

## Deliverable
A ranked list of Mathlib mate/conjugate declarations (with exact names + signatures) that let us
build the affine base-change comparison as an abstract mate, plus a concrete port sketch: which
composite-adjunction mate lemma to instantiate, what `β` plays the role of, and the `IsIso` chain.
Write the persistent rationale to `analogies/fbc-mate-reencode.md`. If Mathlib's mate API is too thin
to express the composite-square mate, say so explicitly and specify the minimal project-side bridge.
