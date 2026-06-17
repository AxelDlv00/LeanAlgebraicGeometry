# AlgebraicJacobian/Picard/FlatteningStratification.lean

## Summary
- **Declarations added (3, all axiom-clean `{propext, Classical.choice, Quot.sound}`):**
  - `AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_finite` (line ~172)
  - `AlgebraicGeometry.GenericFreeness.exists_flat_localizationAway_of_finite` (line ~187)
  - `AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_moduleFinite` (line ~202)
- **Declarations blocked (0 new sorries added).** The 7 pre-existing scheme-level
  sorries are unchanged (now at lines 287, 331, 359, 389, 437, 478, 517 after my
  insertion). I did **not** touch them — see "Why not the 7 sorries" below.
- **Sorry count across file: 7 → 7** (no new sorries; +3 axiom-clean lemmas).
- Mode: mathlib-build. New section: `## Project-local Mathlib supplement —
  algebraic generic freeness (finite case)` inside `namespace GenericFreeness`.

## What was built — the finite-morphism case of generic freeness

The objective was to build `thm:generic_flatness_algebraic`
(`AlgebraicGeometry.TODO.genericFlatnessAlgebraic`) bottom-up, then reduce
`genericFlatness` (L208 → now L287) to it.

I landed the **finite-module / finite-morphism special case** axiom-clean:

- `exists_free_localizationAway_of_finite`: `A` noetherian domain, `M` finite
  `A`-module ⟹ `∃ f ≠ 0, Module.Free (Localization.Away f) (LocalizedModule
  (powers f) M)`.
  **Proof:** `Module.finitePresentation_of_finite` gives finite presentation;
  `Module.FinitePresentation.exists_free_localizedModule_powers` at the generic
  point `S = nonZeroDivisors A`, `Rₛ = FractionRing A` (a field, so the localized
  module is a finite vector space ⇒ `Module.Free` automatic). `r ∈ nonZeroDivisors A`
  ⇒ `r ≠ 0` via `nonZeroDivisors.ne_zero`. Note `FractionRing A = Localization
  (nonZeroDivisors A)` definitionally, so the `Module (FractionRing A) (LocalizedModule …)`
  + `IsScalarTower` + `Nontrivial` instances all fire automatically.
- `exists_flat_localizationAway_of_finite`: same hypotheses, `Module.Flat` form,
  via `Module.Flat.of_free`. (This is the affine-local content the geometric
  `genericFlatness` ultimately needs — flatness, not freeness.)
- `exists_free_localizationAway_of_moduleFinite`: `B` **module-finite** over `A`,
  `M` finite `B`-module ⇒ generic freeness over `A`, via `Module.Finite.trans`.
  This is exactly generic flatness for a **finite morphism** `X → S`.

These are a genuine, reusable special case of the full algebraic theorem (the
`d = 0` / finite case), and a building block for the dévissage leaves.

## Mathlib inventory (verified to exist) for the FULL theorem
The full statement (`B` **finite-type**, not module-finite) is a deep theorem.
Crucially, the dévissage scaffolding is **already in Mathlib**:
- `IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime` — prime-filtration
  dévissage (motive proven for `Subsingleton`, for `N ≃ₗ A ⧸ p`, and for a SES).
- `ModuleCat.free_shortExact` — SES with free ends ⇒ free middle (the glue).
- `exists_finite_inj_algHom_of_fg` / `exists_integral_inj_algHom_of_fg` — Noether
  normalisation **over a field**.
- `Module.free_of_finite_type_torsion_free` — finite torsion-free over a PID is free.
- `Module.Free.tensor` / base-change-of-free, `Module.finitePresentation_of_finite`.

## The single genuinely-missing Mathlib core
After Noether normalisation over `K = Frac A`, one reduces (for `B` a domain,
`M = B`) to: **`B_g` is a finite module over the polynomial ring
`A_g[X₁,…,X_d]`; show `∃ f ≠ 0` with `(B_g)_f` free over `(A_g)_f`.** Mathlib
does **not** have this "generic freeness over a polynomial ring" step (the
dimension-induction / clearing-denominators core). This is the exact next
Mathlib-gradient target. Name it e.g.
`exists_free_localizationAway_of_finite_polynomialAlgebra`:
> `A` noetherian domain, `M` finite `A[X₁…X_d]`-module ⇒ `∃ f ∈ A, f ≠ 0`,
> `M_f` free over `A_f`.
Proof route (Stacks 051R): induction on `d` using the one-variable case +
torsion/PID structure of the generic fibre.

