# Blueprint-reviewer directive — slug `ts242-regate` (same-iter fast-path re-gate)

Whole-blueprint audit (per your standing scope — you always read the entire blueprint and emit the
per-chapter completeness+correctness checklist). This is a same-iter fast-path re-gate after a
blueprint-writer + blueprint-clean round.

**Two chapters were rewritten THIS iter and feed the two live prover lanes** — confirm each is
`complete: true` AND `correct: true` with no must-fix-this-iter finding, so the HARD GATE clears for
prover dispatch:

1. `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` — the §`sec:tensorobj_pullback_monoidality`
   section was rewritten. Check specifically:
   - `lem:pullback_unit_iso`: the proof is now the one-line representable-flatness argument
     (`final_of_representablyFlat` ⇒ `(Opens.map f.base).Final` unconditionally ⇒
     `instIsIsoPullbackObjUnitToUnitOfFinal`); the old false "Final need not hold globally" chart-chase
     and the stale `\uses{lem:pullbackObjUnitToUnit_comp, lem:unitToPushforwardObjUnit_comp}` were removed.
     Confirm the proof is well-formed and the statement pin `\lean{...pullbackUnitIso}` matches.
   - `lem:pullback_tensor_iso`: the proof was rewritten to the concrete-strong-monoidal-pullback route —
     build `P = sheafify∘(sectionwise extendScalars)` (tensorator `distribBaseChange` + `sheafifyTensorUnitIso`),
     prove `P ⊣ pushforward`, obtain `pullback f ≅ P` via `leftAdjointUniq`, and take `pullbackTensorIso` as
     the composite of that bare functor iso with `P`'s tensorator (all isos). Confirm this is a coherent,
     formalizable proof sketch (it is the next prover target, currently unproven — `\lean{}` pin, no
     `\leanok` expected) and that the kept Stacks `lemma-tensor-product-pullback` source quote is intact.
   - `lem:isinvertible_pullback` (Phase 3) statement unchanged.

2. `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` — confirm:
   - new `lem:pullback_spec_tilde_iso` (`(Spec φ)^* M̃ ≅ (R'⊗_R M)~`) is well-formed with `\lean{}` pin,
     a coherent proof sketch, and a valid Stacks 01I9 source quote (the next prover target, no `\leanok`);
   - `lem:affine_base_change_pushforward`'s expanded proof now explicitly names the pullback-of-tilde
     dictionary + the `pushforwardBaseChangeMap ↔ cancelBaseChange` identification (the two previously
     under-specified obligations);
   - `lem:gammaPushforwardIsoAt_naturality` was correctly demoted to a prose remark with no dangling
     `\ref`/`\uses` left behind.

Report your full per-chapter checklist as usual. The two chapters above are the gate-critical ones for
this iter's prover dispatch; flag any must-fix on them explicitly.
