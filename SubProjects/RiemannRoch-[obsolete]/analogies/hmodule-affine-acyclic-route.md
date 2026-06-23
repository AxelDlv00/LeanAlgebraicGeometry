# Analogy: affine acyclicity of `HModule` for quasi-coherent k̄-sheaves

## Mode
api-alignment

## Slug
affine-acyclic

## Iteration
025

## Question
`Scheme.HModule_affine_acyclic`: for a quasi-coherent sheaf `F` of `k̄`-modules on an
affine open `Spec A ⊆ C` (`A` noetherian), `Scheme.HModule k̄ F p = 0` for `p > 0`.
Planned route AVOIDS flasque resolutions, uses an injective hull
`0 → F → Injective.under F → R → 0` in the SHEAF category + dimension shift,
bottoming in "Γ exact on affine qcoh" (Hartshorne III.3.5).
Asks: (1) does Mathlib give `Ext^{≥1}(X,I)=0` for `I` injective, usable for `HModule`?
(2) does Mathlib provide affine/qcoh scheme cohomology vanishing to align to?
(3) is Γ-exactness on affine qcoh in Mathlib? (4) is the route the right shape, and is
`HModule_affine_acyclic` a `prove` or `mathlib-build` target?

## Project artifact(s)
- `Cohomology/StructureSheafModuleK/Carriers.lean:52` — `HModule k F n := Abelian.Ext ((constantSheaf J (ModuleCat k)).obj (ModuleCat.of k k)) F n`. Cohomology = Ext from the constant sheaf, in the abelian category `Sheaf (Opens.grothendieckTopology X) (ModuleCat k̄)`.
- `RiemannRoch/H1Vanishing.lean:341` — `Scheme.HModule_injective_finrank_eq_zero`: `Injective I ⇒ HModule k̄ I i = 0 (i≥1)`. CLOSED axiom-clean.
- `H1Vanishing.lean:358` — `Scheme.injectiveSES F` = `0 → F → Injective.under F → cokernel → 0`; `:369` `injectiveSES_shortExact`. CLOSED.
- `H1Vanishing.lean:401` `ext_one_eq_zero_of_hom_surjective_of_injective`, `:450` `ext_succ_eq_zero_of_injective_of_lower_zero` — the LES dimension-shift lemmas. CLOSED axiom-clean.
- `H1Vanishing.lean:620` `IsFlasque.shortExact_app_surjective` (Hartshorne II.1.16(b): left-flasque ⇒ Γ-level `g` surjective). CLOSED.
- `H1Vanishing.lean:756` `IsFlasque.injective_flasque` — **sorry** (needs `j_!` extension-by-zero, ~100-150 LOC, the gate); `:934` `HModule_flasque_eq_zero` closed at `i=1`, higher `i` gated on `injective_flasque`.

## Decisions identified

### Decision: `Ext^{≥1}(X, I) = 0` for injective `I` (Q1)

- **Mathlib idiom**: `CategoryTheory.HasInjectiveDimensionLT.subsingleton` (and `.subsingleton'`), `Mathlib.CategoryTheory.Abelian.Injective.Dimension` — `Subsingleton (Abelian.Ext Y X i)` for `n ≤ i` given `HasInjectiveDimensionLT X n`. The instance `instHasInjectiveDimensionLTOfNatNatOfInjective` derives `HasInjectiveDimensionLT I 1` from `Injective I`. (Dual: `isZero_Ext_succ_of_projective`, `Mathlib.CategoryTheory.Abelian.Ext`.)
- **Project's path**: already consumes it directly — `HModule_injective_finrank_eq_zero` (L341) and `ext_one_eq_zero_…` (L407) both call `HasInjectiveDimensionLT.subsingleton …` and are CLOSED axiom-clean.
- **Gap**: identical. Usable for `HModule` AS-IS (proven so).
- **Verdict**: PROCEED (already aligned).

### Decision: align to a Mathlib affine/qcoh scheme-cohomology vanishing (Q2)

- **Mathlib inventory** (no affine acyclicity anywhere):
  - `CategoryTheory.Sheaf.H` (`Mathlib.CategoryTheory.Sites.SheafCohomology.Basic`) — abstract SITE cohomology via `Ext`, **AddCommGrpCat-valued only**. Structurally identical to `HModule`: ships `subsingleton_H_of_isZero`, `instSubsingletonHH…OfInjective` (injective ⇒ `H(n+1)` subsingleton), `H.equiv₀` (`H 0 ≃+ sections at terminal`). This is the AddCommGrp analogue of `HModule` + `HModule_injective_finrank_eq_zero` + `HModule_zero_linearEquiv` — it CONFIRMS `HModule`'s design is the correct `ModuleCat k̄`-flavoured parallel of the Mathlib idiom. Mathlib ships only the AddCommGrp version, so `HModule` is a justified specialization, NOT a rogue parallel API. It carries NO affine/qcoh content.
  - `SheafOfModules.IsQuasicoherent` / `QuasicoherentData` / `isQuasicoherent` (`Mathlib.Algebra.Category.ModuleCat.Sheaf.Quasicoherent`) — quasicoherence predicate on a general site. NO acyclicity theorem.
  - `AlgebraicGeometry.tilde` / `ModuleCat.tilde` (`Mathlib.AlgebraicGeometry.Modules.Tilde`) — `M~ : ModuleCat R → (Spec R).Modules`, with `tilde.fullyFaithfulFunctor`, `tilde.adjunction` (`tilde ⊣ moduleSpecΓFunctor`), `tilde.toTildeΓNatIso` (`id ≅ tilde ⋙ Γ`). NO cohomology, NO flasqueness, NO acyclicity. AND it lands in `(Spec R).Modules` (sheaves of 𝒪_X-modules) — a **different category** from the project's `Sheaf (Opens X) (ModuleCat k̄)`.
  - `AlgebraicGeometry.Scheme.EllAdicCohomology` — étale ℓ-adic, irrelevant.
