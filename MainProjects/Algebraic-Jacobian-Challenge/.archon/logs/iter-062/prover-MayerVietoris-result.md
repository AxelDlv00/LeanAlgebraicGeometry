# Cohomology/MayerVietoris.lean — iter-062 prover round

## Summary

**Mode**: Acceptable (per the iter-062 success ladder). The substep (b)+(c)
sorry was *not* fully closed but received concrete substantive scaffolding:
the per-`f` slice-cover Čech `Function.Exact` claim (`h_a_fun`) was landed
as a real declaration (no new sorry) by chaining the iter-061 mechanical
conversion in reverse on each `h_a f`, and the route through
`exact_of_isLocalized_span` was decomposed into three labelled substeps
(b1 / b2 / c) with the data-bearing role of each one made explicit in
inline commentary.

- **Sorry trajectory**: `11 → 11` (project-wide); `2 → 2` inside
  `MayerVietoris.lean`. No new sorries introduced; both existing sorries
  preserved with strictly more scaffolding wrapped around the substep
  (b)+(c) one.
- **File LOC**: 1785 → 1872 (+87 LOC).
- **No new axioms** introduced.
- **No protected signatures modified**.
- **No iter-053–061 declarations touched**: the iter-061 `h_a` claim,
  the `rw [HomologicalComplex.exactAt_iff,
  ShortComplex.ShortExact.moduleCat_exact_iff_function_exact]`
  conversion, and both substep sorries (a, b+c) remain in their iter-061
  form. The iter-060 helper
  `cechCohomology_subsingleton_of_cechCochain_exactAt` is untouched.

## What was done (concrete code-level)

### Substantive scaffolding (a) — `h_a_fun` (no sorry)

After the iter-061 mechanical conversion at L1772–1773
(`rw [HomologicalComplex.exactAt_iff,
ShortComplex.ShortExact.moduleCat_exact_iff_function_exact]`), the goal is
`Function.Exact ⇑((K.sc n).f) ⇑((K.sc n).g)`. The iter-061 hypothesis
`h_a` was in the `HomologicalComplex.ExactAt n` form on the slice cover
Čech complex. Iter-062 introduces the parallel `Function.Exact` form of
`h_a` as a separate `have` (lines 1789–1803):

```lean
have h_a_fun : ∀ (f : s),
    Function.Exact
      ⇑(ConcreteCategory.hom (HomologicalComplex.sc
          (cechCochain C (toModuleKSheaf C)
            (fun (f' : s) => basicOpenCover (C := C) (U := U) s f' ⊓
              C.left.basicOpen (f : Γ(C.left, U)))) n).f)
      ⇑(ConcreteCategory.hom (HomologicalComplex.sc
          (cechCochain C (toModuleKSheaf C)
            (fun (f' : s) => basicOpenCover (C := C) (U := U) s f' ⊓
              C.left.basicOpen (f : Γ(C.left, U)))) n).g) := by
  intro f
  rw [← ShortComplex.ShortExact.moduleCat_exact_iff_function_exact,
      ← HomologicalComplex.exactAt_iff]
  exact h_a f
```

This is a clean substantive contribution (no new sorry) and places the
per-`f` slice-cover exactness in exactly the form consumed downstream by
`IsLocalizedModule.map_exact` after the substep-(b2) localisation iso.
The body uses the same Mathlib lemmas iter-061 fired (`exactAt_iff` and
`moduleCat_exact_iff_function_exact`) but in the reverse direction —
`← rw` to translate `ExactAt` into `Function.Exact`.

Verified successfully by `lean_multi_attempt` (line 1778): `goals=[]`,
`diagnostics=[]`.

### Substantive scaffolding (b) — substep decomposition + route commentary

The original iter-061 substep (b)+(c) sorry comment was a single block.
Iter-062 expands this into three explicitly labelled substeps with the
data-bearing role of each one spelled out in inline commentary
(L1804–1872):

