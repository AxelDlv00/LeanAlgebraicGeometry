# Cohomology/MayerVietoris.lean — iter-061 prover round

## Summary

**Mode**: Acceptable (per the iter-061 success ladder). The single transient
sorry from iter-060 has been decomposed into two substep sorries with
substantive `have`/`rw` scaffolding routing the goal toward the relevant
Mathlib leverage. Substep (a)'s claim is concretely stated as a per-`f`
`ExactAt n` hypothesis on the slice-cover Čech cochain complex; the
remaining assembly sorry is in the `Function.Exact` form after the
mechanical conversion via `HomologicalComplex.exactAt_iff` +
`ShortComplex.ShortExact.moduleCat_exact_iff_function_exact`.

- **Sorry trajectory**: `10 → 11` (project-wide); `1 → 2` inside
  `MayerVietoris.lean`.
- **File LOC**: 1735 → 1785 (+50 LOC).
- **No new axioms** introduced.
- **No protected signatures modified**.
- **No iter-053–060 declarations touched** (helper
  `cechCohomology_subsingleton_of_cechCochain_exactAt` remains in place
  and is still consumed by the structural reduction at the top of the
  body).

## What was done

### Decomposition of the iter-060 single sorry

The iter-060 single transient sorry (at L1729) was replaced with a
structured proof skeleton that:

1. Performs the structural reduction `Subsingleton (cechCohomology n)
   → ExactAt n` via the iter-060 helper
   `cechCohomology_subsingleton_of_cechCochain_exactAt` (unchanged).

2. **Substep (a) — slice-cover Čech complex ExactAt n** is stated as a
   labelled `have h_a : ∀ (f : s), (slice cover Čech).ExactAt n :=
   sorry`, where the slice cover is
   `fun (f' : s) => basicOpenCover s f' ⊓ C.left.basicOpen f.1`. This
   captures the per-`f` data-bearing claim — the cover of `D(f)` by
   `{basicOpenCover s f' ⊓ D(f)}_{f' ∈ s}` is exact at degree `n`. The
   inline-comment annotation names the four-step Mathlib leverage chain:

   - `FormalCoproduct.extraDegeneracyCech`
     (`Mathlib/CategoryTheory/Limits/FormalCoproducts/ExtraDegeneracy.lean` L92)
     — gives `ExtraDegeneracy` on the augmented Čech simplicial object
     from a section `T ⟶ U.obj i₀`. The required section is supplied by
     `D(f) → D(f)` (the cover member at `f' = f`).
   - `SimplicialObject.Augmented.ExtraDegeneracy.homotopyEquiv`
     (`Mathlib/AlgebraicTopology/ExtraDegeneracy.lean` L328) — converts
     `ExtraDegeneracy` into a homotopy equivalence with the constant
     complex on the augmentation, whose positive-degree homology is `0`.
   - Op-passage via `CochainComplex.opEquivalence` — bridges Mathlib's
     chain-complex form to the project's cochain-complex form
     (`alternatingCofaceMapComplex`).
   - Read-off `ExactAt n` for `0 < n` from the null-homotopy.

3. **Mechanical conversion** `ExactAt n → Function.Exact ⇑f ⇑g`. After
   `h_a` is in scope, the goal is rewritten via
   `HomologicalComplex.exactAt_iff` and
   `ShortComplex.ShortExact.moduleCat_exact_iff_function_exact`
   (`Mathlib/Algebra/Homology/ShortComplex/ModuleCat.lean` L78) to
   `Function.Exact ⇑((K.sc n).f) ⇑((K.sc n).g)`. This is a
   single-line `rw` that closes off the substep-(c) routing step
   completely — the next iteration starts from a goal in the form
   `exact_of_isLocalized_span`'s conclusion shape.

