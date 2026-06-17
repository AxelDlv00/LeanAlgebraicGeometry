# Blueprint Review Report

## Slug
rescope-iter062

## Iteration
062

---

## Scoped gate verdict

This is the fast-path re-review of `Cohomology_CechHigherDirectImage.tex` after the
`blueprint-writer/fix-iter062` pass. The two must-fix items from the main iter-062 report
are examined first; the full per-chapter section follows.

### Must-fix item 1 — `lem:slice_structureSheaf_hom`: `ψ_r` type precision

**RESOLVED.** The lemma statement now reads (lines 9800–9825):

```
ψ_r : 𝒪_{U_i} ⟶ (F.sheafPushforwardContinuous RingCat J K).obj 𝒪_{V_i}
```

where:
- `F : Opens U_i → Opens V_i` is the opens-site equivalence induced by the restricted homeomorphism;
- `F.IsContinuous J K` and `F.Final` are stated as explicit hypotheses;
- `(SheafOfModules.pushforward ψ_r).IsRightAdjoint` is stated as the instance that gates
  availability of `SheafOfModules.pullback ψ_r`;
- `\lean{AlgebraicGeometry.sliceStructureSheafHom}` names the build target (marked
  `% NOTE: build target. The Lean declaration does not exist yet.`).

The `\uses{}` block lists `lem:sheafPushforwardContinuous_mathlib`,
`lem:scheme_hom_toRingCatSheafHom_mathlib`, `lem:over_post_forget_mathlib`,
`lem:pushforwardPushforwardEquivalence_mathlib`, `lem:overEquivalence_isContinuous` — all
labels resolve (leandag reports 0 `unknown_uses`). A prover can write a complete Lean
signature directly from this statement.

### Must-fix item 2 — `lem:pushforward_slice_pullback_iso`: concrete LHS + iso path

**RESOLVED.** The lemma statement now reads (lines 9855–9885):

```
(pullback ψ_r).obj (H.over U_i)  ≅  (Φ.functor.obj H).over V_i
```

The iso-assembly proof sketch assembles from two pieces:
1. `pullbackObjUnitToUnit ψ_r` (`lem:pullbackObjUnitToUnit_mathlib`) is an iso because
   `F.Final`.
2. The opens-equivalence object identity `F.obj U_i = V_i` holds by `rfl` (the image
   functor sends `W` to `φ.inv^{-1} W` definitionally, and `V_i` IS defined as
   `φ.inv^{-1} U_i`).

`\uses{lem:slice_structureSheaf_hom, lem:sheafOfModules_pullback_mathlib,
lem:pullbackObjUnitToUnit_mathlib}` — all three labels are defined and resolve. No
`eqToIso` correction is claimed necessary. Proof block correctly states the argument.

The prior `lem:pushforward_commutes_restriction` contradiction is also resolved: the NOTE
now reads "superseded — not an active build target and not on any live `\uses` chain." Grep
confirms the label appears only at its own `\label{}` line — no other `\uses{}` anywhere
references it.

### `\mathlibok` anchor faithfulness — all 5 new anchors verified

Verified against Mathlib sources on disk and by `lake env lean`:

| anchor label | `\lean{}` names | status |
|---|---|---|
| `lem:sheafOfModules_pullback_mathlib` | `SheafOfModules.pullback`, `SheafOfModules.instIsLeftAdjointPullback` | ✓ both verified by `lake env lean` |
| `lem:pullbackObjUnitToUnit_mathlib` | `SheafOfModules.pullbackObjUnitToUnit`, `SheafOfModules.instIsIsoPullbackObjUnitToUnitOfFinal` | ✓ both verified by `lake env lean` |
| `lem:sheafPushforwardContinuous_mathlib` | `CategoryTheory.Functor.sheafPushforwardContinuous` | ✓ in `CategoryTheory/Sites/Continuous.lean` namespace `Functor` |
| `lem:scheme_hom_toRingCatSheafHom_mathlib` | `AlgebraicGeometry.Scheme.Hom.toRingCatSheafHom` | ✓ in `AlgebraicGeometry/Modules/Presheaf.lean` namespace `AlgebraicGeometry.Scheme` |
| `lem:over_post_forget_mathlib` | `CategoryTheory.Over.post_forget_eq_forget_comp` | ✓ in `CategoryTheory/Comma/Over/Basic.lean` namespace `Over` |

No `\mathlibok` anchor uses a fabricated name.

### Dependency graph (leandag)

- **`unknown_uses`: 0** — no broken `\uses{}` cross-references anywhere in the blueprint.
- **`unmatched_lean`: 84** — pre-existing; includes all `\mathlibok` anchor names (expected:
  leandag scans project files, not Mathlib) and unformalized build targets (sorried or not
  yet written). The 5 new anchors appear here for the expected reason.
- **isolated: 1** — a `lean_aux` node (uncovered Lean helper, no blueprint entry). Pre-existing;
  not a blueprint node. Disposition: **keep** (uncovered Lean auxiliary, not a graph gap).

### Rendering lint (blueprint-doctor)

`malformed_refs: 0` — blueprint renders cleanly, no undefined macros, math-delim errors,
or broken references.

---

## Per-chapter

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `lem:slice_structureSheaf_hom` and `lem:pushforward_slice_pullback_iso`: both are
    `% NOTE: build target` (Lean declarations not yet formalized). This is correct — they
    are the objectives for the prover dispatch this iter, not gaps.
  - `lem:pushforward_commutes_restriction`: retained as superseded reference lemma, no
    `\lean{}` hint, not on any live `\uses` chain. Benign.
  - The 5 new `\mathlibok` anchors all carry real Mathlib names; all verified.

*(All other chapters are unchanged from the iter-062 main report. No new must-fix items
introduced elsewhere; blueprint-doctor reports 0 malformed_refs across the whole blueprint.)*

---

## Severity summary

Severity summary: HARD GATE CLEARS — no findings.

**Overall verdict**: Both iter-062 must-fix items are resolved; `Cohomology_CechHigherDirectImage.tex`
is `complete: true`, `correct: true`, with no must-fix-this-iter findings. `CechSectionIdentification.lean`
and `OpenImmersionPushforward.lean` clear the HARD GATE for prover dispatch this iter.
