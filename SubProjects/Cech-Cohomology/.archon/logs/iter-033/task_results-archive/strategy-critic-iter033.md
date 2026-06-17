# Strategy Critic Report

## Slug
iter033

## Iteration
033

## Routes audited

### Route A — acyclic-resolution comparison (CHOSEN)

- **Verdict**: SOUND

### Route B — two spectral sequences (REJECTED)

- **Verdict**: SOUND (correctly excised to prose; not occupying a live route slot)

### The acyclicity bridge (torsor-free)

- **Goal-alignment**: PASS — bridge lifts P3 standard-cover Čech vanishing to affine sheaf vanishing without ever invoking affine vanishing; the non-circular ordering is explicit.
- **Mathematical soundness**: PASS — (1) `injective_cech_acyclic` + (2) `ses_cech_h1` + (3) dimension-shift `cech_eq_cohomology_of_basis` is the standard 01EO chain; bricks (1)(2) done, 01EO landed (per Completed table).
- **Verdict**: SOUND

### Absolute cohomology realization — Form B (Ext of corepresenting object)

- **Verdict**: SOUND

## 02KG re-estimate audit (the iter's only delta)

The delta — re-scoping `toSheaf` epi-preservation from "small project-local instance" to a
multi-lemma right-exactness (`PreservesFiniteColimits`) build — checks out and is an HONEST
UPWARD revision (the opposite of the dishonest-under-count failure mode):

- **Mathlib corroboration**: `SheafOfModules.toSheaf` exists with
  `instPreservesFiniteLimitsSheafAddCommGrpCatToSheaf` (finite *limits*) shipped, but there is
  **no** finite-colimits / epi-preservation instance for `toSheaf`. The colimit side exists only
  one layer down (`PresheafOfModules.Finite.toPresheaf_preservesFiniteColimits`) plus the bridge
  iso `toSheafCompSheafToPresheafIso : toSheaf ⋙ sheafToPresheaf ≅ forget ⋙ toPresheaf`. So
  deriving `toSheaf` epi-preservation genuinely requires assembling presheaf-level right-exactness
  through the sheafification bridge — a real multi-lemma build, not a one-liner. The re-estimate is
  accurate.

- **Circularity check (the directive's first question): NONE.** `toSheaf` right-exactness is a
  structural fact about the forgetful functor `SheafOfModules R ⥤ Sheaf J AddCommGrp`, provable
  from general abelian-category / sheafification infrastructure. Its proof touches no cohomology,
  no Čech complex, no affine Serre vanishing, and no `~`-construction. There is therefore zero
  feedback loop: 02KG consumes `toSheaf`-epi to run `surj_of_vanishing` via
  `Presheaf.IsLocallySurjective`, but the `toSheaf`-epi proof does not consume anything downstream
  of 02KG. The dependency is strictly one-directional and acyclic.

- **Two-front structure (the directive's second question): HOLDS.** The two fronts are genuinely
  independent and both genuinely required:
  - 02KG cover-system delivers affine vanishing for `~`-sheaves (standard-cover Čech vanishing
    lifted through `BasisCovSystem`).
  - 01I8 Route-P global generation delivers `F ≅ ~(ΓF)`, the transfer that carries vanishing from
    `~`-sheaves to *all* quasi-coherent `F`.
  Neither front subsumes the other; the top qcoh theorem's gating on BOTH (STRATEGY lines 17–18,
  the `surj_of_vanishing` and unconditional-`qcoh_iso_tilde_sections` notes) is the correct
  conjunction, not a redundancy. The `toSheaf` re-scope enlarges one leaf of Front 1 only; it does
  not perturb Front 2 or the conjunction.

## Format compliance

- **Size**: 112 lines / ~7 KB — within budget.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Completed`, `## Routes`,
  `## Open strategic questions`, `## Mathlib gaps & new material`, in canonical order.
- **Per-iter narrative detected**: no.
- **Accumulation detected**: no — Completed table is 6 rows, active table holds only unfinished
  phases, Route B is prose-only.
- **Table discipline**: PASS.
- **Format verdict**: COMPLIANT

## Effort honesty (advisory, not a CHALLENGE)

The STRATEGY.md I read still describes the `toSheaf` gate as a "small project-local instance"
(line 98) and "small project-local instance unlocking `Presheaf.IsLocallySurjective`" wording
(lines 75, 97–98), with the 02KG row at `Iters left ~2–3`. The directive states this row is being
adjusted to reflect the `PreservesFiniteColimits` multi-lemma build. To keep the estimate honest,
the in-file wording ("small … instance") and the `~2–3` iters / `~200–350` LOC cells should be
brought into line with the re-scope (a right-exactness build is plausibly the larger share of the
02KG residual). This is a bookkeeping fix the planner has already declared in flight, not a
strategic flaw — flagged only so the file does not retain the stale "small instance" framing.

## Overall verdict

The strategy remains SOUND. The sole delta — re-scoping `toSheaf` epi-preservation to a
`SheafOfModules.toSheaf` finite-colimits/right-exactness build — is corroborated by Mathlib (the
finite-limits instance ships but the colimit/epi side must be built from the presheaf-level
finite-colimit preservation through the sheafification bridge) and is an honest upward revision.
There is no circularity risk: `toSheaf` right-exactness is cohomology-independent structural
infrastructure, so 02KG's dependence on it is strictly one-directional. The two-front structure
(02KG cover-system delivering `~`-sheaf affine vanishing vs 01I8 global generation delivering
`F ≅ ~(ΓF)`, both feeding the top qcoh theorem) holds up — the fronts are independent and both
required, and the re-scope touches only one leaf of the 02KG front. Proceed. The one advisory: the
in-file "small project-local instance" wording and the 02KG iters/LOC cells should be updated to
match the re-estimate so the document does not retain a now-stale effort framing.
