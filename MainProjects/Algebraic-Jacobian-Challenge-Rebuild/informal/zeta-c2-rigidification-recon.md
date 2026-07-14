# (C2) rigidification / comparison-under-a-section — reconnaissance

*2026-07-14, ζ read-only recon. Scope: what the (C2) brick is HERE, the exact landed API it
consumes, the gap list, and a launch-ready brick spec. Read in full or in the cited ranges:
`informal/wave3-picard-design.md` (§4.4 (C2) ledger, §7.3 audit line, §9 OPEN-2, §6 degree/Pic⁰,
§4.3 Layer-2), `references/kleiman-picard-src/kleiman-picard.tex` L1384–1599 (`th:cmp` +
`df:rgd`/`lm:idn`/`lm:aut` + Part-2 proof + `rk:coh`), `AlgebraicJacobian/Challenge.lean`
(frozen), the landed Picard tree (files enumerated in §2 with line numbers), and the old draft
`MainProjects/Algebraic-Jacobian-Challenge` (READ-ONLY, lessons only). Line numbers are as of this
checkout; the Opus prover owns the Lean tree, so re-verify shapes with the LSP before proving.*

---

## 1. What (C2) IS for this project

### 1.1 Kleiman's statement (the mathematics), with the exact ranges read

`references/kleiman-picard-src/kleiman-picard.tex`:

- **`th:cmp` (Comparison), L1384–1399.** Hypothesis: `𝒪_S ≅ f_*𝒪_X` holds *universally*.
  **Part 1** (L1390–1393): the natural maps are injections
  `Pic_{X/S} ↪ Pic_{(X/S)zar} ↪ Pic_{(X/S)ét} ↪ Pic_{(X/S)fppf}`.
  **Part 2** (L1395–1398): "All three maps are isomorphisms if also `f` has a section; the latter
  two maps are isomorphisms if also `f` has a section locally in the Zariski topology; and the
  last map is an isomorphism if also `f` has a section locally in the étale topology."
- **`df:rgd` (rigidification), L1483–1488.** Assume `f` has a section `g` (`fg = 1`). For an
  `S`-scheme `T` and a sheaf `L` on `X_T`, a **`g`-rigidification** of `L` is a choice of iso
  `u : 𝒪_T ≅ g_T^* L`.
- **`lm:idn` (rigidified pairs = relative Pic), L1490–1513.** With a section `g`, the group of iso
  classes of pairs `(L, u)` (`L` invertible on `X_T`, `u` a `g`-rigidification) is carried
  *isomorphically* onto `Pic_{X/S}(T)` by `ρ(L,u) := L`. Surjectivity: normalize any representing
  `M` to `L := M ⊗ (f_T^* g_T^* M)^{-1}`, whose `g`-pullback is canonically trivial (`g_T^* f_T^* =
  1`). Injectivity: rigidification pins the map, so `(L,u) ≅ (f_T^*N, w)` and `≅ (𝒪_{X_T},1)`.
- **`lm:aut` (no automorphisms), L1515–1531.** With a section `g` AND `𝒪_S ≅ f_*𝒪_X` universally,
  every automorphism of a rigidified pair `(L,u)` is trivial. Core: `v ∈ Hom(L,L) = H⁰(𝒪_{X_T}) =
  H⁰(𝒪_T)` (units-of-global-sections), and `g_T^* v = 1` forces `v = 1`.
- **`th:cmp` Part 2 proof, L1533–1564.** Given a section `g`, every `λ ∈ Pic_fppf(T)` lies in
  `Pic_{X/S}(T)`: represent by `λ' ∈ Pic_{X/S}(T')` on a cover `T'→T` with descent data `v'` on
  `T'×_T T'`; the triple-overlap automorphism `v₁₃^{-1} v₂₃ v₁₂` is trivial by `lm:aut`, so the
  rigidified pair `(L',u')` *descends* to `(L,u)` on `X_T`, hence `λ ∈ Pic_{X/S}(T)`. "The rest is
  formal": local-existence-of-section variants follow by Grothendieck-topology sheaf gluing.
- **Discharging the hypothesis:** `𝒪_S ≅ f_*𝒪_X` universally holds for proper, flat, geometrically
  reduced-and-connected fibers (`ex:gc&r`, reading-log L1937); our `C/k` (proper, geometrically
  integral over a field) qualifies. In the landed code this hypothesis is *carried as the instance
  triple* `[IsProper C.hom] [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]` — the
  exact hypothesis block of the (C1) close and of `prPullback_injective`.
- The proof-of-record for `Pic_{X/S} ↪ Pic_zar` via `rk:coh`/`eq:2b` (L1566–1599) is the
  `Pic(R) = Ȟ¹(R,𝒪_R^*)` identification our whole `CechPic` model rests on.

### 1.2 What (C2) is HERE, and where the rational point lives

The rebuild models `Pic_{(X/S)ét}` on affine tests by the **one-step plus** `PicEtAff C A`
(design §4.3), and `Pic_{X/S} → Pic_ét` is its **unit** `PicEtAff.unit C A : relPic C (overSpec k
A) →* PicEtAff C A`. In this model:

- **(C1) = `th:cmp` Part 1** = `PicEtAff.unit` **injective**. This is LANDED and *unconditional*
  (`PicEtAff.unit_injective`, commit 5d7be76376, `Picard/CechKernelLemma.lean:361`): no section
  is needed for injectivity, exactly as Kleiman's Part 1 needs none.
- **(C2) = `th:cmp` Part 2 given Part 1** = `PicEtAff.unit` **surjective when the projection has a
  section**. Because injectivity is already free, the *entire new content of (C2) is surjectivity
  under a section*; combined with (C1) it yields the iso `relPic C A ≃* PicEtAff C A`.