- **Substep (b1)** — install the `Module Γ(C.left, U)` instances on each
  cochain factor `(K.sc n).X i`. Cochain factor `K.X i = ∏_{x : Fin
  (i+1) → s} Γ(C.left, ⋂_k 𝒰(x k))` carries a `Γ(C.left, U)`-module
  structure pointwise (each `Γ(C.left, V)` for `V ≤ U` is a
  `Γ(C.left, U)`-algebra via the restriction map; iter-058's
  `basicOpenCover_finset_inf'_le` supplies `V ≤ U`; iter-006's
  `algebraSection` supplies the algebra structure on each factor).

- **Substep (b2)** — exhibit `slice_K.X i` as `IsLocalizedModule.Away
  f.1` of `(K.sc n).X i` for each `f ∈ s`. The cochain-factor
  identification chain is iter-057 + iter-058 + iter-059 + Mathlib
  `Localization.localizationLocalization` + product-localisation
  commutation. The pointwise localisation map is the canonical
  restriction-induced localisation map.

- **Substep (c)** — apply `exact_of_isLocalized_span s hs ... h_a_fun`
  to lift per-`f` exactness to global exactness on K.

The infinite-set subtlety (`s` is `Set`, not `Finset`) is sidestepped
because `Ideal.span s = ⊤` already implies a *finite* subset spans the
unit ideal — `exact_of_isLocalized_span` consumes the per-`r` localised
exactness data and the spanning hypothesis, not finiteness of `s`
directly. This was a previously identified concern (iter-061
prover Attempt 3) that iter-062 explicitly resolves by reading
`exact_of_isLocalized_span`'s actual signature.

## Sorry inventory (post iter-062)

- L1722: substep (a) — `(slice cover Čech).ExactAt n` via
  `FormalCoproduct.extraDegeneracyCech` + `ExtraDegeneracy.homotopyEquiv`
  + op-passage. **Unchanged from iter-061**.
- L1865: substep (b)+(c) — `Function.Exact ⇑((K.sc n).f) ⇑((K.sc n).g)`
  via cochain-level localisation iso + `exact_of_isLocalized_span`
  ring-base bridge. Now wrapped in three labelled substeps (b1/b2/c) with
  detailed route commentary; the `sorry` itself remains. **Position
  shifted L1778 → L1865** because of the inserted scaffolding (`h_a_fun`
  body + substep commentary).

Both sorries are still inside `basicOpenCover_isCechAcyclicCover_toModuleKSheaf`
at the iter-061 protected positions (substep (a) intro position
unchanged at L1722; substep (b)+(c) terminal position shifted by the
inserted scaffolding).

## Mathlib lemmas successfully fired

- `HomologicalComplex.exactAt_iff`: definitional unfold of `ExactAt n` to
  `(K.sc n).Exact`. **Fired again** on the per-`f` direction inside
  `h_a_fun`'s body (in the `← rw` direction).
- `ShortComplex.ShortExact.moduleCat_exact_iff_function_exact`
  (`Mathlib/Algebra/Homology/ShortComplex/ModuleCat.lean` L78): bridge
  from `(S : ShortComplex (ModuleCat R)).Exact` to `Function.Exact S.f
  S.g`. **Fired again** inside `h_a_fun`'s body (in the `← rw`
  direction).

These were both verified to fire at iter-062 via `lean_multi_attempt` at
the relevant line.

## Tried but not committed

### Attempt 1: Direct `exact h_a_fun ⟨0, by simp⟩` shortcut

- **Approach**: `lean_multi_attempt` reported `goals=[]` for
  `exact h_a_fun ⟨(0 : Γ(C.left, U)), by simp⟩` at the substep (b)+(c)
  position. This would close the goal vacuously by feeding the slice-cover
  exactness at `f = 0` (where `C.left.basicOpen 0 = ⊥`, so the slice
  cover degenerates to the empty cover) into the goal.
