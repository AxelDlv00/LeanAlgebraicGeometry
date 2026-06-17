---
slug: iter034
iteration: "034"
generated_by: blueprint-reviewer
---

# Blueprint Review — iter-034

## Summary

**Return value:** `iter034: GATE-CLEARS — 3 chapters audited, 3 findings (0 must-fix, 2 soon, 1 informational), 0 unstarted-phase proposals`

Both iter-034 prover lanes CLEARED:
- **Lane 1** (`AffineSerreVanishing.lean`, 02KG cover-system): all 4 target blocks present, complete, correct, properly cited.
- **Lane 2** (`TildeExactness.lean`, 01I8 Route-P P3): `lem:tilde_preserves_kernels` with 4 bundled declarations present, complete, correct; NOTE block acknowledges the Lean instance is project-to-build.

---

## Per-chapter verdicts

### Chapter 1: `Cohomology_HigherDirectImage.tex`

```
complete: true
correct:  true
findings: none
```

57-line chapter, single definition `def:higher_direct_image`.
- `\leanok` present on the definition block.
- `\lean{AlgebraicGeometry.higherDirectImage}` hint present.
- Stacks citation and SOURCE QUOTE block present.
- `\uses{}` edges: none (leaf node, correct).
- No gaps, no isolated nodes contributed.

### Chapter 2: `Cohomology_AcyclicResolution.tex`

```
complete: true
correct:  true
findings: none
```

1052-line chapter covering the horseshoe lemma (7 sub-lemmas), dimension-shift lemma, cosyzygies, and the acyclic-resolution comparison theorem.
- Top theorem `\lean{CategoryTheory.Functor.rightDerivedIsoOfAcyclicResolution}` carries `\leanok`.
- All horseshoe sub-lemmas (`lem:biprod_injective`, `lem:degree_split`, `lem:stage_mono`, `lem:twist`, `lem:dComp`, `lem:chainMap`, `lem:resolvesMiddle`) carry `\leanok` and `\lean{...}` hints.
- All `\mathlibok` and `\leanok` anchors are present and consistent with the file's compile status.
- All `\uses{}` edges point to real labels (`leandag unknown_uses: []`).
- Proofs are detailed with SOURCE QUOTE blocks backed by `references/homological-acyclic-derived.tex` / `references/homological-acyclic-homology.tex`.

### Chapter 3: `Cohomology_CechHigherDirectImage.tex`

```
complete: partial  (2 nodes missing \lean{} hints; 1 known P1a gap; see findings below)
correct:  true     (all present blocks are structurally and semantically correct)
```

Massive consolidated chapter (~5500 lines) covering 10 Lean files via `% archon:covers` directives. All `\uses{}` edges resolve (`leandag unknown_uses: []`). The `blueprint-doctor` run is entirely clean (no malformed_refs, no broken_refs, no axiom_decls, no covers_problems, no orphan_chapters).

---

## Findings

### F1 — SOON: `lem:cech_free_eval_prepend_homotopy` missing `\lean{}` hint

- **Node:** `lem:cech_free_eval_prepend_homotopy`
- **File territory:** `FreePresheafComplex.lean`
- **Issue:** Blueprint lemma exists with statement and proof sketch, but no `\lean{AlgebraicGeometry...}` hint assigned. The `leandag show gaps` output confirms this is one of exactly 2 nodes missing a `\lean{}` annotation.
- **Downstream impact:** 16 downstream nodes in the DAG cannot be linked to Lean declarations until this hint is assigned.
- **Severity:** `soon` — not blocking either iter-034 active lane; FreePresheafComplex territory is quiescent this iter.
- **Action:** Plan agent should assign a `\lean{}` hint to this node in the next blueprint pass touching FreePresheafComplex.

### F2 — SOON: `lem:cech_free_eval_prepend_homotopy_spec` missing `\lean{}` hint

- **Node:** `lem:cech_free_eval_prepend_homotopy_spec`
- **File territory:** `FreePresheafComplex.lean`
- **Issue:** Same as F1 — blueprint lemma present, no `\lean{...}` hint. This is the contracting identity for the prepend homotopy (companion to F1).
- **Downstream impact:** 15 downstream nodes.
- **Severity:** `soon` — same rationale as F1.
- **Action:** Assign `\lean{}` hint alongside F1.

### F3 — INFORMATIONAL: `lem:isQuasicoherent_restrict_basicOpen` is the P1a gap (known, not a live lane)

- **Node:** `lem:isQuasicoherent_restrict_basicOpen` → `\lean{AlgebraicGeometry.isQuasicoherent_restrict_basicOpen}`
- **Status:** Present in blueprint with detailed proof sketch (mentions `lemma-widetilde-pullback`). NOT `\leanok`. A `% NOTE:` block explicitly states the required SheafOfModules restriction-to-`D(f)` machinery is absent from Mathlib.
- **Severity:** `informational` — this is the documented P1a gap (01I8 Route-P phase), earmarked for decomposition as an effort-break item this iter. It is NOT a gate for either iter-034 prover lane.
- **Action:** No immediate blueprint action required. P1a decomposition proceeds via the planned effort-break analysis.

