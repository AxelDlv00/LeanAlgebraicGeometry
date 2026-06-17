# Lean ↔ Blueprint Check Report

## Slug
quot-iter040

## Iteration
040

## Files audited
- Lean: `/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean`
- Blueprint: `/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_QuotScheme.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.pullback_composite_immersion_isIso_fromTildeΓ}` (chapter: `lem:pullback_composite_immersion_isIso_fromTildeΓ`, blueprint line 4250–4251)

- **Lean target exists**: yes (line 1969)
- **Signature matches**: yes
  - Blueprint conclusion: `IsIso ((pullback j).obj M).fromTildeΓ` where `j = compositeBasicOpenImmersion`.
  - Lean statement: `IsIso (@Scheme.Modules.fromTildeΓ ... ((Scheme.Modules.pullback (compositeBasicOpenImmersion M q s i hs)).obj M))`. The existential iso-of-pullbacks half is implicit (it appears only in the proof body), but the primary conclusion matches.
- **Proof follows sketch**: yes — proof uses `isIso_fromTildeΓ_of_iso` + `pullbackComp` coherences exactly as the blueprint prescribes; `isIso_fromTildeΓ_restrict_basicOpen` plays the role of the P1 keystone.
- **Axiom status**: clean (`propext`, `Classical.choice`, `Quot.sound` only).
- **Notes**: none.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.composite_immersion_range_basicOpen}` (chapter: `lem:composite_immersion_range_basicOpen`, blueprint line 4278–4279)

- **Lean target exists**: **NO** — the declaration pinned by `\lean{...}` does not exist. The Lean file contains `compositeBasicOpenImmersion_opensRange` (line 2002), not `composite_immersion_range_basicOpen`. These are different names; the LSP hover confirms the actual name is `AlgebraicGeometry.Scheme.Modules.compositeBasicOpenImmersion_opensRange`.
- **Signature matches**: **partial** — the blueprint `lem:composite_immersion_range_basicOpen` bundles **three** claims:
  1. `j.opensRange = D(s)`  ← **present** in `compositeBasicOpenImmersion_opensRange`
  2. `j''ᵁ D(f') = D(f) ⊓ D(s)` ← **absent** from Lean
  3. `σ(f') = algebraMap R Rₛ f` ← **absent** from Lean (definitional, but not a named theorem)
- **Proof follows sketch**: partial — the existing `compositeBasicOpenImmersion_opensRange` proof is correct and axiom-clean for claim (1). Claims (2) and (3) are not yet formalized.
- **Axiom status**: `compositeBasicOpenImmersion_opensRange` is clean; the missing claims have no Lean body at all.
- **Notes**: See Red Flags section.

---

## Red Flags

### `\lean{...}` pin names a non-existent declaration

**`lem:composite_immersion_range_basicOpen` (blueprint line 4279)**:

```
\lean{AlgebraicGeometry.Scheme.Modules.composite_immersion_range_basicOpen}
```

No Lean declaration with this name exists. The prover wrote `compositeBasicOpenImmersion_opensRange` instead. The `sync_leanok` phase will fail to find the pinned name and leave the block unmarked; the dependency chain for `lem:section_localization_hfr_basicOpen` and `lem:flocus_section_scalar_tower` (both `\uses{lem:composite_immersion_range_basicOpen}`) will appear unlinked in the blueprint graph.

**Required fix**: change the `\lean{...}` pin to
`\lean{AlgebraicGeometry.Scheme.Modules.compositeBasicOpenImmersion_opensRange}`.

### Partial formalization — missing `% NOTE:` annotation

The blueprint block `lem:composite_immersion_range_basicOpen` bundles three sub-statements; only sub-statement (1) is in Lean. The block carries no `% NOTE:` marker to signal this to reviewers or `sync_leanok`. This should be annotated:

```
% NOTE: partial — only j.opensRange = D(s) is formalized (compositeBasicOpenImmersion_opensRange).
%   Sub-statements (2) j''ᵁ D(f') = D(f) ⊓ D(s) and (3) σ(f') = algebraMap R Rₛ f are not yet
%   present as named Lean declarations.
```

### No `sorry`, no placeholder bodies, no excuse-comments

All four new declarations have genuine, axiom-clean proofs/bodies. No sorries, no `True`-valued stubs, no excuse-comments were found.

---

## Unreferenced declarations (coverage debt)

These two declarations have **no** `\lean{...}` block in the blueprint. Both appear substantive (not trivial one-liner helpers):

| Lean declaration | Line | What it is |
|---|---|---|
| `compositeBasicOpenImmersion` | 1950 | `noncomputable def` — the composite open immersion `j = isoSpec.inv ≫ ι_W ≫ ι_{q.X i}`. Used in all three companion theorems. |
| `compositeBasicOpenImmersion_isOpenImmersion` | 1991 | `instance` — `IsOpenImmersion j`. Required for `.opensRange`, image-opens, and `gammaImageRingEquiv`. |

The directive confirms these are intentional `lean_aux` additions (no dedicated blueprint block expected at this stage). Flagged here for completeness; they belong under a `def` or `instance` block in the chapter once the producer is assembled.

---

## Blueprint adequacy for this file

**Coverage**: 2 of the 4 new declarations have a `\lean{...}` block in the chapter. The 2 uncovered ones (`compositeBasicOpenImmersion`, `compositeBasicOpenImmersion_isOpenImmersion`) are auxiliary and acknowledged as `lean_aux` by the directive.

**Proof-sketch depth for the 4 new decls**: adequate. The blueprint subsection "Section-transport producer for the basic-open Hfr" (lines 4235–4246) describes `j` clearly in prose; `lem:pullback_composite_immersion_isIso_fromTildeΓ` has a complete proof sketch (lines 4264–4275) that the Lean proof follows faithfully.

**Proof-sketch depth for the still-blocked top producer `section_localization_hfr_basicOpen`**: adequate in structure — the blueprint proof sketch (lines 4374–4403) is detailed, naming all five ingredients (a)–(d) + combiner with precise cross-references. The blocker is **not** blueprint depth: sub-lemmas (b) (partially formalized), (c) `gamma_image_iso_semilinear_top`, and (d) `flocus_section_scalar_tower` are simply not yet in Lean. The existing chapter prose is sufficient to guide their formalization once the prover turns to them.

**Hint precision**: **wrong** for `lem:composite_immersion_range_basicOpen` — the `\lean{...}` pin names a declaration that does not exist. All other `\lean{...}` pins in the four-declaration set are correct.

**Generality**: matches need.

**Recommended chapter-side actions**:
1. **(must-fix)** Correct the `\lean{...}` pin in `lem:composite_immersion_range_basicOpen` from `composite_immersion_range_basicOpen` to `compositeBasicOpenImmersion_opensRange`.
2. **(major)** Add a `% NOTE:` annotation to `lem:composite_immersion_range_basicOpen` flagging that only the range identity (claim 1) is formalized; claims (2) and (3) remain open.
3. **(minor)** Add `lean_aux` `def` and `instance` blocks (or a prose paragraph) for `compositeBasicOpenImmersion` and `compositeBasicOpenImmersion_isOpenImmersion` once the producer is assembled — currently their absence is acceptable but would cause an orphan audit finding on chapter completion.

---

## Severity summary

| Finding | Severity |
|---|---|
| `\lean{...}` pin in `lem:composite_immersion_range_basicOpen` names non-existent declaration `composite_immersion_range_basicOpen` (Lean has `compositeBasicOpenImmersion_opensRange`) | **must-fix-this-iter** |
| Partial formalization: `lem:composite_immersion_range_basicOpen` bundles 3 claims; Lean has only claim (1); no `% NOTE:` | **major** |
| `compositeBasicOpenImmersion` (def) has no blueprint block | minor (lean_aux, acknowledged) |
| `compositeBasicOpenImmersion_isOpenImmersion` (instance) has no blueprint block | minor (lean_aux, acknowledged) |

**Overall verdict**: One must-fix — the `\lean{...}` pin in `lem:composite_immersion_range_basicOpen` is broken (names a non-existent Lean declaration); the block also needs a `% NOTE:` for its partial formalization. All four new declarations are otherwise axiom-clean and mathematically faithful to the blueprint. — 2 declarations checked against blueprint blocks, 2 red flags.
