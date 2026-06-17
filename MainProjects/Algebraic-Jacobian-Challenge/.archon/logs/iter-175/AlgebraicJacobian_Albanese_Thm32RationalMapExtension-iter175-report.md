# AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean

## Lane J file-skeleton — iter-175

### Scope

New file scaffold for **A.4.c** (Milne *Abelian Varieties* §I.3 Theorem 3.2),
the rational-map extension theorem for nonsingular varieties into abelian
varieties. Blueprint chapter:
`blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex` (single
`\lean{...}` pin at line 50, theorem `thm:rational_map_to_av_extends`).

### Result

**COMPLETE** — Lane J file-skeleton lands as specified:

- New file `AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean`
  created (162 LOC, including docstring + module preamble + namespace
  scaffolding).
- New directory `AlgebraicJacobian/Albanese/` created (sibling to
  `Picard/`, `RiemannRoch/`, `Genus0BaseObjects/`).
- Single pinned declaration `AlgebraicGeometry.Scheme.RationalMap.extend_to_av`
  scaffolded with substantive type signature and `by sorry` body.
- Module import added to `AlgebraicJacobian.lean` (post the existing
  `RiemannRoch.RRFormula` line).

### Build verification

- `lake build AlgebraicJacobian.Albanese.Thm32RationalMapExtension` → exits
  `0` (8317/8317 jobs).
- `lake build AlgebraicJacobian` (top-level) → exits `0` (8346/8346
  jobs). All existing sorries preserved; one new sorry warning for the new
  file's single pinned declaration:
  `AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean:162:8:
   declaration uses 'sorry'`.

### Declaration scaffolded

#### `AlgebraicGeometry.Scheme.RationalMap.extend_to_av` (file line 162)

- **Approach:** substantive type signature against Mathlib's existing
  `AlgebraicGeometry.Scheme.RationalMap` API (`X.left.RationalMap A.left`)
  and `Scheme.Hom.toRationalMap` (the canonical coercion `X ⟶ Y →
  X.RationalMap Y`). The conclusion `∃! (g : X.left ⟶ A.left),
  g.toRationalMap = f` encodes existence + uniqueness of the regular
  extension exactly as Milne states it.
- **Hypotheses (matching the chapter §1):**
  - Base: `{kbar : Type u} [Field kbar] [IsAlgClosed kbar]`.
  - Smooth variety `X : Over (Spec (.of kbar))` with the project's
    "nonsingular variety" instances `[Smooth X.hom]
    [GeometricallyIrreducible X.hom] [IsSeparated X.hom]
    [LocallyOfFiniteType X.hom] [IsIntegral X.left] [IsReduced X.left]`.
  - Abelian variety `A : Over (Spec (.of kbar))` with the project's
    AV-quartet instances `[GrpObj A] [IsProper A.hom] [Smooth A.hom]
    [GeometricallyIrreducible A.hom]`.
- **Result:** RESOLVED at scaffold level. iter-176+ body work, gated on
  A.4.a (`Albanese/CodimOneExtension.lean`) and A.4.b
  (`Albanese/AuslanderBuchsbaum.lean`).
- **Body sketch (in docstring + namespace comment) for iter-176+:**
  1. Pick a `PartialMap` representative `φ` via
     `Scheme.RationalMap.toPartialMap` (uses `X` reduced + `A` separated).
  2. `φ.domain = ⊤` from combining `thm:codim_one_extension` (complement
     codim `≥ 2`) with `lem:milne_codim1_indeterminacy` (complement empty
     or pure codim `1`).
  3. Read off `g := φ.hom`; verify `g.toRationalMap = f`.
  4. Uniqueness from `AlgebraicGeometry.ext_of_isDominant` + reducedness
     of `X`.

### Notes for plan agent

1. **`\lean{...}` reservation reconciliation.** The blueprint chapter
   `AbelianVarietyRigidity.tex` line 821 reserves
   `AlgebraicGeometry.rationalMap_to_av_extends` (the *flat-namespace*
   form) for what is now this same theorem. The Lane J scaffold uses the
   `Scheme.RationalMap` namespace form
   `AlgebraicGeometry.Scheme.RationalMap.extend_to_av` per the chapter at
   `Albanese_Thm32RationalMapExtension.tex` line 50 (`\lean{...}`). A
   future blueprint-writer / plan agent pass should retarget the
   reservation in `AbelianVarietyRigidity.tex` to the new
   namespaced name (or — equivalently — drop the now-superseded
   reservation, since the prose context of that block is just citing
   downstream-of-Rigidity 3.2, not the theorem itself). This is a
   chapter-prose edit, not a Lean edit, and is flagged here only because
   the chapter contents flag a "reconciliation pass" in the strategy note
   at line 23–26 of `Albanese_Thm32RationalMapExtension.tex`.

2. **Blueprint `\leanok` is deterministic.** The `sync_leanok` pass will
   add `\leanok` on the *statement* block of
   `thm:rational_map_to_av_extends` automatically once it observes the
   declaration in the environment (substantive type + body present, even
   if `sorry`). No manual marker edits needed.

### Lemmas / Mathlib API surveyed

Used in the type signature / docstring:

- `AlgebraicGeometry.Scheme.RationalMap` (Mathlib type) — partial-map
  equivalence class on dense opens.
- `AlgebraicGeometry.Scheme.Hom.toRationalMap` (Mathlib def) — canonical
  coercion `X ⟶ Y → X.RationalMap Y`.
- `AlgebraicGeometry.Scheme.RationalMap.toPartialMap` (Mathlib def) — for
  `X` reduced and `Y` separated, picks a `PartialMap` representative on
  the domain of definition.
- `AlgebraicGeometry.ext_of_isDominant` (Mathlib theorem) — agreement
  principle for reduced + separated targets, used in the uniqueness arm.

No `sorry` introduced beyond the single pinned declaration. Zero axioms.
File compiles cleanly under `lake build`.
