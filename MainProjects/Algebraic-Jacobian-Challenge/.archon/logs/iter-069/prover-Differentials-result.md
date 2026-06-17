# Prover Results: AlgebraicJacobian/Differentials.lean

## Iteration 069

### Completed

#### `cotangentExactSeqBeta` (L218–L268)

**Status:** Fully implemented, compiles.

**Construction:** The relative-quotient cotangent map `Ω_{X/S} ⟶ Ω_{X/Y}` for a composition `X ⟶ Y ⟶ S` is constructed via the universal property of `relativeDifferentials (f ≫ g)`.

**Key steps:**
1. Let `φ1' = adj_{f≫g}.homEquiv.symm (f ≫ g).c` (the ring presheaf map for `relativeDifferentials (f ≫ g)`).
2. Let `φ2' = adj_f.homEquiv.symm f.c` (the ring presheaf map for `relativeDifferentials f`).
3. Construct the natural transformation `η : (pullback (f ≫ g).base).obj S.presheaf ⟶ (pullback f.base).obj Y.presheaf` as the adjunct of `g.c ≫ (pushforward g.base).map (adj_f.unit.app Y.presheaf)` under `adj_fg`.
4. Prove the factorization `η ≫ φ2' = φ1'` by showing both sides have the same image under `adj_fg.homEquiv`:
   - `adj_fg.homEquiv (η ≫ φ2') = (f ≫ g).c` via adjunction naturality and `LocallyRingedSpace.comp_c`.
   - `adj_fg.homEquiv φ1' = (f ≫ g).c` by definition.
5. Use the universal derivation `d2 = derivation' φ2'` of `relativeDifferentials f` to build a derivation `d1` of `relativeDifferentials f` relative to `φ1'`. The `d_app` condition uses the factorization `η ≫ φ2' = φ1'`.
6. Apply the universal property `isUniversal' φ1'` to obtain the presheaf morphism, then package it as a `SheafOfModules.Hom`.

**Tactics used:** `calc`, `simp only [Category.assoc]`, `erw`, `congr 1`, `Equiv.apply_symm_apply`, `Adjunction.homEquiv_naturality_right`, `LocallyRingedSpace.comp_c`.

---

### Remaining sorries

| Declaration | Line | Status | Notes |
|---|---|---|---|
| `cotangentExactSeqAlpha` | 199 | `sorry` | Base-change map `f^* Ω_{Y/S} ⟶ Ω_{X/S}`. Requires constructing a derivation of `(pushforward f).obj (relativeDifferentials (f ≫ g))` relative to `φ_g'` using `KaehlerDifferential.D` composed with `f.c`. Needs naturality and `d_app` proofs involving the pullback composition isomorphism `pullbackComp`. |
| `relativeDifferentialsPresheaf_isSheaf` | 113 | `sorry` | Sheaf condition on the relative differentials presheaf. Requires localization compatibility of `KaehlerDifferential` with respect to basic opens and gluing. |
| `cotangentExactSeq_structure` | 239 | `sorry` | Bundled exactness claim. Blocked on `cotangentExactSeqAlpha`. Once `α` is available, the ring-level `KaehlerDifferential.exact_mapBaseChange_map` provides the ingredients. |
| `smooth_iff_locally_free_omega` | 281 | `sorry` | Characterization of smoothness via local freeness of `Ω_{X/S}`. |
| `cotangent_at_section` | 297 | `sorry` | Cotangent space at a section. Depends on `smooth_iff_locally_free_omega`. |
| `serre_duality_genus` | 441 | `sorry` | Serre duality genus equality. Independent of the cotangent sequence. |

---

### Recommendations for next iteration

1. **Priority 1:** `cotangentExactSeqAlpha`. The strategy is to use the adjunction `pullbackPushforwardAdjunction f` to convert the goal to constructing a morphism `relativeDifferentials g ⟶ (pushforward f).obj (relativeDifferentials (f ≫ g))`, then apply the universal property of `relativeDifferentials g` with the derivation `D(φ1'.app (f⁻¹U)) ∘ f.c.app U`.
2. **Priority 2:** `relativeDifferentialsPresheaf_isSheaf`. The blueprint suggests using `KaehlerDifferential.isLocalizedModule` for basic-open gluing, then extending to all opens via standard sheaf-on-basis lemmas.
3. **Priority 3:** Once `α` and `β` are both closed, `cotangentExactSeq_structure` follows from the ring-level exactness theorem glued pointwise.
