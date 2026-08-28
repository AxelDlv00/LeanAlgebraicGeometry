I have everything I need. Here is the audit.

## AJC coherent-sheaf vanishing audit (read-only)

All paths under `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/`. Namespaces: `fiberModule`/`fiberSectionsModule` live in `AlgebraicGeometry.Scheme.Hom`; the `_of_isZero` lemmas in `AlgebraicGeometry.Scheme.Modules`.

### 1. `IsZero F` from fibrewise/stalkwise/pointwise vanishing

**ABSENT in project as a coherent-sheaf statement.** No lemma concludes `IsZero (F : X.Modules)` from per-fibre or per-stalk vanishing. This is exactly the open target `hz` — see the docstring at `Picard/DivFamilyZero.lean:568-583` (`divFunctorDegZero_representableByTerminal_of_isZero`), which explicitly names `x.HasFiberDeg 0 → IsZero x.F` as "the honest remaining gap."

Closest existing bricks (not the sheaf-level statement, but reusable inputs):
- `AlgebraicJacobian/Cohomology/ModulesCoverConservativity.lean:37` `isIso_iff_isIso_restrict {X : Scheme} {M N : X.Modules} (φ : M ⟶ N) (𝒰 : X.OpenCover) : IsIso φ ↔ ∀ j, IsIso ((Scheme.Modules.restrictFunctor (𝒰.f j)).map φ)` — cover-conservativity for `X.Modules` morphisms (via `toPresheaf` reflecting isos + stalk detection). Detects iso on an *open* cover, not on scheme-theoretic fibres.
- `AlgebraicJacobian/Picard/TwoTermFiniteFree.lean:311` `subsingleton_of_forall_maximal_le_smul` and `:339` `surjective_of_baseChange_quotient_surjective` — the *module-level* Nakayama "fibrewise vanishing at all maximal ideals ⟹ zero/surjective" for a `Module.Finite A Q`. This is the algebraic engine one would lift, but it is stated for `Type u` modules, not `X.Modules`.

No stalk-conservativity lemma of the form `(∀ x, IsZero (stalk)) → IsZero F` exists for `X.Modules` (searched `isZero_iff_stalk`, `isZero_of_forall`, etc. — nothing).

### 2. Finitely-presented/coherent module with empty support is zero

**ABSENT.** Only the *forward* direction exists:
- `Picard/DivFamilyZero.lean:351` `isEmpty_schematicSupport_of_isZero {M : Y.Modules} (hM : IsZero M) : IsEmpty (Scheme.Modules.schematicSupport M)` and `:340` `annihilator_of_isZero : Scheme.Modules.annihilator M = ⊤`.

The reverse (empty support / annihilator = ⊤ ⟹ `IsZero`) is not in the project. Note `Picard/QuotScheme.lean:530` `annihilator_ideal_le` only gives `(annihilator F).ideal U ≤ Module.annihilator …`; the reverse inclusion is flagged as "blocked on `isLocalizedModule_basicOpen`" (`QuotScheme.lean:518-519,528-529`). So even "support = points where fibre/stalk ≠ 0" is not available in the strong direction.

### 3. `fiberModule` / `fiberSectionsModule` (definitions + IsZero↔Subsingleton/finrank)

All in `Picard/HilbertPolynomial.lean`, namespace `AlgebraicGeometry.Scheme.Hom`:
- `:77` `noncomputable def Hom.fiberModule (π : X ⟶ S) (s : S) (F : X.Modules) : (π.fiber s).Modules := (Scheme.Modules.pullback (π.fiberι s)).obj F`
- `:87` `Hom.fiberResidueMap (π : X ⟶ S) (s : S) : S.residueField s ⟶ Γ(π.fiber s, ⊤)`
- `:96` `@[reducible] noncomputable def Hom.fiberSectionsModule (π : X ⟶ S) (s : S) (G : (π.fiber s).Modules) : Module (S.residueField s) Γ(G, ⊤) := Module.compHom Γ(G, ⊤) (π.fiberResidueMap s).hom` (not an instance; brought in with `letI`).

Relating `IsZero (fiberModule …)` to `Subsingleton Γ`/`finrank` — only via the generic `subsingleton_sections_of_isZero` applied to a fibre, demonstrated once at the zero divisor:
- `Picard/DivFamilyZero.lean:437` `DivFamily.isZero_fiberModule_zero (t) : IsZero ((pullback.snd π T.hom).fiberModule t (DivFamily.zero π T).F)` (via `Functor.map_isZero`, since `fiberModule` is an additive pullback).
- `:445` `DivFamily.fiberDeg_zero` chains `isZero_fiberModule_zero → subsingleton_sections_of_isZero → Module.finrank_zero_of_subsingleton`. This is the `IsZero (fiberModule) → finrank = 0` direction. There is **no** converse (`finrank = 0 → IsZero (fiberModule)`), which is your step (B).

### 4. Finite-dimensionality of `Γ(fiberModule t F, ⊤)`

**PRESENT but gated on projectivity, and it is the twist-`0` special case.** In `Picard/SerreFiniteness.lean`:
- `:155` `hilbertFunction_finiteDimensional (π : X ⟶ S) (L F : X.Modules) (s : S) (hproj : π.IsProjectiveWith L) (hF : F.IsFinitePresentation) (m : ℕ) : letI := π.fiberSectionsModule s (…moduleTensorPow (π.fiberModule s F) (π.fiberModule s L) m) ; FiniteDimensional (S.residueField s) Γ(moduleTensorPow (fiberModule s F) (fiberModule s L) m, ⊤)`.

  Setting `m = 0` gives `FiniteDimensional κ(s) Γ(fiberModule s F, ⊤)` (the tensor-pow at 0 is `F_s`), **but only under `π.IsProjectiveWith L`**, not from proper-support alone. It inherits one named `sorry` from the leaf `sectionGradedModule_fg` (`:130`).