**The section, and the rational-point vocabulary (checked in the frozen file).**
`AlgebraicJacobian/Challenge.lean` — the `Curve` structure (L67–72) carries **only** `[IsProper]`,
`[SmoothOfRelativeDimension 1]`, `[GeometricallyIrreducible]`. It carries **NO** point, NO
`HasRationalPoint`. The `k`-rational point appears *only* as an explicit argument to the
Abel–Jacobi map: `ofCurve (P : 𝟙_ (Over (Spec (.of k))) ⟶ C)` (L125) and `comp_ofCurve` (L130).
So (C2) must **not** be stated with a `HasRationalPoint C` hypothesis over `k` — design §7.3 audit
line is explicit: "(C2) … needed only over `k'` with `C(k') ≠ ∅`; NOT stated with
`HasRationalPoint C` over `k` (the challenge takes no point)". The section is a **hypothesis of the
theorem**, discharged downstream (Wave 4) over a finite separable `k'` with `C(k') ≠ ∅`, where a
`k'`-point base-changes to a section over *every* `k'`-test.

A "section of the projection over `T`" is, by the universal property of the cartesian product,
the *same datum* as a `T`-point of the curve: `Hom_{Spec k}(T, C) ≃ {σ : T ⟶ C ⊗ T | σ ≫ snd C T =
𝟙_T}`. The ergonomic form is a curve point `σ : overSpec k A ⟶ C` (a morphism in `Over (Spec k)`);
then Kleiman's `g_T^* L` is literally `σ^* L` and the base-scheme `S = Spec k`, `X = C.left`,
`f = C.hom`, `X_T = (C ⊗ T).left`, `f_T = (snd C T).left`.

### 1.3 The recommended exact (C2) statement

```lean
/-- (C2), comparison under a section (Kleiman, *The Picard Scheme*, Thm 2.5(2)). If the
projection of the curve product over an affine test has a section — equivalently, a `T`-point
of the curve `σ : overSpec k A ⟶ C` in `Over (Spec k)` — then the unit of the étale plus
construction is surjective. With (C1) `PicEtAff.unit_injective` it is bijective, so the plain
relative Picard group *already equals* the étale-sheafified one over section-admitting tests. -/
theorem PicEtAff.unit_surjective_of_section
    [IsProper C.hom] [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]
    (A : Type u) [CommRing A] [Algebra k A] (σ : overSpec k A ⟶ C) :
    Function.Surjective (PicEtAff.unit C A)

/-- The packaged comparison iso under a section. -/
noncomputable def PicEtAff.unitEquiv_of_section
    [IsProper C.hom] [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]
    (A : Type u) [CommRing A] [Algebra k A] (σ : overSpec k A ⟶ C) :
    relPic C (overSpec k A) ≃* PicEtAff C A :=
  MulEquiv.ofBijective (PicEtAff.unit C A)
    ⟨PicEtAff.unit_injective C A, PicEtAff.unit_surjective_of_section C A σ⟩
```

Why this shape (not a bijectivity monolith, not a `HasRationalPoint` class):

1. **Isolates the new content.** (C1) already gives injectivity for free; stating (C2) as
   `_surjective_of_section` mirrors Kleiman (Part 1 = separatedness, Part 2-given-Part-1 =
   surjectivity) and lets the bijection be a two-line `ofBijective` assembly.
2. **Section as hypothesis, point-form.** `σ : overSpec k A ⟶ C` is the discoverable form; the
   Wave-4 consumer feeds the base-changed `k'`-point. Provide the tiny bridge
   `sectionOfPoint σ : overSpec k A ⟶ C ⊗ overSpec k A` with `sectionOfPoint σ ≫ snd C _ = 𝟙`
   (a `CartesianMonoidalCategory.lift` of `⟨toUnit ≫ σ …⟩`) so both spellings are available; the
   proof uses `σ^* = (sectionOfPoint σ)^* ∘ (fst)^*`-free restriction of cocycles.
3. **Matches the landed (C1) surface verbatim** (same instance triple, same `overSpec k A` affine
   test, same `PicEtAff.unit C A`), so it drops straight into the file family.

**Content of the surjectivity proof** (Kleiman Part-2 recast on the landed cocycle model): a plus
class `mk C E x` is a descent class `x ∈ descentClasses C E` = a `λ' ∈ relPic C (Spec B)` (`B =
E.Carrier`, `A → B` étale faithfully flat) with `p₁^*λ' = p₂^*λ'` on `Spec(B ⊗_A B)`. The class
equation gives an iso of the two pullbacks but not a *canonical* one; the section-rigidification
(`lm:idn` normalization: replace the representing bundle by its `σ`-rigidified twist, so `σ^*` is
trivial) removes the automorphism ambiguity (`lm:aut`, whose ring heart is `Γ((C⊗T).left,⊤) = Γ(T)`
= `Over.universalSections`), turning the class equation into an honest **module descent datum** on
the invertible sheaf along `A → B`. That datum descends by **brick 4** (`Module.DescentDatum`,
`Invertible.of_invertible_tensorProduct_of_faithfullyFlat`) to an invertible `A`-module, transported
through the affine dictionary `cechPicEquivPic` to a class on `Spec A`, giving `λ ∈ relPic C
(overSpec k A)` with `unit λ = mk C E x`. This is the *reverse* of the (C1) close: (C1) proved a
class *killed* on the cover descends (kernel ⊆ range `p_A^*`); (C2) proves *every* descent class is
*hit* — the two together are the iso, exactly `th:cmp` Parts 1+2.

