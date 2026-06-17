# Blueprint Review Report

## Slug
tsgate206

## Iteration
206

## Scope note
Same-iter fast-path re-review scoped to `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`
(Lean file `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`, A.1.c.SubT), per directive.
Cross-chapter checks performed for dangling ref elimination and external label resolution.

---

## Per-chapter

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **soon** — `lem:tensorobj_inverse_invertible` proof `\uses` block lists only
    `lem:tensorobj_preserves_locally_trivial`, but the proof glues the contraction
    isomorphism via restriction compatibility, which calls for `lem:tensorobj_restrict_iso`
    too. The statement `\uses` correctly lists it; the proof `\uses` is a subset and
    the dependency graph is not broken (statement `\uses` drives the graph), but the
    proof block is slightly misleading for a prover reading it. Fix: add
    `lem:tensorobj_restrict_iso` to the proof `\uses` of `lem:tensorobj_inverse_invertible`.
  - **informational** — Blueprint proof of `lem:tensorobj_restrict_iso` correctly
    argues the affine comparison isomorphism via flatness (`Module.Invertible.lTensor_bijective_iff`,
    verified by writer via LSP). It does not separately describe the **construction**
    of the comparison morphism `(L ⊗_X M)|_f → L|_f ⊗_U M|_f` at the sheaf level
    (the "strong-monoidal pullback" step). The Lean file (`TensorObjSubstrate.lean:249`)
    has this obstacle documented in the sorry comment. The mathematics is correct;
    the prover will need to construct the comparison before proving it is an iso.
    Not a gate-blocking issue — the named sorry `tensorObj_restrict_iso` at line 249
    provides the scaffolded target and explains the construction gap.
  - **informational** — Stale web HTML files (`blueprint/web/`) still reference
    `thm:scheme_modules_monoidal` in the table-of-contents sidebar (generated from
    the prior build). The `.tex` source is clean (grep confirms zero matches in
    `blueprint/src/chapters/`). Blueprint rebuild will clear the stale web artifacts.
  - **informational** — `lem:tensorobj_restrict_iso`, `lem:tensorobj_assoc_iso`,
    `lem:tensorobj_unit_iso`, `lem:tensorobj_comm_iso` are intentionally unpinned
    (`\lean{}` empty). The target name `AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso`
    is already present in the Lean file (line 249); the plan agent / lean-scaffolder
    should pin it and assign names for the three iso lemmas when scaffolding this iter.

---

## Detailed findings supporting the verdict

### 1. Completeness

**New lemmas (four)** — all present and adequately specified:

- `lem:tensorobj_restrict_iso`: Full lemma block (statement + proof). The proof
  localises to affine opens, invokes flatness of line bundles
  (`Module.Invertible ⇒ Projective ⇒ Flat`, Mathlib.RingTheory.PicardGroup), applies
  `Module.Flat.lTensor_preserves_injective_linearMap` and right-exactness to get
  bijectivity of the comparison, then glues. Mathlib name
  `Module.Invertible.lTensor_bijective_iff` verified by writer via LSP. Adequate for a prover.

- `lem:tensorobj_assoc_iso`: Full block. Proof: common trivializing cover → invoke
  `lem:tensorobj_restrict_iso` to localise both sides → standard ring associativity →
  local isos agree on overlaps (naturality of module associator against restriction
  comparisons) → glue. Existence-of-iso only; no pentagon claimed.

- `lem:tensorobj_unit_iso`: Full block. Proof: trivializing cover → restrict commutes
  with `⊗` via `lem:tensorobj_restrict_iso` → standard `A ⊗_A L_i ≅ L_i` → glue.
  Both left and right unit cases covered.

- `lem:tensorobj_comm_iso`: Full block. Proof: trivializing cover → braiding on
  A-modules → glue. Parallel structure to assoc.

**`thm:rel_pic_addcommgroup_via_tensorobj` proof** is fully rewritten:
- Four axioms (assoc, unit, comm, inverse) each mapped explicitly to the corresponding
  iso lemma.
- Each axiom is stated as a `Nonempty(... ≅ ...)` proposition; no coherence datum
  consumed — correctly argued.
- Well-definedness of the group operation on iso-classes argued via functoriality
  (`lem:scheme_modules_tensorobj_functoriality`).
- Subgroup claim: `lem:pullback_compatible_with_tensorobj` shows `π_T^*` carries
  tensor to tensor and unit to unit → image is a subgroup.
- QuotientAddGroup assembly: standard — quotient of abelian group by subgroup is
  abelian via `QuotientAddGroup`; kernel identified as `π_T^* Pic(T)`.
- Mathlib idiom alignment (`CommRing.Pic` / `instCommGroupPic`) noted for prover.

**Group-law assembly is complete**: four iso lemmas + `lem:tensorobj_lift_onproduct`
(subtype restriction) + `lem:pullback_compatible_with_tensorobj` (subgroup) +
`thm:relative_pic_quotient_well_defined` (underlying set) + `QuotientAddGroup` = full
`AddCommGroup` instance. No step missing.

### 2. Correctness

