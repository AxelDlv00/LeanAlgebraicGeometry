# Mathlib Analogist Directive

## Slug
finite-prod-loc

## Design question

**Two-part question on Phase A of `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`:**

(Q1) The proof of `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` contains a sorry at L1783 named `h_loc_exact`, which states exactness of the LOCALIZED Čech differential at each `f ∈ s₀`:

```lean
have h_loc_exact (f : ↑s₀) : Function.Exact
    ⇑(LocalizedModule.map (Submonoid.powers (f.1 : R)) f_R)
    ⇑(LocalizedModule.map (Submonoid.powers (f.1 : R)) g_R) := sorry
```

where `f_R, g_R : scK₀.X_i →ₗ[R] scK₀.X_{i+1}` are the `R`-linear repackagings of the K₀ Čech differential at degree `n` (R := `Γ(C.left, U)`) and `scK₀.X_i = ∏ᶜ (Fin (i+1) → ↑s₀ → Γ(C.left, basicOpenCover_finite_inf'))`.

The intended derivation (per the surrounding docstring):
- `h_a₀_fun f : Function.Exact (slice-cover Čech at degree n)` is available in scope (sorry-routed via `h_a₀ f`).
- The slice cover over `D(f)` is indexed identically, but with each factor `Γ(C.left, V_x)` replaced by `Γ(C.left, V_x ⊓ D(f))`.
- By the universal property of localisation: `Γ(C.left, V_x ⊓ D(f)) ≅ LocalizedModule (powers f) Γ(C.left, V_x)` (i.e. the basic-open D(f) is the localisation).
- Hence `slice-cover differential = LocalizedModule.map (powers f) (K₀ differential)` after the product-localisation commutation `LocalizedModule (powers f) (∏ᶜ_x M_x) ≅ ∏ᶜ_x LocalizedModule (powers f) M_x`.

The CIRCULAR issue: Mathlib's `LocalizedModule.map_exact` requires the UNLOCALIZED exactness `Function.Exact f_R g_R` — which is exactly what we are trying to prove via `exact_of_localized_span`. So `LocalizedModule.map_exact` CANNOT close `h_loc_exact` directly; the closure must go through `h_a₀_fun f` + product-localisation commutation.

**Question Q1**: Does Mathlib have (a) the product-localisation commutation `LocalizedModule (powers a) (∏ᶜ_x M_x) ≅ ∏ᶜ_x LocalizedModule (powers a) M_x` for FINITE products in `ModuleCat k` (or in `ModuleCat R` more generally) AND (b) the associated `IsLocalizedModule.Pi` typeclass with `IsLocalizedModule (powers a) (Pi-component-wise localisation map)`? If yes, name the declarations and module paths. If no, characterize the gap (how big — does Mathlib have it for `LinearMap` directly even if not for `ModuleCat`; for `Submonoid` instead of `powers`; etc).

If part (a) exists, characterize the typical recipe for "given exactness of a slice complex via product-localisation, conclude exactness of the LocalizedModule.map differential". The strategy-critic estimated ~80 LOC. Validate that estimate or revise it.

(Q2) The lane has been STUCK 7 consecutive iters on `cechCofaceMap_pi_smul` (L1120 sorry, body):

```lean
theorem cechCofaceMap_pi_smul {C : Over (Spec (.of k))} {U : C.left.Opens}
    (hU : IsAffineOpen U) (s₀ : Finset Γ(C.left, U)) {n : ℕ} (hn : 0 < n) :
    ∀ (r : ↑Γ(C.left, U)) (y : ↑(∏ᶜ Z₁)),
      ((alternatingCofaceMap ...).hom (r • y)) = r • ((alternatingCofaceMap ...).hom y) := by
  -- ... 60 LOC of scaffolding via funext + Pi.smul_apply + show-pivot + ...
  -- per-summand discharge:
  intro i _ r' y'
  simp only [ModuleCat.hom_comp, LinearMap.comp_apply]
  funext j'
  simp only [Pi.smul_apply]
  show ... = r' • ...
  rw [..., ← ConcreteCategory.comp_apply, ...]
  rw [show (ConcreteCategory.hom : _ → _) = ModuleCat.Hom.hom from rfl]
  simp only [ModuleCat.hom_comp, LinearMap.comp_apply]
  -- iter-107 staging:
  have hRel' : (ComplexShape.up ℕ).prev n + 2 = n + 1 := by omega
  have h_iter104 := cechCofaceMap_summand_family_R_linear hU s₀ n hn i r' y'
  sorry
```