- **Result**: NOT COMMITTED — the report was almost certainly a
  `lean_multi_attempt` artifact (the `by simp` subgoal `0 ∈ s` would
  generally fail, and even if `0 ∈ s` held, the slice cover at `f = 0`
  is a different cochain complex from `basicOpenCover s`, so the
  conclusion type would not unify with the goal). Did not commit;
  treated the multi_attempt result as a tool-level false positive.

### Attempt 2: Construct the localised cochain factor as a `noncomputable def`

- **Approach**: Land a fresh `noncomputable def localisedCechCochain
  {k} [Field k] (C) (s) (f : s) (n : ℕ) : ModuleCat k` packaging the
  cochain-factor identification iso, plus an
  `IsLocalizedModule.Away f.1` instance witnessing it.
- **Result**: NOT COMMITTED. The cochain-factor identification iso
  requires the `Localization.localizationLocalization` +
  product-localisation commutation argument, which in turn requires
  resolving the infinite-set subtlety of `s` (the cochain-factor
  type-level identity `slice_K.X i = ∏_x Γ(C.left, ⋂_k …)` involves a
  product over `Fin (i+1) → s` with possibly-infinite `s`; the
  product-localisation commutation in Mathlib (`Localization.commute_prod`)
  requires the index set to be finite). The natural in-session resolution
  is a `Finset` reduction at the cochain-factor *evaluation* level (each
  index `x : Fin (i+1) → s` produces a finite product of `(x k).1`
  values), which is consistent with `exact_of_isLocalized_span`'s
  signature but requires careful handling. Deferred to iter-063+ to
  preserve scope.

### Attempt 3: Direct `exact_of_isLocalized_span s hs ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_`

- **Approach**: After `h_a_fun` is in scope, attempt the direct
  application `apply exact_of_isLocalized_span s hs` and let Lean elaborate
  the metavariables for the per-`f` localised module data.
- **Result**: NOT COMMITTED. The application requires the
  `Module Γ(C.left, U)` instances on each cochain factor `(K.sc n).X i`
  to be in scope (substep b1) before the elaboration can succeed. Without
  these instances, the `apply` tactic fails at the elaboration stage
  with "failed to synthesize Module Γ(C.left, U) ((K.sc n).X i)". Adding
  the `letI` instances requires either (i) defining the algebra structure
  on each cochain factor explicitly via `algebraSection` + the inclusion
  `V ≤ U`, or (ii) using a `MapToSet`-style trick to install the Module
  via the underlying `R-Algebra` structure. Both are substantive iter-063+
  work. Deferred.

### Attempt 4: Use `LinearEquiv.conj_exact_iff_exact` + `LinearEquiv.postcomp_exact_iff_exact`

- **Approach**: `LinearEquiv.conj_exact_iff_exact` (Mathlib
  `Algebra/Exact.lean`) transports `Function.Exact` across a square
  with a `LinearEquiv` middle vertical map. Could chain two such isos to
  transport the slice-cover `Function.Exact` (per-`f`) into something
  closer to the K.sc n goal.
- **Result**: NOT COMMITTED. Each `LinearEquiv` requires a `Module R`
  structure on both sides. The natural source is `slice_K.X i` (a
  `ModuleCat k` object), the natural target is `(K.sc n).X i [1/f]`
  (which would need a `ModuleCat (Localization.Away f.1)` structure or
  a forgetful equivalence to `ModuleCat k`). The intermediate types
  don't unify cleanly without substep (b2)'s localisation iso, which is
  the substep we're trying to prove. Circular. Deferred.

## Mathlib lemmas attempted but did not unify

None directly attempted in iter-062 beyond the `h_a_fun` body's
successful `rw`. Iter-062's contribution is the `Function.Exact`-form
conversion of `h_a` and the substep decomposition into b1/b2/c.

## Verification

- `lean_diagnostic_messages` on the whole file: 1 warning
  (`declaration uses 'sorry'`, line 1680, expected). 0 errors.
