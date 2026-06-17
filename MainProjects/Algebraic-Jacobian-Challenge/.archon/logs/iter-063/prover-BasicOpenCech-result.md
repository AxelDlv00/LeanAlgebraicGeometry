# Cohomology/BasicOpenCech.lean — iter-063 prover round

## Summary

**Mode**: Acceptable (per the iter-063 success ladder). The substep (b)+(c)
sorry was *not* closed but received a substantive iter-063 contribution:
the *finite-subspanning extraction* (via Mathlib's
`Ideal.span_eq_top_iff_finite`) was landed as a real declaration
(`have hs_fin`) inside the proof, and the comment block on the remaining
sorry was rewritten to (i) diagnose precisely why the iter-062 substep
(b1)/(b2) plan does **not** directly apply (product-localisation
commutation fails for infinite index sets), and (ii) lay out the
iter-064+ trajectory in three concrete components.

- **Sorry trajectory**: `11 → 11` (project-wide); `2 → 2` inside
  `BasicOpenCech.lean`. No new sorries introduced.
- **File LOC**: 593 → 643 (+50 LOC).
- **No new axioms** introduced.
- **No protected signatures modified**.
- **No iter-053–062 declarations touched**: the iter-060 helper
  `cechCohomology_subsingleton_of_cechCochain_exactAt`, the iter-061
  `h_a` claim + structural `rw`, and the iter-062 `h_a_fun` data-bearing
  `have` are all preserved verbatim.
- **No other `.lean` file modified**: this round is contained to
  `BasicOpenCech.lean`.

## What was done (concrete code-level)

### Iter-063 substantive contribution: finite-subspanning extraction + obstruction diagnosis

The iter-062 single substep (b)+(c) sorry comment block (~21 lines) was
replaced with an iter-063 progress note (~55 lines) that:

1. **Diagnoses precisely** why the iter-062 substep (b1)/(b2)/(c) plan
   does NOT directly apply: the cochain factor
   `K.X i = ∏ᶜ_{x : Fin (i+1) → s} P.obj (op (∏ᶜ_k 𝒰(x k)))`
   has *infinite* index set `Fin (i+1) → s` when `s` is infinite, and
   `LocalizedModule (powers f) (∏ᶜ_x M_x) ≄ ∏ᶜ_x LocalizedModule (powers f) M_x`
   in general for infinite products. So `slice_K.X i = ∏_x Γ(V_x ⊓ D(f))`
   is **not** literally `(K.X i)[1/f]` — the natural map between them is
   *not* an `IsLocalizedModule.Away f.1`.

2. **Lands the finite-subspanning extraction** as a real `have`
   (lines 569–571 of the new file):

   ```lean
   have hs_fin : ∃ s' : Finset Γ(C.left, U), (↑s' : Set Γ(C.left, U)) ⊆ s ∧
       Ideal.span (↑s' : Set Γ(C.left, U)) = ⊤ :=
     (Ideal.span_eq_top_iff_finite (s := s)).mp hs
   ```

   This `have` is proven (no new sorry) and brings the finite subspanning
   data into the proof context for the next iteration to consume.
   Verified via `lean_multi_attempt` at line 582 of the pre-iter-063 file
   (the first snippet returned `goals=[]`, `diagnostics=[]`).

3. **Lays out the iter-064+ trajectory** in three concrete components:
   - (i) Čech-cohomology refinement transport `s → s₀` (using `hs_fin`):
     given `s₀ ⊆ s` with `Ideal.span ↑s₀ = ⊤`, show
     `Function.Exact (K(s).sc n).f (K(s).sc n).g ↔
        Function.Exact (K(s₀).sc n).f (K(s₀).sc n).g`.
   - (ii) Substep (b2) at the *finite* cover `s₀` where the
     product-localisation commutation succeeds (since
     `Fin (i+1) → ↑s₀` is finite, the product-of-localisations is the
     localisation-of-product).
   - (iii) `exact_of_isLocalized_span (↑s₀ : Set _) hs_fin.choose_spec.2 ...
     h_a_fun_on_s₀` to close the goal.

   The component (i) Čech-refinement transport is the new iter-064+
   substantive work. A natural framing is to use the lattice-supremum
   agreement `⨆ basicOpenCover s = U = ⨆ basicOpenCover s₀` and the
   product universal property to build a cochain-complex map
   `K(s) → K(s₀)` and prove it induces an isomorphism on degree-`n`
   Čech cohomology.

