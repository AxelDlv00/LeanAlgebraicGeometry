# Blueprint-reviewer directive — iter-145

## Iteration

145

## Scope

Whole-blueprint audit (per dispatcher_notes: always whole blueprint, no scope limiting).

## Context — minimal

The blueprint lives at `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/*.tex`. There are 11 chapters; an enumeration is given by:

```
AbelJacobi.tex                                  (89 LOC)
AlgebraicJacobian_Cotangent_GrpObj.tex          (129 LOC; pointer chapter for Cotangent/GrpObj.lean)
Cohomology_MayerVietoris.tex                    (947 LOC)
Cohomology_SheafCompose.tex                     (40 LOC)
Cohomology_StructureSheafAb.tex                 (78 LOC)
Cohomology_StructureSheafModuleK.tex            (655 LOC)
Differentials.tex                               (209 LOC)
Genus.tex                                       (69 LOC)
Jacobian.tex                                    (452 LOC)
Rigidity.tex                                    (71 LOC)
RigidityKbar.tex                                (1790 LOC)
```

## Specific items to confirm or surface

1. **`RigidityKbar.tex` post-iter-144-writer state**: the `blueprint-writer-rigiditykbar-iter144` dispatch landed 5 edits including (a) a NEW first-class `\begin{lemma}` block at L1628 (`lem:GrpObj_basechange_along_proj_two_inv_app_isIso`), (b) a `\paragraph{Iter-144 chart-algebra pivot --- disposition}` at L88, (c) a `\paragraph{Iter-144 chart-algebra envelope for piece (ii)}` at L99, (d) a Rule-4 iter-143 empirical block at L852, (e) a Step-3 status refresh. Confirm: are these landed correctly? Does the chart-algebra envelope for piece (ii) at L99–L114 provide enough mathematical detail for an iter-146+ prover to scaffold the chart-algebra (α) `Algebra.IsPushout`-from-affine-product + (β) per-chart translation-invariance helpers? If not, surface MUST-FIX with concrete missing items.

2. **`Jacobian.tex` post-iter-144-writer state**: 4 edits landed (Route A reframing as COMMITTED per iter-144 user-hint; Route B reframing as historical alternative not pursued; iter-135 paragraph status refresh; preamble refresh). Iter-144 review surfaced two cleanup-residual items: L370–377 Mathlib-summary parallel-route framing (was it cleared?), L425 theorem-statement wording. Confirm.

3. **`AlgebraicJacobian_Cotangent_GrpObj.tex` (pointer chapter) post-iter-144-writer state**: 5 edits landed (3x declaration-status refresh, ADD iter-143 IsIso `\item` to `\itemize`, intro chart-algebra disposition NOTE). The iter-144 review also flagged: pointer chapter uses `\fst{...}` / `\snd{...}` macros undefined in `blueprint/src/macros/common.tex` — confirm whether this is now broken or whether the rest of the chapter convention also uses undefined macros (so it's consistent if a bit cosmetically loose).

4. **Iter-145+ chart-algebra piece (ii) sub-piece coverage**: the iter-144 STRATEGY.md commits iter-146+ piece (ii) PIN-path-(b) prover lane to ~600–1050 LOC across 5 sub-pieces:
   - chart-algebra (α) `Algebra.IsPushout`-from-affine-product helper (~80–150 LOC)
   - chart-algebra (β) per-chart translation-invariance Kähler-derivation (~150–300 LOC)
   - algebra-level core `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` (~200–350 LOC)
   - integrally-closed-constants helper (~50–100 LOC)
   - scheme-level lift via `Scheme.Over.ext_of_eqOnOpen` (~100–150 LOC)
   Does `RigidityKbar.tex` § "Piece (ii) chart-algebra envelope" decompose far enough for the iter-146+ prover? If not, list which sub-pieces need `\begin{lemma}` / `\begin{theorem}` first-class blocks with `\lean{...}` hints BEFORE iter-146+ prover lane fires — that is a HARD-GATE-FIRES situation analogous to iter-144's RigidityKbar.tex / Jacobian.tex / pointer chapter must-fixes.

5. **Sync_leanok mis-mark carry-overs**: iter-144 review listed `sync_leanok` mis-mark at `RigidityKbar.tex:406, 524, 1152`. Post-iter-144 writer edits these line numbers may have shifted. Surface the current canonical line numbers if the mis-marks are still present, so the next deterministic `sync_leanok` phase resolves them.

6. **Stale `\notready` markers**: scan all chapters for `\notready` that should now be `\leanok` or removed (the deterministic phase only adds/removes `\leanok`; `\notready` is review-agent semantic territory but the reviewer should flag stale entries).

7. **Cross-chapter `\uses{...}` / `\ref{...}` integrity**: confirm no broken references introduced by the iter-144 writer edits.

## Output expectations

Per dispatcher_notes blueprint-reviewer descriptor: emit per-chapter checklist (complete: true/false, correct: true/false), list of must-fix-this-iter findings, list of soon items, and list of informational items. Report goes to `task_results/blueprint-reviewer-iter145.md` (the wrapper handles this).

## HARD GATE rule for the planner

For each Lean file F the planner is considering for iter-146+ `## Current Objectives`, the corresponding chapter must be complete + correct + no must-fix touching it. If any chapter fails the gate, planner DROPS F and dispatches a follow-up blueprint-writer for the failing chapter THIS iter.

## What NOT to do

- Do NOT add or remove any `\leanok` marker (deterministic sync_leanok phase owns those).
- Do NOT instruct the planner to ship `\mathlibok` (review-agent territory).
- Do NOT recommend strategy changes outside blueprint adequacy.