4. **Substep (b)+(c) — localised-Čech identification + local-to-global**
   remains as a single labelled `sorry`. The inline-comment annotation
   describes the full cochain-factor identification chain:

   - iter-057 `basicOpenCover_finset_inf'_eq_basicOpen_prod` applied to
     the augmented index `{f} ∪ image x` to identify
     `(slice cover).X^n` cochain factor as `D(f · ∏ k, (x k).1)` basic
     open
   - iter-059 `basicOpenCover_finset_inf'_isLocalization` to identify
     the sections on this basic open with `Localization.Away
     (f · ∏ k, (x k).1) Γ(C.left, U)`
   - localisation transitivity `R[1/(f·g)] = R[1/g][1/f]` to factor out
     `f`
   - product-localisation commutation to identify
     `(∏_x R[1/∏_k (x k).1])[1/f]` with `K.X^n[1/f]`
   - `IsLocalizedModule.map_exact`
     (`Mathlib/Algebra/Module/LocalizedModule/Exact.lean` L56) to
     transport the cochain identification to the differential
   - `exact_of_isLocalized_span`
     (`Mathlib/RingTheory/LocalProperties/Exactness.lean` L173) to
     globalize per-`f` exactness across the spanning hypothesis
     `hs : Ideal.span s = ⊤`
   - Ring-base reconciliation: `(K.sc n).f.hom` is `k`-linear over
     `ModuleCat k`, but `exact_of_isLocalized_span` consumes
     `Γ(C.left, U)`-linear maps. They coincide as set-functions
     (`Function.Exact` doesn't see the ring), but the type-level
     reconciliation requires either explicit `Module Γ(C.left, U)`
     instance plumbing on each cochain factor, or an explicit linear-map
     upgrade.

## Sorry inventory (post iter-061)

- L1722: substep (a) — `(slice cover Čech).ExactAt n` via
  `FormalCoproduct.extraDegeneracyCech` + `ExtraDegeneracy.homotopyEquiv`
  + op-passage.
- L1778: substep (b)+(c) — `Function.Exact ⇑((K.sc n).f) ⇑((K.sc n).g)`
  via cochain-level localisation iso + `exact_of_isLocalized_span`
  ring-base bridge.

## Mathlib lemmas successfully fired

- `HomologicalComplex.exactAt_iff`: definitional unfold of `ExactAt n`
  to `(K.sc n).Exact`. Verified via `lean_multi_attempt`.
- `ShortComplex.ShortExact.moduleCat_exact_iff_function_exact`
  (`Mathlib/Algebra/Homology/ShortComplex/ModuleCat.lean` L78):
  bridge from `(S : ShortComplex (ModuleCat R)).Exact` to
  `Function.Exact S.f S.g` (function-level). Despite the
  `ShortExact.` namespace prefix, the lemma itself is about plain
  `Exact`. Verified via `lean_multi_attempt`.

## Tried but not committed

### Attempt 1: Split substep (b) from substep (c) as separate sorries

- **Approach**: Introduce a `have h_b : ... → ...` capturing the
  localised-Čech identification as a typed implication, separate from
  substep (c)'s `exact_of_isLocalized_span` application.
- **Result**: NOT COMMITTED. The natural type for `h_b` requires
  spelling out the localised cochain modules — either as
  `Localization.Away f.1 (K.X n)` (which doesn't carry the right
  `ModuleCat` structure to be a cochain-complex factor) or as a
  `ShortComplex` iso between the localised K's sc-n and the slice's
  sc-n. Both require defining the localised cochain complex as a
  `noncomputable def`, which iter-061 prefers not to land as a
  half-formed declaration. The current "substep (b)+(c) combined"
  sorry is preferred because it admits the next iteration to either
  build the localised cochain as data (the recommended route) or
  attempt a direct `Function.Exact` proof bypassing the iso entirely.

### Attempt 2: Directly apply `exact_of_localized_span` and unify

- **Approach**: After the `rw` to `Function.Exact`, attempt
  `exact exact_of_localized_span s hs _ _ ?_` and let Lean try to
  unify the linear maps.
- **Result**: NOT COMMITTED. The signature
  `exact_of_localized_span : ∀ {R M N L} [...] (s : Set R)
  (spn : Ideal.span s = ⊤) (f : M →ₗ[R] N) (g : N →ₗ[R] L)
  (h : ...) → Function.Exact f g` requires the linear maps to be
  `R`-linear, where `R = Γ(C.left, U)`. Our maps are `k`-linear over
  `ModuleCat k`. The unification fails because there is no
  `Module Γ(C.left, U) ((K.sc n).X₁ : Type u)` instance directly
  available — the section module's `Γ(C.left, U)`-module structure
  must be re-established via either:
  (a) explicit instance synthesis under a `letI := ...` block; or
  (b) construction of an explicit linear-map upgrade.
  Both are substantive iter-062+ scaffolding.

### Attempt 3: Reduce to a finite subcover of `s`

- **Approach**: The classical Stacks 01ED proof requires `s` to be
  finite. Extract a finite subset `s₀ ⊆ s` with `Ideal.span s₀ = ⊤`
  (possible since `Ideal.span s = ⊤` implies a finite combination
  yielding `1`), then prove the theorem for `s₀` and transport to `s`.
- **Result**: NOT COMMITTED. The required finite-subcover reduction
  changes the theorem's *cover index type* from `s` (a Set) to `s₀`
  (a Finset). This requires either reproving `IsCechAcyclicCover`
  under a different cover indexing (and showing the cover-of-`s` is
  also Čech-acyclic when the cover-of-`s₀` is), or refactoring the
  theorem statement — neither is in scope for iter-061. The
  localisation-commutes-with-products subtlety (which fails for
  infinite products) will resurface in substep (b)'s product-
  factorisation step and need handling at iter-062+ — the natural
  resolution is to invoke `Subtype.fintypeSubtype` once `s` is
  finite, but this requires WLOG-finiteness of `s` to be installed
  upstream of the substep work.

## Mathlib lemmas attempted but did not unify (or not yet needed)

None at the level of substep (b)+(c) — the unification work for
`FormalCoproduct.extraDegeneracyCech`,
`SimplicialObject.Augmented.ExtraDegeneracy.homotopyEquiv`,
`CochainComplex.opEquivalence`, `IsLocalizedModule.map_exact`, and
`exact_of_isLocalized_span` is deferred to iter-062+ when the
infrastructure for the slice cover (substep a) and the localised
Čech complex (substep b) is in scope. Iter-061's contribution is the
structural decomposition + conversion-to-`Function.Exact` skeleton,
not the unification of these lemmas.

## Verification

- `lean_diagnostic_messages` on the whole file: 1 warning
  (`declaration uses 'sorry'`, line 1680, expected). 0 errors.
- File-local sorry count: 2 (lines 1722 and 1778, both inside
  `basicOpenCover_isCechAcyclicCover_toModuleKSheaf`).
- Project-wide sorry count: 11 (was 10).
- File LOC: 1785 (was 1735, +50 LOC).
- No new `axiom` declarations.
- Protected signatures unchanged.
- Iter-053–060 declarations untouched.

## Next-iteration recommendation

The iter-060 prover recommended starting substep (b) (the
localised-Čech identification) because it is data-bearing. Iter-061
agrees with this recommendation. The natural iter-062 work is:

1. **Define the localised Čech short complex as a `noncomputable def`**.
   Either as `Localization.Away f.1 (K.X n)` packaged into a
   `ShortComplex`, or as a constructive build from the slice-cover
   Čech complex via the iter-057+ identification chain.

2. **Construct the identification iso** between this localised short
   complex and the slice-cover Čech short complex at degree `n`,
   landing at a `ShortComplex` `Iso` or a `LinearEquiv` at each
   cochain factor.

3. **Address the ring-base mismatch** for substep (c) by either:
   - Adding `Module Γ(C.left, U)` instances on the cochain factors
     under a `letI` block, or
   - Providing an explicit `Γ(C.left, U)`-linear upgrade of
     `(K.sc n).f.hom` whose `Function.Exact`-shape coincides with the
     `k`-linear one.

4. **Apply `exact_of_isLocalized_span`** with the per-`f` data:
   - `h_a f` (from substep (a)) gives the slice complex is exact
   - The iso from (1)+(2) transports this to "K's localisation at f
     is exact"
   - The `Γ(C.left, U)`-linear upgrade from (3) makes the types match
     `exact_of_isLocalized_span`'s signature

Substep (a) can wait for iter-063+ — its infrastructure
(`FormalCoproduct.extraDegeneracyCech` in `Over D(f)`, or its op-dual
on `Opens`, plus op-passage from chain to cochain complexes) is
delicate but well-charted by Mathlib. Iter-061 prefers to leave
substep (a) as a clean `ExactAt n` claim rather than half-build the
extra-degeneracy infrastructure.

## Blueprint markers ready

- Theorem statement `thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf`
  with `\lean{Scheme.basicOpenCover_isCechAcyclicCover_toModuleKSheaf}`:
  Lean declaration is present (with `sorry` body), so the deterministic
  `sync_leanok` phase should keep `\leanok` on the **statement** block
  (already present from iter-060).
- The proof block remains unmarked (no `\leanok`) because the body
  still carries 2 sorries.

No blueprint chapter updates are needed for iter-061 — the chapter's
informal four-step proof matches the substep taxonomy (a/b/c) and the
iter-061 decomposition is purely on the Lean side.
