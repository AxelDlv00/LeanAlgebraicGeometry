# The affine dictionary `X.CechPic ≃* CommRing.Pic Γ(X, ⊤)` — design (run 0027, s0018)

Item-5 of the Wave-3 Picard design (`wave3-picard-design.md` §4.4): the missing brick between
the definitional Čech Picard group and mathlib's `CommRing.Pic`.  We prove it for an
arbitrary **affine scheme** `X` against `A := Γ(X, ⊤)` — no `Spec R`/`ΓSpecIso` plumbing in
the core construction; consumers specialize `X := Spec R`.  (This is literally a TODO in
mathlib's `RingTheory/PicardGroup.lean`: "Exhibit isomorphism with sheaf cohomology
`H¹(Spec R, 𝓞ˣ)`" — everything below is built PR-shaped.)

## Route (Čech class → invertible module): Zariski descent along a basic cover

A unit Čech cocycle `γ` on a pointed cover `𝒰` of affine `X` is converted into a
**descent datum on the free rank-1 module** over the faithfully flat `A`-algebra
`B := ∏ i, Γ(X, X.basicOpen (r i))` for a finite covering family of basic opens refining
`𝒰`, and descended to an invertible `A`-module by the landed brick-4
(`Descent/ModuleDescent.lean` + `Descent/InvertibleModule.lean`).  No sheaf-theoretic
"twisted glued sections" module is ever constructed; localization algebra does everything.

Layers (each a file):

1. **`Descent/UnitDescent.lean`** (pure algebra).  For a unit `u : (B ⊗[A] B)ˣ` define
   `Module.IsDescentCocycle u` (normalization `lmul' u = 1` + cocycle identity via the three
   inclusions `B ⊗ B → B ⊗ B ⊗ B`), the comodule-form datum `DescentDatum.ofUnit`
   (coaction `x ↦ u * (x ⊗ₜ 1)`), and the descended submodule `hu.descended ⊆ B` with the
   full calculus, everything up to canonical `A`-module iso:
   * `descended 1 ≃ A` (Amitsur degree 0);
   * coboundary invariance `descended (ι₂β · ι₁β⁻¹ · u) ≃ descended u` (elementary: `β •`);
   * `descended u ⊗ descended v ≃ descended (u·v)` (via `equivDescended` against
     `distribBaseChange` + the two `descentEquiv`s; datum check is ring algebra on tensors);
   * base-change functoriality along any `h : B →ₐ[A] B'` of faithfully flat algebras:
     `descended u ≃ descended ((h ⊗ h) u)` (via `cancelBaseChange`);
   * triviality: `descended u ≅ A → u = ι₂β · ι₁β⁻¹` for the unit `β = m₀`, where `m₀` is
     the image of `1`; bijectivity of `(· * m₀)` comes from `descentEquiv`, so `m₀ ∈ Bˣ`.
   * Pic-level wrappers `IsDescentCocycle.picClass : CommRing.Pic A` + the four laws.

2. **`Algebra/PiLocalization.lean`** (pure algebra, generic).  For a finite family of
   `A`-algebras `S i` with `IsLocalization.Away (f i) (S i)`:
   * **the pi-ext lemma**: two `A`-algebra maps `(∀ i, S i) →ₐ[A] C` agreeing on the
     idempotents `Pi.single i 1` are equal.  Proof: `Φᵢ := (quotient by span{1 - φ(eᵢ)}) ∘
     φ(single i ·)` is a *unital* `A`-algebra map out of the localization `S i`, so unique
     (`IsLocalization.ringHom_ext`); multiply the resulting congruence by the idempotent.
     This single lemma discharges every transport identity below — no naturality diagrams.
   * `Module.FaithfullyFlat A (∀ i, S i)` when `Ideal.span (range f) = ⊤` (flat: finite
     product of localizations; faithful: `iff_flat_and_proper_ideal`, a maximal `m` misses
     some `f i`, and `m`-extension stays proper in `S i`).
   * `AlgEquiv`s `(∀ i, S i) ⊗[A] (∀ j, T j) ≃ₐ[A] ∀ p : ι × κ, S p.1 ⊗[A] T p.2`
     (finite `TensorProduct.piRight` twice, ring structure by tensor induction) and the
     component upgrade `S ⊗[A] T ≃ₐ[A] C` for `[Away f S] [Away g T] [Away (f*g) C]`
     (`IsLocalization.tensor` + `Submonoid.map_powers` + `IsLocalization.Away.mul'` +
     `IsLocalization.algEquiv`); canonical maps `Away.algHomOfDvd (f ∣ g) : S_f →ₐ[A] S_g`;
     `Subsingleton (S →ₐ[A] C)` for localizations makes all choices canonical.

3. **`Algebra/LocalizationCocycle.lean`**: packaging.  Given units
   `γ p ∈ (T p.1 p.2)ˣ` on the double overlaps with (i) diagonal normalization in `S i` and
   (ii) the cocycle identity in the triple overlaps `W i j k` (all maps the canonical ones),
   produce `cocycleUnit γ ∈ (B ⊗[A] B)ˣ` (via the layer-2 equivalences) with
   `IsDescentCocycle`, plus: multiplicativity in `γ`, coboundary detection
   (`cocycleUnit γ = descentCoboundary β ↔` componentwise), and refinement transport along
   `τ : ι' → ι` with `f (τ i') ∣-up-to-radical f' i'`.  All verified through the pi-ext
   lemma by evaluating on idempotents (`doubleEquiv (eᵢ ⊗ eⱼ) = single (i,j) 1` is forced).

4. **`Picard/PicAffine.lean`** (the dictionary).  For affine `X`:
   `CechPic.toPic : X.CechPic →* CommRing.Pic Γ(X, ⊤)`.
   * Choices per class: pointed basic refinement `x ∈ D(r x) ≤ 𝒰 x`
     (`IsAffineOpen.exists_basicOpen_le`), finite subcover `σ : Fin n → X` (compactness),
     `γ̃ (i,j) := unitsEvInf γ (σ i) (σ j)` restricted to `Γ(X, X.basicOpen (rᵢ * rⱼ))`
     (`Scheme.basicOpen_mul`); conditions (i),(ii) from `unitsEvInf_trans`.
   * Well-definedness: a single master comparison — enlarge the finite family
     (map-transport along an index inclusion), refine both packages to the common pointed
     refinement `𝒰₁ ⊓ 𝒰₂` with `r x := r₁ x * r₂ x`, where the H¹ classes agree, hence the
     cocycles are cohomologous and layer-1 coboundary invariance finishes.  All comparisons
     evaluate `γ` at the *same pairs of points*, so no cross-point cocycle juggling occurs.
   * Injectivity: `picClass = 1` gives componentwise `β i ∈ Γ(X, D i)ˣ`; the general-family
     glued-coboundary lemma (generalizing `exists_glued_coboundary` from
     `RefinementInjectivity.lean` to an arbitrary finite refining family) rebuilds a
     coboundary on `𝒰` itself; conclude with `CechPic.mk_eq_one_iff`.
   * Surjectivity (Phase 2 of the dictionary, may slip a session): invertible `M` is
     finite projective (mathlib), trivializes on a basic cover by
     `Module.FinitePresentation.exists_lift_equiv_of_isLocalizedModule` at each prime +
     `Pic (local ring) = 0`; transition cocycle → class; `toPic` of it is `Pic.mk A M` by
     descent uniqueness (`equivDescended`).  Then `cechPicEquivPic : X.CechPic ≃* Pic Γ(X,⊤)`
     and naturality in `X` (next session, needed by the (C1) assembly).

## Why this route (vs. glued-sections module)

Localizing an equalizer submodule of an infinite product (pointed covers have one open per
point!) needs finite-subcover surgery *inside* every localization argument; the descent
route quarantines quasi-compactness into a single choice of finite basic subcover and
reuses the landed effectivity/uniqueness/invertibility bricks unchanged.  The extra cost —
`B ⊗[A] B ≃ ∏ (double overlaps)` — is pure `IsLocalization` bookkeeping, and every identity
between maps out of localizations is *free* (`Subsingleton`-style uniqueness + idempotent
evaluation), which is exactly what makes the cocycle-condition transport tractable in Lean.
