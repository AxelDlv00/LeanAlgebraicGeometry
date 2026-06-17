# Cohomology/MayerVietoris.lean — iter-060 prover round

## Summary

**Mode**: Acceptable (per the directive's success ladder). Theorem stated with
the substantive Čech acyclicity claim, structural decomposition via one
helper, and a single named transient `sorry` carrying the substantive Stacks
01ED extra-degeneracy + local-to-global content.

- **Sorry trajectory**: `9 → 10` (one new transient sorry in `MayerVietoris.lean`).
- **File LOC**: 1622 → 1735 (+113 LOC).
- **No new axioms** introduced.
- **No protected signatures modified**.

## Declarations added (iter-060)

### 1. Helper: `cechCohomology_subsingleton_of_cechCochain_exactAt`

Bridge lemma — **fully closed** (no sorry, kernel-only). Given
`(cechCochain C F 𝒰).ExactAt n`, produces `Subsingleton (cechCohomology C F 𝒰 n)`.

```lean
theorem cechCohomology_subsingleton_of_cechCochain_exactAt
    {k : Type u} [Field k] {C : Over (Spec (.of k))}
    {F : Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} k)}
    {ι : Type u} {𝒰 : ι → TopologicalSpace.Opens C.left.toTopCat}
    {n : ℕ} (h : (cechCochain C F 𝒰).ExactAt n) :
    Subsingleton (cechCohomology C F 𝒰 n) :=
  ModuleCat.subsingleton_of_isZero h.isZero_homology
```

Body chains:
- `HomologicalComplex.ExactAt.isZero_homology` (Mathlib
  `Algebra/Homology/ShortComplex/HomologicalComplex.lean`): from `ExactAt n`
  obtains `IsZero ((cechCochain C F 𝒰).homology n)`.
- `ModuleCat.subsingleton_of_isZero` (Mathlib
  `Algebra/Category/ModuleCat/Basic.lean`): from `IsZero M` on `M : ModuleCat R`
  obtains `Subsingleton ↑M`.

This is the **structural skeleton** common to every `IsCechAcyclicCover`
instance proof; the substantive content lives in `ExactAt n`.

### 2. Main theorem: `basicOpenCover_isCechAcyclicCover_toModuleKSheaf`

Stated with the protected signature; body uses the helper plus one named
transient sorry covering the Stacks 01ED argument.

```lean
theorem basicOpenCover_isCechAcyclicCover_toModuleKSheaf
    {k : Type u} [Field k] {C : Over (Spec (.of k))}
    {U : TopologicalSpace.Opens C.left.toTopCat} (hU : IsAffineOpen U)
    (s : Set Γ(C.left, U)) (hs : Ideal.span s = ⊤) :
    IsCechAcyclicCover (toModuleKSheaf C)
        (basicOpenCover (C := C) (U := U) s) where
  subsingleton_cechCohomology n hn := by
    refine cechCohomology_subsingleton_of_cechCochain_exactAt (n := n) ?_
    -- goal: (cechCochain C (toModuleKSheaf C) (basicOpenCover s)).ExactAt n
    -- substeps (a)+(b)+(c) — see comments in source
    sorry
```

The structural reduction `Subsingleton (cechCohomology n) → ExactAt n` is
**closed**. What remains as a single sorry is the substantive `ExactAt n`
claim, with an extensive docstring + inline-comment decomposition naming the
three substeps for the next iteration:

- **(a) extra-degeneracy at `D(f)`**: `FormalCoproduct.extraDegeneracyCech`
  + `SimplicialObject.Augmented.ExtraDegeneracy.homotopyEquiv` +
  `CochainComplex.opEquivalence` op-passage.
- **(b) localised-Čech identification**: chain iter-057 + iter-058 + iter-059
  with `IsLocalizedModule.map_exact`.
- **(c) local-to-global**: `exact_of_isLocalized_span` (Mathlib
  `RingTheory/LocalProperties/Exactness.lean` L173) on the family of
  per-`f` exactnesses.

## Tried but not committed

### Attempt: Decompose into two separate `sorry`s (substep (a)+(b) vs (c))

- **Approach**: Introduce a local `have hloc : ∀ f : s, …localised exactness…`
  and then derive the global `ExactAt` from `exact_of_isLocalized_span`.
- **Result**: NOT COMMITTED. The type of the localised exactness predicate
  requires constructing the cover-of-`D(f)` slice cover and the localised
  Čech cochain complex (an iter-061+ infrastructure step). Stating `hloc`
  without those objects in scope ends up either (i) requiring pre-statements
  that themselves need helper lemmas, or (ii) a `∀ f, ∃ …` shape where the
  existential's existential witness is data that the substantive proof
  would have to supply anyway. Either route bloats the file without
  capturing meaningful content beyond what the current annotated single
  sorry already records.
- **Next-iteration recommendation**: do not insist on splitting (a)+(b) from
  (c) at iter-061; instead, the iter-061 prover should build a
  `cechCochain_basicOpenCover_localise` definition (the localised Čech
  complex) and an identification iso with the cover-of-`D(f)` Čech
  complex *as the first half* of the iter-061 session, then tackle (a)+(b)
  with both objects in scope.

### Attempt: Close via `s = ∅` vacuous closure

- **Approach**: Note that `Ideal.span ∅ = ⊥`, so `Ideal.span s = ⊤` would
  force `1 = 0` in `Γ(C.left, U)`, making the ring trivial and the cover
  empty.
- **Result**: REJECTED by directive (`Closing … by assuming s = ∅, …,
  or any other shortcut that bypasses the localization-then-extra-degeneracy
  argument` is explicitly listed as a forbidden dead end in `PROGRESS.md`).
  Even though it would technically close the theorem, it bypasses the
  substantive cohomological content, so the prover declined this route.

### Attempt: Close via `n = 1` special case + induction

- **Approach**: For `n = 1`, the `ExactAt` claim is the sheaf-axiom Čech
  condition; for `n > 1`, use a Mayer-Vietoris reduction.
- **Result**: REJECTED. The Mayer-Vietoris reduction would route through
  `HasCechToHModuleIso`, which is the **second** branch (Branch B of the
  analogy report) — exactly what the directive said *not* to attempt in
  the same iteration as `IsCechAcyclicCover`. Also, even the `n = 1` case
  needs the sheaf-axiom for `toModuleKSheaf` on basic-open covers, which is
  itself a non-trivial setup.

## Mathlib lemmas that successfully fired

- `ModuleCat.subsingleton_of_isZero` (`Mathlib/Algebra/Category/ModuleCat/Basic.lean`):
  `IsZero M → Subsingleton ↑M` for `M : ModuleCat R`. Used in the helper.
- `HomologicalComplex.ExactAt.isZero_homology` (`Mathlib/Algebra/Homology/ShortComplex/HomologicalComplex.lean`):
  `ExactAt n → IsZero (homology n)`. Used in the helper.

## Mathlib lemmas attempted that did not unify (or were not yet needed)

None at this stage — the structural reduction goes through cleanly. The
unification work for the substep lemmas
(`exact_of_isLocalized_span`, `IsLocalizedModule.map_exact`,
`FormalCoproduct.extraDegeneracyCech`,
`SimplicialObject.Augmented.ExtraDegeneracy.homotopyEquiv`,
`CochainComplex.opEquivalence`) is deferred to iter-061+ when the
infrastructure (augmentation, slice-cover, localised-cochain identification)
is in scope.

## Verification

- `lean_diagnostic_messages` on the whole file: 1 warning (`declaration uses
  'sorry'`, line 1680, expected). 0 errors.
- File-local sorry count: 1 (line 1729, in
  `basicOpenCover_isCechAcyclicCover_toModuleKSheaf`).
- Project-wide sorry count: 10 (was 9, plan band is 9 + n where each new
  sorry is justified by a comment naming the substep — this single sorry
  carries a multi-line annotated breakdown plus the doc-string substep
  taxonomy, so the convention is met).
- No new `axiom` declarations.
- Protected signatures unchanged.
- Iter-053–059 declarations untouched.

## Next-iteration scoping suggestion

The iter-060 single transient sorry decomposes into three substeps. The
**most economical** iter-061 scoping is to attack substep (b) first (the
localised-Čech identification), because:

1. Substep (b) requires building the "localised Čech cochain" — a definition,
   not a theorem. It can be checked compositionally (term-mode) and lands a
   single new declaration plus its identification iso, ~30-50 LOC.
2. With (b) landed, substep (a) (extra-degeneracy on the slice) reduces to a
   single Mathlib invocation chain (~30-40 LOC of routine repackaging).
3. Substep (c) (`exact_of_isLocalized_span`) is then a 1-2 line application
   given (a) and (b) are in scope.

The alternative scoping — attacking substep (a) first — would require
spelling out the augmented Čech simplicial object project-side (since
Mathlib's `FormalCoproduct.augmentOfIsTerminal` lives at the simplicial-object
level, not at the cochain-complex level), which is another ~30-50 LOC of
non-content infrastructure.

## Blueprint markers ready

After this iteration, `Cohomology_MayerVietoris.tex` § *Čech acyclicity for
the structure sheaf on affine basic-open covers* has:
- Theorem statement `thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf`
  with `\lean{Scheme.basicOpenCover_isCechAcyclicCover_toModuleKSheaf}`:
  Lean declaration is present (with `sorry` body), so the deterministic
  `sync_leanok` phase should add `\leanok` to the **statement** block.
- The proof block remains unmarked (no `\leanok`) because the body still
  carries a `sorry`.

Helper `Scheme.cechCohomology_subsingleton_of_cechCochain_exactAt` is closed
kernel-only but is not in the blueprint chapter (it's a pure structural
bridge lemma; not part of the mathematical narrative). The prover does not
add blueprint entries for helpers like this — that is the plan agent's call
if it deems the helper worth surfacing.
