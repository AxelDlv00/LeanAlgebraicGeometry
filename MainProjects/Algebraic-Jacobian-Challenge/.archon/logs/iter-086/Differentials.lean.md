# AlgebraicJacobian/Differentials.lean — iter-086

## Summary

**Result: REVERT COMPLETED (mandatory step landed).**
**Optional alternative route: NOT ATTEMPTED — no clean Mathlib lemma found.**

- Sorry count before: 5 (post iter-085, with false-signature helper at L501–521)
- Sorry count after: 5 (helper removed; `case h_exact` is now an honest `sorry`)
- Compilation: ✅ clean (only sorry warnings + 1 pre-existing long-line warning unrelated to this lane)

## Step 1 — Mandatory revert (LANDED)

### Action 1.1: deleted iter-085 false helper at L501–521

The block

```lean
-- GAP-FILL (iter-085, Lane 2): Stalkwise criterion for exactness ...
lemma _root_.SheafOfModules.exact_iff_stalkwise
    {C : Type*} [Category C] {J : CategoryTheory.GrothendieckTopology C}
    {R : CategoryTheory.Sheaf J RingCat}
    (S : CategoryTheory.ShortComplex (SheafOfModules R)) : S.Exact := by
  sorry
```

is fully removed from the file. The 16-line GAP-FILL comment block immediately above the declaration was also deleted (it was part of the same logical block, justifying the false signature).

### Action 1.2: replaced `case h_exact` body

Old (iter-085, L654–666):
```lean
case h_exact =>
  -- Iter-085 (Lane 2): closed via the project-local Mathlib-gap-fill helper
  -- `_root_.SheafOfModules.exact_iff_stalkwise` ...  [13 lines of comments]
  exact _root_.SheafOfModules.exact_iff_stalkwise _
```

New (iter-086, now at L612–616):
```lean
case h_exact =>
  -- Iter-086 (Lane 2): the iter-085 false-signature helper has been reverted.
  -- Alternative route deferred: see `blueprint/src/chapters/Differentials.tex`
  -- § Cotangent exact sequence for the section-wise + sheafification strategy.
  sorry
```

The replacement comment is 3 lines (≤ 6, as required).

### Verification

`lean_diagnostic_messages` reports:
- 5 `declaration uses sorry` warnings: L113 (`relativeDifferentialsPresheaf_isSheaf`), **L517** (`cotangentExactSeq_structure` — the `h_exact` we just reverted), L950 (`smooth_iff_locally_free_omega`), L966 (`cotangent_at_section`), L1110 (`serre_duality_genus`).
- 1 pre-existing long-line warning at L626 (in a comment block — not introduced by this iter).
- 0 errors. File compiles.

No new axioms introduced. The four preserved helpers (`SheafOfModules.epi_of_epi_presheaf`, `PresheafOfModules.Derivation.postcomp_comp`, `cotangentExactSeqBeta_hη`, the iter-084 `refine ⟨?h_exact, ?h_epi⟩` + `case h_epi` body) remain intact.

## Step 2 — Alternative route exploration (NOT FORMALIZED)

Per plan-agent instructions: "If you don't find a clean Mathlib lemma for (1), STOP and report." The searches below confirm no such direct lemma exists in current Mathlib.

### `lean_local_search` queries run

| Query | Result |
|---|---|
| `SheafOfModules.exact` | **empty** |
| `PresheafOfModules.shortComplex` | **empty** |
| `Sheaf.exact` | **empty** |
| `ShortComplex.Exact` | **empty** (only the inductive declaration itself is well known) |
| `SheafOfModules` | structure declaration only |
| `exact_iff_stalk` | `TopCat.Sheaf.exact_iff_stalkFunctor_map_exact` (sheaf of *abelian groups*, not `SheafOfModules`) |
| `stalkFunctor` | only `TopCat.Presheaf.stalkFunctor` (AddCommGrp level, not module-stalk level) |
| `exact_of_presheaf` | **empty** |
| `SheafOfModules.forget` | not found by direct prefix (the forget functor is `SheafOfModules.forget R`, used at L478 of this file via `(SheafOfModules.forget R).map f`) |
| `ShortComplex.map_exact` | **empty** |

### `lean_leansearch` queries run