---

## 2. Exact API map (verbatim signatures, file:line)

All paths under `AlgebraicJacobian/`. Standing header (every file below):
`variable {k : Type u} [Field k] (C : Over (Spec (.of k)))`; `overSpec k A : Over (Spec k)` is the
affine test `Spec A → Spec k` (`Cohomology/SectionsBaseChange.lean:97`,
`noncomputable abbrev overSpec`). Conventions the (C2) spec-writer MUST honor (from the ζ/Layer-2
sessions): consume section-values through the ∃!-API `IsPullbackValue`/`picEtMapVal_spec`; state
everything with **explicit `k`-AlgHoms** via `mapAlg`; `attribute [local instance]
Over.sectionsAlgebra` when touching section rings.

### 2.1 Relative Picard functor `relPic` (the source of the unit)

`Picard/RelPic.lean`:
```lean
def picFromBase (T) : Subgroup ((C ⊗ T).left.CechPic) := (CechPic.map (snd C T).left).range   -- :54
def relPic (T) : Type u := (C ⊗ T).left.CechPic ⧸ picFromBase C T                              -- :63
noncomputable def relPicMk (T) : (C ⊗ T).left.CechPic →* relPic C T                            -- :70
lemma relPicMk_eq_relPicMk_iff {L L'} : relPicMk C T L = relPicMk C T L' ↔ L / L' ∈ picFromBase C T  -- :80
theorem relPic.ind {motive} (mk : ∀ L, motive (relPicMk C T L)) (x) : motive x                 -- :86
noncomputable def relPicMap (g : T' ⟶ T) : relPic C T →* relPic C T'                           -- :106
noncomputable def relPicFunctor : (Over (Spec (.of k)))ᵒᵖ ⥤ CommGrpCat.{u}                     -- :133
noncomputable def relPicMapCurve (g : C' ⟶ C) : relPicFunctor C ⟶ relPicFunctor C'             -- :185  (+ _id :208, _comp :219)
lemma mem_picFromBase_iff {L} : L ∈ picFromBase C T ↔ ∃ N, CechPic.map (snd C T).left N = L     -- :57
```
`Picard/RelPicAlgebra.lean` (the algebra-indexed face — (C2) states things here):
```lean
noncomputable def relPicAlgMap (f : A →ₐ[k] B) : relPic C (overSpec k A) →* relPic C (overSpec k B)  -- :88
   := relPicMap C (Over.overSpecMap f)
@[simp] lemma relPicAlgMap_id …                                                                -- :93
lemma relPicAlgMap_comp (f g x) : relPicAlgMap C (g.comp f) x = relPicAlgMap C g (relPicAlgMap C f x)  -- :98
```

### 2.2 The plus construction `PicEtAff` and its unit (the target of the unit)

`Picard/PicEtAff.lean` (`variable {A} [CommRing A] [Algebra k A]`):
```lean
def doubleInl / doubleInr (E : Algebra.EtaleCover A) : E.Carrier →ₐ[k] E.Carrier ⊗[A] E.Carrier -- :64 / :69
def descentClasses (E) : Subgroup (relPic C (overSpec k E.Carrier))                             -- :76
   := MonoidHom.eqLocus (relPicAlgMap C (doubleInl E)) (relPicAlgMap C (doubleInr E))
lemma mem_descentClasses_iff {E x} : x ∈ descentClasses C E ↔ …(doubleInl) x = …(doubleInr) x   -- :82
def descentMap {E F} (h : E.Carrier →ₐ[A] F.Carrier) : descentClasses C E →* descentClasses C F -- :127
theorem relPicAlgMap_congr {E R…} (j₁ j₂ : E.Carrier →ₐ[A] R) (hx : x ∈ descentClasses C E) :
    relPicAlgMap C (j₁.restrictScalars k) x = relPicAlgMap C (j₂.restrictScalars k) x           -- :161  ★ keystone
theorem descentMap_congr (h₁ h₂) (x) : descentMap C h₁ x = descentMap C h₂ x                    -- :188
def PicEtAff (A) : Type u := Quotient (picEtAffSetoid C (A := A))                               -- :218  (CommGroup :337)
def PicEtAff.mk (E) (x : descentClasses C E) : PicEtAff C A                                     -- :224
theorem PicEtAff.ind …                                                                          -- :227
theorem PicEtAff.mk_eq_mk_iff {E F x y} : mk C E x = mk C F y ↔
    ∃ (G) (f : E.Carrier →ₐ[A] G.Carrier) (g : F.Carrier →ₐ[A] G.Carrier),
      descentMap C f x = descentMap C g y                                                       -- :235
@[simp] theorem PicEtAff.mk_descentMap (h x) : mk C F (descentMap C h x) = mk C E x             -- :244
theorem PicEtAff.mk_mul_mk_same (E x y) : mk C E x * mk C E y = mk C E (x * y)                  -- :301
theorem PicEtAff.mk_one (E) : mk C E 1 = 1                                                      -- :315
lemma tautological_mem_descentClasses (E) (x : relPic C (overSpec k A)) : … ∈ descentClasses C E -- :365
def PicEtAff.unit (A) : relPic C (overSpec k A) →* PicEtAff C A                                 -- :377  ★ the unit (C2) hits
```
`Picard/PicEtAffMap.lean` (functoriality in the test algebra — (C2) states via `mapAlg`):
```lean
def PicEtAff.mapAlg (φ : A →ₐ[k] A') : PicEtAff C A →* PicEtAff C A'                            -- :275
theorem PicEtAff.mapAlg_id / mapAlg_comp                                                        -- :282 / :297
theorem PicEtAff.mapAlg_unit (φ x) : mapAlg C φ (unit C A x) = unit C A' (relPicAlgMap C φ x)   -- :286  ★ unit naturality
```
`Picard/RelPicCoverInjective.lean` (the (C1) corollary (C2) complements):
```lean
theorem PicEtAff.unit_eq_mk (E) (z) :
    unit C R z = mk C E ⟨relPicAlgMap C ((Algebra.ofId R E.Carrier).restrictScalars k) z, …⟩     -- :48
theorem relPicAlgMap_injective_of_etaleCover (E) :
    Function.Injective (relPicAlgMap C ((Algebra.ofId R E.Carrier).restrictScalars k))          -- :81  [proper+gi+gr]
```