## Sorry inventory (post iter-063)

- L444 (substep (a)): `(slice cover Čech).ExactAt n` via
  `FormalCoproduct.extraDegeneracyCech` + `ExtraDegeneracy.homotopyEquiv`
  + op-passage. **Unchanged from iter-061**.
- L633 (substep (b)+(c)): `Function.Exact ⇑((K.sc n).f) ⇑((K.sc n).g)`
  via the iter-063 finite-subspanning trajectory. **Position shifted
  L582 → L633** because of the iter-063 inserted scaffolding (`hs_fin`
  + expanded comment block).

Both sorries remain inside `basicOpenCover_isCechAcyclicCover_toModuleKSheaf`
at the iter-061-protected positions (with iter-063 position shifts).

## Mathlib lemmas successfully fired

- `Ideal.span_eq_top_iff_finite`
  (`Mathlib/RingTheory/Ideal/Span.lean`): `Ideal.span s = ⊤ ↔
  ∃ s' : Finset _, ↑s' ⊆ s ∧ Ideal.span ↑s' = ⊤`. **NEW in iter-063**;
  fires inside the `hs_fin` `have` body. Verified via `lean_multi_attempt`
  at the substep position (returned `goals=[]`, `diagnostics=[]`).

The earlier-iteration Mathlib leverage chain remains in place
(`HomologicalComplex.exactAt_iff`,
`ShortComplex.ShortExact.moduleCat_exact_iff_function_exact`, iter-057's
`basicOpenCover_finset_inf'_eq_basicOpen_prod`, iter-058's
`basicOpenCover_finset_inf'_le`, iter-059's
`basicOpenCover_finset_inf'_isLocalization`).

## Tried but not committed

### Attempt 1: Direct `apply exact_of_isLocalized_span s hs`

- **Approach**: After the iter-061 `rw` to `Function.Exact` form, attempt
  `apply exact_of_isLocalized_span s hs` and let Lean elaborate the
  metavariables.
- **Result**: NOT COMMITTED. `lean_multi_attempt` at the sorry position
  reports the application *fails* with a unification error:
  `exact_of_isLocalized_span` expects
  `F : ?m.209 →ₗ[Γ(C.left, U)] ?m.210` and
  `G : ?m.210 →ₗ[Γ(C.left, U)] ?m.211`, but the goal has
  `Function.Exact ⇑(ConcreteCategory.hom ((K.sc n).f)) ⇑(ConcreteCategory.hom ((K.sc n).g))`
  where the morphism is *k-linear* (`ConcreteCategory.hom` extracts the
  k-linear function, not a Γ(C.left, U)-linear map). Substep (b1) is
  precisely the bridge that would lift these k-linear functions to
  Γ(C.left, U)-linear maps (via Module Γ(C.left, U) instances on the
  cochain factors). Without (b1) in place, the `apply` cannot succeed.

### Attempt 2: Direct `exact exact_of_localized_span s hs _ _ ?_`

- **Approach**: Try the canonical-localization form
  `exact_of_localized_span` (uses Mathlib's `LocalizedModule (powers r.1)`
  directly, no flexibility on choice of localized module).
- **Result**: NOT COMMITTED. The application fails with
  `typeclass instance problem is stuck: Module Γ(C.left, U) ?m.222`.
  Same root cause as Attempt 1: the cochain factor's `Γ(C.left, U)`-module
  structure must be installed before either of `exact_of_localized_span`
  or `exact_of_isLocalized_span` can fire.

### Attempt 3: Install Module Γ(C.left, U) via `letI` on a generic V ≤ U

- **Approach**: Use the algebra structure from the restriction map
  `(C.left.presheaf.map (homOfLE hVU).op).hom.toAlgebra` to install
  `Algebra Γ(C.left, U) Γ(C.left, V)`, then `Algebra.toModule` for the
  Module instance.
