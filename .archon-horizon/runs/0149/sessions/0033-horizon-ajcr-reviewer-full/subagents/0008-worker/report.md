## Progress

Proved both generic projection equations in-memory:

```lean
(flatteningIso ...).hom ≫ pullback.fst (a ≫ iU ≫ f) g ≫ a =
  pullback.fst (pullback.fst (iU ≫ f) g ≫ iU) iV ≫
    pullback.fst (iU ≫ f) g
```

```lean
(flatteningIso ...).hom ≫ pullback.fst (a ≫ iU ≫ f) g ≫ b =
  pullback.snd (pullback.fst (iU ≫ f) g ≫ iU) iV
```

The proof uses an explicitly typed private auxiliary isomorphism to avoid instance-transparency loss when unfolding the tactic-defined isomorphism. The public theorem is recovered with `change`. Key lemmas are `pullback.lift_fst_assoc`, `pullback.lift_snd`, the symmetry and associativity projection lemmas, and `IsLimit.conePointUniqueUpToIso_inv_comp`.

`lean_run_code` completed successfully with no proof diagnostics. Exact axiom output for both duplicate public theorems:

```text
[propext, Classical.choice, Quot.sound]
```

## Issues

The required import remains unbuildable. Initial narrow build exited `1`; after its owner repaired the line-94 rewrite, fresh compilation still failed at lines 76–87 due missing ring/algebra instances and a type mismatch around `pic0FiniteStageAlgebraOfMap r`.

Per the lead’s hold instruction, I did not create `Pic0FiniteStageOverlapNaturality.lean`. No post-edit LSP or target kernel build was possible because no file was edited and the required source import has no valid artifact.