### 2.3 (C1) separatedness — the LANDED pair the (C2) proof mirrors and reuses

```lean
-- Picard/CechKernelLemma.lean:361  (the unconditional (C1) close, commit 5d7be76376)
theorem PicEtAff.unit_injective [IsProper C.hom][GeometricallyIrreducible C.hom][GeometricallyReduced C.hom]
    (A) : Function.Injective (PicEtAff.unit C A)
-- Picard/EtaleSeparatednessClose.lean:193   (the reduction template; (C2) will need the DUAL of hker)
theorem PicEtAff.unit_injective_of_ker (A) (hker : ∀ B …[FaithfullyFlat A B], ∀ E, cg^* E = 1 → ∃ M₁, p_A^* M₁ = E) : …
theorem Over.exists_cechPic_map_snd_eq_of_ker (hker) (L N₀) (h : p_B^* N₀ = cg^* L) : ∃ M, p_A^* M = L  -- :115
-- Picard/EtaleSeparatedness.lean:125   (ζ1 class-level coherence seed — reusable in (C2))
theorem Over.cechPicMap_tensorInl_eq_tensorInr (L N h) : (Spec tensorInl)^* N = (Spec tensorInr)^* N
def tensorInl / tensorInr : B →ₐ[k] B ⊗[A] B    -- :87/:93   lemma tensorInl_comp_ofId  -- :100
-- Picard/Separatedness.lean:269   (brick 3, arbitrary T, = lm:aut ring heart via units-of-sections)
theorem Over.prPullback_injective : Function.Injective (Scheme.CechPic.map (snd C T).left)
-- Picard/UniversalSections.lean:123   (= lm:aut input:  Γ((C⊗Spec A).left,⊤) = A)
noncomputable def Over.universalSections : CommRingCat.of A ≅ Γ((C ⊗ overSpec k A).left, ⊤)     -- (Equiv :129)
```

### 2.4 The Zariski sep/glue pair and the π-cover descent (Layer-2 engine, reused by (C2))

`Picard/PicEtAffZariskiSep.lean`:
```lean
theorem PicEtAff.eq_of_away_eq (hg : Ideal.span (Set.range g) = ⊤) {x y : PicEtAff C A}
    (h : ∀ i, mapAlg C (IsScalarTower.toAlgHom k A (S i)) x = mapAlg C … y) : x = y            -- :137  (Zariski separation)
theorem exists_relPicAlgMap_eq_of_mapAlg_eq …                                                  -- :48
theorem exists_etaleCover_pi (hg …) …                                                          -- :98
```
`Picard/PicEtAffZariskiGlue.lean`:
```lean
theorem PicEtAff.exists_mapAlg_eq_of_compat (hg …) (x : ∀ i, PicEtAff C (S i)) (hcompat …) :
    ∃ z : PicEtAff C A, ∀ i, mapAlg C (IsScalarTower.toAlgHom k A (S i)) z = x i               -- :337  (Zariski gluing)
theorem relPicAlgMap_algEquiv_injective (e : A ≃ₐ[k] B) : Function.Injective (relPicAlgMap C e.toAlgHom)  -- :274
theorem mapAlg_mk_eq_mk …                                                                       -- :287
```
`Picard/RelPicPi.lean` (finite-product covers = the shape of étale covers on a field/localization):
```lean
theorem relPic.eq_of_pi_proj_eq [Finite ι] {ζ ζ'} (…proj-wise equal…) : ζ = ζ'                 -- :297
theorem relPic.exists_pi_lift [Finite ι] (ξ : ∀ i, relPic C (overSpec k (B i))) : ∃ …           -- :342
theorem isPullback_whiskerLeft / range_whiskerLeft [IsOpenImmersion g.left]                     -- :56 / :73
```

### 2.5 Layer-2 `picEt` and the affine comparison (where a *global/functorial* (C2) would live)