Six distinct prover attempts (rw [ModuleCat.hom_zsmul], generalize hσ, body-local rfl-helpers, simp [hom_smul], reverse the L1114 simp, change/show with named family + explicit eqToHom proof) ALL failed at the same root cause: discrim-tree pattern unification + whnf reduction on an **anonymous-closure `Pi.lift` codomain** when trying to push a ℤ-action through the morphism.

The structural shape: an alternating sum `∑_{i : Fin (n+1)} (-1)^↑i • (Pi.lift (fun i_1 ↦ Pi.π Z₁ (i_1 ∘ δ i) ≫ F.map _.op) ≫ eqToHom h)` where the inner `Pi.lift` body is an anonymous closure in `i`. Iter-104 introduced a NAMED family `cechCofaceMap_summand_family (s₀ n i : Fin (... + 2))` and proved R-linearity `cechCofaceMap_summand_family_R_linear` (binder-level proof, 50 LOC) — but applying it at the call site requires bridging from the call-site anonymous closure to the named family, which has repeatedly failed at the elaborator level.

**Question Q2**: Is there a Mathlib idiom for proving R-linearity of an alternating sum of categorical morphisms `∑ (-1)^i • (Pi.lift ... ≫ eqToHom)` that AVOIDS the per-summand pattern-match-on-anonymous-closure approach? For example:
- Is there a `Preadditive` / `LinearCategory` / `Linear k` -level lemma that handles `(-1)^i • f` and `(Σ f_i)` and `Pi.lift`-style limits compositionally?
- Mathlib has `CechComplex` / `simplicialNerve` infrastructure — does it provide R-linearity for the Čech coface map automatically (e.g. via `Linear k` instance on `ModuleCat k`)?
- Could the project re-architect `cechCofaceMap` so its TYPE provides R-linearity directly (via `Linear k`)? — e.g. defining the alternating sum AS a morphism in a linear category, and inheriting R-linearity from `Preadditive` operations + `Linear k`.

Specifically: characterize how Mathlib's `Cech` cohomology / nerve-style constructions on `ModuleCat k` PRESERVE R-linearity. If Mathlib doesn't provide this directly (a Mathlib gap), characterize the gap; otherwise propose a project-side refactor of `cechCofaceMap_pi_smul`'s formulation that lets us derive R-linearity from the typeclass structure instead of an explicit alternating-sum proof.

## Project artifact(s) under question

- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:1683-1786` — the `h_K₀_exact` block including h_a₀, h_a₀_fun, h_loc_X_i, f_R, g_R, h_loc_exact (L1783 sorry).
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:836-1121` — the body of `cechCofaceMap_pi_smul` including the iter-099/100/101/103 scaffold + iter-107 partial `have h_iter104` staging.
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:454-477` — `cechCofaceMap_summand_family` definition (named morphism family).
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:494-595` — `cechCofaceMap_summand_family_R_linear` proof (50-LOC binder-level proof — works).

## Out of scope

- Do NOT propose changes to protected declarations in `archon-protected.yaml`.
- Do NOT propose changes that require Phase C3 closure (Hilbert / Quot schemes).
- For Q1: do not propose using `LocalizedModule.map_exact` directly — the directive's analysis confirms it's circular here.
- For Q2: do not re-propose any of the 6 failed attempts; the prover task results document them.

## Persistent analogy file

Write the design-rationale to `analogies/finite-product-localisation-and-cech-r-linearity.md`. Index it from `analogies/` if there's an index file.

## Verdict shape

For BOTH questions, report:
- **MATHLIB IDIOM**: <name> + brief signature, OR "no Mathlib idiom for this exists".
- **PROJECT ALIGNMENT**: PROCEED | ALIGN_WITH_MATHLIB | MATHLIB_GAP_CONFIRMED.
- **COST OF DIVERGENCE / FIX**: if ALIGN, what does the refactor look like; if PROCEED, what's the proof-strategy recipe; if MATHLIB_GAP, what's the project-local fix.
- **CONFIDENCE**: HIGH / MEDIUM / LOW.

