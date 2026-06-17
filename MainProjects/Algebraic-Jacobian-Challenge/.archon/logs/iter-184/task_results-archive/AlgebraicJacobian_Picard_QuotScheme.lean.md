# AlgebraicJacobian/Picard/QuotScheme.lean — iter-183 Lane F PIVOT

## Summary

**Status: PARTIAL (PIVOT goal achieved; consumer body structured but inline-sorry remains).**

- Sorries entering: 8.
- Sorries exiting: **9** (+1; matches the directive's "UP by 1" prediction).
- Project axioms: **0** (unchanged).
- New decl: `Scheme.Modules.pullback_app_isoTensor` (typed-sorry def at L480).
- Consumer `_of_isAffineBase` body (L515): restructured to actively
  consume the new def; one residual inline `sorry` for the
  Beck–Chevalley compatibility step.

The PIVOT directive's primary ask (introduce the load-bearing typed-sorry
def named in the analogy file) is satisfied. The consumer body now
threads the new def via a structured `letI`/`let _isoLHS` chain, making
the iter-184+ closure path explicit.

## Scheme.Modules.pullback_app_isoTensor (L480 — NEW typed sorry)

### Approach
- **Approach:** Add the load-bearing typed-sorry def per
  `analogies/quotscheme-pullback-affine-section.md` Decision 1
  (`BUILD_PROJECT_HELPER` verdict).
- **Signature**: takes `g : Y ⟶ X`, `N : X.Modules`, an affine open
  `U : Y.Opens`, an affine open `V : X.Opens`, and compatibility
  `e : U ≤ g ⁻¹ᵁ V`. Returns
  `Γ((pullback g).obj N, U) ≃ₗ[Γ(Y, U)] TensorProduct Γ(X, V) Γ(Y, U) Γ(N, V)`.
  The `Γ(X, V)`-algebra structure on `Γ(Y, U)` is captured via a
  signature-embedded `letI : Algebra Γ(X, V) Γ(Y, U) := (g.appLE V U e).hom.toAlgebra`.
- **Body:** `letI ... ; exact sorry` (Tier-3 typed sorry — direct sorry
  on a substantive type, ~120–200 LOC body owed iter-184+).
- **Result:** RESOLVED — def added, file compiles, type-checks.
- **Tier:** Tier-3 (direct sorry; substantive Stacks 01HQ / 01I8 content
  via the `Tilde` route to be discharged iter-184+).

### Key Mathlib lemmas verified in scope
- `Scheme.Hom.appLE`: `Γ(Y, U) ⟶ Γ(X, V)` for compatible affine pair.
  Signature returns CommRingCat morphism; `.hom` extracts `→+*`.
- `RingHom.toAlgebra`: gives `Algebra` instance from a ring map.
- `IsAffineOpen`, `IsAffineOpen.isAffine_of_isOpen`, etc.
- `TensorProduct R M N` over the `R`-algebra `S`.

### Notes for iter-184+ body closure
The body's intended construction (Stacks 01HQ / 01I8):
1. Reduce to the affine case by `Scheme.Modules.Hom.isIso_iff_isIso_app`
   or restrict to the affine open `U`.
2. On `Spec Γ(X, V)`, `tilde N` realizes `Γ(tilde N, ⊤) = N`
   (`AlgebraicGeometry.Modules.Tilde.isoTop`).
3. The analogous identification `(pullback g).obj (tilde N) ≅ tilde (Γ(Y, U) ⊗_{Γ(X, V)} N)`
   at Spec rings, then promoted to a general affine open in `Y`.

## canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen_of_isAffineBase (L515 — consumer body)

### Attempt 1
- **Approach:** Consume the new `pullback_app_isoTensor` via a structured
  `letI`/`let _isoLHS` chain. Set `V := ⊤ : S.Opens` (affine via
  `isAffineOpen_top`), `e := le_top`, instantiate the algebra structure
  via `(g.appLE ⊤ U e).hom.toAlgebra`, and bind the LHS iso to
  `_isoLHS`. Outline the RHS algebraic iso (via `Flat.flat_appLE` +
  `Module.Flat.isBaseChange` + `IsBaseChange.equiv`) in comments.
- **Result:** PARTIAL — body is structured (no longer bare `sorry`); single
  inline `sorry` for the Beck–Chevalley compatibility step (the BC arrow
  equals `_isoLHS` composed with the algebraic iso under the
  `pushforward_obj_obj`-rfl identification on the RHS).