---

## Isolation and DAG health

| Category | Count | Disposition |
|---|---|---|
| Total nodes | 128 | — |
| Isolated nodes | 1 | keep (lean_aux) |
| Gaps (missing `\lean{}`) | 2 | soon (F1, F2 above) |
| Unknown `\uses{}` edges | 0 | clean |

**Isolated node:** `lean:AlgebraicGeometry.CechAcyclic.affine`
- Type: `lean_aux` (uncovered Lean helper in `CechAcyclic.lean` with a sorry)
- Disposition: **keep** — lean_aux isolated nodes are expected uncovered Lean helpers, not blueprint coverage obligations. This node predates the P3 completion and represents a superseded proof path; it will be cleaned up when `CechAcyclic.lean` is finalized.

---

## HARD GATE determination — iter-034 prover lanes

### Lane 1: `AffineSerreVanishing.lean` (02KG cover-system build)

All required target blocks are present, complete, and correct:

| Block | `\lean{}` | Statement | Proof sketch | `\uses{}` sound | Notes |
|---|---|---|---|---|---|
| `lem:toSheaf_preservesFiniteColimits` | `AlgebraicGeometry.toSheaf_preservesFiniteColimits` | ✓ | ✓ 3-step (sheafificationCompToSheaf square → retract → colimit preservation) | ✓ | project-bespoke build, bounded ~80–150 LOC |
| `lem:to_sheaf_preserves_epi` | `AlgebraicGeometry.toSheaf_preservesEpimorphisms` | ✓ | ✓ 1-para corollary of above + `preservesEpi_of_preservesColimitsOfShape_mathlib` | ✓ | |
| `lem:affine_surj_of_vanishing` | `AlgebraicGeometry.affine_surj_of_vanishing` | ✓ | ✓ 3-step (local surjectivity via epi → refine to standard cover → glue via ses_cech_h1) | ✓ | |
| `def:affine_cover_system` | `AlgebraicGeometry.affineCoverSystem` | ✓ | ✓ (uses affine_faces_mem + affine_surj_of_vanishing + injective_cech_acyclic) | ✓ | Stacks Tag 02KG cited |
| `lem:standard_cover_cofinal` (support, done) | `AlgebraicGeometry.standard_cover_cofinal` | ✓ | `\leanok` | ✓ | iter-032 |
| `lem:affine_injective_acyclic` (support, done) | `AlgebraicGeometry.affine_injective_acyclic` | ✓ | `\leanok` | ✓ | iter-031 |

**GATE CLEARS for Lane 1.**

### Lane 2: `TildeExactness.lean` (01I8 Route-P P3)

| Block | `\lean{}` | Statement | Proof sketch | `\uses{}` sound | Notes |
|---|---|---|---|---|---|
| `lem:tilde_preserves_kernels` | 4 decls bundled: `tildePreservesFiniteLimits`, `tilde_preservesFiniteColimits`, `tilde_toStalk_map_injective`, `tilde_preservesFiniteLimits_of_preservesKernels` | ✓ | ✓ stalkwise-flatness argument (stalk of ~M at p is M_p; localization is flat; stalkwise isos suffice; ~ preserves kernels); 2 SOURCE QUOTE PROOF blocks | ✓ | `% NOTE:` block acknowledges Lean instance is project-to-build (absent from Mathlib) |

**GATE CLEARS for Lane 2.**

No must-fix findings touch either target block.

---

## Unstarted-phase proposals

**None.** All 4 remaining strategy phases have substantial blueprint coverage:

| Phase | Blueprint status |
|---|---|
| 02KG `affine_serre_vanishing` | Full coverage: `lem:toSheaf_preservesFiniteColimits`, `lem:to_sheaf_preserves_epi`, `lem:affine_surj_of_vanishing`, `def:affine_cover_system`, `lem:standard_cover_cofinal`, `lem:affine_injective_acyclic` — all present |
| 01I8 Route P | Full P0–P4 chain present via `rem:o1i8_decomposition`; P1a gap is documented |
| P5a vanishing inputs | Coverage present for R^if_* resolution form, Hⁿ-bridge, augmented-Čech acyclicity |
| P5b comparison assembly | `lem:cech_computes_cohomology` present as top-level target |

No new blueprint prose is needed for any active phase.

---

## Structural health summary

- **blueprint-doctor**: CLEAN (0 malformed_refs, 0 broken_refs, 0 axiom_decls, 0 covers_problems, 0 orphan_chapters)
- **leandag unknown_uses**: `[]` — no broken `\uses{}` edges
- **leandag gaps**: 2 (F1, F2 — FreePresheafComplex, soon-severity, not blocking active lanes)
- **leandag isolated**: 1 (lean_aux, keep)
- **Total blueprint nodes**: 128

---

*Generated by blueprint-reviewer subagent, iter-034.*