**Flat-exactness argument** (`lem:tensorobj_restrict_iso`): mathematically sound.
Line bundles are locally free of rank one → finitely generated projective → flat.
For a flat module `L`, `lTensor L` preserves injections; `⊗` is always right-exact
(preserves surjections); together these force bijectivity. Applied to the structural
comparison for `M` under restriction, this yields bijectivity of the full comparison.
The Mathlib-specific chain (`Module.Invertible.lTensor_bijective_iff`) was LSP-verified
by the writer.

**Group axioms as propositions**: correct. `Nonempty T` is a `Prop` in Lean 4;
proof-irrelevant, so no coherence witnesses are needed for the group axioms. The
monoidal-coherence bypass (`rem:scheme_modules_monoidal_off_path`) is mathematically
justified.

**`Pic⁰`-as-line-bundle-group vs Kleiman §2 and Stacks 01CR**: the chapter defines
`[L] + [L'] := [L ⊗ L']` on iso-classes of line bundles on `C ×_k T`, quotiented by
`π_T^* Pic(T)`. Kleiman df:aPf/df:Pfs (cited with verbatim `% SOURCE QUOTE`) defines
exactly this structure. Stacks 01CR defines the Picard group of a scheme as the group
of iso-classes of invertible sheaves under tensor — matches. Citation discipline is
satisfied: `% SOURCE:` with `(read from references/kleiman-picard-src/kleiman-picard.tex)`,
verbatim `% SOURCE QUOTE:` in original LaTeX, visible `\textit{Source: ...}` inline. ✓

**No `thm:scheme_modules_monoidal` references in `.tex` source**: confirmed by grep
(zero matches across all `blueprint/src/chapters/*.tex`). Web HTML artifacts are
stale but not blocking.

### 3. Lean target formulation

**Pre-existing pinned declarations** — all well-formed:

| Label | Lean pin | \leanok | Lean file location | Status |
|---|---|---|---|---|
| `def:scheme_modules_tensorobj` | `AlgebraicGeometry.Scheme.Modules.tensorObj` | ✓ | line 113 | scaffold present |
| `lem:scheme_modules_tensorobj_functoriality` | `…tensorObj_functoriality` | ✓ | line 129 | scaffold present |
| `lem:tensorobj_preserves_locally_trivial` | `…tensorObj_isLocallyTrivial` | ✓ | line 277 | scaffold present |
| `lem:tensorobj_inverse_invertible` | `…exists_tensorObj_inverse` | ✓ | line 300 | sorry scaffold |
| `lem:tensorobj_lift_onproduct` | `…tensorObjOnProduct` | ✓ | line 312 | scaffold present |
| `thm:rel_pic_addcommgroup_via_tensorobj` | `…PicSharp.addCommGroup_via_tensorObj` | ✓ | line 339 | sorry scaffold |

All six pins name real declarations in `TensorObjSubstrate.lean` (or `PicSharp` namespace).
None points to a non-existent or wrong-type declaration. ✓

**New unpinned lemmas** (`lem:tensorobj_restrict_iso`, `lem:tensorobj_assoc_iso`,
`lem:tensorobj_unit_iso`, `lem:tensorobj_comm_iso`): intentionally `\lean{}` at
this stage, acceptable per the directive's "to be assigned at scaffold time" policy.
`tensorObj_restrict_iso` at line 249 of the Lean file is the natural pin for
`lem:tensorobj_restrict_iso`; the other three have no current scaffold and need
new declarations.

**Orphaned Lean decl** (noted by writer, not a gate issue): `monoidalCategory`
instance (line 150 of Lean file, `:= sorry`) was pinned to `thm:scheme_modules_monoidal`
which is now a remark with no `\lean{}` pin. Blueprint-doctor may flag this as an
orphan. Off critical path; plan agent to decide whether to delete or leave dormant.

### 4. External cross-references

All external `\uses` targets resolve:
- `def:pullback_along_projection` → `Picard_LineBundlePullback.tex` line 209 ✓
- `thm:relative_pic_quotient_well_defined` → `Picard_LineBundlePullback.tex` line 331 ✓
- `lem:rel_pic_sharp_groupoid` → `Picard_RelPicFunctor.tex` line 76 ✓

No cross-chapter label resolution failures.

---

## Severity summary

Severity summary: HARD GATE CLEARS — no must-fix-this-iter findings.

**Soon (2)**:
1. `Picard_TensorObjSubstrate.tex` / `lem:tensorobj_inverse_invertible` proof `\uses`:
   add `lem:tensorobj_restrict_iso` to proof body `\uses` to match statement `\uses`.
2. Assign `\lean{}` pins for the four new unpinned lemmas at scaffold time (
   `lem:tensorobj_restrict_iso` → `…tensorObj_restrict_iso` already exists in Lean file).

**Informational (2)**:
1. Blueprint proof of `lem:tensorobj_restrict_iso` does not address construction of the
   comparison morphism at the sheaf level (the strong-monoidal pullback gap documented
   in the Lean sorry comment at line 249). Math correct; prover briefing recommended.
2. Stale web HTML TOC references to `thm:scheme_modules_monoidal`. Source is clean;
   rebuild will clear.

**Overall verdict**: Chapter `Picard_TensorObjSubstrate.tex` clears the HARD GATE —
complete: true, correct: true, no must-fix findings. Prover may be dispatched on
`TensorObjSubstrate.lean` this iter.