- **Result**: ARCHITECTURALLY VIABLE per-component (per-section), but
  does **not** scale up to the cochain factor `(K.sc n).X i` because the
  cochain factor is `∏ᶜ` (the categorical product in `ModuleCat k`), not
  a literal Π-type. `ModuleCat.piIsoPi` gives a LinearEquiv to the
  Π-type, but the LinearEquiv is over `k`, not over `Γ(C.left, U)`, so
  transporting Module Γ(C.left, U) across it requires a separate proof.
  Per-component installation is straightforward; product-level
  installation is the iter-064+ work in component (ii) of the trajectory.

### Attempt 4: Use `LocalizedModule (powers r.1) (∏ᶜ_x Γ(V_x))` directly

- **Approach**: Apply `exact_of_localized_span` with the canonical
  `LocalizedModule` form, then prove the per-r `Function.Exact`
  via a direct argument bypassing the slice-cover identification.
- **Result**: NOT COMMITTED. The `Function.Exact` on
  `LocalizedModule (powers r) (∏ᶜ_x Γ(V_x))` requires understanding the
  module structure of localisations of infinite products, which Mathlib
  does not directly expose. The route via the slice cover (using the
  iter-061 `h_a_fun`) is more natural but requires the product-localisation
  commutation, which only holds for finite index sets — hence the
  iter-063 reduction to `s₀` (finite subspanning).

## Mathlib lemmas attempted but did not unify

- `apply exact_of_isLocalized_span s hs` — fails because the goal's
  underlying morphisms are k-linear `ConcreteCategory.hom`s, not
  `Γ(C.left, U)`-linear.
- `apply exact_of_localized_span (R := Γ(C.left, U)) s hs _ _ ?_` — fails
  because of an unresolved typeclass instance for
  `Module Γ(C.left, U) (some cochain factor)`.

## Verification

- `lean_diagnostic_messages` on the whole file: 1 warning
  (`declaration uses 'sorry'`, line 402, expected). 0 errors.
- File-local sorry count: 2 (lines 444 and 633, both inside
  `basicOpenCover_isCechAcyclicCover_toModuleKSheaf`).
- Project-wide sorry count: 11 (unchanged from iter-062's verified
  baseline). Confirmed via
  `python3 sorry_analyzer.py AlgebraicJacobian/ --format=summary`.
- File LOC: 643 (+50 from 593).
- `lake env lean AlgebraicJacobian/Cohomology/BasicOpenCech.lean`
  succeeds with only the expected `declaration uses 'sorry'` warning.
- No new `axiom` declarations.
- Protected signatures unchanged.
- Iter-053–062 declarations untouched.

## Iter-064 next-iteration recommendation

The iter-063 finite-subspanning extraction `hs_fin` is now in scope
inside the proof. Iter-064+ should pick up from there to build the
three trajectory components:

1. **Component (i) — Čech-cohomology refinement transport `s → s₀`**:
   given `hs_fin = ⟨s₀, h_sub, h_top⟩`, prove
   ```
   Function.Exact ⇑(ConcreteCategory.hom (K(s).sc n).f) ⇑(ConcreteCategory.hom (K(s).sc n).g) ↔
   Function.Exact ⇑(ConcreteCategory.hom (K(s₀).sc n).f) ⇑(ConcreteCategory.hom (K(s₀).sc n).g)
   ```
   where `K(s') := cechCochain C (toModuleKSheaf C) (basicOpenCover s')`.
   Natural framing: there is a cochain-complex map
   `K(s) → K(s₀)` (induced by the cofinal inclusion
   `↑s₀ ⊆ s` and the product universal property — each multi-index
   `x : Fin (i+1) → ↑s₀` lifts to `x' : Fin (i+1) → s` via inclusion,
   and the section restriction `Γ(V_x) → Γ(V_x')` is the identity since
   `V_x = V_x'`). Showing this induces an iso on degree-`n` cohomology
   would close the transport. This may not be straightforward — it
   requires either constructing a homotopy or directly comparing the
   ker/range characterizations. A spectral-sequence argument (Stacks
   03OW) is more general but ~600+ LOC; the direct argument is the
   recommended route.