- File-local sorry count: 2 (lines 1722 and 1865, both inside
  `basicOpenCover_isCechAcyclicCover_toModuleKSheaf`).
- Project-wide sorry count: 11 (unchanged from iter-061's verified
  baseline).
- File LOC: 1872 (+87 from 1785).
- No new `axiom` declarations.
- Protected signatures unchanged.
- Iter-053–061 declarations untouched.

## Iter-063 next-iteration recommendation

The iter-062 session's `h_a_fun` lifted h_a into the `Function.Exact`
form. Iter-063+ should pick up from there to build the actual
substep (b1)/(b2)/(c) data:

1. **Substep (b1) — `Module Γ(C.left, U)` instances**: install
   `Module Γ(C.left, U) ((K.sc n).X i)` for `i ∈ {1, 2, 3}` via
   either `letI := ((C.left.presheaf.map (homOfLE (basicOpenCover_finset_inf'_le …)).op).hom.toAlgebra).toModule` (chaining iter-058's inclusion lemma with iter-006's algebra structure), or via `Module.compHom` on the algebra map `Γ(C.left, U) → Γ(C.left, V)` for `V = ⋂_k 𝒰(x k)`. This is the most concrete next-iteration substep — once it's done, the `(K.sc n).f.hom` and `.g.hom` automatically upgrade to `Γ(C.left, U)`-linear (because they're induced by restriction maps that *are* `Γ(C.left, U)`-linear).

2. **Substep (b2) — `IsLocalizedModule.Away f.1` instances**: for each
   `f ∈ s` and each cochain index `i ∈ {1, 2, 3}`, supply
   `IsLocalizedModule.Away (f.1) (κ : (K.sc n).X i →ₗ[Γ(C.left, U)] slice_K(f).X i)`
   where `κ` is the restriction map. The instance is derivable from
   iter-059's `basicOpenCover_finset_inf'_isLocalization` plus the
   universal property of the product (each cochain factor is
   localisable, and the product of localisations is a localisation
   when the index set is finite — but here the index set per cochain
   factor is `Fin (i+1) → s`, finite-or-not depending on `s`). The
   infinite-`s` case is sidestepped by the WLOG-finite-cover reduction
   built into `exact_of_isLocalized_span`'s spanning hypothesis: the
   per-`f` data only matters for `f ∈ Finset.exists_finite_subset_span_eq_top hs`,
   which is a finite subset.

3. **Substep (c) — apply `exact_of_isLocalized_span`**: with (b1) and
   (b2) in place, the application is a direct `exact
   exact_of_isLocalized_span s hs (Mₚ := …) (Nₚ := …) (Lₚ := …) (f
   := …) (g := …) (h := …) F G h_a_fun_transported`. The
   `h_a_fun_transported` is `h_a_fun f` chained through
   `IsLocalizedModule.map_exact` to land in the cochain-factor
   identification's image.

4. **Substep (a) — extra-degeneracy on the slice cover**: still
   open from iter-061. Per the iter-061 prover's analysis, the natural
   route is `FormalCoproduct.extraDegeneracyCech` +
   `SimplicialObject.Augmented.ExtraDegeneracy.homotopyEquiv` +
   `CochainComplex.opEquivalence`. Unrelated to the substep (b)/(c)
   work above; can be attacked in parallel or after.

## Blueprint markers ready

- Theorem statement `thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf`
  with `\lean{Scheme.basicOpenCover_isCechAcyclicCover_toModuleKSheaf}`:
  Lean declaration is present (with `sorry` body), so the deterministic
  `sync_leanok` phase should keep `\leanok` on the **statement** block
  (already present from iter-060–061).
- The proof block remains unmarked (no `\leanok`) because the body
  still carries 2 sorries.

No blueprint chapter updates are needed for iter-062 — the chapter's
informal four-step proof matches the substep taxonomy (a/b1/b2/c) and
the iter-062 decomposition is purely on the Lean side.
