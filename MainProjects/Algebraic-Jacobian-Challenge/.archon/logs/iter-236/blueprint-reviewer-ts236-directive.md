# blueprint-reviewer — iter-236 whole-blueprint audit

Audit the WHOLE blueprint (`blueprint/src/chapters/*.tex`). Produce your standard
per-chapter checklist (complete? correct? Lean targets well-formulated? proofs detailed
enough to formalize? multi-route coverage?) plus the `## Unstarted-phase blueprint
proposals` section for any strategy phase with no blueprint coverage.

Context for the HARD GATE (which chapters feed live prover lanes THIS iter):
- `Picard_TensorObjSubstrate.tex` — backs `Picard/TensorObjSubstrate/StalkTensor.lean`
  (the d.2 stalk-tensor critical path). The active prover work this iter is stage (iv)
  balancing `revBihom_balanced` → `stalkTensorRev` → stage (v) `stalkTensorIso`
  (`lem:stalk_tensor_commutation`). Check whether §`sec:tensorobj_stalk_tensor` is
  detailed enough to guide the balancing sub-step (the prover hit a CommRingCat/RingCat
  + `restrictScalars` carrier-duality wall on `revBihom_balanced`; the recommended route
  is to prove balancing at the STALK level via `germ_smul`).
- `Cohomology_FlatBaseChange.tex` — backs `Cohomology/FlatBaseChange.lean`. It was
  reframed iter-235 around tilde full-faithfulness + the single brick
  `lem:pushforward_spec_tilde_iso`. Check the reframe is coherent and the brick block is
  adequate to formalize.

Both chapters are otherwise gating this iter's two prover lanes — flag any
must-fix-this-iter issue on either. Held/paused chapters (RR.*, Rigidity, Genus0, QuotScheme,
FlatteningStratification, AlbaneseUP, HigherDirectImage, CMRegularity, SemiContinuity)
are NOT under active prover work this iter — report their status for completeness but they
do not gate this iter.