`Picard/PicEt.lean`:
```lean
def PicEtAff.congr (e : A ≃ₐ[k] B) : PicEtAff C A ≃* PicEtAff C B                               -- :59
def picEt (T) : Type u := picEtSubgroup C T   -- compatible families over T.left.affineOpens    -- :105  (CommGroup :108)
def picEt.eval (U : T.left.affineOpens) : picEt C T →* PicEtAff C Γ(T.left, U.1)                -- :126
def picEtAffineEquiv (A) : picEt C (overSpec k A) ≃* PicEtAff C A                               -- :235  ★ affine collapse
   (picEtAffineEquiv_apply :240, picEtAffineEquiv_symm_apply_val :247)
```
`Picard/PicEtMap.lean` (functoriality — consume section values through this ∃!-API):
```lean
def picEt.IsPullbackValue (f : T' ⟶ T) (s : picEt C T) (W) (v : PicEtAff C Γ(T'.left, W.1)) : Prop  -- :55
theorem pullbackValue_unique (hv hv') : v = v'                                                  -- :63
theorem exists_isPullbackValue … / exists_unique …                                             -- :108 / :196
noncomputable def picEtMapVal (f s W) : PicEtAff C Γ(T'.left, W.1)                              -- :212
lemma picEtMapVal_spec (f s W) : IsPullbackValue C f s W (picEtMapVal C f s W)                  -- :216  ★ the ∃!-API
lemma picEtMapVal_eq_of / picEtMapVal_eq_mapAlg                                                 -- :220 / :227
noncomputable def picEtMap (f : T' ⟶ T) : picEt C T →* picEt C T'   (picEtMap_id :261, _comp :275)  -- :234
noncomputable def picEtFunctor : (Over (Spec (.of k)))ᵒᵖ ⥤ CommGrpCat.{u}                      -- :314
theorem picEtAffineEquiv_naturality (φ : A →ₐ[k] B) (s) :
    picEtAffineEquiv C B (picEtMap C (Over.overSpecMap φ) s) = PicEtAff.mapAlg C φ (picEtAffineEquiv C A s)  -- :354
```
Section-ring plumbing (`Picard/PicEtSections.lean`): `overSpecΓTopAlgEquiv : Γ((overSpec k A).left,⊤)
≃ₐ[k] A` (:176), `appLEAlgHom` (:91), `resAlgHom` (used throughout); `attribute [local instance]
Over.sectionsAlgebra` (:57). **NOTE:** there is NO `picEtUnit : relPicFunctor C ⟶ picEtFunctor C`
anywhere in the tree — the Layer-2 unit does not yet exist (gap G4).

### 2.6 Module descent (brick 4) + affine Čech↔ring dictionary (the (C2) surjectivity engine)

`Descent/ModuleDescent.lean`: `structure Module.DescentDatum A B M` (:124); `.baseChange` (:141);
`.descended` (the equalizer `{m | δ m = 1 ⊗ₜ m}`); `.comparison_bijective` (**effectivity**, :63
docstring); `.descentEquiv : B ⊗[A] M₀ ≃ₗ[B] M`; `.unitEquiv : N ≃ₗ[A] (baseChange A B N).descended`;
`.equivDescended` (**uniqueness**). `Descent/InvertibleModule.lean:229`:
`Invertible.of_invertible_tensorProduct_of_faithfullyFlat` (an invertible module with a descent
datum descends to an invertible module). Dictionary: `Picard/CechPicSurjective.lean:283`
`Scheme.cechPicEquivPic (X) [IsAffine X] : X.CechPic ≃* CommRing.Pic Γ(X, ⊤)` (naturality
`toPic_map`/`toPic_mapAlgebra` in `Picard/CechPicToPicNaturality.lean`). These are exactly the
bricks the (C1) close already drives (`EtaleSeparatednessClose.lean:136–155`), so (C2) reuses the
identical toolchain in the opposite direction (class → datum → descended module → class).

### 2.7 Divisor / degree adjacency (NOT yet wired to Pic — see §3)

