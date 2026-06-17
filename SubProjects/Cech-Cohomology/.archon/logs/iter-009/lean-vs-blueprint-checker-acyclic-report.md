# Lean ↔ Blueprint Check Report

## Slug
acyclic

## Iteration
009

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_AcyclicResolution.tex`

---

## Per-declaration

### `\lean{CategoryTheory.Functor.rightDerivedOneIsoCokerOfAcyclic}` (chapter: `lem:acyclic_one_iso_coker`)

- **Lean target exists**: yes (line 689)
- **Signature matches**: yes
  - Blueprint: `(R¹G)(A) ≅ coker(G(J) → G(Z))` for an additive left-exact `G` and SES `0 → A → J → Z → 0` with `J` right-G-acyclic.
  - Lean: `(G.rightDerived 1).obj ses.X₁ ≅ cokernel (G.map ses.g)` with `[G.Additive]`, `[PreservesFiniteLimits G]`, `hses : ses.ShortExact`, `[G.IsRightAcyclic ses.X₂]`.
  - `ses.X₁ = A`, `ses.X₂ = J`, `ses.X₃ = Z`; `ses.g : J → Z` is the surjection; `[PreservesFiniteLimits G]` is the correct Lean encoding of left-exactness (as stated in the blueprint setup prose, lines 38–39).
- **Proof follows sketch**: yes
  - Blueprint proof (lines 720–747): δ⁰ is epi (since `(R¹G)(J) = 0` by acyclicity), the segment `G(J) → G(Z) →^δ⁰ (R¹G)(A) → 0` is exact, so δ⁰ exhibits `(R¹G)(A)` as coker of `G(J) → G(Z)`; two naturality steps (`isoRightDerivedObj` for ψ, `rightDerivedZeroIsoSelf` for degree 0) identify the homology map with `G.map ses.g`.
  - Lean proof (lines 693–725): horseshoe resolutions `I_A`, `I_J`, `I_C`; `hSG` short-exactness after applying `G`; `hepi : Epi (hSG.δ 0 1)` via `epi_δ` + acyclicity of `I_J` at degree 0; `hex.gIsCokernel` gives the cokernel cocone; chain of isos via `I_A.isoRightDerivedObj G 1`, `cokernel.mapIso` (with `I_J.isoRightDerivedObj`, `I_C.isoRightDerivedObj`), `G.rightDerivedZeroIsoSelf`, closed by `isoRightDerivedObj_hom_naturality`.
  - Mathematical steps match exactly.
- **Axioms**: `propext`, `Classical.choice`, `Quot.sound` — standard kernel only.
- **Sorries**: none.
- **`\leanok`**: statement block and proof block both carry `\leanok` — correct.
- **notes**: None.

---

### `\lean{CategoryTheory.Functor.rightDerivedIsoOfAcyclicResolution}` (chapter: `lem:acyclic_resolution_computes_derived`)

- **Lean target exists**: yes (line 893)
- **Signature matches**: yes, with one minor encoding difference noted below
  - Blueprint: additive left-exact `G`; resolution `0 → A → J⁰ → J¹ → ···` with every `Jⁿ` right-G-acyclic; conclusion `(RⁿG)(A) ≅ Hⁿ(G(J•))`.
  - Lean: `(G : 𝒜 ⥤ ℬ) [G.Additive] [PreservesFiniteLimits G]`, `(K : CochainComplex 𝒜 ℕ)` (augmentation-dropped resolution), `(A : 𝒜)`, `(e : A ≅ K.cycles 0)`, `(hexact : ∀ n, K.ExactAt (n+1))`, `[∀ n, G.IsRightAcyclic (K.X n)]`, `(n : ℕ)`, returning `(G.rightDerived n).obj A ≅ ((G.mapHomologicalComplex _).obj K).homology n`.
  - The augmented presentation `0 → A → K` is replaced by the isomorphism `e : A ≅ K.cycles 0` (augmentation-dropped encoding). These are mathematically equivalent: `K.cycles 0 = ker(K.d 0 1)` and `hexact` forces the resolution to be exact in all positive degrees. The blueprint's iter-009 directive explicitly acknowledges this TARGET-3 encoding.
  - `[∀ n, G.IsRightAcyclic (K.X n)]` correctly encodes "every `Jⁿ` is right-G-acyclic".
- **Proof follows sketch**: yes
  - Blueprint proof (lines 996–1049): degree-0 by `H⁰(G(J•)) ≅ G(A)` + `R⁰G ≅ G`; positive degrees by staircase of dimension-shift isos `(RⁿG)(A) ≅ (Rⁿ⁻¹G)(Z¹) ≅ ··· ≅ (R¹G)(Zⁿ⁻¹)`, closed by `lem:acyclic_one_iso_coker` giving `(R¹G)(Zⁿ⁻¹) ≅ coker(G(Jⁿ⁻¹) → G(Zⁿ))`, then `lem:cohomology_of_applied_resolution` identifying that cokernel with `Hⁿ(G(J•))`.
  - Lean proof (lines 899–922): `stairGen m s` encodes `(R^{m+1}G)(K.cycles s) ≅ (R¹G)(K.cycles (s+m))` by `m`-fold induction on `rightDerivedShiftIsoOfAcyclic (cosyzygyShortExact K s (hexact s))`; case `n=0`: `rightDerivedZeroIsoSelf.app A ≪≫ G.mapIso e ≪≫ G.gHomologyZeroIso K`; case `n=m+1`: `(G.rightDerived (m+1)).mapIso e ≪≫ stairGen m 0 ≪≫ eqToIso ··· ≪≫ G.rightDerivedOneIsoCokerOfAcyclic (cosyzygyShortExact K m (hexact m)) ≪≫ (G.cohomologyAppliedResolutionIso K m).symm`.
  - Mathematical structure matches blueprint exactly.
- **Axioms**: `propext`, `Classical.choice`, `Quot.sound` — standard kernel only.
- **Sorries**: none.
- **`\leanok`**: statement block and proof block both carry `\leanok` — correct.
- **notes**: The status comment in the Lean file (lines 924–963) is an iteration log from iter-006; it correctly describes history and is not an excuse-comment. It does not affect the declaration.

---

## Red flags

*(Section empty — no red flags found.)*

---

## Unreferenced declarations (informational)

All major infrastructure declarations are referenced in the blueprint via `\lean{...}` hints. The following are local helpers not separately blueprinted; all are reasonable:

| Declaration | Role | Concern |
|---|---|---|
| `Functor.isZero_homology_mapHomologicalComplex_of_isRightAcyclic` | Bridges `IsRightAcyclic` vanishing to complex-level zero; used by `rightDerivedShiftIsoOfSplitResolutionSES` | None — reasonable helper |
| `shortExact_of_degreewise_splitting` | Assembles splitness into short-exactness | None |
| `shortExact_map_mapHomologicalComplex_of_degreewise_splitting` | `G` applied to degreewise-split SES is short-exact | None |
| `cosyzygy_iCycles_comp_toCycles`, `epi_toCycles_of_exactAt`, `cosyzygyKernelFork` | Sublemmas for `cosyzygyShortExact` | None |
| `Functor.cosyzygyShortComplex` | Definition supporting `cosyzygyShortExact` | None |
| `Functor.gCosyzygyIsoCocycles_hom_iCycles`, `Functor.gCosyzygyIsoCocycles_toCycles` | Naturality lemmas supporting `cohomologyAppliedResolutionIso` | None |
| `single₀_hom_ext` (private) | Horseshoe helper | None |

None of these is a substantive standalone claim that the blueprint omits improperly.

---

## Blueprint adequacy for this file

- **Coverage**: All substantive declarations have a corresponding `\lean{...}` block. Helper-only declarations are appropriately not individually blueprinted. 2/2 focal declarations covered; overall coverage adequate.
- **Proof-sketch depth**: **adequate**. Both `lem:acyclic_one_iso_coker` and `lem:acyclic_resolution_computes_derived` have detailed proof sketches (lines 716–747, 996–1049) that clearly guided the Lean proofs. The staircase structure, the cokernel identification at the base, and the degree-0 left-exactness argument are all spelled out.
- **Hint precision**: **precise**. The `\lean{...}` names match the Lean declarations exactly.
- **Generality**: **matches need**. The blueprint's scope (abelian category, additive functor, enough injectives) matches the Lean variables exactly.
- **Minor gap** (not blocking): The blueprint states the resolution input as the augmented sequence `0 → A → J⁰ → J¹ → ···`, while the Lean implementation uses the augmentation-dropped encoding `(K, e : A ≅ K.cycles 0, hexact)`. The Lean docstring at lines 878–892 explains this encoding, but the blueprint does not note the translation. This is not a mismatch — the two are equivalent and the Lean docstring bridges the gap — but a one-sentence note in `lem:acyclic_resolution_computes_derived`'s statement block would improve blueprint↔Lean transparency.
- **Recommended chapter-side actions**:
  - (Minor) In `lem:acyclic_resolution_computes_derived`'s statement block, add a sentence noting that the Lean formalization drops the augmentation and passes instead `K : CochainComplex` with `e : A ≅ K.cycles 0` and `hexact : ∀ n, K.ExactAt (n+1)`, to explain the signature to future readers.

---

## Severity summary

| Finding | Severity |
|---|---|
| Blueprint doesn't document the `e : A ≅ K.cycles 0` augmentation-dropped encoding convention | **minor** |

**must-fix-this-iter**: 0 findings.

**Overall verdict**: Both `rightDerivedOneIsoCokerOfAcyclic` and `rightDerivedIsoOfAcyclicResolution` are sorry-free, use only standard Lean 4 kernel axioms, match their blueprint signatures and proof sketches faithfully, and have correctly placed `\leanok` markers; the only finding is a minor blueprint clarity gap in the resolution-input description. — 2 declarations checked, 0 red flags.
