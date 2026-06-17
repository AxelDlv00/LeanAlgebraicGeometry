# Blueprint Writer Directive

## Slug
mv-iter110

## Target chapter
blueprint/src/chapters/Cohomology_MayerVietoris.tex

## Strategy context
Blueprint-reviewer-iter110 flagged `Cohomology_MayerVietoris.tex` as `complete: partial` AND `correct: partial` (also flagged by blueprint-reviewer-iter109 as MINOR, deferred from iter-109). Two specific issues:

1. **L1198 stale 3-tuple Mathlib-gap-list**: the prose enumerates the project's named Mathlib gaps as the 3-tuple `(instIsMonoidal_W, h_exact, nonempty_jacobianWitness)`. Post-iter-109 the named-gap surface is **6 + 1 budget-deferral**: (1) `instIsMonoidal_W`, (2) `h_exact`, (3) `nonempty_jacobianWitness`, (4) `PicardFunctor.representable`, (5) `SheafOfModules.pullback_tensorObj`, (6) `SheafOfModules.pullback_oneIso`, plus the 1 budget-deferral `BasicOpenCech.lean:1846` `h_loc_exact`. The remark's enumeration is the load-bearing project-wide gap list; readers will trust the count.

2. **L1196 substep numbering inconsistency vs L1167-1176**: the L1167-1176 substep enumeration introduces substeps (i)=Image-Finset bridge, (ii)=Restriction-of-section, (iii)=Per-coord `IsLocalization.Away`, (iv)=Finite-product localization lift. L1196 then attributes "(i) and (ii)" to "the inclusion `V_x ⊆ U` and the restriction-of-section identity" and "(iii)" to "the image-Finset bridge and the per-coord `IsLocalization.Away` certificate". This shifts the substep labels by one slot. Cosmetic but a real source of reader confusion.

## Required content

Fix the two specific issues identified by blueprint-reviewer-iter110. These are precision edits, not content restructuring.

### 1. L1198 stale gap-list

Update the 3-tuple Mathlib-gap-list enumeration to the post-iter-109 6+1 surface. Frame it as a list of named-deferred sorries that the autonomous loop currently does NOT attempt to close (per the project's exit policies):

- `instIsMonoidal_W` (varying-ring `stalk_tensorObj` gap; `Modules/Monoidal.lean:173`).
- `cotangentExactSeq_structure.h_exact` (sheaf-of-modules exactness criterion; `Differentials.lean:636`).
- `nonempty_jacobianWitness` (Hilbert/Quot schemes + finite-group quotients; `Jacobian.lean:179`).
- `PicardFunctor.representable` (gated on Phase C3; `Picard/Functor.lean:181`).
- `SheafOfModules.pullback_tensorObj` (`μ`-iso of missing `Monoidal` instance; `Picard/LineBundle.lean:82`).
- `SheafOfModules.pullback_oneIso` (`ε`-iso of same; `Picard/LineBundle.lean:96`).
- Plus 1 budget-deferral: `BasicOpenCech.lean:1846` `h_loc_exact` (NOT a Mathlib gap; mechanizable from Mathlib's `IsLocalizedModule.{Away,pi,prodMap}`).

Keep the count current. Do NOT enumerate this in the body of every theorem; just refresh the one place (L1198 area) where the 3-tuple appears.

### 2. L1196 substep numbering

Re-read L1167-1176 to find the substep introduction. Then re-read L1196 (and any nearby attribution lines) to find the off-by-one. Pick ONE of the two reconciliation actions:

- (a) Renumber L1167-1176 to match L1196's attribution.
- (b) Renumber L1196's attribution to match L1167-1176.

Strong preference: (b) (don't change the introduction; fix the attribution). The substep introduction (L1167-1176) is the source of truth; downstream references should follow it.

Also: consider whether `IsLocalizedModule.prodMap` should be mentioned in the L1176 substep enumeration (it appears in the actual iter-109 mechanization plan + is named in the strategy as a Mathlib-API piece). Add a one-sentence mention of `prodMap` in passing if it fits naturally; otherwise this is informational-only.

## Out of scope

- The substantive content of the Mayer-Vietoris LES + Čech acyclicity machinery is final; do NOT touch the substantive theorem blocks, the consumer chain, or the off-limits `BasicOpenCech.lean` sub-routes (L1120 PAUSED, L1212/L1536/L1564 deferred, L1846 budget-deferred).
- `Remark rem:basicOpenCover_step2_status` is correctly disclosed; do NOT touch.
- Other chapters: do NOT touch.

## References
- The current `STRATEGY.md` end-state (post-iter-110 updates also landing this iter) is the source of truth for the 6+1 gap surface.

## Expected outcome

A targeted ~2-edit chapter refresh. Chapter goes from `complete: partial` × `correct: partial` to `complete: true` × `correct: true` per blueprint-reviewer-iter110 must-fix.
