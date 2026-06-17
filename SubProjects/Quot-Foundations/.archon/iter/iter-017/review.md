# Iter 017 — Review (Quot-Foundations)

## Verdict

Build GREEN (`lake build` of all 3 modified modules → EXIT 0, re-verified this review; only expected
`sorry` warnings; blueprint-doctor clean; 0 ∞-holes). **3-lane prover dispatch (FBC fine-grained, GF
prove, QUOT mathlib-build); all three delivered real axiom-clean content.** Net **−1 active sorry**
(GF L5 closed) and **+18 new axiom-clean declarations**, all re-verified `{propext, Classical.choice,
Quot.sound}`. **Two multi-iter walls broke this iter** via the exact correctives the planner staged:
the FBC Seam-2 "motive is not type correct" wall (CHURNING, iters 014–016) through the subst-able-legs
restructure, and the GF L5 OreLocalization instance-presentation diamond (critical-watch, iters
015–016) through dropping the redundant canonical existential at the producer. Every `sorry` is honest
scaffolding.

## Overall progress this iter (active sorry per file)

- **FBC 4→4** — Seam-2 structural wall DISSOLVED. Concrete `base_change_mate_fstar_reindex` now
  `sorry`-free (reduces to `…_legs`); 4 new axiom-clean sub-lemmas (`base_change_mate_codomain_read_legs`
  + 3 `gammaMap_pushforward*` Γ-collapses). The Seam-2 content `sorry` MOVED + shrank into
  `base_change_mate_fstar_reindex_legs` (step-iii mate-unwinding only — isolated to one concrete affine
  goal, no longer a motive wall). Seam 3 / affine / FBC-B untouched (gated on Seam 2).
- **FlatteningStratification 4→3** (**−1**) — GF L5 `exists_free_localizationAway_polynomial` CLOSED
  axiom-clean; `gf_torsion_reindex` signature simplified (dropped the redundant canonical existential),
  re-verified axiom-clean. L4 / genericFlatnessAlgebraic / genericFlatness(GF-geo) remain (expected).
- **QuotScheme 4→4** (+13 axiom-clean decls, additive) — Route-2 first dispatch. Keystone D6
  `subquotient_degreewise_diff` + `subquotientHilb` (both pinned) + 11 ambient-homogeneity-calculus aux
  decls. No isDefEq/whnf pathology fired (validates Route-2). The 4 pre-existing protected stubs
  unchanged.
- **GrassmannianCells / RegroupHelper 0/0** — DONE, untouched.

## What shaped iter-018 (live frontiers)

1. **FBC Seam 2 is one prove-pass from closed.** `base_change_mate_fstar_reindex_legs` step-iii is a
   freshly-isolated, dispatchable goal (NOT churning). Needs a thin writer round to pin the 5 new FBC
   decls first (HARD GATE), then a `prove` pass. Closing it cascades to Seam 3 → section_identity →
   cancelBaseChange.
2. **GF critical path moved to L4** `exists_localizationAway_finite_mvPolynomial` (L5 closed). Effort-break
   into the two scouted sub-pieces (algebraic-independence descent + module-finiteness Finset-fold) before
   a prover.
3. **QUOT next lane = the finiteness encoding** (`subquotient_hilbertSeries_rational` P(r) +
   `subquotient_finite_transfer`). D6 + the ambient calculus are ready inputs. Large self-contained build
   — own dedicated lane; the subalgebra-only finiteness route is RULED OUT (use the polynomial ring +
   `eval(t_{r-1}=0)`).
4. **Coverage debt: 16 new `lean_aux` nodes** (all this iter; ALL proved axiom-clean) need blueprint
   blocks — 4 FBC Seam-2 sub-lemmas + 11 QUOT ambient-calculus + (one private, no pin). Listed in
   `session_17/recommendations.md`. The planner should fold these into the FBC pin-adding writer round
   (#1) and a new QUOT "Ambient homogeneity calculus" subsubsection.

## Anomalies / debt surfaced (not blocking)

- **Stale FBC signature comment corrected (this review):** `Picard_FlatteningStratification.tex`
  `lem:gf_torsion_reindex` INTENDED LEAN SIGNATURE comment listed the now-removed redundant `Module
  A_g T_g` binder — replaced with a `% NOTE:` recording the iter-017 drop, matching the landed decl.
- **`set_option maxHeartbeats 1600000` bumps** in the FBC Seam-2 work (the `exact`-onto-`…_legs`
  change-of-rings dictionary unfoldings) — honest (certify a proof-irrelevant defeq, not a loop);
  lean-auditor to confirm.
- **`lake env lean <file>` emits SPURIOUS instance-diamond errors** (omits lakefile `[leanOptions]`)
  that appear identically in the pre-edit baseline — `lake build <module>` is authoritative and the LSP
  agrees with it. Captured in user memory; reconfirmed this iter.
- **Long-line linter warnings** (FlatBaseChange.lean ~1450/1475/1489/1491) — cosmetic, prover-cleanup.
- **Pervasive predecessor-project iter/STATUS markers** in FBC/RelativeSpec/QuotScheme — provenance
  noise, prover-cleanup (tracked since iter-011).

## Review subagents dispatched (4)

- **lean-auditor `iter017`** — whole-project audit (no strategy bias).
- **lean-vs-blueprint-checker `fbc` / `gf` / `quot`** — one per prover-touched file.

Findings landed in `session_17/recommendations.md` (CRITICAL/HIGH at top). Reports under
`.archon/task_results/`, archived to `logs/iter-017/`. _(Verdicts summarised once all four return.)_

## Blueprint markers updated (manual)

- `Picard_FlatteningStratification.tex`, `lem:gf_torsion_reindex`: corrected the INTENDED LEAN
  SIGNATURE comment (dropped the removed binder, added a `% NOTE:`).
- No `\mathlibok` (all new decls are project lemmas), no `\lean{...}` renames, no stale `\notready`.
  `\leanok` on closed proof blocks owned by `sync_leanok` (iter 17, sha ac7b842, +3/−0).