`Picard/DivisorClass.lean`: `structure LocalEquations (X)` (:112) → `picClass : X.CechPic` (:238),
with `restrict`/`mul`/`rescale` invariance (the (a) local-equations → class constructor of design
§2.6; **no** graph/point-divisor/pullback-compat yet). `RiemannRoch/Divisor.lean`: `CurveDivisor`
(:42), `deg` (residue-degree-weighted, :56) with `deg_add`/`deg_single` — a Weil-divisor degree,
**not** connected to `CechPic`/`relPic`/`picEt`. No `divisorClass : CurveDivisor → CechPic`, no
`deg_divisorClass`, no `pic0Functor`, no `degAt`, no `graphLocalEquations`, no `abelElement`, no
`JacobianData`/`Witness.lean` (the `Witness*.lean` files are (C1) coherent-witness descent, unrelated
to the design's `JacobianData`).

### 2.8 Frozen consumer and old-draft prior art

Frozen: `Challenge.lean` `Curve` (:67, no point), `ofCurve P` (:125), `comp_ofCurve` (:130),
`Jacobian`/`instGrpObj`/`baseChangeIso` sorries.

Old draft `MainProjects/Algebraic-Jacobian-Challenge` (READ-ONLY, lessons only):
`AlgebraicJacobian/Picard/RigidifiedPic.lean` — `structure Rigidification σ L` (:70) = trivialization
`σ^* L ≅ 𝒪_T`; `exists_rigidification_relPicRel σ hσ L` (:86) = **`lm:idn` surjectivity** by the
twist `L' = L ⊗ π_T^*((σ^*L)^{-1})` (`H_T`-equiv to `L`, rigidified). `FGAPicRepresentability.lean`
— `class HasRationalPoint C : Prop := ⟨Nonempty {σ : Spec k ⟶ C.left // σ ≫ C.hom = 𝟙}⟩` (:139): a
`k`-point of the curve stored as a *section of `C → Spec k`*, then used to make the plain relative
functor representable **conditional on `[HasRationalPoint C]`**; the single real sorry was
`instHasPicScheme [HasRationalPoint C] : HasPicScheme C := ⟨sorry⟩` (recon `old-draft-picard-recon.md`
§4), and the class stored `Nonempty (RepresentableBy)` — the datum was lost. **Binding lessons for
(C2):** (i) the rigidification twist `L ⊗ π_T^*((σ^*L)^{-1})` and the `lm:idn`/`lm:aut` decomposition
worked cleanly even in the old sheaf-object model — the *cocycle* model makes them cheaper still;
(ii) DO NOT introduce a `HasRationalPoint C` typeclass at the `k`-level — take the section as a
theorem hypothesis (design §7.3); (iii) DO NOT store `Nonempty`; (C2) is a bijection *theorem*, its
inverse a genuine `MulEquiv`, no existence-only wrappers.

---

## 3. Gap list (dependency order) + degree/Pic⁰ sequencing

Legend: **[indep]** independent of unlanded work · **[C1/L2]** needs landed (C1)/Layer-2 (both
present) · **[σ]** needs the curve's section/rational point.

**G0 — section↔point bridge. [indep, tiny].** `sectionOfPoint (σ : overSpec k A ⟶ C) : overSpec k A
⟶ C ⊗ overSpec k A` with `sectionOfPoint σ ≫ snd C _ = 𝟙` and `sectionOfPoint σ ≫ fst C _ = σ`
(`CartesianMonoidalCategory.lift ⟨toUnit ≫ σ, 𝟙⟩`-style). Gives the σ-pullback `σ^*` as a
`CechPic.map` and its interaction with `snd`/`fst`. Prereq for every [σ] item.

**G1 — rigidification normalization (`lm:idn`, cocycle form). [σ].** For `λ ∈ relPic C (overSpec k
B)` and a section `σ_B` over `B`, produce a representative `L` on `(C ⊗ Spec B).left` with `σ_B^* L`
canonically trivial (twist by `(fst)^*` of `σ_B^*` of the representative; the pullback-from-base
part dies in `relPic`). Shape:
```lean
lemma relPic.exists_rigidified_rep (σ : overSpec k B ⟶ C) (λ : relPic C (overSpec k B)) :
    ∃ L : (C ⊗ overSpec k B).left.CechPic, relPicMk C _ L = λ ∧ CechPic.map (sectionOfPoint σ).left L = 1
```
Reuses `mem_picFromBase_iff`, `relPicMk_eq_relPicMk_iff`; old draft's `exists_rigidification_relPicRel`
is the exact analogue.

**G2 — automorphism triviality (`lm:aut`), already essentially landed. [C1].** "A unit on `(C ⊗
Spec B).left` restricting to `1` along `σ_B` is `1`" — this is `Γ((C⊗Spec B).left,⊤) = Γ(Spec B)` =
`Over.universalSections` composed with `σ_B` being a section; and at cocycle level it is precisely
`prPullback_injective`/`unitsRes_injective`. Package as a one-liner `aut_trivial_of_section` from
the landed `Separatedness.lean` bricks. Low risk.

**G3 — (C2) surjectivity core: descent class → descended class. [σ, C1/L2].** THE brick. Given
`x ∈ descentClasses C E` on an étale cover `A → B = E.Carrier` and a section `σ_A` over `A` (which
base-changes to `σ_B` over `B`): use G1 to rigidify the representing `λ' = ↑x`, use the descent
equation `p₁^*λ' = p₂^*λ'` + G2 to promote it to a `Module.DescentDatum` on the invertible module
(via `cechPicEquivPic`), descend by brick 4 (`Invertible.of_invertible_tensorProduct_of_faithfullyFlat`
+ `DescentDatum.descended`) to `M : CommRing.Pic A`, transport to `λ ∈ relPic C (overSpec k A)`, prove
`unit C A λ = mk C E x` via `unit_eq_mk` + `mk_eq_mk_iff` + `relPicAlgMap_congr`. Delivers
`PicEtAff.unit_surjective_of_section`. This is the mirror of `EtaleSeparatednessClose.lean` — same
toolchain, opposite direction; the "one genuinely delicate step" (design §4.4) is building the
*comodule* descent datum from the class equation, where the rigidification (G1) supplies the missing
canonical coherence that `relPicAlgMap_congr` alone does not.

**G4 — Layer-2 unit `picEtUnit : relPicFunctor C ⟶ picEtFunctor C`. [C1/L2, indep of σ].** Does NOT
exist. Build the natural transformation whose affine component is `picEtAffineEquiv.symm ∘ unit`;
naturality from `mapAlg_unit` + `picEtAffineEquiv_naturality` + the glue-functoriality of `picEtMap`.
Needed independently by Wave 4 (representability compares `relPic` and `picEt`); the natural place to
land it is alongside the affine (C2). Independent of the section — build it first, then G5.

**G5 — global/functorial (C2) (optional, Wave-4 convenience). [σ, needs G3+G4].** `picEtUnit` is a
natural iso over section-admitting tests: `picEtUnit.app T` bijective when `snd C T` has a section.
For affine `T` this is G3 transported through `picEtAffineEquiv`; for general `T` it glues over
affine opens (each inheriting a section from the global one), licensed by `picEt` sheaf-uniqueness
(`picEt.ext_of_le_cover`, `PicEtMap.lean`). Wave 4 may only need the affine form (G3) + `picEtUnit`
(G4); land G5 only if Wave 4's assembly asks for it.

**Blueprint bookkeeping. [indep].** A `sec:PicardEtale` "(C2)/Rigidification" chapter with
`\lean`/`\leanok` nodes and `\source{kleiman-picard}` anchors on `th:cmp` Part 2, `df:rgd`,
`lm:idn`, `lm:aut` (a blueprint agent, editing only `blueprint/**`, does this concurrently).

### 3.1 What (C2) shares with the degree/Pic⁰ interface (design §6) — sequencing