- **Conclusion**: there is NOTHING to align/consume for the vanishing itself. `HModule` cannot consume any Mathlib affine-acyclicity because none exists; the only structurally-matching object (`Sheaf.H`) is degree-shift/H⁰ infrastructure with no scheme content.
- **Verdict**: NEEDS_MATHLIB_GAP_FILL.

### Decision: Γ-exactness on affine qcoh (Q3)

- **Mathlib inventory**: `CategoryTheory.Sheaf.Γ` + `HasGlobalSectionsFunctor` (`Mathlib.CategoryTheory.Sites.GlobalSections`), `SheafOfModules.sectionsFunctor`, `AlgebraicGeometry.Scheme.Γ` — all abstract/definitional. NO exactness-on-affines (Hartshorne III.3.5), NO QCoh(Spec A) ≃ A-Mod ABELIAN equivalence with exactness (only the `tilde` adjunction + `toTildeΓNatIso`, not the exact-equivalence packaging).
- **Verdict**: NEEDS_MATHLIB_GAP_FILL — genuine build.

### Decision: is the injective-hull + dimension-shift route the right shape? (Q4)

- **Homological scaffold** (injective SES, `Ext^{≥1}(_,I)=0`, the two LES dimension-shift lemmas): correctly Mathlib-aligned and ALREADY BUILT/CLOSED in H1Vanishing.lean. This part is fine.
- **The specific resolution choice is the WRONG shape.** `Injective.under F` is the injective hull in the abelian sheaf category `Sheaf (Opens X) (ModuleCat k̄)`; its cokernel `R` is **NOT quasi-coherent**. Consequences:
  - **i ≥ 2**: dimension shift `H^i(F) ≅ H^{i-1}(R)` lands on a non-qcoh `R`; the affine-acyclic hypothesis cannot be reapplied → the induction has no base. (Equivalently it would need Γ right-exact on the injective SES of an arbitrary sheaf = "every sheaf acyclic" = false.)
  - **i = 1**: `H^1(F) = coker(Γ(I) → Γ(R))`. "Γ exact on affine **qcoh**" (III.3.5) is a statement about SES of QUASI-COHERENT sheaves and does NOT apply to `0→F→I→R→0` whose middle/right terms are not qcoh. The route conflates two different exactness statements.
- **Correct, classically/Mathlib-aligned shape** (Hartshorne III.3.5 proper): resolve INSIDE qcoh. Embed `Γ(F) ↪ I` (`I` an injective `A`-module), `F ≅ Γ(F)~ ↪ I~`; `I~` is flasque (Hartshorne III.3.4) **and** qcoh, cokernel `R` qcoh, recursion stays in qcoh. This RE-ENGAGES flasque machinery the directive wanted to avoid. Project already has the key bridge `IsFlasque.shortExact_app_surjective` (II.1.16(b)) giving Γ-surjectivity when the LEFT term is flasque, and `HModule_flasque_eq_zero` closed at `i=1`. Genuinely missing: (i) `tilde`-of-injective-module is flasque (III.3.4 — not in Mathlib); (ii) a bridge `(Spec A).Modules` / A-Mod → the project's `Sheaf (Opens X) (ModuleCat k̄)` category (different categories); (iii) full flasque⇒acyclic = the gated `injective_flasque`/`j_!` sorry, OR an abstract acyclic-resolution-computes-`rightDerived` comparison (Mathlib has `Functor.rightDerived` + `ProjectiveResolution.isoLeftDerivedObj` but no ready right-derived F-acyclic comparison, and `HModule` is Ext-native not `rightDerived Γ`-native, so a bridge is needed there too).
- **Verdict**: `HModule_affine_acyclic` is a `mathlib-build` (multi-step), NOT a `prove`. The injective-hull-in-sheaf-category route as stated is divergent-and-wrong for the qcoh recursion.

## Recommendation

Keep the homological scaffold (it is the right Ext-native shape and already closed). Do NOT
attempt `HModule_affine_acyclic` as a one-shot `prove` via `Injective.under F` + dimension
shift — the sheaf-category injective hull's cokernel leaves the quasi-coherent class, so the
recursion has no base and III.3.5 cannot be applied at i=1. Re-scope it as a `mathlib-build`
with sub-targets: (a) a qcoh/k̄-sheaf bridge to `AlgebraicGeometry.tilde` + the
`A`-Mod ↔ `Sheaf(Opens X)(ModuleCat k̄)` category bridge; (b) `tilde`-of-injective-module is
flasque (Hartshorne III.3.4); (c) reuse `IsFlasque.shortExact_app_surjective` +
`HModule_flasque_eq_zero` — which means clearing the `injective_flasque`/`j_!` gate (or an
abstract acyclic-resolution comparison) is on the critical path either way. Net: the project
cannot dodge the flasque-vanishing dependency for the FULL `p>0` statement; only the `p=1`
slice is reachable from the already-closed flasque-H¹ base, and only for sheaves it can show
flasque (qcoh sheaves are not flasque, so even p=1 needs the tilde-flasque embedding).
