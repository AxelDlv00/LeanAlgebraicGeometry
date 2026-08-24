# Finiteness of H¹(C, 𝒪_C) — the two-lattice plan (Wave 1 finale)

*2026-07-11 design note. Consumes Lane A (`exists_isFinite_toP1`) and Lane B (the
2-affine-cover H¹ cokernel bridge). Produces `Module.Finite k (H¹ₖ(C, 𝒪_C))`, which makes
`genus` correct (not merely defined) and feeds the χ-ledger (Wave 2 item 7).*

## Setup

Let `π : C ⟶ ℙ¹` be a finite `k`-morphism (Lane A). Put `Vᵢ := π⁻¹(D₊(Xᵢ))`. Then, all
already proved in `Curve/MapToP1.lean`:

- `V₀`, `V₁` are affine opens of `C` (`isAffineOpen_preimage_chartOpen`),
- `V₀ ⊔ V₁ = ⊤` (`preimage_chartOpen_sup`),
- `Γ(C, V₀)` is module-finite over `Γ(ℙ¹, D₊(X₀)) ≅ k[t]` (`finite_app_chartOpen`),
- `Γ(C, V₀ ⊓ V₁)` is module-finite over `Γ(ℙ¹, D₊(X₀X₁)) ≅ k[T,T⁻¹]` (`finite_app_overlap`).

Lane B's bridge: `H¹ₖ(C, 𝒪_C) ≃ₗ[k] coker(Γ(V₀) ⊕ Γ(V₁) →ₗ[k] Γ(V₀ ⊓ V₁))`,
map `(s₀, s₁) ↦ s₀|∩ − s₁|∩`.

## The pure-algebra keystone (PR-candidate; new file, suggest `Cohomology/TwoLattice.lean`)

**Lemma (two lattices).** Let `N` be a module over `R := k[T,T⁻¹]`, and let
`Q₀, Q₁ ⊆ N` be `k`-submodules such that

1. `T • Q₀ ⊆ Q₀` and `Q₀` is generated over `k[T]` by finitely many elements
   `x₁, …, x_r` **which generate `N` over `R`**;
2. `T⁻¹ • Q₁ ⊆ Q₁`;
3. localization towards `Q₁`: for every `n ∈ N` there is `m` with `T^{−m} • n ∈ Q₁`.

Then `N / (Q₀ + Q₁)` is a finite-dimensional `k`-vector space.

*Proof.* Choose `M` with `T^{−M} • xᵢ ∈ Q₁` for all `i` (hypothesis 3, max over the finitely
many generators). Every element of `N` is an `R`-combination of the `xᵢ`, so it suffices to
bound the monomials `T^j • xᵢ` modulo `Q₀ + Q₁`:

- `j ≥ 0`: `T^j • xᵢ ∈ Q₀` (hypothesis 1, `k[T]`-stability);
- `j ≤ −M`: `T^j • xᵢ = T^{j+M} • (T^{−M} • xᵢ) ∈ Q₁` (since `j + M ≤ 0` and `Q₁` is
  `k[T⁻¹]`-stable);
- `−M < j < 0`: finitely many classes, `≤ r·(M−1)` of them.

So the quotient is spanned by `{[T^j • xᵢ] : −M < j < 0}`. ∎

Formalization notes:

- Base ring `R := LaurentPolynomial k` (mathlib `k[T;T⁻¹]`, `LaurentPolynomial.T` invertible).
- Phrase hypothesis 1 as: a `Finset` `s : Finset N` with `Q₀ = Submodule.span k[T] s`
  (via `Module.Finite` of a `k[T]`-submodule structure) and `Submodule.span R s = ⊤`.
  Getting "generators of `Q₀` over `k[T]` generate `N` over `R`" from
  "`N = Q₀` localized at `T`" is a one-line upgrade: enlarge any `R`-generating set of `N`
  by clearing denominators (each `R`-generator has `T^m•n ∈ Q₀`; those `T^m•n` plus the
  original `k[T]`-generators of `Q₀` work). Alternatively state 1 directly with a
  localization hypothesis symmetric to 3 plus `Module.Finite k[T] Q₀` and derive the span
  form inside the proof.
- Everything is elementary module theory; no schemes in this file.

## The geometric glue (suggest `Cohomology/Finiteness.lean`)

Instantiate: `N := Γ(C, V₀ ⊓ V₁)`, `Q₀ := im(res : Γ(V₀) → N)`, `Q₁ := im(res : Γ(V₁) → N)`.

- **Module structures.** `N` is an algebra over `Γ(ℙ¹, D₊(X₀X₁))`, transported to
  `k[T,T⁻¹]` along the P1Charts identification (`Γ(D₊(X₀X₁)) ≅ k[T,T⁻¹]`, already landed).
  `T` acts on `N` as multiplication by `π♯(t₀)|∩` where `t₀ = X₁/X₀` is the chart-0
  coordinate. `Q₀` is `k[T]`-stable because `res` is a ring hom and `π♯(t₀)` restricts from
  `V₀`; symmetrically for `Q₁` with `T⁻¹ = π♯(t₁)|∩`.
- **Finiteness inputs.** `Module.Finite k[T,T⁻¹] N` from `finite_app_overlap`;
  `Module.Finite k[t] Γ(V₀)` from `finite_app_chartOpen`, so `Q₀` is a module-finite image.
- **Localization inputs (hypothesis 3 and the span upgrade).**
  `V₀ ⊓ V₁ = V₀.basicOpen (π♯(t₀)|_{V₀})`: the overlap is the locus in `V₀` where the
  chart-0 coordinate pulls back invertibly — prove via
  `Scheme.preimage_basicOpen`/`chartOpen_inf` transported through `π`. Then
  `IsAffineOpen.isLocalization_basicOpen` gives `Γ(V₀ ⊓ V₁) = Γ(V₀)[1/π♯t₀]`, whose
  standard surjectivity-up-to-powers statement (`IsLocalization.Away` +
  `IsLocalization.mk'_surjective`) is exactly "∀ n ∃ m, T^m • n ∈ Q₀", and symmetrically
  for `Q₁`.
- **Conclusion.** `coker ≅ N/(Q₀ + Q₁)` finite over `k`; transport along Lane B's bridge:

  ```
  instance : Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 1)
  ```

  (equivalently `FiniteDimensional k H¹`), keyed on the curve hypothesis bundle. Note the
  instance must not depend on the *choice* of `π` — it doesn't: `π` is consumed inside an
  `∃`-elimination producing a `Prop` (`Module.Finite`), so no data escapes.

## Order of work

1. `TwoLattice.lean` (pure algebra, independent — can start before Lanes A/B land).
2. Overlap-as-basic-open + localization bookkeeping (needs Lane A's `π` only for the final
   instantiation; the `Vᵢ` lemmas are already in `MapToP1.lean` stated for an arbitrary
   finite `π`, so this too can start now, quantified over `π`).
3. Final instance + `genus`-correctness corollaries once Lane B's bridge lands.