- **The unit + comparison.** `pic0Functor` (design §6.2) is a subfunctor of `picEtFunctor`; `degAt`
  restricts a `picEt` class to `Spec K`-points and takes a degree over a finite separable `K'/K` —
  which uses *the same field-cover cofinality and the same `relPic ≃ picEt` comparison over fields*
  that (C2) provides (over a field a section always exists once `C(K')≠∅`, and field-extension
  covers are the π-covers of §2.4). So **G4 (`picEtUnit`) is a shared prerequisite** of both (C2)-
  global and the degree/Pic⁰ interface. Build G4 once, before either.
- **Disjoint cores.** (C2)'s hard content (module descent under a section, G3) and the degree's hard
  content (divisor↔Pic class `divisorClass`, `deg_divisorClass` via finite-flat pushforward rank,
  the χ-ledger connection — none landed, §2.7) do **not overlap**. They can proceed in parallel once
  G4 exists.
- **Ordering recommendation.** (a) G0–G2 (cheap, [σ]/[C1]); (b) **G3 = affine (C2)** — the wave-3
  keystone, mirrors the just-landed (C1) close, highest value, no dependence on any degree work; (c)
  G4 `picEtUnit` in parallel with G3 (independent); (d) THEN the degree/Pic⁰ brick, which consumes
  G4 and the *independent* `divisorClass`/`deg` wiring. Do **not** merge (C2) and degree into one
  brick: they share only G4 and would otherwise bloat past the 500-line rule with two unrelated hard
  cores. Sequence (C2) *first* (it is the Wave-3 completion item and de-risks G4 for the degree
  brick); degree/Pic⁰ is Wave-3's *last* interface item and can start its independent `divisorClass`
  lane immediately in parallel.

---

## 4. Launch-ready draft brick spec (house format)

