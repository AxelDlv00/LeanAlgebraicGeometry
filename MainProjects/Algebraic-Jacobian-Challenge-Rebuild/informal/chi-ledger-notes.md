# χ-ledger lane — pre-design ground truth (run 0025, session 0002)

*Scouting notes for Wave-2 item 7 (`RiemannRoch/Degree.lean`, interface (E-i)–(E-iv) pinned in
`wave3-picard-design.md` §6.1). Not yet a binding design; recorded so the eventual designer does
not re-derive the codebase facts below.*

## Ground truth (verified in the tree, 2026-07-11)

- `Sheaf.HModule' F U n` (`Cohomology/OverOpen.lean:268`) is `Abelian.Ext (freeModuleSheaf J R U) F n`
  — Ext **on the whole site** from the free sheaf on `U`. It is NOT slice cohomology of `U`
  by definition.
- The landed affine vanishing `IsAffineOpen.subsingleton_moduleKSheaf_hModule'_one`
  (`Cohomology/AffineVanishing.lean:309`) is proved **for the structure sheaf specifically**
  (Serre cobounding through `cokernel_app_surjective`, which manipulates `Γ`-sections of
  `moduleKSheaf` over basic opens). There is no general "vanishing for any sheaf iso to 𝒪 on
  the affine" statement in the tree.
- Consequence: §6.1's remark that for a 2-cover twisted sheaf `F_g` the instances
  `Subsingleton (HModule' F_g Vᵢ 1)` "transport along `F_g|Vᵢ ≅ 𝒪|Vᵢ`" is NOT a rewrite;
  a restricted iso does not act on whole-site Ext. Three honest options:
  1. **Slice comparison lemma** (mathlib-PR grade, reusable): `Ext^n_{Sh(X)}(j_! A, F) ≃
     Ext^n_{Sh(U)}(A, F|_U)` for the open embedding `j : U ↪ X` (exact `j_!`, restriction
     preserving injectives). Then restricted isos transport vanishing. Clean, one-time cost.
  2. **Re-run Serre cobounding for `F_g`**: generalize `cokernel_app_surjective` from
     `moduleKSheaf` to any `F` that is "invertible-glued" on the affine — inspect whether the
     proof only touches sections over opens `⊆ U` (if so, the restricted iso rewrites it).
  3. **Avoid sheaf-level twists in the χ-ledger entirely** (divisor-first, recommended below).
- `Scheme.twoCoverH1LinearEquiv` (`TwoCover.lean:94`) is already general-coefficients: any
  `F : Sheaf (Opens.grothendieckTopology X) (ModuleCat k)` + the two Subsingleton instances.
- Mathlib's `Abelian.Ext` provides the covariant LES in the second argument (SES of sheaves ⇒
  LES of `HModule'`), so skyscraper dévissage is available without new machinery.

## Recommended shape (to be confirmed by the χ-design session)

Divisor-first, mirroring the classical curve theory and the (E-i) normalization:

- Realize `𝒪(D)` for an effective divisor `D` on the curve as the **subsheaf of the constant
  function-field sheaf** `K_C` cut by stalkwise order conditions (DVR stalks are landed:
  `Curve/StalksDVR.lean`), NOT as a cocycle twist. `𝒪 = 𝒪(0) ⊆ 𝒪(D)` with quotient a finite
  skyscraper of `k`-dimension `deg D` (local colengths; finite flat rank of `𝒪_D` gives (E-i)).
- `h⁰/h¹/χ` of these subsheaves via whole-site `HModule` + the Ext LES on
  `0 → 𝒪(D′) → 𝒪(D) → (skyscraper) → 0`; finiteness inherited from the landed
  `Module.Finite k H¹(C,𝒪)` by dévissage; `χ(𝒪(D)) = χ(𝒪) + deg D` by additivity. `χ(𝒪) = 1 − g`
  from `Γ(C,𝒪)=k` + the genus definition.
- (E-ii) hom property + well-definedness on classes: through L2's meromorphic bridge (every
  class is a divisor-class difference) + "principal divisors have degree 0" (order-sum of a
  rational function vanishes — the one genuinely new arithmetic input; Weil repartition /
  two-chart argument over `ℙ¹` via the landed finite `π : C → ℙ¹` is the candidate route).
- (E-iv) field-extension invariance: via `Cohomology/SectionsBaseChange.lean` (lane L3, in
  flight this session) + flat `⊗[k] K` exactness on the two-term complexes.
- The cocycle ↔ divisor interface stays in L2 (`DivisorClass.lean`/`MeromorphicTrivialization.lean`);
  the χ-ledger never needs `Subsingleton (HModule' F_g Vᵢ 1)` on this route — option 3 above,
  and the §6.1 coordination note to Wave 2 becomes moot.
