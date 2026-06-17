# Iter-031 plan — Lane A re-param LANDED (CONVERGING); drive CechBridge family form + open 01I8 Route-P (P0/P1)

## Entering state (verified)
iter-030's two mathlib-build lanes processed:
- **Lane A `FreePresheafComplex.lean` COMPLETE (+50 `…Fam` decls).** The entire free Čech resolution chain
  re-parameterized from `(𝒰 : X.OpenCover)[Finite 𝒰.I₀]` to a raw finite family `{ι}[Finite ι](U : ι → Opens X)`
  with NO covering hypothesis, up to and including `cechFreeComplex_quasiIsoFam`. All axiom-clean. The prover
  REJECTED the wrapper-delegation suggestion (would break `CechBridge:251 dsimp only [cechFreeSimplicial]`) and
  ADDED a parallel `section FamilyParameterized`, keeping the X.OpenCover decls byte-identical → CechBridge +
  PresheafCech stay green & untouched. The design fork (⊤-vs-`D(f)`) is now dissolved on the free side.
- **Lane B `QcohTildeSections.lean` PARTIAL (+3).** 01I8 steps (2)–(3) formalised
  (`isIso_fromTildeΓ_of_genSections`, `qcoh_iso_tilde_sections_of_genSections`, `free_isQuasicoherent`),
  reducing the residual to step (1) affine global generation. Prover correctly declined to relabel the gap.

Project sorry = 2 (both frozen/superseded: `CechHigherDirectImage:672` frozen target, `CechAcyclic:75` dead).
Build green. unmatched started at 54 (50 Fam + 3 QcohTilde + dead node).

## What I did this iter (plan phase)
1. Processed both lanes (task_done += the 53 decls; task_pending header refreshed; PROGRESS rewritten).
2. **progress-critic `iter031`** — Route A **CONVERGING** (family `injective_cech_acyclic` is a bounded mirror
   of an existing axiom-clean proof, upstream now supplied); Route B **UNCLEAR** (2 of K=4 iters, structural
   narrowing genuine) but at the edge of CHURNING. Contingency named: if Route B PARTIALs on P1 again, run a
   Mathlib-analogy consult before the next QcohTilde prover.
3. **mathlib-analogist `o1i8route` (pre-empting the contingency this iter):** no Mathlib shortcut exists for
   `[IsQuasicoherent F]→IsIso F.fromTildeΓ`. **Route P (global generation)** selected; **Route G (module
   gluing) REJECTED** (no `Module.GlueData`; FF descent a Mathlib TODO). First lane = pure-topology
   `exists_finite_basicOpen_subcover`. Persisted `analogies/o1i8-qcoh-tilde-route.md`.
4. **STRATEGY.md** — refined the 01I8 open-question bullet + Mathlib-gaps bullet to the Route-P P0–P4
   decomposition + Route-G rejection; bumped 02KG iters-left ~4→~5–6 (strategy-critic note: estimate
   under-counted the full P0–P4 + `tilde_preserves_kernels` chain). Route A core untouched.
5. **blueprint-writer `iter031`** (consolidated chapter): JOB 1 cleared coverage debt (50 Fam + 3 QcohTilde
   bundled into existing `\lean{}` lists, **unmatched 54→1**); JOB 2 added CechBridge family pins
   (`injective_cech_acyclicFam`, `sectionCechComplexMapOpIsoFam`); JOB 3 expanded `rem:o1i8_decomposition`
   into the Route-P `\uses`-chain P0–P4 + sub-gap `tilde_preserves_kernels` + 3 QcohTilde blocks. (The
   subagent finished its edits + self-verified but its wrapper was interrupted before writing the report;
   edits persisted to disk and were independently confirmed: unmatched=1, all 11 new names present.)
6. **blueprint-clean `iter031`** — all 12 new-block source quotes verbatim-confirmed against
   `references/stacks-schemes.tex`; all `\uses{}` resolve.
7. **strategy-critic `iter031`: SOUND** — Route-P decomposition non-circular (P1 `qcoh_localized_sections` is
   a low-level H⁰/localization fact independent of the cohomology machinery it serves → no regress);
   Route-G rejection verified correct (`Module.GlueData` absent); `tilde_preserves_kernels` honestly
   self-flagged. Two non-blocking format notes (iter-narrative phrase; under-counted estimate) — both fixed
   in STRATEGY.md this phase.
8. **blueprint-reviewer `iter031`: HARD GATE CLEARS** — both chapters complete+correct, all FOUR prover
   targets FORMALIZE-READY (`injective_cech_acyclicFam`, `sectionCechComplexMapOpIsoFam`, P0
   `exists_finite_basicOpen_subcover`, P1 `qcoh_localized_sections`). One informational note: P1's
   IsLocalizedModule-from-gluing step names no Lean API — flagged to the prover.
9. Wrote PROGRESS.md (TWO parallel lanes, scaffold keywords on both zero-sorry path lines), task ledgers,
   this sidecar, objectives.md.

## Decision made

### D1 — Two parallel mathlib-build lanes: CechBridge family form (Route A) + QcohTilde Route-P P0/P1 (Route B).
**Chosen.** Route A's CechBridge family `injective_cech_acyclic` is the natural CONVERGING next deliverable
(progress-critic) — a bounded mirror of an existing axiom-clean proof now that `cechFreeComplex_quasiIsoFam`
is supplied. Route B opens the Route-P chain at its provable leaf P0 (pure topology, axiom-clean-able) and
attempts the load-bearing P1. The files are independent (neither imports the other; both 0-sorry → scaffold
keyword on each path line). **Why both this iter (not serialize):** they share no file and no race; the
user's standing parallelism directive favors splitting; and Route B's P0 is genuinely ready (analogist gave
exact Mathlib handles), so there is no reason to idle it behind Route A.

**Reversal signal:** if CechBridge's family mirror hits real defeq-carrier friction (the documented P3b
hazard) it hands off cleanly (mathlib-build, no sorry) and a follow-up lane finishes it. If QcohTilde P1
PARTIALs (likely, ~few-hundred LOC), that is acceptable progress provided P0 lands green + P1's local-triv
scaffold compiles — but a 3rd consecutive QcohTilde PARTIAL with no new sub-structure is the iter-032
CHURNING trigger, at which point the corrective is a fine-grained / effort-breaker split of P1 (the
mathlib-analogy consult already ran), NOT another mathlib-build round on the same recipe.

### D2 — Pre-empt the progress-critic's Route-B contingency NOW rather than wait for a 3rd PARTIAL.
The critic said "run a Mathlib-analogy consult IF iter-031 PARTIALs." I ran it this iter instead, so the
prover enters P0/P1 with the route already vetted (Route P, P0–P4 decomposition, exact Mathlib handles).
This converts a would-be reactive iter-032 consult into proactive blueprint structure, and means a P1
PARTIAL next iter escalates straight to a decomposition split rather than spending iter-032 on the consult.

## Subagent skips
- lean-auditor / lean-vs-blueprint-checker: review-phase subagents, not dispatched in the plan phase.
- strategy-auditor / dag-walker / effort-breaker / refactor / lean-scaffolder / reference-retriever: no
  trigger this iter (strategy SOUND via critic; blueprint complete via reviewer; no scaffold-hint injection
  needed beyond PROGRESS recipes; all sources already local).

## Prior critique status
- iter-030 strategy-critic SOUND (no live challenge) — carried; this iter's strategy edit (Route-P
  refinement) re-validated SOUND by strategy-critic `iter031` with two format notes, both addressed.