- Supporting: `:114` `Scheme.Hom.fiberModule_isFinitePresentation` (finite presentation descends to fibres); `:130` `sectionGradedModule_fg_fiber`; `:105` `IsProjectiveWith.fiber`.

No lemma gives finite-dimensionality of `Γ(F_t)` from **proper support + finite presentation** without a projectivity/`IsProjectiveWith` hypothesis. Related base-change fact (does not itself give finiteness): `Picard/SchematicSupport.lean:736` `finrank_gammaTop_baseChange_of_hasProperSupport` (finrank of `Γ` is invariant under field base change, given `HasProperSupport` + quasicoherence).

### 5. The four `_of_isZero` lemmas (used in `DivFamily.zero`, ~line 400)

All in `Picard/DivFamilyZero.lean`, namespace `Scheme.Modules`, variable `{Y : Scheme.{u}}`:
- `:317` `subsingleton_sections_of_isZero {M : Y.Modules} (hM : IsZero M) (V : Y.Opens) : Subsingleton Γ(M, V)`
- `:303` `isFinitePresentation_of_isZero {M : Y.Modules} (hM : IsZero M) : M.IsFinitePresentation`
- `:328` `coherentSheafFlat_of_isZero {S' : Scheme.{u}} (g : Y ⟶ S') {M : Y.Modules} (hM : IsZero M) : Scheme.CoherentSheafFlat g M`
- `:362` `hasProperSupport_of_isZero {S' : Scheme.{u}} (g : Y ⟶ S') {M : Y.Modules} (hM : IsZero M) : Scheme.Modules.HasProperSupport g M`

Consumed at `:400-402` in `DivFamily.zero`, and `subsingleton_sections_of_isZero` again at `:451`.

### 6. `Subsingleton Γ(F_t) → IsZero (fiberModule t F)`

**ABSENT.** Only the opposite implication exists (`subsingleton_sections_of_isZero`, item 5). No lemma in the project derives `IsZero` of a sheaf-on-a-scheme from vanishing global sections — consistent with your note that it is false without finite support. Any such lemma would have to carry finite-support/finite-generation hypotheses; none is present. (The nearest genuine "vanishing ⟹ zero" is the module-level Nakayama in `TwoTermFiniteFree.lean:311,339`, which requires `Module.Finite`.)

### 7. `DivSupportQuasiFinite.lean` — support quasi-finiteness/finiteness over the base

Namespace `Scheme.DivFamily`; the support map is `Modules.schematicSupportι x.F ≫ pullback.snd π T.hom`. Main theorems:
- `:382` `locallyQuasiFinite_of_finite_fibers (x) (hfib : ∀ t, (support-map ⁻¹' {t}).Finite) : LocallyQuasiFinite (support-map)`
- `:395` `locallyQuasiFinite_iff_finite_fibers (x) : LocallyQuasiFinite (support-map) ↔ ∀ t, (support-map ⁻¹' {t}).Finite`
- `:405` `locallyQuasiFinite_iff_isFinite_fiber (x) : LocallyQuasiFinite (support-map) ↔ ∀ t, IsFinite (support-map.fiberToSpecResidueField t)`
- `:417` `locallyOfFiniteType_support (x) : LocallyOfFiniteType (support-map)` (from `properSupport`)
- `:423` `quasiCompact_support (x) : QuasiCompact (support-map)`
- `:434` `locallyQuasiFinite_of_fibers (x) (h : ∀ t, LocallyQuasiFinite (support-map.fiberToSpecResidueField t)) : LocallyQuasiFinite (support-map)`
- `:455` `isFinite_support (x) (hqf : LocallyQuasiFinite (support-map)) : IsFinite (support-map)` (proper + quasi-finite ⟹ finite)
- `:535` `isFinite_support_of_fibers (x) (h : ∀ t, LocallyQuasiFinite (…fiberToSpecResidueField t)) : IsFinite (support-map)`
- `:498` `locallyQuasiFinite_zero` and `:545` `isFinite_support_zero` — the empty-divisor instances.

Important caveats stated in-file:
- The general fibre-finiteness antecedent (`∀ t, …`) is **an unproved hypothesis** everywhere except at `DivFamily.zero`; the geometry ("a nonempty effective Cartier divisor on a relative curve has finite fibres") is explicitly *untouched* (`:485-493`).
- `:511-533` records a **withdrawn** claim: there is a *second, unnamed* carrier-mismatch obligation — these theorems quantify over `Hom.fiber (support-map) t` (the fibre of the *support*), whereas the `DivDegree.lean` fibre sequence uses `fiberModule` of `x.F`; and the needed reverse annihilator inclusion (`QuotSupportBaseChange.lean` only proves `annihilator F ≤ (annihilator (g'^* F)).map g'`) is "nowhere in the project."

### Bottom line for your decomposition
- Step (A) `(∀ t, IsZero (fiberModule t F)) → IsZero F`: **not present** in any form (neither fibre nor stalk conservativity for `X.Modules`). Closest reusable pieces: `isIso_iff_isIso_restrict` (open-cover conservativity) and the module-level Nakayama `subsingleton_of_forall_maximal_le_smul`.
- Step (B) `finrank κ(t) Γ = 0 → IsZero (fiberModule t F)`: **not present**; only the forward `IsZero → finrank = 0` (`fiberDeg_zero`) exists. Finite-dimensionality of `Γ(F_t)` needed for it exists only under `IsProjectiveWith` (`hilbertFunction_finiteDimensional`, `m=0`), not from proper support alone, and it carries an inherited `sorry`.