```
# Brick spec — (C2): comparison under a section, `PicEtAff.unit_surjective_of_section`

*Written 2026-07-14 (orchestrator), (C1) + Layer-2 landed. Consumer: one implementation agent.
This is the surjectivity half of Kleiman 2.5(2) — the last Picard-comparison item of Wave 3.
The CONTRACT is binding; the route is the designed one, you own the organization. OPEN-2 of
`informal/wave3-picard-design.md`: statement is Wave-3, proof was allowed to slip to Wave-4 —
(C1) landed unconditionally, so prove it now.*

## Mission

Deliverable contract (in order):
1. `sectionOfPoint (σ : overSpec k A ⟶ C) : overSpec k A ⟶ C ⊗ overSpec k A` with
   `sectionOfPoint σ ≫ snd C _ = 𝟙` and `… ≫ fst C _ = σ` (G0), and the σ-pullback lemmas.
2. `PicEtAff.unit_surjective_of_section [IsProper C.hom][GeometricallyIrreducible C.hom]
   [GeometricallyReduced C.hom] (A) (σ : overSpec k A ⟶ C) : Function.Surjective (PicEtAff.unit C A)`
   (G1+G2+G3). Kernel-green, axiom-clean `[propext, Classical.choice, Quot.sound]`, no sorry.
3. `PicEtAff.unitEquiv_of_section (A) (σ) : relPic C (overSpec k A) ≃* PicEtAff C A` via
   `MulEquiv.ofBijective ⟨unit_injective, unit_surjective_of_section⟩`.
4. Package what falls out for the degree/Pic⁰ and Wave-4 consumers: `aut_trivial_of_section` (G2),
   `relPic.exists_rigidified_rep` (G1). If `picEtUnit` (G4) is trivial to add alongside, add it;
   otherwise leave a design note (it is a separate independent brick).

Staged fallback: (1) full contract; (2) G0–G2 + `exists_rigidified_rep` + G3 stated with the
module-descent step as the recorded frontier; (3) largest green committed prefix with a precise
frontier. Never red, never sorry.

## READ FIRST (binding order)
1. This recon (`informal/zeta-c2-rigidification-recon.md`) §1 (statement) + §2 (API) + §3 (gaps).
2. `informal/wave3-picard-design.md` §4.4 (C2) ledger, §7.3 audit line, §9 OPEN-2.
3. Kleiman `references/kleiman-picard-src/kleiman-picard.tex` L1483–1564 (`df:rgd`, `lm:idn`,
   `lm:aut`, Part-2 proof) — the mathematics you are recasting on cocycles.
4. The (C1) close as the mirror template: `Picard/EtaleSeparatednessClose.lean`,
   `Picard/CechKernelLemma.lean`, `Picard/EtaleSeparatedness.lean` (ζ1). Your G3 is its dual:
   class → descent datum → descended module → class (the SAME `Module.DescentDatum` /
   `Invertible.of_invertible_tensorProduct_of_faithfullyFlat` / `cechPicEquivPic` toolchain, opposite
   direction).
5. Landed API you consume verbatim (§2 of the recon for exact lines): `PicEtAff.unit`,
   `unit_injective`, `unit_eq_mk`, `mk_eq_mk_iff`, `descentClasses`, `relPicAlgMap_congr`,
   `relPicMk_eq_relPicMk_iff`, `mem_picFromBase_iff`, `Over.universalSections`,
   `Over.prPullback_injective`, `Module.DescentDatum.*`, `Scheme.cechPicEquivPic`,
   old-draft `RigidifiedPic.lean` (READ-ONLY, `lm:idn` twist).

## Design constraints (binding — the ζ2/ζ3 kernel discipline)
- The section is a THEOREM HYPOTHESIS `σ : overSpec k A ⟶ C`, never a `HasRationalPoint` class,
  never a `Curve`-field (the frozen `Curve` carries no point; audit §7.3). No `Nonempty`-wrapped
  data: the inverse is a genuine `MulEquiv`.
- Consume section values through the ∃!-API (`IsPullbackValue`/`picEtMapVal_spec`); state all
  algebra-indexed maps with explicit `k`-AlgHoms via `mapAlg`; `attribute [local instance]
  Over.sectionsAlgebra` (and the `WitnessAway` section-algebra locals if you cross section rings).
- Kernel discipline: opaque `def`s for repeated cover/class/unit/section data + named `≤`/refinement
  lemmas; one abstract lemma per rewrite-heavy step, instantiated by a single application; NO
  `rw`/`simp only … at` on hypotheses mentioning concrete curve/Spec towers; do every uniqueness over
  the double-cover base `B ⊗[A] B`, never over `A` (HO-unification sticks on metavariable
  projections — pin targets like `(B := E.Carrier ⊗[A] E.Carrier)`). Never put binders whose types
  use local scheme notation in `variable` (declarations silently vanish — verify keystones
  per-constant).
- Files ≤ 500 lines; namespace `AlgebraicGeometry`; mathlib naming + complete docstrings;
  `set_option autoImplicit false`; no new axioms. Suggested: `Picard/Rigidification.lean` (G0–G2 +
  `exists_rigidified_rep`), `Picard/PicEtAffSection.lean` (G3 + `unitEquiv_of_section`) — split as
  content dictates. Wire new files into `AlgebraicJacobian.lean` (a blueprint agent edits only
  `blueprint/**` concurrently). NEVER touch `Challenge.lean`.
- Search before proving (`lean_local_search`, `lean_loogle`, `lean_leansearch`) — especially the
  `CechPic` mk-calculus and mathlib faithfully-flat descent; most single steps exist.

## Verification (FOREGROUND, non-negotiable)
Iterate with the lean-lsp MCP; never two lake builds concurrently. When done: root `lake build`
blocked to completion (paste tail), `lean_verify` on `PicEtAff.unit_surjective_of_section`,
`PicEtAff.unitEquiv_of_section`, and every new keystone (axioms exactly `[propext, Classical.choice,
Quot.sound]`), `grep -n -w sorry` on touched files (exits 1 on zero matches — no `&&`-chaining).
Do NOT run git; do NOT commit.

## Report format (final message)
Files (line counts) · keystones with one-line statements · which organization G3 took and why (and
whether `picEtUnit`/G4 was folded in or deferred) · build tail verbatim · lean_verify outputs
verbatim · frontier if staged · what the degree/Pic⁰ spec-writer must know (in particular the exact
form of `unitEquiv_of_section` and any field-cover/`picEtUnit` hooks it can consume).
```

---

## 5. Eight-line summary + recommendation

1. (C2) HERE = Kleiman `th:cmp` Part 2 recast: `PicEtAff.unit` is *surjective when the projection
   has a section*; with the landed unconditional (C1) `unit_injective` this is the iso
   `relPic C A ≃* PicEtAff C A`. The only new content is surjectivity-under-a-section.
2. The frozen `Curve` (`Challenge.lean:67`) carries NO point; the `k`-point enters only as `ofCurve`'s
   argument — so (C2) takes the section as a HYPOTHESIS, never a `HasRationalPoint C` class.
3. Kleiman read: `th:cmp` L1384–1399, Part-1 proof L1454–1481, `df:rgd` L1483–1488, `lm:idn`
   L1490–1513, `lm:aut` L1515–1531, Part-2 proof L1533–1564, `rk:coh`/`eq:2b` L1566–1599.
4. The proof mirrors the just-landed (C1) close (`EtaleSeparatednessClose.lean`) in reverse:
   rigidify (`lm:idn`) → kill automorphisms (`lm:aut` = `universalSections`/`prPullback_injective`)
   → build a `Module.DescentDatum` → descend by brick 4 → transport via `cechPicEquivPic`.
5. Old-draft prior art (`RigidifiedPic.lean`) confirms the `lm:idn` twist `L ⊗ π_T^*((σ^*L)^{-1})`
   and warns: no `HasRationalPoint` class, no `Nonempty`-stored datum.
6. The Layer-2 unit `picEtUnit : relPicFunctor ⟶ picEtFunctor` does NOT exist (gap G4) and is a
   shared prerequisite of both (C2)-global and the degree/Pic⁰ interface.
7. Recommended (C2) statement: `PicEtAff.unit_surjective_of_section [IsProper][GeometricallyIrreducible]
   [GeometricallyReduced] (A) (σ : overSpec k A ⟶ C) : Function.Surjective (PicEtAff.unit C A)`, plus
   `unitEquiv_of_section := MulEquiv.ofBijective ⟨unit_injective, …⟩`.
8. Gap headline count: **6** (G0 bridge, G1 `lm:idn`, G2 `lm:aut`, G3 surjectivity core, G4
   `picEtUnit`, G5 optional global (C2)); degree/Pic⁰ shares only G4.

**Exact (C2) statement recommended:**
```lean
theorem PicEtAff.unit_surjective_of_section
    [IsProper C.hom] [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]
    (A : Type u) [CommRing A] [Algebra k A] (σ : overSpec k A ⟶ C) :
    Function.Surjective (PicEtAff.unit C A)
```

**Sequencing (C2) vs degree/Pic⁰:** land (C2) FIRST as the Wave-3 completion keystone — G0–G3 mirror
the fresh (C1) close and depend on no degree work; build G4 `picEtUnit` in parallel (independent of
the section, shared with degree). THEN the degree/Pic⁰ brick, whose independent `divisorClass`/`deg`
lane (§2.7 — not yet wired) can start immediately in parallel but which consumes G4. Do NOT merge the
two bricks: they share only G4 and have disjoint hard cores; merging blows the 500-line rule.