2. **Component (ii) — Substep (b2) on the finite cover `s₀`**: with `s₀`
   finite, the cochain factor is now a *finite* product
   `(K(s₀).X i) = ∏ᶜ_{x : Fin (i+1) → ↑s₀} Γ(V_x)`, and the
   product-localisation commutation holds:
   `LocalizedModule (powers f.1) (∏ᶜ_{x : Finite} M_x) ≅ ∏ᶜ_x LocalizedModule (powers f.1) M_x`.
   This gives substep (b2) on `s₀`: for each `f : ↑s₀` and each cochain
   factor index `i`, the slice cover's `i`-th factor is
   `IsLocalizedModule.Away f.1` of `K(s₀).X i`. Substep (b1) is
   installable for `s₀` via the iter-062 plan
   (`letI := ((C.left.presheaf.map …).hom.toAlgebra).toModule`) since
   the finite product preserves the Module Γ(C.left, U) structure
   pointwise.

3. **Component (iii) — `exact_of_isLocalized_span (↑s₀ : Set _) h_top
   ...`**: with (b1) and (b2) on `s₀` in place, apply
   `exact_of_isLocalized_span` to get
   `Function.Exact ⇑(K(s₀).sc n).f ⇑(K(s₀).sc n).g`. Combining with
   (i) closes the original goal.

### Alternative routes considered

- **Direct via canonical `LocalizedModule (powers f.1) (∏ᶜ_x Γ(V_x))`**:
  Use `exact_of_localized_span s hs` (which uses Mathlib's canonical
  `LocalizedModule`). The per-`r` `Function.Exact` then requires proving
  exactness of the canonical localization of `K.sc n`, which can be
  attacked via factoring through the (potentially infinite) product and
  using `LocalizedModule.map_exact` componentwise. This route avoids
  the refinement transport (i) but requires understanding
  `LocalizedModule` of infinite products. The slice-cover approach (via
  `h_a_fun`) is preferred.

- **Substep (a) attack instead**: substep (a) (extra-degeneracy on the
  slice cover) is independent of (b)+(c) and could be pursued in
  parallel. The iter-061 prover analysis notes its leverage chain
  (`FormalCoproduct.extraDegeneracyCech` +
  `SimplicialObject.Augmented.ExtraDegeneracy.homotopyEquiv` +
  `CochainComplex.opEquivalence`) is delicate but well-charted. Iter-064
  could split the prover work into two parallel sub-objectives:
  substep (a) and the iter-063 trajectory component (i).

### Iter-063 strategic note

The iter-063 work explicitly resolves the iter-061 prover's Attempt 3
dead-end ("Reduce to a finite subcover of `s`"). Rather than reproving
the theorem under a different cover indexing (which the iter-061 prover
correctly identified as out of scope), iter-063 extracts `s₀` *inline*
without changing the exposed cover indexing, and the transport from
`s₀`-cover exactness back to `s`-cover exactness is now a clearly
labelled iter-064 work item (component (i) of the trajectory). This
preserves the theorem signature while opening up the substantive
Mathlib-aligned route.

## Blueprint markers ready

- Theorem statement `thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf`
  with `\lean{Scheme.basicOpenCover_isCechAcyclicCover_toModuleKSheaf}`:
  Lean declaration is present (with `sorry` body), so the deterministic
  `sync_leanok` phase should keep `\leanok` on the **statement** block
  (already present from iter-060–062).
- The proof block remains unmarked (no `\leanok`) because the body still
  carries 2 sorries.

No blueprint chapter updates are needed for iter-063 — the chapter's
informal four-step proof matches the substep taxonomy (a/b/c) and the
iter-063 finite-subspanning + obstruction-diagnosis insight lives purely
on the Lean side. (One might add a remark to
`blueprint/src/chapters/Cohomology_MayerVietoris.tex` § "Čech acyclicity"
clarifying that the formal proof reduces to a finite subspanning subset
via `Ideal.span_eq_top_iff_finite`, but this is a review-agent
discretionary task.)
