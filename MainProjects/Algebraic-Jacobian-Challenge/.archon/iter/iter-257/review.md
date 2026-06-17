# Iter-257 (Archon canonical) — review

## Outcome at a glance

- **The "engine lane crashes 5 → 1 (four bodies axiom-clean) and reveals its sole blocker is the SAME
  over↔restrict wall as the dual lane; both substrate lanes (D3′, dual Step-4) make real structural
  progress but neither closes its target, and both expose that their blueprint sketches are wrong /
  under-specified at the genuine hard step" iter.** Three prover lanes, all `opus`, mode `prove`.
  - **Lane engine** (`Picard/LineBundleCoherence.lean`): **5 → 1**. Closed axiom-clean:
    `exists_trivializing_cover`, `chart_free_rank_one`, + reusable §1b bricks
    `freeUnitIso`/`unitGenerators`/`unitPresentation`. `chartPresentation`/`isFinitePresentation`/
    `isFiniteType` complete-modulo the single iso `chartOverIso` (`#print axioms` shows `sorryAx` only
    via it). The planner's `Presentation.ofIsIso e.hom` recipe was type-incorrect (slice-site vs
    open-subscheme category mismatch); the prover rebuilt the chart presentation through an explicit
    bridge so the engine factors through one iso. **Genuine frontier win.**
  - **Lane TS-cmp** (`Picard/TensorObjSubstrate.lean`, D3′ `pullbackTensorMap_restrict`): **2 → 2**,
    PARTIAL. Closed `toRingCatSheafHom_comp_hom_reconcile` (`rfl`, axiom-clean) and found the Sq2
    ring-map reconcile is DEFINITIONAL (disproving the blueprint's "non-trivial transport" prose). Did
    NOT meet the pc257 bar — the genuine Sq2 (Sq2b = `pullbackComp` monoidality) is Mathlib-absent with
    three documented frictions. Prover correctly removed non-elaborating helpers, kept file green, left a
    typed sorry + ROADMAP.
  - **Lane TS-inv** (`Picard/TensorObjSubstrate/DualInverse.lean`, `dual_restrict_iso` Step-4):
    **1 → 2** (decomposed). New signature-verified helper `sliceDualTransport` (body sorry) + wired
    Step-4 assembly. Not closed: magnitude (~200 LOC) + a decisive cross-lane compilation race.
- **Builds:** all three files green (prover-verified `lake build` exit 0).
- **Canonical critical-path counter:** the ⊗-inverse `exists_tensorObj_inverse` is still open; but the
  **A.2.c engine deliverable** (`isFinitePresentation`) is now one iso from done — a real frontier
  down-move (4 declaration-sorries eliminated).
- **`sync_leanok`** sha `a60632e1`, **+1 / −0** (`Picard_RelPicFunctor.tex`) — and that +1 IS the
  recurring `\uses{}`-corruption (see Structural).

## The defining finding — the engine and the dual lane are the same wall

iter-256 opened the engine lane; iter-257 takes it from a 5-sorry skeleton to a single isolated
isomorphism, with four bodies closed axiom-clean. But the most consequential output is not the count: it
is that the engine's sole remaining sorry (`chartOverIso : M.over U ≅ unit (X.ringCatSheaf.over U)`) is
**the same Mathlib-scale construction** as the dual lane's open chain (`sliceDualTransport` →
`dual_restrict_iso` → `exists_tensorObj_inverse`). Both are the modules-level lift of
`Opens.overEquivalence` (`SheafOfModules.overEquivalence`) — the slice-site ↔ open-subscheme-site
equivalence with a varying ring. The two highest-priority open obligations on the Picard critical path
now share one root build (~200–350 LOC, own file; `informal/chartOverIso.md`). This is the single
clearest planning signal of the iter: **build `SheafOfModules.overEquivalence` once, unblock both** —
after a mathlib-analogist pass reconciles the routes (the dual prover currently builds `sliceDualTransport`
sectionwise, not via the equivalence).

## The honest counterweight — two CONVERGING lanes that did not converge

pc257 read both substrate lanes CONVERGING. The iter's evidence pushes back on that:

1. **D3′ "converged" on a triviality.** The only thing TS-cmp closed (`toRingCatSheafHom_comp_hom_reconcile`)
   turned out to be `rfl` — the blueprint had mislabelled a definitional fact as "non-trivial transport".
   The genuine content (Sq2b, `pullbackComp` monoidality) is now exposed as Mathlib-absent, mirroring
   `Adjunction.isMonoidal_comp` by mate calculus, with three statement-level frictions that block even
   *stating* it. That is closer to STUCK-risk than CONVERGING, and the next progress-critic should be told.
   The correct next move is a cross-domain analogist consult BEFORE any prover round — the pattern that
   paid off twice (whisker252, mapin255, dualstep4-257).
2. **Dual Step-4 was throttled by a process error, not just magnitude.** The prover's non-close is partly
   the genuine ~200-LOC build, but it explicitly cites the cross-lane compilation race as decisive:
   `DualInverse.lean` imports `TensorObjSubstrate.lean`, which the concurrent TS-cmp prover broke for most
   of the session, so the LSP returned empty goals. This is a dispatch-design bug — do not co-schedule a
   prover on a file and a prover on its importer.

Neither lane closed its assigned target, and all three prover-touched chapters now carry must-fix
blueprint findings (below). The forward motion is real (engine 4-close; both substrate lanes have
verified structural floors), but the next iter cannot simply re-dispatch.

## Subagent verdicts (this review)

- **lean-auditor `aud257`:** files honest — all sorries correctly typed, no vacuous bodies, no
  excuse-comments. 5 MAJOR **stale comments** (file headers undercount sorries; a stale ROADMAP
  "ITER-257 FINDINGS" describing already-done `rfl` work; a stale comment inside the *closed*
  `homOfLocalCompat` at L639; a borderline-excuse "concurrently-broken dependency" note). All prover-fixable.
- **lvb-lbc257 / lvb-tos257 / lvb-dual257:** all three return **must-fix BLUEPRINT** findings —
  `Picard_LineBundleCoherence.tex` elides the `chartOverIso` bridge; `Picard_TensorObjSubstrate.tex` Sq2
  prose is false + Sq2b absent (D3′) and the dual Step-4 assembly is stale. The TensorObjSubstrate chapter
  `% archon:covers` both substrate files, so one writer pass fixes the gate for both lanes.

## Markers / structural (details in summary.md)

- Added two `% NOTE:` annotations (review domain) flagging the disproven/under-specified sketches in
  `Picard_LineBundleCoherence.tex` (chartOverIso bridge) and `Picard_TensorObjSubstrate.tex` (Sq2 false /
  Sq2b absent). No `\mathlibok`, no `\lean{}` renames, no stale `\notready`.
- blueprint-doctor: `Cohomology_CechHigherDirectImage.tex` (new) covers a non-existent `.lean` + 5 broken
  `\ref`; `Picard_RelPicFunctor.tex:144-146` `\uses{}`-corruption re-introduced by `sync_leanok` itself.

## Subagent skips

(none — all review-phase recommended subagents dispatched: lean-auditor + per-file lean-vs-blueprint
for all 3 prover-touched files.)
