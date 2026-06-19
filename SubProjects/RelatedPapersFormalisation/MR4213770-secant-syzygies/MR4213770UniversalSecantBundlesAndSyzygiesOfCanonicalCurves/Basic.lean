import MR4213770UniversalSecantBundlesAndSyzygiesOfCanonicalCurves.Foundations

/-
# Universal secant bundles and syzygies of canonical curves — basic layer

Scaffolding of the *basic layer* for Kemeny,
*Universal secant bundles and syzygies of canonical curves* (MR4213770).

This file introduces, as compiling stubs, the three **even-genus foundational
definitions** in the `MR4213770` namespace, pinned in
`blueprint/src/chapters/Kemeny_UniversalSecantBundles.tex`.

Every declaration here is an `opaque` constant with an explicit witnessing value,
so the file compiles cleanly with no `axiom` and no `sorry`.  Later iterations
replace these placeholders with the genuine constructions and build the lemma /
theorem statement stubs on top.
-/

namespace MR4213770

open AlgebraicGeometry

/-- Kernel bundle `M_L` (`def:kemeny_kernel_bundle`).

For a line bundle `L` on `X`, the kernel bundle `M_L` is the kernel of the
evaluation morphism `ev_L : H⁰(L) ⊗ 𝒪_X → L`, i.e. `M_L = ker(ev_L)`, sitting in
the left-exact sequence `0 → M_L → H⁰(L) ⊗ 𝒪_X → L`.  This is the specialisation
of the general evaluation kernel `M_F = ker(ev_F)`
(`AlgebraicGeometry.Scheme.Modules.evalKernel`, the `found:eval_kernel_bundle`
substrate in `Foundations.lean`) to `F = L`.  When `L` is globally generated the
evaluation map is surjective, the sequence is short exact, and `M_L` is a vector
bundle of rank `h⁰(L) - 1` (`kernelBundle_isLocallyFree`, a later iteration). -/
noncomputable def kernelBundle {X : Scheme.{u}} (L : X.Modules) : X.Modules :=
  AlgebraicGeometry.Scheme.Modules.evalKernel L

/-- Kernel bundle and Koszul-cohomology reduction (`def:kemeny_kernel_bundle_reduction`).

The kernel bundle `M_L` is defined by `0 → M_L → H⁰(L) ⊗ 𝒪_X → L → 0`.  For the
even-genus K3 surface, the desired vanishing `K_{k,1}(X,L) = 0` follows from
`H¹(X, ⋀^{k+1} M_L) = 0`.  Foundational placeholder stub for the even-genus
section; the genuine definition (and the reduction statement it packages) lands
in a later iteration. -/
opaque KernelBundleReduction : Prop := True

/-- Universal zero locus (`def:kemeny_universal_zero_locus`).

With `ℙ = ℙ(H⁰(E))` and projections `p : X × ℙ → X`, `q : X × ℙ → ℙ`, the
universal zero locus is `𝒵 = {(x,s) | s(x) = 0} ⊆ X × ℙ`.  It is smooth over `X`
and finite flat over `ℙ` under the Picard-rank-one hypothesis.  Foundational
placeholder stub; the genuine subscheme construction lands in a later iteration. -/
opaque UniversalZeroLocus : Type := Unit

/-- Universal secant bundles (`def:kemeny_universal_secant_bundles`).

Let `π : B → X × ℙ` be the blow-up of `𝒵` with exceptional divisor `D`, and
`p' = p ∘ π`, `q' = q ∘ π`.  The bundle `𝒮` is defined by
`0 → 𝒮 → q'^* q'_*(p'^* L ⊗ I_D) → p'^* L ⊗ I_D → 0`, and `Γ` is the quotient in
`0 → 𝒮 → π^* ℳ → Γ → 0`.  `𝒮` and `Γ` are Kemeny's universal secant bundles.
Foundational placeholder stub; the genuine bundle constructions land in a later
iteration. -/
opaque UniversalSecantBundles : Type := Unit

end MR4213770
