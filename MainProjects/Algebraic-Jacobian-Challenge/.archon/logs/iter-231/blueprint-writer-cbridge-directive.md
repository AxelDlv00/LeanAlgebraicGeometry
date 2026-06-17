# blueprint-writer directive — cbridge (fix the falsified C-bridge proof recipe)

## Scope (edit ONLY this chapter)
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

## The problem (blueprint-reviewer ts231 MUST-FIX, hard gate)
The proof body of `lem:dual_isLocallyTrivial` (around lines 3002–3038) still describes an
EMPIRICALLY FALSIFIED recipe: it claims the post-H1 residual
`(pushforward β).obj (dual A) ≅ dual ((pushforward β).obj A)` is discharged by the shared
slice-site sheaf equivalence `lem:open_immersion_slice_sheaf_equiv` (`overSliceSheafEquiv`). The
iter-230 binding probe proved this WRONG (three live-confirmed mismatches: sheaf-level vs
presheaf-level; fixed value-category vs varying-`𝒪(V)`-module fibration; whole-`U` slice site vs
per-open slices). There is an iter-230 `% NOTE … EMPIRICALLY FALSIFIED — pending blueprint-writer
rewrite` comment marking the paragraph; the rewrite was never done. A prover reading this chapter
would attempt the refuted recipe.

## Required edits

### 1. Add a named bridge lemma `lem:dual_restrict_iso` (it does NOT currently exist)
Add, immediately BEFORE `lem:dual_isLocallyTrivial`, a lemma block:
- `\label{lem:dual_restrict_iso}`, `\lean{AlgebraicGeometry.Scheme.Modules.dual_restrict_iso}`,
  `\uses{def:scheme_modules_dual, lem:restrictscalars_ringiso_dualequiv}`.
- Statement: for an open immersion `f : Y → X` and `M ∈ X.Modules`, a natural iso
  `(dual M).restrict f ≅ dual (M.restrict f)` of `𝒪_Y`-modules. (Only opens `V ⊆ U`, with `U` the
  image of `f`, are needed downstream.)
- Source: this is the classical internal-hom base-change iso `f^*ℋom(A,𝒪) ≅ ℋom(f^*A, f^*𝒪)`
  specialised to the structure sheaf; cite Stacks 17 (modules on ringed spaces, internal hom) — verify
  the verbatim `% SOURCE QUOTE` against `references/stacks-modules.tex` if you cite a specific tag,
  otherwise mark it project-bespoke (no external proof to quote).

### 2. Proof recipe for `lem:dual_restrict_iso` (the CORRECT route — replaces the falsified one)
This is a REAL natural iso, NOT a definitional equality (do NOT claim "literally equal"/"identity on
values" — the iter-230 probe confirmed it is non-`rfl`). It is, however, the FAVORABLE
iso-base-change case. Build it at the **presheaf-of-modules level** (where the residual lives),
objectwise in the open `V`, using THREE ingredients (do NOT use `overSliceSheafEquiv`):
- (a) the **per-`V` slice equivalence** `Over_Y V ≌ Over_X (f.opensFunctor V)` — the per-open shadow
  of `TopologicalSpace.Opens.overEquivalence`, valid because `f` is an open immersion so
  `f.opensFunctor` is fully faithful with image `{W ≤ U}`;
- (b) the codomain is the structure sheaf `𝒪`, which agrees on opens `≤ U`, so the target side of the
  internal hom matches under (a);
- (c) the **ring-iso transport**: `β = (toRingCatSheafHom f).hom` is a sectionwise ring ISO, so
  `restrictScalars β` is an EQUIVALENCE (`restrictScalars_isEquivalence_of_ringEquiv`); the
  ModuleCat-level shadow is `lem:restrictscalars_ringiso_dualequiv`. This carries the `𝒪_X(fV)`-module
  structure to the `𝒪_Y(V)`-module structure.
Assemble (a)+(b)+(c) into the comparison and check naturality in `V`; coherence of the slice
reindexing is light because `Opens` is a thin poset, but the module structure does NOT trivialise
(that is why it is a real ~150–300 LOC build, the FAVORABLE case, not near-definitional).

### 3. Rewrite the `lem:dual_isLocallyTrivial` proof body
Replace the falsified paragraph (the `overSliceSheafEquiv`-discharge text, ~lines 3002–3038, and the
stale `% NOTE … EMPIRICALLY FALSIFIED` comment) with: trivialise `L` on an affine open `U`
(`L|_U ≅ 𝒪_U`), then `(dual L)|_U ≅ dual(L|_U)` by `lem:dual_restrict_iso`, `≅ dual 𝒪_U` by
`dualIsoOfIso`, `≅ 𝒪_U` by `dual_unit_iso`. Update its `\uses{}` to cite
`lem:dual_restrict_iso, lem:restrictscalars_ringiso_dualequiv` and DROP
`lem:open_immersion_slice_sheaf_equiv`.

### 4. Remove all references to `lem:open_immersion_slice_sheaf_equiv` from the C-bridge blocks
(`lem:dual_restrict_iso` and `lem:dual_isLocallyTrivial`, statement AND proof `\uses`). The
`overSliceSheafEquiv` lemma itself remains in the chapter (it is a real proven lemma the A-engine
`lem:sheafofmodules_hom_of_local_compat` uses) — do NOT delete that block; only stop citing it from
the C-bridge.

## Out of scope
Do NOT touch other chapters. Do NOT add `\leanok` / `\mathlibok` markers. Do NOT rewrite the A-engine
or assembly blocks beyond the `\uses` corrections above.