- **Why partial:** the Beck–Chevalley compatibility itself (showing
  the canonical `mateEquiv`-built BC arrow factors through the iso
  chain) requires explicit computation of `mateEquiv`'s action on
  sections — non-trivial 3rd-party gap. The directive's
  "sorry-free assembly" aspiration assumed Mathlib's mateEquiv exposes
  this compatibility; in practice it does not at the pinned commit.
- **Tier:** Tier-2 modulo `pullback_app_isoTensor` AND modulo the BC
  compatibility (the latter inline as `sorry`).

### Key Mathlib lemmas verified
- `isAffineOpen_top : IsAffineOpen (⊤ : S.Opens)` (under `[IsAffine S]`)
  — verified via `lean_leansearch`.
- `Scheme.Hom.flat_appLE`: `(g.appLE V U e).hom.Flat` for affine pair.
- `Scheme.Modules.pushforward_obj_obj`: `Γ((pushforward f).obj M, U) = Γ(M, f ⁻¹ᵁ U)` (rfl).

### Dead ends / pivots
- iter-181 strategy of "decompose into more helpers around the gap"
  was DECLARED WRONG by iter-182 analogist consult; this iter
  followed the PIVOT recommendation (`BUILD_PROJECT_HELPER` for the
  load-bearing leaf) and resists the temptation to add another
  decomposition helper for the consumer body.
- Considered making the typed-sorry def return `IsIso` of the BC arrow
  directly (would close the consumer body trivially). REJECTED: the
  analogy file recommends the iso form because it is reusable
  Mathlib-grade structure, not a one-shot `IsIso` claim.

## Off-target sorries (unchanged)

The following sorries are explicitly OUT OF SCOPE per the Lane F
directive:
- L170 `hilbertPolynomial` (file-skeleton stub — iter-177+ work).
- L208 `QuotFunctor` (file-skeleton stub — iter-177+ work).
- L245 `Grassmannian` (file-skeleton stub — iter-177+ work).
- L272 `Grassmannian.representable` (file-skeleton stub — iter-177+ work).
- L326 `QuotScheme` (file-skeleton stub — iter-177+ work).
- L576 `_of_isAffineOpen` (base-side Mayer-Vietoris — Decision 3 gap).
- L617 `_of_affineCover` (target-side Mayer-Vietoris — Decision 3 gap).

## Blueprint coordination

Blueprint chapter `blueprint/src/chapters/Picard_QuotScheme.tex` already
identifies the LHS bridge as a project-side bridge (L851–856). No
new `\lean{...}` block needed — the new
`Scheme.Modules.pullback_app_isoTensor` decl is an INTERNAL helper, not a
blueprint pin (the chapter's pins are the 6 statements at the top of the
file: `hilbertPolynomial`, `QuotFunctor`, `Grassmannian`,
`Grassmannian.representable`, `QuotScheme`, `flatBaseChangeCohomology`).

### Recommendation for blueprint-writer iter-184
Add a `\lean{}` pin for `Scheme.Modules.pullback_app_isoTensor` in the
"Cohomology and base change" section (around L851–856 of the chapter),
noting it as the load-bearing project-side bridge.

## Iter-184+ path forward

1. **Close `pullback_app_isoTensor` body** (~120–200 LOC) via the
   Tilde route on Spec + affine-open promotion. This single closure
   retires the sorryAx taint of `_of_isAffineBase` (modulo BC compat).
2. **Close BC compatibility** in the `_of_isAffineBase` body: either
   build a project-side `mateEquiv_app_sections` compat lemma, OR
   exhibit the BC arrow's inverse directly via the iso chain (avoiding
   the compatibility claim).
3. **Then** the affine-base helper is Tier-1 axiom-clean; transitively
   feeds `_of_isAffineOpen` (gap (b)) and `flatBaseChangeCohomology`.

## Net sorry accounting (iter-183)

| Line | Decl | Status |
|---|---|---|
| 170 | `hilbertPolynomial` | sorry (off-target) |
| 208 | `QuotFunctor` | sorry (off-target) |
| 245 | `Grassmannian` | sorry (off-target) |
| 272 | `Grassmannian.representable` | sorry (off-target) |
| 326 | `QuotScheme` | sorry (off-target) |
| **480** | **`pullback_app_isoTensor`** | **NEW typed sorry (Lane F PIVOT primary)** |
| **515** | **`_of_isAffineBase`** | **structured body + 1 inline sorry (BC compat)** |
| 576 | `_of_isAffineOpen` | sorry (off-target) |
| 617 | `_of_affineCover` | sorry (off-target) |

Entering: 8 / 0 axioms. Exiting: **9 / 0 axioms** (+1 sorry, no axiom regression).