## Decomposition of `genericFlatnessAlgebraic` (for the planner)
1. **[LANDED]** finite case (above).
2. **[medium, Mathlib-present ingredients]** dévissage glue: reduce arbitrary
   finite `B`-module `M` to `M = B/p`. Use `induction_on_isQuotientEquivQuotientPrime
   (A := B)`. SES step: given `f₁, f₃ ≠ 0` for the sub/quotient, take `f = f₁f₃`,
   localise the (A-linear) SES at `powers f`, package as a `ShortComplex (ModuleCat
   (Away f))` that `IsLocalizedModule`-exactness makes `ShortExact`, apply
   `ModuleCat.free_shortExact`. **Friction:** the common-denominator base-change
   iso `Away(f₁f₃) ⊗_{Away f₁} LocalizedModule(powers f₁) N ≅ LocalizedModule(powers
   (f₁f₃)) N` and the `Module A N` (restrict-scalars from `Module B N` via
   `Algebra A B`, non-instance) must be built by hand. No one-liner exists
   (`exact?` fails on the further-localization-preserves-free step). ~150 LOC.
3. **[reduce]** `B/p` ⇒ `B` a domain, `M = B`; split `ker(A→B)` ≠ 0 (then `B_r = 0`
   for `r ≠ 0` in the kernel — trivially free) vs. `A ↪ B`.
4. **[MISSING CORE]** the polynomial-ring step above.

## Why not the 7 scheme-level sorries
- **`genericFlatness` (now L287) — SIGNATURE DEFECT, currently UNPROVABLE.**
  `X.Modules = SheafOfModules X.ringCatSheaf` is the **full** category of
  `𝓞_X`-modules; the hypothesis carries **no coherence / finite-type condition on
  `F`**. Generic flatness is FALSE for non-coherent sheaves (e.g. an infinite direct
  sum need not become flat on any nonempty open). The conclusion (`∃ V` nonempty
  open, flatness on all affine `U ≤ V`) cannot be honestly produced for arbitrary
  `F`. **Recommendation to USER/planner:** add a `[hypothesis: F coherent / of
  finite type]` to the signature (it is NOT in `archon-protected.yaml`, so the
  planner may re-sign it). The blueprint `thm:generic_flatness` (geometric form)
  explicitly requires `𝓕` coherent; the Lean signature dropped it.
- The other 6 (`flatLocusStratification`, `flatLocusReduction`, `flatLocusAssembly`,
  `flatteningStratification`, `flatteningStratification_universal`, `ofCurve`) are
  all downstream of `genericFlatness` and additionally need Mathlib-absent AG
  infrastructure (relative `ℙⁿ_S`, Castelnuovo–Mumford regularity, cohomology &
  base change, locally-closed-immersion stratification API). None is closable in a
  single session; several also lack the coherence hypothesis on `F`.

## Per-declaration log

### exists_free_localizationAway_of_finite — RESOLVED (axiom-clean)
- Approach: generic-point localization + `exists_free_localizedModule_powers`.
- Verified: `#print axioms` = `{propext, Classical.choice, Quot.sound}`.

### exists_flat_localizationAway_of_finite — RESOLVED (axiom-clean)
- Approach: free ⇒ flat via `Module.Flat.of_free` (name `Module.Free.flat` does
  NOT exist — dead end avoided).

### exists_free_localizationAway_of_moduleFinite — RESOLVED (axiom-clean)
- Approach: `Module.Finite.trans B M` (needs `[Module.Finite A B] [Module.Finite B M]
  [IsScalarTower A B M]`) then the finite case.

### genericFlatnessAlgebraic (full) — NOT ADDED
- Cannot be added with a sorry (mathlib-build invariant). Missing core named above.
- Dead end: `Module.freeLocus`/`Module.isOpen_freeLocus` do NOT apply — they need
  `Module.FinitePresentation R M` over the **base** `R = A`, but `M` is finite only
  over `B`, not over `A`. The whole subtlety of generic freeness is precisely that
  `M` is not `A`-finite.

## Why I stopped
**Partial progress.** 3 axiom-clean declarations added (the finite-morphism case of
generic freeness — a genuine special case of `genericFlatnessAlgebraic`). Stopped
because the remaining work splits into (a) the dévissage glue (~150 LOC of
localization plumbing — feasible but heavy, high risk of not closing in-session,
and mathlib-build forbids committing a partial decl with a sorry), and (b) the
genuinely **Mathlib-absent core**: generic freeness for a finite module over a
polynomial ring `A[X₁…X_d]` (named precisely above). Informal agent (Moonshot)
consulted: confirmed the proof structure and that the polynomial-ring step is the
hard residue with no Mathlib shortcut. Also surfaced a blocking **signature defect**
on `genericFlatness` (missing coherence hypothesis on `F`) that makes it currently
unprovable as stated — flagged for the planner/USER.

## Blueprint markers
- The 3 new lemmas are project-local supplements with **no blueprint pin** (they are
  a strict special case of `thm:generic_flatness_algebraic`, not the pinned full
  statement). Do NOT mark `thm:generic_flatness_algebraic` `\leanok` — it is not
  formalized. No marker action needed from review for these.