| Query | Best result |
|---|---|
| "SheafOfModules short complex exact iff presheaf section exact" | only generic results (`HomologicalComplex.exact_of_degreewise_exact` — wrong category, not `SheafOfModules`; `ShortComplex.Exact` constructor) |
| "PresheafOfModules exact iff pointwise sections" | only generic `hom_ext_iff`/`isSheaf` results; no pointwise-exactness lemma |
| "sheafification preserves short exact sequence sheaf of modules" | `PresheafOfModules.instPreservesFiniteLimitsSheafOfModulesSheafification` (yes, sheafification preserves finite limits → it's left exact too) and `PresheafOfModules.sheafification` (the functor itself); but no direct `Sheaf.exact_of_presheaf_exact` |
| "ShortComplex exact reflected faithful functor" | **`CategoryTheory.ShortComplex.exact_map_iff_of_faithful`** found: for `F : C ⥤ D` faithful + preserving zero morphisms and the relevant left/right homology, `(S.map F).Exact ↔ S.Exact`. **Also** `Functor.reflects_exact_of_faithful` (in abelian category setting). |

### What's missing for a clean alternative route

The blueprint's section-wise + sheafification strategy would need:

1. **A `SheafOfModules`-level exactness lemma reflecting presheaf-level exactness.** Mathlib has:
   - `CategoryTheory.ShortComplex.exact_map_iff_of_faithful` (general functorial reflection of exactness) — but applying it requires the faithful functor `SheafOfModules R ⥤ PresheafOfModules R.val` (which is the `.val` projection plus structure) to preserve enough homology, which is not currently a Mathlib instance for `SheafOfModules`.
   - `Functor.reflects_exact_of_faithful` (abelian-category specialisation) — `SheafOfModules R` over `Opens X` is abelian (for `R` a sheaf of rings) only under additional setup that Mathlib provides indirectly via `Sheaf J AddCommGrpCat`. The category-theoretic abelian-ness of `SheafOfModules` is not packaged as a single `[Abelian (SheafOfModules R)]` instance accessible by name.

2. **A `PresheafOfModules`-level "exact iff pointwise" lemma.** Searches show no such lemma is exported. The pointwise (section-wise) characterisation of exactness for `PresheafOfModules R₀` would be the direct analogue of `HomologicalComplex.exact_of_degreewise_exact`, but `PresheafOfModules R₀` is not a `HomologicalComplex`-shape — it's a `R₀ ⟶ ⟨ModuleCat ↑R₀⟩` indexed family, and Mathlib hasn't packaged pointwise-exactness for it.

3. **Section-level identification of the cotangent short complex** with the ring-level Kähler exact sequence (`KaehlerDifferential.exact_mapBaseChange_map` applied at each open `U`'s ring chain `S(U) → Y(f(U)) → X((f∘g)(U))`). Even if (1) and (2) existed, the *content* of the proof would still demand identifying the descent maps `cotangentExactSeqAlpha.val.app U` and `cotangentExactSeqBeta.val.app U` with `KaehlerDifferential.mapBaseChange` and `KaehlerDifferential.map` respectively — this is the same bundled-vs-unbundled bridge obstacle that blocked `h_epi` in iter-083.

### Bottom line

The plan-agent's two-prong existence check is negative:
- (1) No `SheafOfModules.exact_of_presheaf_exact` / `Sheaf.exact_of_presheaf_exact` / `PresheafOfModules.shortComplex_exact_iff_pointwise` exists in Mathlib.
- (2) Even routing via `CategoryTheory.ShortComplex.exact_map_iff_of_faithful` would require building the faithful functor + its `PreservesLeftHomologyOf` / `PreservesRightHomologyOf` instances for `SheafOfModules R`, which is not currently in Mathlib.

Per the plan-agent's instruction: stopped without introducing a helper. `case h_exact` is left as `sorry`.

## Suggested next-iteration path

Two viable routes for iter-087+:

### Route A (top-down, "build the missing Mathlib infra")
Land the helper `SheafOfModules.exact_of_presheaf_exact` (iff form) as a project-local helper. It would have signature roughly:
```lean
lemma SheafOfModules.exact_of_presheaf_exact
    {C : Type*} [Category C] {J : GrothendieckTopology C}
    {R : Sheaf J RingCat}
    (S : ShortComplex (SheafOfModules R))
    (h : (S.map (SheafOfModules.toPresheaf R)).Exact) : S.Exact
```
(Or the iff form. Has a TRUE, instantiable signature — not the iter-085 false form.) The body would use `CategoryTheory.ShortComplex.exact_map_iff_of_faithful` against `SheafOfModules.toPresheaf` together with the (proven) faithfulness of that functor plus the (provable) preservation-of-homology instances. The body could in principle close without `sorry` — the technical work is in the homology-preservation argument.

### Route B (bottom-up, "ring-level direct")
Skip `SheafOfModules`-level exactness entirely. Construct an explicit kernel-image factoring via:
- `ShortComplex.exact_iff_image_eq_kernel` (or analogous).
- For each open `U`, compute both ker and im as modules over `X.presheaf.obj (op U)` using `KaehlerDifferential.exact_mapBaseChange_map`.
- Glue across opens via sheafification's left-exactness (`PresheafOfModules.instPreservesFiniteLimitsSheafOfModulesSheafification`).

Route A is shorter once the infra is in place; Route B is concrete but mechanically long.

## Blueprint flag

The blueprint chapter `blueprint/src/chapters/Differentials.tex` § "Cotangent exact sequence" declares `lem:sheafOfModules_exact_iff_stalkwise`. Since iter-086 reverts the false-signature helper, this blueprint lemma block should be either:
- (a) **rewritten** to describe Route A's *true*-signature helper (`SheafOfModules.exact_of_presheaf_exact`), or
- (b) **removed**, with the cotangent-exactness chapter section noting that the alternative route is deferred to iter-087+.

Suggest the plan agent update the blueprint to reflect the chosen direction for iter-087.

## Files changed

- `AlgebraicJacobian/Differentials.lean`: removed L501–521 helper + comment block; replaced L654–666 `case h_exact` body with a 4-line `sorry`-with-pointer block. Net change: file shrank by 25 lines.

## Markers to set (for the sync_leanok deterministic phase)

- `cotangentExactSeq_structure`: still `\leanok` in statement (`sorry` body), no `\leanok` in proof block.
- The blueprint `lem:sheafOfModules_exact_iff_stalkwise` block: review agent to annotate with `% NOTE: false signature in iter-085 rejected; helper removed iter-086. Awaiting Route A/B in iter-087+`.
